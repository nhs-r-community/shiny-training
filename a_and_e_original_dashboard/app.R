library(shiny)
library(tidyverse)
library(DT)
library(leaflet)
library(shinydashboard)

load("ae_attendances.RData")

ui <- dashboardPage(
  dashboardHeader(title = "A and E data"),
  dashboardSidebar(
    sidebarMenu(id = "tabset",
                menuItem("Graph", tabName = "graph", icon = icon("dashboard")),
                menuItem("Map", tabName = "map", icon = icon("th"))
    ),
    dateRangeInput("date", "Date range", 
                   as.Date("2016-04-01"), 
                   as.Date("2019-03-01"),
                   startview = "year")
  ),
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "graph",
              fluidRow(
                box(title = "Attendance over time",
                    plotOutput("graph")),
                box(width = 3, 
                      uiOutput("trustControl")
                    )
                )
      ),
      
      # Second tab content
      tabItem(tabName = "map",
              box(
                leafletOutput("trustMap", height = 600, width = 500)
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
  
  output$trustControl <- renderUI({
    
    selectInput("trust",
                "Select Trust",
                choices = unique(filter_data()$Name),
                multiple = TRUE)
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
    
    validate(need(input$trust, "Please select a Trust"))
    
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