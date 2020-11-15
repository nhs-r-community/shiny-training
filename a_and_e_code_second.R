
# conditional panel----

input$tabset == "map" # test for this

conditionalPanel(
  condition = ####,
    selectInput("trust",
                "Select Trust",
                choices = unique(ae_attendances$Name),
                multiple = TRUE)
  
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

