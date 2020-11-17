library(shiny)
library(tidyverse)
library(DT)
library(leaflet)
library(knitr)
library(rmarkdown)

load("ae_attendances.RData")

ui <- fluidPage(
  
  # Application title
  titlePanel("A and E data"),
  
  fluidRow(
    column(3, 
           dateRangeInput("date", "Date range", 
                          as.Date("2016-04-01"), 
                          as.Date("2019-03-01"),
                          startview = "year"),
           conditionalPanel(
             condition = "input.tabset == 'graph'",
             uiOutput("trustControl")
           ),
           downloadButton("downloadReport", "Download report")),
    
    column(9, 
           tabsetPanel(id = "tabset",
                       tabPanel("Graph", value = "graph", plotOutput("graph")),
                       tabPanel("Map", value = "map", 
                                leafletOutput("trustMap", height = 600, width = 500))
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
      geom_line() + 
      facet_wrap(~ Name, scales = "free")
  })
  
  output$downloadReport <- downloadHandler(
    filename = "report.docx",
    content = function(file){
      
      if(!isTruthy(input$trust)){
        
        showModal(
          modalDialog(
            title = "Error!",
            HTML("Please select a trust first"),
            easyClose = TRUE
          )
        )
      }
      
      params <- list(date_from = input$date[1],
                     date_to = input$date[2],
                     trust = input$trust)
      
      render("report.Rmd", output_format = "word_document",
             output_file = "report.docx", quiet = TRUE, params = params,
             envir = new.env(parent = globalenv()))
      
      # copy docx to 'file'
      file.copy("report.docx", file, overwrite = TRUE)
    }
  )
  
}

# Run the application 
shinyApp(ui = ui, server = server)