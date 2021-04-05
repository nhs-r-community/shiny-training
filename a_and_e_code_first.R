
# right at the top

library(tidyverse)
library(leaflet)
load("ae_attendances.Rdata")

# UI 

# select date range

sidebarLayout(
  sidebarPanel(
    
    dateRangeInput(), # as.Date("2016-04-01") to as.Date("2019-03-01")
    
    selectInput(...,
                multiple = TRUE), # select trust
    
  ),
  
# inside main panel

plotOutput(), # place graph in tab one
  
leafletOutput() # place map in tab two

  mainPanel(
    tabsetPanel(
      tabPanel("Label", outputFunction("nameOfOutput")),
      tabPanel("Label2", outputFunction2("nameOfOutput2"))
    )
  )
)

# server code- complete

server <- function(input, output) {
  
  filter_data <- reactive({
    
    sample_trusts <- ae_attendances %>% 
      filter(period >= input$date[1], period <= input$date[2]) %>% 
      arrange(Name)
  })
  
  output$trustMap <- renderLeaflet({
    
    filter_data() %>%
      leaflet() %>%
      addTiles() %>%
      setView(lng = -2, lat = 53, zoom = 7) %>%
      addCircleMarkers(lng = ~ lon, lat = ~ lat, weight = 1,
                       radius = ~ attendances/ 1000,
                       layerId = ~org_code)
  })
  
  output$graph <- renderPlot({
    
    graph_data <- filter_data() %>% 
      filter(Name %in% input$trust)
    
    graph_data %>% 
      group_by(period, Name) %>% 
      summarise(mean_attendance = mean(attendances)) %>% 
      ggplot(aes(x = period, y = mean_attendance)) +
      geom_line() + facet_wrap(~ Name, scales = "free")
  })
}