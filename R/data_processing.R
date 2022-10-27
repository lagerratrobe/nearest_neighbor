# data_processing.R

# Creates initial data file for use in nearest_neighbor project

library(sf)
library(dplyr)

df <- sf::st_read("hospitals (raw)/hospitals.shp")

# Select out the fields we want,
# drop the geometry column,
# set the data types
clean_df <- df |> 
  transmute(ID,
         NAME, 
         ADDRESS,
         CITY,
         STATE,
         COUNTY,
         ZIP,
         TYPE,
         STATUS,
         LATITUDE = as.numeric(LATITUDE),
         LONGITUDE = as.numeric(LONGITUDE),
         BEDS = as.integer(BEDS),
         TRAUMA,
         HELIPAD) |> 
  st_drop_geometry()

# Quick visual inspection of data types
glimpse(clean_df[1,])
sprintf("%.8f",clean_df[1,]$LATITUDE)
sprintf("%.8f",clean_df[1,]$LONGITUDE)

# Save out as an RDS file
saveRDS(clean_df, "Data/usa_hospitals.RDS")
