
# Set up ----
#source script to load packages
source("code/0_libraries.R")

# get species lists ----

#list of focal species 
focal_sp <- c("Yellow Warbler", "Wilson's Warbler", "Warbling Vireo", "Black-headed Grosbeak", "Purple Finch", "Chestnut-backed Chickadee", "Western Flycatcher")

#read in AOS North America checklist and filter to focal species
#this ensures they are listed in taxonomic order and gives more taxonomic information (family, scientific name)

aos_checklist <- read_csv("data/NACC_list_species_2024.csv") %>% 
  filter(common_name %in% focal_sp)

# import data from Google Sheets ----

#read in individual sheets (1 per day)

#Round 1 ----
Ellwood_2025_06_18 <- read_sheet("https://docs.google.com/spreadsheets/d/1QVSkGbZxlq0ZbWmu40SsNY4cnZfR5376Xe0QS0HW9Yw/edit?gid=0#gid=0")  

Atascadero_2025_06_19 <- read_sheet("https://docs.google.com/spreadsheets/d/1W_LAFmjLoMvpnsNEjhi-Pb2xZM8cMdxpNpYjwUS11Vk/edit?gid=0#gid=0")

#Round 2 ----
Ellwood_2025_06_25 <- read_sheet("https://docs.google.com/spreadsheets/d/1J7jfTSaFu-AhboBX8Qlv-WGFrkVNQ92KucSjN34pHo4/edit?gid=0#gid=0") %>% 
  #fill NA values for specific columns based on values above
  fill(Site, aru_site_name, Date, Surveyor, Time_start, Time_stop) 

Atascadero_2025_06_27 <- read_sheet("https://docs.google.com/spreadsheets/d/1U3xrgwKnzCwHA2i4aa1CwpnDBge7ViizlcsIIby1lOs/edit?gid=0#gid=0") %>% 
  #fill NA values for specific columns based on values above
  fill(Site, aru_site_name, Date, Surveyor, Time_start, Time_stop) 

# Round 3 ----
Atascadero_2025_07_01 <- read_sheet("https://docs.google.com/spreadsheets/d/1XtjiHkkbtpBRlr472N-wo0OtnAyIv-fTR5vPYW5En68/edit?gid=0#gid=0") %>% 
  #fill NA values for specific columns based on values above
  fill(Site, aru_site_name, Date, Surveyor, Time_start, Time_stop)

Ellwood_2025_07_02 <- read_sheet("https://docs.google.com/spreadsheets/d/12gD8q2Qz3AVibUXeqmKMb1NTxRYsxupaKrcIOO1YqZg/edit?gid=0#gid=0") %>% 
  #fill NA values for specific columns based on values above
  fill(Site, aru_site_name, Date, Surveyor, Time_start, Time_stop)

#Round 4 ----
Atascadero_2025_07_15 <- read_sheet("https://docs.google.com/spreadsheets/d/1Eegp06Z-SKHS1-gdJLb7sNjndbThpvNn5xA4WMcemaQ/edit?gid=0#gid=0") %>% 
  #fill NA values for specific columns based on values above
  fill(Site, aru_site_name, Date, Surveyor, Time_start, Time_stop)


Ellwood_2025_07_16 <- read_sheet("https://docs.google.com/spreadsheets/d/16AniPKMXiikSF75Qs0brzaEdFYLper_64KL1R4mAG8s/edit?gid=0#gid=0") %>% 
  #fill NA values for specific columns based on values above
  fill(Site, aru_site_name, Date, Surveyor, Time_start, Time_stop)

# Round 5 (not entered yet)

point_counts_all <- bind_rows(Ellwood_2025_06_18, 
                              Atascadero_2025_06_19,
                              Ellwood_2025_06_25,
                              Atascadero_2025_06_27,
                              Atascadero_2025_07_01,
                              Ellwood_2025_07_02,
                              Atascadero_2025_07_15,
                              Ellwood_2025_07_16) %>% 
  #make column names easier to work with
  clean_names() %>% 
  #extract time of day from the time columns 
  #FIXME: time currently stored as date-time
  mutate(time_start = as_hms((time_start)),
         time_stop = as_hms(time_stop))

#write to csv
write_csv(point_counts_all, file = "data/point_counts_compiled.csv")


#filter by focal species
point_counts_filtered <- point_counts_all %>% 
  filter(species %in% aos_checklist$common_name)

#summarize (should make zeros explicit)
point_count_summary <- point_counts_filtered %>% 
  group_by(species, site) %>% 
  summarize(n_detections = n())

# quick plot

fig_total_counts <- ggplot(data = point_count_summary, aes(x = n_detections  , y = species, fill = site, color = site)) +
  geom_point() +
  theme_cowplot() +
  xlab("Species") +
  ylab("Total detections") +
  scale_x_continuous(limits = c(0,NA))
  
fig_total_counts

ggsave("figures/point_counts.png", fig_total_counts)
