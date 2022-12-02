# Feature building in R

library(sf)
library(dplyr)

# First, pull in some states and extract Washington
states <- st_read("/data/GIS_Data/CensusBoundary_files/cb_2018_us_state_20m.shp", crs = '4326')
glimpse(states)

wa_state <- states %>% filter(STUSPS == "WA")
plot(wa_state$geometry)

saveRDS(wa_state, "Data/wa_state_poly.RDS")

# What's the extent of WA?
st_bbox(wa_state)
# xmin       ymin       xmax       ymax 
# -124.72584   45.54432 -116.91599   49.00249 

# So now we need a City point that is roughly in the middle of the state.
# This doesn't need to be perfect, using Ellensburg
ellens <- places_sf %>% filter(FEATURE_NAME == "Ellensburg", STATE_ALPHA == "WA")
plot(ellens$geometry, add=TRUE) # (-120.5478 46.99651), Good enough

# So, we want some 1-degree boxes around Ellensburg, we need 6 boxes total

# mid_top (-121, 47) x (-120, 48)
mt <- st_sf(a = c("ll", "ur"), geom = st_sfc( st_point(c(-121,47), dim = 2), st_point(c(-120,48), dim = 2) ), crs = 4326)
plot(mt$geom, add = TRUE)

# middle_middle, ll = (-121, 46) ur = (-120, 47)
mm <- st_sf(a = c("ll", "ur"), geom = st_sfc( st_point(c(-121,46), dim = 2), st_point(c(-120,47), dim = 2) ), crs = 4326)
plot(mm$geom, add = TRUE)

# mid_bot = (-121, 45) x (-120, 46)
mb <- st_sf(a = c("ll", "ur"), geom = st_sfc( st_point(c(-121,45), dim = 2), st_point(c(-120,46), dim = 2) ), crs = 4326)
plot(mb$geom, add = TRUE)

###
# left_top (-122, 47) x (-121, 48)
lt <- st_sf(a = c("ll", "ur"), geom = st_sfc( st_point(c(-122,47), dim = 2), st_point(c(-120,48), dim = 2) ), crs = 4326)
plot(lt$geom, add = TRUE)

# left_middle, ll = (-122, 46) ur = (-121, 47)
lm <- st_sf(a = c("ll", "ur"), geom = st_sfc( st_point(c(-122,46), dim = 2), st_point(c(-121,47), dim = 2) ), crs = 4326)
plot(lm$geom, add = TRUE)

# left_bot = (-121, 45) x (-120, 46)
lb <- st_sf(a = c("ll", "ur"), geom = st_sfc( st_point(c(-122,45), dim = 2), st_point(c(-121,46), dim = 2) ), crs = 4326)
plot(lb$geom, add = TRUE)

