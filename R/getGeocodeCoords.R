getGeocodeCoords <- function (
    street = NULL,
    city = NULL,
    state = NULL
) {
  library(httr)
  library(stringr)
  
  baseURL <- "https://geocoding.geo.census.gov/geocoder/locations/address?"
  
  # Function to replace spaces with "+" symbol
  spaceReplace <- function(df) {stringr::str_replace_all(df, "[ ]", "+")}
  
  # Build the request string
  request <- spaceReplace(paste0("street=", street, 
                                 "&city=", city, 
                                 "&state=", state, 
                                 "&benchmark=2020", 
                                 "&format=json"))
  
  # Tack the base address and request string together 
  requestURL <- paste0(baseURL, request)
  
  # Make the actual request as a "GET" command
  response <- httr::GET(requestURL)
  
  # Status tells us if the request was successful, etc
  status <- httr::http_status(response)
  
  # Check that the request succeeded before proceeding further
  if (status$message == "Success: (200) OK") {
    # Parse the response
    response_data <- httr::content(response)
    
    # Extract the coordinates from the response
    coordinates <- response_data$result$addressMatches[[1]]$coordinates
    
    return(coordinates)
  } else {
    # Do something meaningful 
    sprintf("There was an error getting this request: \n", requestURL )
  }
}
