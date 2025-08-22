# Set up ----
#source script to load packages
source("code/survey_trees.R")


#get data from Google Sheet ----

#(only run if needed)
#canopy_data <- read_sheet(ss = "https://docs.google.com/spreadsheets/d/1-6KxPlx7A_2O5rPtUDqLYgNQOndxxXWVSjc2x1u01Ig/edit?gid=0#gid=0")

#write to file
#write_csv(canopy_data, "data/point_intercept_canopy_transects_2025-08-21.csv")


#load data from csv ----

# read in Jepson list

CA_plants <- read_csv(file = "data/jepson_list_2025-08-21.csv")  %>% 
  unite(binomial, genus, species, sep = " ", remove = FALSE)


canopy_data <- read_csv(file = "data/point_intercept_canopy_transects_2025-08-22.csv")

# get species list from canopy_data

species_high <- unique(canopy_data$above_5_m_cover)

species_low <- unique(canopy_data$below_5_m)

species_both <- union(species_high, species_low)

species_transect <- as.data.frame(species_both) %>% 
  rename(binomial = species_both ) %>% 
  #join Jepson data
  left_join(CA_plants) %>% 
  select(binomial:nativity) %>% 
  unique() %>% 
  mutate(nativity = case_when(
    binomial == "Fraxinus uhdei" ~ "NATURALIZED",
    binomial == "Syzygium paniculatum" ~ "NATURALIZED",
    .default = nativity
  )) %>% 
  drop_na() %>% 
  #rename nativity codes
  mutate(Status = case_match(nativity,
                               "NATURALIZED" ~ "Non-native",
                               "NATIVE" ~ "Native")
  )




#notes: Jepson has one row for every subspecies...
#Fraxinus uhdei not in the Jepson


#note: AC-12 is the one that was collected twice
canopy_data_deduplicated <- canopy_data %>% 
  #filter out duplicated transect data
  filter(!(ARU == "AC-12" & Recorder == "Lisa Stratton")) %>%
  mutate(below_5_m = replace_na(below_5_m, "open"),
         above_5_m_cover = replace_na(above_5_m_cover, "open"))

#high (> 5 m) summary
transect_summary_high <- canopy_data_deduplicated %>% 
  group_by(ARU, above_5_m_cover) %>% 
  summarize(points_high = n(),
            percent_high = points_high/26*100) %>% 
  mutate(Cover = above_5_m_cover) %>% 
  filter(Cover != "open") %>% 
  left_join(species_transect, by = join_by("Cover" == "binomial"))

# low (<5 m) summary
transect_summary_low <- canopy_data_deduplicated %>% 
  group_by(ARU, below_5_m) %>% 
  summarize(points_low = n(),
            percent_low = points_low/26*100) %>% 
  mutate(Cover = below_5_m) %>% 
  filter(Cover != "open") %>% 
  left_join(species_transect, by = join_by("Cover" == "binomial"))


# Figures by species ----
#make figure for low stratum
fig_low_pit <- ggplot(data = transect_summary_low, 
                      aes(x = ARU , 
                          y = percent_low, 
                          group = Cover,
                          fill = Cover)) +
  geom_col() +
  ylab("Cover (%)") +
  labs(title = "Low stratum (<5 m)") +
  theme_cowplot()

fig_low_pit


#make figure for high stratum
fig_high_pit <- ggplot(data = transect_summary_high, 
                      aes(x = ARU , 
                          y = percent_high, 
                          group = Cover,
                          fill = Cover)) +
  geom_col() +
  ylab("Cover (%)") +
  labs(title = "High stratum (>5 m)") +
  theme_cowplot()

fig_high_pit

# Team comparison ----

canopy_data_qa_qc <- canopy_data %>% 
  #select only the duplicated transect
  filter(ARU == "AC-12") %>% 
  #change NAs to "open"
  mutate(below_5_m = replace_na(below_5_m, "open"),
         above_5_m_cover = replace_na(above_5_m_cover, "open"))

