# Set up ----
#source script to load packages
source("code/0_libraries.R")

#read in individual sheets (1 per site and round of surveying)

# round 1 ----
R1_EW <- read_sheet("https://docs.google.com/spreadsheets/d/11LvIr1BTAlVAseYOcaFbqqcSU8jbIsr6Ugh2mGN4qKg/edit?gid=0#gid=0") %>% 
  clean_names() %>% 
  #fill NA values for specific columns based on values above
  fill(site, date, survey_type, observer, temp_f, site_notes, time, survey_code, leaf_length, number_leaves, herbivory_percent) %>% 
  #problems caused by data in wrong column
  mutate(number_leaves = as.numeric(number_leaves),
         herbivory_percent = as.numeric(herbivory_percent))

R1_AC <- read_sheet("https://docs.google.com/spreadsheets/d/1dcgOch8yOuFYNgQzJMgnAntAETPNBd0L83tfDUcvXjg/edit?gid=0#gid=0") %>% 
  clean_names() %>% 
  #fill NA values for specific columns based on values above
  fill(site, date, survey_type, observer, temp_f, site_notes, time, survey_code, leaf_length, number_leaves, herbivory_percent)


# round 2 ----
R2_AC <- read_sheet("https://docs.google.com/spreadsheets/d/1qdSLQDAS7aV6D8ZUvvYOfGN-D96deh3HJRcLmGx43zk/edit?gid=0#gid=0") %>% 
  clean_names() %>% 
  #fill NA values for specific columns based on values above
  fill(site, date, survey_type, observer, temp_f, site_notes, time, survey_code, leaf_length, number_leaves, herbivory_percent)

R2_EW <- read_sheet("https://docs.google.com/spreadsheets/d/13ycy1crmJ6GM_YHJehRlkFr1fYcOZNQ8DsPWglM-Wi8/edit?usp=drivesdk") %>% 
  clean_names() %>% 
  #fill NA values for specific columns based on values above
  fill(site, date, survey_type, observer, temp_f, site_notes, time, survey_code, leaf_length, number_leaves, herbivory_percent)



# round 3 ----
R3_AC <- read_sheet("https://docs.google.com/spreadsheets/d/172N7UQAuOK3_l8qqukiaRqY3EMJMP87m6Pww8y-lW4w/edit?usp=drivesdk") %>% 
  clean_names() %>% 
  #fill NA values for specific columns based on values above
  fill(site, date, survey_type, observer, temp_f, site_notes, time, survey_code, leaf_length, number_leaves, herbivory_percent)

R3_EW <- read_sheet("https://docs.google.com/spreadsheets/d/1b7P7-CEHqYJVjCABV_O2kjwJpxGbbPXiDVTpt3tbpFQ/edit?usp=drivesdk") %>% 
  clean_names() %>% 
  #fill NA values for specific columns based on values above
  fill(site, date, survey_type, observer, temp_f, site_notes, time, survey_code, leaf_length, number_leaves, herbivory_percent)

# round 4 ----
R4_AC <- read_sheet("https://docs.google.com/spreadsheets/d/1puD2IQhEJ_nsicDhLz2R1UQKRN49-dDBaTTSd4VCzWM/edit?usp=drivesdk") %>% 
  clean_names() %>% 
  #fill NA values for specific columns based on values above
  fill(site, date, survey_type, observer, temp_f, site_notes, time, survey_code, leaf_length, number_leaves, herbivory_percent)

R4_EW <- read_sheet("https://docs.google.com/spreadsheets/d/1pvOXvHncaixcmtX4rDSnO6LXTUkrIkWWw7aHhlfY4V8/edit?usp=drivesdk") %>% 
  clean_names() %>% 
  #fill NA values for specific columns based on values above
  fill(site, date, survey_type, observer, temp_f, site_notes, time, survey_code, leaf_length, number_leaves, herbivory_percent)

# round 5 ----
R5_AC <- read_sheet("https://docs.google.com/spreadsheets/d/13hW0REjy28RPiVMZW6NT7L4TsS0o2OjZaGuhsTnqyAk/edit?usp=drivesdk") %>% 
  clean_names() %>% 
  #fill NA values for specific columns based on values above
  fill(site, date, survey_type, observer, temp_f, site_notes, time, survey_code, leaf_length, number_leaves, herbivory_percent)

R5_EW <- read_sheet("https://docs.google.com/spreadsheets/d/1i7EHw-oD905TZo1z22S4pe6AX7F2J-oSvLELv5qIAuU/edit?usp=drivesdk") %>% 
  clean_names() %>% 
  #fill NA values for specific columns based on values above
  fill(site, date, survey_type, observer, temp_f, site_notes, time, survey_code, leaf_length, number_leaves, herbivory_percent)


#combine data sets
arthropod_surveys <- bind_rows(R1_EW, 
                               R1_AC,
                               R2_AC,
                               R2_EW,
                               R3_AC,
                               R3_EW,
                               R4_AC,
                               R4_EW,
                               R5_AC,
                               R5_EW)

#write to file
write_csv(arthropod_surveys, "data/arthropod_surveys_compiled.csv")

#basic summary
arthropod_summary <- arthropod_surveys %>% 
  group_by(site, arthropod_common_name) %>% 
  summarize(total_count = sum(number))

  
  
