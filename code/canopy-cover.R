# Set up ----
#source script to load packages
source("code/survey_trees.R")


#get data from Google Sheet ----

#(only run if needed)
#canopy_data <- read_sheet(ss = "https://docs.google.com/spreadsheets/d/1-6KxPlx7A_2O5rPtUDqLYgNQOndxxXWVSjc2x1u01Ig/edit?gid=0#gid=0")

#write to file
#write_csv(canopy_data, "data/point_intercept_canopy_transects_2025-08-21.csv")


#load data from csv ----

canopy_data <- read_csv(file = "data/point_intercept_canopy_transects_2025-08-21.csv")

#note: AC-12 is the one that was collected twice
canopy_data_deduplicated <- canopy_data %>% 
  #filter out duplicated transect data
  filter(!(ARU == "AC-12" & Recorder == "Lisa Stratton")) %>%
  mutate(below_5_m = replace_na(below_5_m, "open"),
         above_5_m_cover = replace_na(below_5_m, "open"))
  
  

#high (> 5 m) summary
transect_summary_high <- canopy_data_deduplicated %>% 
  group_by(ARU, above_5_m_cover) %>% 
  summarize(points_high = n(),
            percent_high = points_high/26*100) %>% 
  mutate(Cover = above_5_m_cover) %>% 
  filter(Cover != "open")

# low (<5 m) summary
transect_summary_low <- canopy_data_deduplicated %>% 
  group_by(ARU, below_5_m) %>% 
  summarize(points_low = n(),
            percent_low = points_low/26*100) %>% 
  mutate(Cover = below_5_m) %>% 
  filter(Cover != "open")

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



