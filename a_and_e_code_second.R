
# conditional panel----

conditionalPanel(
  condition = ####,
  uiOutput("trustControl")
)

# dynamic UI----

# ui 

uiOutput("trustControl")

# server

output$trustControl <- renderUI({
  
  #...
})

# validating the state of the application----

validate(need(input$something, "Please do..."))

req(input$something)

