
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