## high stratum comparison ----
comparison_high <- canopy_data_qa_qc %>% 
  group_by(Measurer, above_5_m_cover) %>% 
  summarize(points_high = n(),
            percent_high = points_high/26*100) %>% 
  mutate(Cover = above_5_m_cover) %>% 
  filter(Cover != "open") %>% 
  left_join(species_transect, by = join_by("Cover" == "binomial"))


fig_comparison_high <- ggplot(data = comparison_high, 
                       aes(x = Measurer , 
                           y = percent_high, 
                           group = Cover,
                           fill = Cover)) +
  geom_col() +
  ylab("Cover (%)") +
  labs(title = "High stratum (>5 m)") +
  theme_cowplot() +
  scale_y_continuous(expand = c(0,NA))

fig_comparison_high

## low stratum comparison ----
comparison_low <- canopy_data_qa_qc %>% 
  group_by(Measurer, below_5_m) %>% 
  summarize(points_low = n(),
            percent_low = points_low/26*100) %>% 
  mutate(Cover = below_5_m) %>% 
  filter(Cover != "open") %>% 
  left_join(species_transect, by = join_by("Cover" == "binomial"))


fig_comparison_low <- ggplot(data = comparison_low, 
                              aes(x = Measurer , 
                                  y = percent_low, 
                                  group = Cover,
                                  fill = Cover)) +
  geom_col() +
  ylab("Cover (%)") +
  labs(title = "Low stratum (<5 m)") +
  theme_cowplot() +
  scale_y_continuous(expand = c(0,NA))

fig_comparison_low

fig_comparisons <- plot_grid(fig_comparison_high,
                             fig_comparison_low,
                             nrow = 2)

fig_comparisons

ggsave("figures/transect_team_comparison.pdf", 
       fig_comparisons)


#Alternate approach to comparisons
#see which tranect points had equal values

SL_data <- canopy_data_qa_qc %>% 
  filter(Measurer == "Santiago Lupi")

JB_data <- canopy_data_qa_qc %>% 
  filter(Measurer == "Jeremiah Bender" )

#join

SL_JB_join <- SL_data %>% 
  left_join(JB_data, by = join_by(Point, tape_distance_m))

#how many low points agreed?
check_low <- SL_JB_join %>% 
  filter(below_5_m.x == below_5_m.y)

#17 of 26 points were in agreement

check_high <- SL_JB_join %>% 
  filter(above_5_m_cover.x == above_5_m_cover.y)

#21 of 26 points in agreement

# Figures by native status ----

# Low stratum ----
## low stratum nativeness summary
summary_low_status <- transect_summary_low %>% 
  group_by(ARU, nativity) %>% 
  summarize(
    points_total_low = sum(points_low),
    percent_low = points_total_low /26*100
  )

#make figure for low stratum
fig_low_status <- ggplot(data = transect_summary_low, 
                      aes(x = ARU , 
                          y = percent_low, 
                          group = Status,
                          fill = Status)) +
  geom_col() +
  ylab("Absolute cover (%)") +
  labs(title = "(b) Low stratum (<5 m)") +
  theme_cowplot() +
  scale_fill_manual(values = colors_native_b) +
  scale_y_continuous(limits = c(0,100), expand = c(0,0))


fig_low_status

#high stratum native status ----
summary_high_status <- transect_summary_high %>% 
  group_by(ARU, Status) %>% 
  summarize(
    points_total_high = sum(points_high),
    percent_high = points_total_high/26*100
  )


fig_high_status <- ggplot(data = summary_high_status, 
                       aes(x = ARU , 
                           y = percent_high, 
                           group = Status,
                           fill = Status)) +
  geom_col() +
  ylab("Absolute cover (%)") +
  labs(title = "(a) High stratum (>5 m)") +
  theme_cowplot() +
  scale_fill_manual(values = colors_native_b) +
  scale_y_continuous(limits = c(0,100), expand = c(0,0))


fig_high_status

fig_canopy <- plot_grid(
  fig_high_status,
  fig_low_status,
  nrow = 2
)

fig_canopy

ggsave(filename = "figures/Fig_canopy_cover_2025-08-22.pdf",
       width = 180,
       height = 180,
       units = "mm")


