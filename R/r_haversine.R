# r_haversine.R

r_haversine <- function(
    lat1,
    lon1,
    lat2,
    lon2
) {
  R = 3959.87433 # this is in miles.  For Earth radius in kilometers use 6372.8 km
  
  # n * (pi/180) converts n from degrees to radians
  dLat <- (lat2 - lat1) * (pi/180)
  dLon <- (lon2 - lon1) * (pi/180)
  lat1 <- lat1 * (pi/180) 
  lat2 <- lat2 * (pi/180)
  
  a = sin(dLat/2)**2 + cos(lat1)*cos(lat2)*sin(dLon/2)**2
  c = 2*asin(sqrt(a))
  
  return(R*c)
}

# Given the following values:
# lon1 <- -117.4234
# lat1 <- 47.6518
# lon2 <- -122.374334
# lat2 <- 47.524384
# 
# r_haversine(lat1, lon1, lat2, lon2)
#
# Should return:
#
# 230.9093 mi
