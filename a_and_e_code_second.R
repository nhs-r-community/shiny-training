
# conditional panel----

input$tabset == "graph" # test for this

mainPanel(
  tabsetPanel(id = "tabset", # need id
              tabPanel("Graph", value = "graph", plotOutput("graph")),
              tabPanel("Map", value = "map", 
                       leafletOutput("trustMap", height = 600, width = 500)
              ))
)

conditionalPanel(
  condition = ####,
    uiOutput("trustControl")
  
)

# dynamic UI----

# ui 

uiOutput("trustControl")

# server

output$trustControl <- renderUI({
  
  selectInput("trust",
              "Select Trust",
              choices = unique(ae_attendances$Name),
              multiple = TRUE)
})

# validating the state of the application----

validate(need(input$something, "Please do..."))

req(input$something)

