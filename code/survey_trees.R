# Set up ----
#source script to load packages
source("code/0_libraries.R")

#read in Google Sheet with information on trees (species and locations) for arthropod surveys
survey_trees <- read_sheet("https://docs.google.com/spreadsheets/d/1Srv19FkyvrlMOKrPIIfxB8UuFXuNQoblnqwP8OXjdJU/edit?gid=1506704030#gid=1506704030") 

#summarize by ARU site
tree_site_summary <- survey_trees %>% 
  group_by(aru_site) %>% 
  count(species_scientific)

#Plot sample composition for each survey site (15 trees)
fig_sampled_trees <- ggplot(data = tree_site_summary, aes(x = aru_site, y = n, fill = species_scientific)) +
  geom_col() +
  xlab("ARU site") +
  ylab("Trees sampled") +
  theme_cowplot() +
  scale_y_continuous(expand = c(0,NA)) +
  #scale_fill_manual(values = cal_palette("figmtn")) +
  guides(fill=guide_legend(title="Species")) 

fig_sampled_trees

ggsave("figures/Fig_sampled_trees_draft.pdf", fig_sampled_trees,
       width = 190,
       height = 140,
       units = "mm")

#Summarize by overall area
tree_area_summary <- survey_trees %>% 
  group_by(area) %>% 
  count(species_scientific)

#plot
fig_sampled_trees_by_area <- ggplot(data = tree_area_summary, aes(x = area, y = n, fill = species_scientific)) +
  geom_col() +
  xlab("Survey area") +
  ylab("Trees sampled") +
  theme_cowplot() +
  scale_y_continuous(expand = c(0,NA)) +
  #scale_fill_manual(values = cal_palette("figmtn")) +
  guides(fill=guide_legend(title="Species")) 

fig_sampled_trees_by_area

ggsave("figures/Fig_sampled_trees_by_area_draft.pdf", fig_sampled_trees_by_area)

