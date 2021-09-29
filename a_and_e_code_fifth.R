
ui <- dashboardPage(
  dashboardHeader(),
  dashboardSidebar(
    sidebarMenu(id = "tabset",
                menuItem("Graph", tabName = "graph", icon = icon("dashboard")),
                menuItem("Map", tabName = "map", icon = icon("th"))
    ),
    uiOutput("dateRangeUI")
  ),
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "graph",
              fluidRow(plotOutput("graph"),
                       selectInput("trust",
                                   "Select Trust",
                                   choices = unique(ae_attendances$Name),
                                   multiple = TRUE))
      ),
      
      # Second tab content
      tabItem(tabName = "map",
              box(
                leafletOutput()
              )
      )
    )
  )
)

# https://rstudio.github.io/shinydashboard/structure.html#valuebox

# ui

valueBox()

# Dynamic valueBoxes

valueBoxOutput("daysBox")

# server

output$daysBox <- renderValueBox({
  valueBox(
  )
})
