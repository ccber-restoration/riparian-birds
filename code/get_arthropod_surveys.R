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

#read in individual sheets (1 per site and round of surveying)

EW_arthropods_1 <- read_sheet("https://docs.google.com/spreadsheets/d/11LvIr1BTAlVAseYOcaFbqqcSU8jbIsr6Ugh2mGN4qKg/edit?gid=0#gid=0")

AC_arthropods_1 <- read_sheet("https://docs.google.com/spreadsheets/d/1dcgOch8yOuFYNgQzJMgnAntAETPNBd0L83tfDUcvXjg/edit?gid=0#gid=0")

arthropod_surveys <- bind_rows(EW_arthropods_1, 
                               AC_arthropods_1)
