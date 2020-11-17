
ui <- dashboardPage(
  dashboardHeader(),
  dashboardSidebar(
    sidebarMenu(id = "tabset",
                menuItem("Graph", tabName = "graph", icon = icon("dashboard")),
                menuItem("Map", tabName = "map", icon = icon("th"))
    ),
    dateRangeInput()
  ),
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "graph",
              fluidRow(plotOutput("graph"),
                       uiOutput("trustControl"))
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
