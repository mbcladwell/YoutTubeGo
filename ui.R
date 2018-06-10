library(shiny)
library(dplyr)

ui <- shinyUI(fluidPage(
  
  mainPanel(
    
    # Output: Tabset w/ plot, summary, and table ----
    tabsetPanel(type = "tabs",
                tabPanel("Add", 
                         
                         textInput("artist", label = h3("Artist"), value = ""),
                         textInput("title", label = h3("Title"), value = ""),
                         uiOutput("genreSelector"),
                         textInput("url", label = h3("URL"), value = ""),
                         actionButton("click", label = "ADD")          
                         
                         ),
                tabPanel("Query",  
                           shinyUI(fluidPage(
                             uiOutput("genreSelector2"),
                             if(!is.null("genreSelector2")) uiOutput("artistSelect"),
                     h4("Artist Title"),
               
                    htmlOutput("text1")
                  
                ))), 
               tabPanel("Table",  DT::dataTableOutput("table.output")),
               tabPanel("Utilities", actionButton("backup", label = "Backup"),
                        htmlOutput("backuptext") )
               
               ))))


