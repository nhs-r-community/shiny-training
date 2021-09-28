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
    uiOutput("dateRangeUI")
  ),
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "graph",
              fluidRow(
                box(title = "Attendance over time",
                    plotOutput("graph")),
                box(width = 6, 
                    selectInput("trust",
                                "Select Trust",
                                choices = unique(ae_attendances$Name),
                                multiple = TRUE),
                    valueBox(length(unique(ae_attendances$Name)), 
                             "Number of trusts",
                             icon = icon("hospital")),
                    valueBoxOutput("daysBox")
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
  
  output$dateRangeUI <- renderUI({
    
    dateRangeInput("date", "Date range", 
                   min(ae_attendances$period), 
                   max(ae_attendances$period),
                   startview = "year")
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
  
  output$daysBox <- renderValueBox({
    
    valueBox(
      input$date[2] - input$date[1],
      "Days summarised", icon = icon("calendar-alt"),
      color = "green"
    )
  })
}

# Run the application 
shinyApp(ui = ui, server = server)