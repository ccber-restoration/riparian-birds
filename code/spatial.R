#read in aru locations

aru_sites <- read_csv(file = "data/aru_sites_2025.csv")

aru_sites_sf <- st_as_sf(aru_sites, 
                         coords=c("x","y"), crs=4326) # remember x=lon and y=lat
mapview(aru_sites_sf)      

#read in Google Sheet with information on trees (species and locations) for arthropod surveys
survey_trees <- read_sheet("https://docs.google.com/spreadsheets/d/1Srv19FkyvrlMOKrPIIfxB8UuFXuNQoblnqwP8OXjdJU/edit?gid=1506704030#gid=1506704030") %>% 
  filter(!is.na(latitude)) %>% 
  filter(!is.na(longitude))

survey_trees_sf <- st_as_sf(survey_trees,
                            coords = c("latitude", "longitude"), crs=4326)

mapview(survey_trees_sf)
