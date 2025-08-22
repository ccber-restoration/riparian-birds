#packages

#general use
library(tidyverse)

# import data from Google Sheets
library(googlesheets4)

#data cleaning
#see https://cran.r-project.org/web/packages/janitor/vignettes/janitor.html#do-those-dataframes-actually-contain-the-same-columns
library(janitor)

#deal with dates and times
library(lubridate)
library(hms)

#spatial
#library(mapview)
#library(sf)

#figures
library(cowplot)
#library(calecopal)


# color palette ----

#color palette using publication codes
colors_native <- c("darkgreen", "tomato")

colors_native_b <- c("#84A6A2", "#BE5A47")
