
library(shiny)
library(tidyverse)
library(DT)
library(leaflet)

load(url("https://github.com/nhs-r-community/shiny-training/blob/main/a_and_e_first/ae_attendances.RData?raw=true"))

ui <- fluidPage(
  
  # Application title
  titlePanel("A and E data"),
  
  sidebarLayout(
    sidebarPanel(
      dateRangeInput("date", "Date range", 
                     as.Date("2016-04-01"), 
                     as.Date("2019-03-01"),
                     startview = "year"),
      selectInput("trust",
                  "Select Trust",
                  choices = unique(ae_attendances$Name),
                  multiple = TRUE)
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Graph", 
                 plotOutput("graph")),
        tabPanel("Map", 
                 leafletOutput("trustMap")
        )
      )
    )
  )
)

server <- function(input, output) {
  
  filter_data <- reactive({
    
    ae_attendances %>% 
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

# Run the application 
shinyApp(ui = ui, server = server)
