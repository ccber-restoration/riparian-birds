# Set up ----
#source script to load packages
source("code/0_libraries.R")

#read in individual sheets (1 per site and round of surveying)

# round 1 ----
arthropods_1_EW <- read_sheet("https://docs.google.com/spreadsheets/d/11LvIr1BTAlVAseYOcaFbqqcSU8jbIsr6Ugh2mGN4qKg/edit?gid=0#gid=0") %>% 
  clean_names() %>% 
  #fill NA values for specific columns based on values above
  fill(site, date, survey_type, observer, temp_f, site_notes, time, survey_code, leaf_length, number_leaves, herbivory_percent) %>% 
  #problems caused by data in wrong column
  mutate(number_leaves = as.numeric(number_leaves),
         herbivory_percent = as.numeric(herbivory_percent))

arthropods_1_AC <- read_sheet("https://docs.google.com/spreadsheets/d/1dcgOch8yOuFYNgQzJMgnAntAETPNBd0L83tfDUcvXjg/edit?gid=0#gid=0") %>% 
  clean_names() %>% 
  #fill NA values for specific columns based on values above
  fill(site, date, survey_type, observer, temp_f, site_notes, time, survey_code, leaf_length, number_leaves, herbivory_percent)


# round 2 ----
arthropods_2_AC <- read_sheet("https://docs.google.com/spreadsheets/d/1qdSLQDAS7aV6D8ZUvvYOfGN-D96deh3HJRcLmGx43zk/edit?gid=0#gid=0") %>% 
  clean_names() %>% 
  #fill NA values for specific columns based on values above
  fill(site, date, survey_type, observer, temp_f, site_notes, time, survey_code, leaf_length, number_leaves, herbivory_percent)



# round 3 ----

# round 4 ----

# round 5 ----

#combine data sets
arthropod_surveys <- bind_rows(arthropods_1_EW, 
                               arthropods_1_AC)

#write to file
write_csv(arthropod_surveys, "data/arthropod_surveys_compiled.csv")

#basic summary
arthropod_summary <- arthropod_surveys %>% 
  group_by(site, arthropod_common_name) %>% 
  summarize(total_count = sum(number))

  
  
