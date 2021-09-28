
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
      DTOutput("table"),
      plotOutput("graph")
    )
  )
)


# Define server logic required to draw a histogram
server <- function(input, output) {
  
  returnData <- reactive({
    
    ShinyContactData %>% 
      filter(Status %in% input$status) %>% 
      filter(Year %in% input$year) %>%
      group_by(Month, Group1) %>% 
      summarise(count = n()) %>% 
      ungroup()
  })
  
  output$table <- renderDT({
    
    returnData() %>% 
      spread(., Group1, count)
  })
  
  output$graph <- renderPlot({
    
    returnData() %>% 
      ggplot(aes(x = Month, y = count, colour = Group1)) +
      geom_line()
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
