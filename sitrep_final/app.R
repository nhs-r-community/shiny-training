
library(tidyverse)
library(lubridate)
library(DT)

load("ShinyContactData.rda")

ui <- fluidPage(
  
  # Application title
  titlePanel("Sitrep"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      selectInput("groupBy", "Group by 1 or 2",
                  choices = c("Group1", "Group2")),
      selectInput("weekMonth", "Group by week or month", 
                  choices = c("Week" = "Week", "Month")),
      selectInput("year", "Select year(s)", 
                  choices = unique(ShinyContactData$Year),
                  multiple = TRUE, selected = max(ShinyContactData$Year)),
      selectInput("status", "Filter by status (defaults to all)",
                  choices = unique(ShinyContactData$Status),
                  multiple = TRUE)
    ),
    mainPanel(
      DTOutput("table")
    )
  )
)


# Define server logic required to draw a histogram
server <- function(input, output) {
  
  returnData <- reactive({
    
    return_data <- ShinyContactData
    
    if(isTruthy(input$status)){
      
      return_data <- ShinyContactData %>% 
        filter(Status %in% input$status)
    }
    
    return_data %>% 
      filter(Year %in% input$year) %>%
      rename(group_variable = .data[[input$groupBy]]) %>% 
      group_by(.data[[input$weekMonth]], group_variable) %>% 
      summarise(count = n()) %>% 
      ungroup() %>% 
      spread(., group_variable, count)
  })
  
  output$table <- renderDT({
    
    returnData()
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
