
# at the top of the code file

library(tidyverse)
library(lubridate)
library(DT)

load("ShinyContactData.rda")

# ui

selectInput()

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