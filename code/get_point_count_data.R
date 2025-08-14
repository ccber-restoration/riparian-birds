
# Set up ----
#source script to load packages
source("code/0_libraries.R")

# get species lists ----

#list of focal species, in taxonomic order 
focal_sp <- c("Western Flycatcher",
              "Warbling Vireo",
              "Chestnut-backed Chickadee", 
              "Purple Finch",
              "Yellow Warbler", 
              "Wilson's Warbler", 
              "Black-headed Grosbeak"
              )

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

# Round 5 ----
Atascadero_2025_07_29 <-  read_sheet("https://docs.google.com/spreadsheets/d/1fy57SYbNKj_Y9YV_mrACQWhktlQ03-_9OSCl_rP2_-U/edit?gid=0#gid=0") %>% 
  #fill NA values for specific columns based on values above
  fill(Site, aru_site_name, Date, Surveyor, Time_start, Time_stop)

Ellwood_2025_07_30 <- read_sheet("https://docs.google.com/spreadsheets/d/1n5YLuXa3wOJrPQbNXHT93mZlowy2Dy2j9Md0AnVpiCs/edit?gid=0#gid=0") %>% 
  #fill NA values for specific columns based on values above
  fill(Site, aru_site_name, Date, Surveyor, Time_start, Time_stop)

#Round 6 (completing week of 11 August) ----


# compile ----
point_counts_all <- bind_rows(Ellwood_2025_06_18, 
                              Atascadero_2025_06_19,
                              Ellwood_2025_06_25,
                              Atascadero_2025_06_27,
                              Atascadero_2025_07_01,
                              Ellwood_2025_07_02,
                              Atascadero_2025_07_15,
                              Ellwood_2025_07_16,
                              Atascadero_2025_07_29,
                              Ellwood_2025_07_30) %>% 
  #make column names easier to work with
  clean_names() %>% 
  #extract time of day from the time columns 
  #FIXME: time currently stored as date-time
  mutate(time_start = as_hms((time_start)),
         time_stop = as_hms(time_stop))

#write to csv
write_csv(point_counts_all, file = "data/point_counts_compiled_2025-08-13.csv")


#filter by focal species
point_counts_filtered <- point_counts_all %>% 
  filter(species %in% aos_checklist$common_name)

#summarize (should make zeros explicit)
point_count_summary <- point_counts_filtered %>% 
  group_by(species, site) %>% 
  summarize(n_detections = n()) %>% 
  #complete 0s
  as_tibble() %>% 
  #make variables factors
  mutate_at(c("species", "site"), as.factor) %>% 
  #complete implicit missing combinations of site & species
  complete(species,site) %>% 
  #fill in 0s
  mutate(n_detections = case_when(
    is.na(n_detections) ~ 0,
    .default = n_detections
  ))


# quick plot

fig_total_counts <- ggplot(data = point_count_summary, aes(x = n_detections,
                                                           y = species ,
                                                           #fill = site, 
                                                           color = site)) +
  geom_point() +
  theme_cowplot() +
  ylab("Species") +
  xlab("Total detections") +
  scale_x_continuous(limits = c(0,NA)) +
  theme(legend.position = "bottom")
  
fig_total_counts

ggsave("figures/point_counts_2025-08-13.pdf", 
       fig_total_counts,
       width = 150,
       units = "mm")

#site summary
point_count_aru_site_summary <- point_counts_filtered %>% 
  group_by(site, aru_site_name, species) %>% 
  summarize(n_detections = n()) %>% 
  #complete 0s
  as_tibble() %>% 
  #make variables factors
  mutate_at(c("species", "site", "aru_site_name"), as.factor) %>% 
  #complete implicit missing combinations of site & species
  complete(species,site, aru_site_name) %>% 
  mutate(n_detections = case_when(
    is.na(n_detections) ~ 0,
    .default = n_detections
  ))

# make plot!
fig_by_aru <- ggplot(data = point_count_aru_site_summary, aes(x = n_detections,
                                                           y = species ,
                                                           #fill = site, 
                                                           color = site)) +
  geom_jitter(width = 0) +
  theme_cowplot() +
  ylab("Species") +
  xlab("Total detections") +
  scale_x_continuous(limits = c(0,NA)) +
  theme(legend.position = "bottom")

fig_by_aru

fig_by_aru_jitter <- ggplot(data = point_count_aru_site_summary, aes(x = n_detections,
                                                              y = species,
                                                              color = site, 
                                                              group = aru_site_name)) +
  geom_jitter(width = 0) +
  theme_cowplot() +
  ylab("Species") +
  xlab("Total detections") +
  scale_x_continuous(limits = c(0,NA)) +
  theme(legend.position = "bottom")

fig_by_aru_jitter

ggsave("figures/focal_sp_detections_by_point_2025-08-13.pdf", 
       fig_by_aru_jitter,
       width = 150,
       units = "mm")
