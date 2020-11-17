
# server

returnData <- reactive({
  
  return_data <- ShinyContactData
  
  if(isTruthy(input$status)){
    
    ## complete
  }
  
  return_data %>% 
    
    ## complete  
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