
### layout

# take out sidebar panel and replace with:

fluidRow(
  column(3,
         # inputs
  ),
  
  column(9, 
         # outputs
  )
)

### RMarkdown report

# UI

downloadButton("downloadReport", "Download report")

# server

output$downloadReport <- downloadHandler(
  filename = "report.docx",
  content = function(file){
    
    params <- list(date_from = input$date[1],
                   date_to = input$date[2],
                   trust = input$trust)
    
    render("report.Rmd", output_format = "word_document",
           output_file = "report.docx", quiet = TRUE, params = params,
           envir = new.env(parent = globalenv()))
    
    # copy docx to 'file'
    file.copy("report.docx", file, overwrite = TRUE)
  }
)

# RMarkdown

# YAML

---
  title: "A and E report"
date: "`r format(Sys.time(), '%d %B, %Y')`"
params: 
  date_from : NA
date_to : NA
trust : NA
---
  
  # R
  
  load("ae_attendances.RData")

report_data <- ae_attendances %>% 
  filter(period >= date_from, period <= date_to,
         Name == trust)