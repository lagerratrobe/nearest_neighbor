# test_5_closest.R - Quick and dirty script to determine what the 5 closest hospitals are to an arbitrary point

# Uses sf::st_is_within_distance(x, y = x, dist, sparse = TRUE, ...)


library(sf)
library(dplyr)

source("R/r_haversine.R")

# will become a function eventually
fiveClosestHospitals <- function(lat, lon) {}

# Get raw data (neither of these are spatial objects - yet)
hospitals <- readRDS("Data/usa_hospitals.RDS")
places <- readRDS("Data/gnis_pop_place.RDS")

hospitals_sf <- st_as_sf(hospitals, coords = c("LONGITUDE", "LATITUDE"),  crs = 4326)
places_sf <- st_as_sf(places, coords = c("PRIM_LONG_DEC", "PRIM_LAT_DEC"),  crs = 4326)

# Test known distance between 2 points, (47.524384, -122.374334) and (47.6518, -117.4234)

test_points <- read.table(header = TRUE, text="
id  lat  lon
pt1  47.524384  -122.374334
pt2  47.6518 -117.4234
")

# Create spatial objects
test_points_sf <- st_as_sf(test_points, coords = c("lon", "lat"),  crs = 4326)

# Distance between 2 points, in meters, using sf
real_distance <- st_distance(test_points_sf[1,], test_points_sf[2,])

# Set units to NULL
units(real_distance) <- NULL

# Using Haversine
haversine_distance <- r_haversine(test_points[1,]$lat, test_points[1,]$lon, test_points[2,]$lat, test_points[2,]$lon)

# Test function
library(testthat)
test_that("Percent difference between Haversine and st_distance is less than 1%", {
  expect_lt(abs( 
    ((real_distance - haversine_distance) / haversine_distance) * 100 
    ), 1 )
})

# Back to the original question...
# How many hospitals within n meters of a specific location?
sprague <- places_sf %>% filter(FEATURE_NAME == "Sprague", STATE_ALPHA == "WA", COUNTY_NAME == "Lincoln")
jd <- places_sf %>% filter(FEATURE_NAME == "John Day", STATE_ALPHA == "OR")
sequim <- places_sf %>% filter(FEATURE_NAME == "Sequim", STATE_ALPHA == "WA")


hospitals_sf[sf::st_is_within_distance(jd, 
                          hospitals_sf, 
                          58000, 
                          sparse = FALSE),] %>% 
  filter(STATUS == "OPEN") %>%
  filter(!TRAUMA == "NOT AVAILABLE" & !TYPE == "REHABILITATION") %>%
  filter(grepl("LEVEL I$|LEVEL II|LEVEL III|LEVEL IV", TRAUMA)) %>%
  select(NAME, TYPE, BEDS, CITY, STATE, TRAUMA)
