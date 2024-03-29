
mainPanel(
  tabsetPanel(id = "tabset", # need id
              tabPanel("Graph", value = "graph", plotOutput("graph")),
              tabPanel("Map", value = "map", 
                       leafletOutput("trustMap", height = 600, width = 500)
              ))
)

# dynamic UI----

# ui 

uiOutput("dateRangeUI")

# server

output$dateRangeUI <- renderUI({
  
  dateRangeInput("date", "Date range", 
                 min(ae_attendances$period), 
                 max(ae_attendances$period),
                 startview = "year")
})

# conditional panel----

input$tabset == "graph" # test for this

conditionalPanel(
  condition = "input.tabset == 'graph'",
    selectInput("trust",
                "Select Trust",
                choices = unique(ae_attendances$Name),
                multiple = TRUE)
)

# validating the state of the application----

validate(need(input$something, "Please do..."))

req(input$something)

