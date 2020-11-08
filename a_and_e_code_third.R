
### layout

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
  content = function(file){
    
    params <- list(date_from = input$date[1],
                   date_to = input$date[2],
                   trust = input$trust)
    
    render(paste0("report.Rmd"), output_format = "word_document",
           output_file = "report.docx", quiet = TRUE, params = params,
           envir = new.env(parent = globalenv()))
    
    # copy docx to 'file'
    file.copy(paste0("report.docx"), file, overwrite = TRUE)
  }
)

# RMarkdown

# YAML

params: 
  date_from : NA
date_to : NA
trust : NA
output: html_document

# R

load("ae_attendances.RData")

report_data <- ae_attendances %>% 
  filter(period >= date_from, period <= date_to,
         Name == trust)