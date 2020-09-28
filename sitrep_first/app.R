
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
      selectInput("year", "Select year(s)", 
                  choices = unique(ShinyContactData$Year),
                  multiple = TRUE, 
                  selected = max(ShinyContactData$Year)),
      selectInput("status", "Filter by status",
                  choices = unique(ShinyContactData$Status),
                  multiple = TRUE, 
                  selected = unique(ShinyContactData$Status))
    ),
    mainPanel( 
      DTOutput("table")
    )
  )
)


# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$table <- renderDT({
    
    ShinyContactData %>% 
      filter(Year %in% input$year,
             Status %in% input$status) %>%
      group_by(Month, Group1) %>% 
      summarise(count = n()) %>% 
      ungroup() %>% 
      spread(., Group1, count)
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
