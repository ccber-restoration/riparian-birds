#packages

library(tidyverse)

#data cleaning
#see https://cran.r-project.org/web/packages/janitor/vignettes/janitor.html#do-those-dataframes-actually-contain-the-same-columns
library(janitor)

# import data from Google Sheets
library(googlesheets4)

#deal with dates and times
library(lubridate)
library(hms)

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


