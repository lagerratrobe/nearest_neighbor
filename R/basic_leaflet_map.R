# basic_leaflet_map.R

# Just the basic code needed to display the basic 5 points in a leaflet map

library(leaflet)
library(sf)
library(dplyr)

# Sets the initial map location and zoom level (roughly Puget Sound)
homeLat <- 47.53319
homeLon <- -122.3727
usaZoom <- 10

# Just base data, no spatial object types, yet
data <- readRDS("Data/usa_hospitals.RDS")
head(data)

# Pull in an icon to use as map marker for hospital locations 
hospIcon <- makeIcon(
  iconUrl = "https://icons.iconarchive.com/icons/fa-team/fontawesome/48/FontAwesome-House-Medical-icon.png",
  iconWidth = 16, iconHeight = 16
)

leafMap <- leaflet(data = data) %>%
  setView(lat = homeLat, lng = homeLon, zoom = usaZoom) %>%
  addTiles() %>%
  addMarkers(~LONGITUDE, 
             ~LATITUDE,
             icon = hospIcon,
             popup = ~NAME, 
             label = ~NAME) |>
  addProviderTiles("CartoDB.Positron")

leafMap

## Next Steps
## Convert hospitals to spatial objects and load into map
# CE.sf <- df60 %>%   
#   filter(LEVL_CODE == 2 & CNTR_CODE %in% c("AT","CZ","DE","HU","PL","SK")) %>% 
#   select(NUTS_ID) 
# 
# leaflet(CE.sf) %>% etc..
##
)
