
library(dplyr)
library(shiny)
library(leaflet)
library(sf)

usaLat <- 47.53319
usaLon <- -122.3727
usaZoom <- 5
iconURL <- "https://raw.githubusercontent.com/Rush/Font-Awesome-SVG-PNG/master/black/png/48/plane.png"

leafletIcon <- makeIcon(
  iconUrl = iconURL,
  iconWidth = 16, iconHeight = 16
)

airports <- read.csv("../Data/airports.csv")


ui <- fluidPage(
  tags$h1("US Airports"),
  selectInput(inputId = "inputState", label = "Select state:", multiple = TRUE, choices = sort(airports$STATE), selected = "WA"),
  tags$h2("Leaflet"),
  leafletOutput(outputId = "leafletMap")
)

server <- function(input, output) {
  data <- reactive({
    airports %>%
      filter(STATE %in% input$inputState) %>%
      mutate(INFO = paste0(AIRPORT, " | ", CITY, ", ", STATE))
  })
  
  output$leafletMap <- renderLeaflet({
    leaflet(data = data()) %>%
      setView(lat = usaLat, lng = usaLon, zoom = usaZoom) %>%
      addTiles() %>%
      addMarkers(~LONGITUDE, ~LATITUDE, icon = leafletIcon, popup = ~INFO, label = ~INFO) %>%
      addProviderTiles(providers$CartoDB.Positron)
  })

}


shinyApp(ui = ui, server = server)
