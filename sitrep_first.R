
# at the top of the code file

library(tidyverse)
library(lubridate)
library(DT)

load("ShinyContactData.rda")

# ui

selectInput()
DTOutput()
plotOutput()

# server

output$table <- renderDT({
  
  ShinyContactData %>% 
    filter(Year %in% input$year,
           Status %in% input$status) %>%
    group_by(Month, Group1) %>% 
    summarise(count = n()) %>% 
    ungroup() %>% 
    spread(., Group1, count)
})

output$graph <- renderPlot({
  
  ShinyContactData %>% 
    filter(Year %in% input$year,
           Status %in% input$status) %>%
    group_by(Month, Group1) %>% 
    summarise(count = n()) %>% 
    ungroup() %>% 
    ggplot(aes(x = Month, y = count, colour = Group1)) +
    geom_line()
})