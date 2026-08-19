# the purpose of this script is to filter the thresholded detection data for focal species to just the sites of interest and re-create the figure Conor shared using the reduced data set

source("code/0_libraries.R")

# read in data from Conor
call_detections <- read_csv("data/ARU_detections/site_call_rate_index.csv") %>% 
  filter(str_starts(site, "AC|EW")) %>% 
  mutate(Area = case_when(
    str_starts(site, "AC") ~ "Atascadero",
    str_starts(site, "EW") ~ "Ellwood"
  ))


fig_call_rate <- ggplot(data = call_detections, aes(x = site, y = index, color = Area)) +
  geom_pointrange(aes(ymin = lwr, ymax = upr)) +
  facet_wrap(vars(common_name), scales = "free", nrow = 3) +
  ylab("Modeled call rate (calls/min)") +
  xlab("ARU site") +
  theme_bw()

fig_call_rate

# read in point count data ----

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

# read in point count data from summer 2025
point_counts <- read_csv("data/point_counts_compiled_2025-08-13.csv")

#FIXME- not working currently:  complete the data with every combination of survey metadata and species, so the implicit 0s become explicit
# point_counts_completed <- point_counts %>% 
#   complete(nesting(site: time_stop), species, fill = list(score = NA))

#filter by focal species
point_counts_filtered <- point_counts %>% 
  filter(species %in% aos_checklist$common_name)

# a problem here is that because focal species were never recorded in point counts at AC_12, this site drops out entirely...the solution is to do the complete step upstream



#summarize 
point_count_summary <- point_counts_filtered %>% 
  select(-site) %>% 
  group_by(species, aru_site_name) %>% 
  summarize(n_detections = n()) %>% 
  # complete 0s
  as_tibble() %>% 
  # make variables factors
  mutate_at(c("species", "aru_site_name"), as.factor) %>% 
  # complete implicit missing combinations of site & species
  complete(species, aru_site_name) %>% 
  # fill in 0s
  mutate(n_detections = case_when(
    is.na(n_detections) ~ 0,
    .default = n_detections
  ))

# join total point count detections to call rates

combined <- call_detections %>% 
  left_join(point_count_summary, by = join_by(site == aru_site_name, common_name == species))

# plot

fig_comparison <- ggplot(data = combined, aes(x = index, y = n_detections, shape = Area, color = site)) +
  geom_point() +
  facet_wrap(vars(common_name), nrow = 3, scales = "free") +
  xlab("Modeled call rate (calls/min)") +
  ylab("Total point count detections")

fig_comparison

