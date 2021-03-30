
# server

returnData <- reactive({
  
  ShinyContactData %>% 
    filter(...) %>% 
    group_by(...) %>% 
    summarise(...)

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
