
#source script to load packages
source("code/0_libraries.R")

#read in individual sheets (1 per day)

Ellwood_2025_06_18 <- read_sheet("https://docs.google.com/spreadsheets/d/1QVSkGbZxlq0ZbWmu40SsNY4cnZfR5376Xe0QS0HW9Yw/edit?gid=0#gid=0")  

Atascadero_2025_06_19 <- read_sheet("https://docs.google.com/spreadsheets/d/1W_LAFmjLoMvpnsNEjhi-Pb2xZM8cMdxpNpYjwUS11Vk/edit?gid=0#gid=0")

Ellwood_2025_06_25 <- read_sheet("https://docs.google.com/spreadsheets/d/1J7jfTSaFu-AhboBX8Qlv-WGFrkVNQ92KucSjN34pHo4/edit?gid=0#gid=0")



point_counts_all <- bind_rows(Ellwood_2025_06_18, 
                              Atascadero_2025_06_19,
                              Ellwood_2025_06_25) %>% 
  #make column names easier to work with
  clean_names() %>% 
  #extract time of day from the time columns (currently stored as date-time)
  mutate(time_start = as_hms((time_start)),
         time_stop = as_hms(time_stop))

#list of focal species 
focal_sp <- c("Yellow Warbler", "Wilson's Warbler", "Warbling Vireo", "Black-headed Grosbeak", "Purple Finch", "Chestnut-backed Chickadee", "Western Flycatcher")


#read in AOS North America checklist and filter to focal species
#this ensures they are listed in taxonomic order and gives more taxonomic information (family, scientific name)

aos_checklist <- read_csv("data/NACC_list_species_2024.csv") %>% 
  filter(common_name %in% focal_sp)


#filter by focal species
point_counts_filtered <- point_counts_all %>% 
  filter(species %in% aos_checklist$common_name)

#summarize 
point_count_summary <- point_counts_filtered %>% 
  group_by(species, site) %>% 
  summarize(n_detections = n())
