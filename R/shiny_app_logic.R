# shiny_app_guts.R

#  Load the hospital data
library(sf)
library(dplyr)

# Read in the data and filter it down to only hospitals that have ER's
df <- readRDS("Data/usa_hospitals.RDS") |>
  filter(STATUS == "OPEN") %>%
  filter(!TRAUMA == "NOT AVAILABLE" & !TYPE == "REHABILITATION")
  # filter(grepl("LEVEL I$|LEVEL II|LEVEL III|LEVEL IV", TRAUMA))

# Create spatial features and select only ID for use in distance calcs (lat/lon get converted to geom)
df_sf <- st_as_sf(df, coords = c("LONGITUDE", "LATITUDE"),  crs = 4326) |>
  select(ID)

# Create a sample point, equiv to geocoding response
sample_point <- st_sfc(st_point(c(-122.3727, 47.53319)), crs=4326)

# Calculate the distance to all hospitals from sample point
df_sf$distance <- st_distance(sample_point, df_sf)[1,]
units(df_sf$distance) <- NULL
df_sf$dist_miles <- df_sf$distance / 1609.344 # convert to miles

# Pull the 5 closest hospitals out
closest_five <- df_sf |> 
  arrange(distance) |> 
  slice_head(n=5)

closest_five

left_join(closest_five, df) |> 
  select(ID,
         NAME, CITY, TRAUMA, dist_miles)
