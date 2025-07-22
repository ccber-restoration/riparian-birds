#read in aru locations

aru_sites <- read_csv(file = "data/aru_sites_2025.csv")

aru_sites_sf <- st_as_sf(aru_sites, 
                         coords=c("x","y"), crs=4326) # remember x=lon and y=lat

mapview(aru_sites_sf)                         

