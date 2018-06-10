library(shiny)
library(dplyr)

server <- shinyServer(function(input, output, session) {
  
  infile <- "./data.csv"
  outfile <- "./out.csv"
  
  values <- reactiveValues(d = read.csv(infile, header=TRUE, sep=",", quote="", stringsAsFactors=FALSE))
  
 # genre.list <- reactive({ unique(values[['d']]$genre) })  ##also works
  genre.list <- reactive({ unique(values$d$genre) })
  
  
  output$genreSelector <- renderUI({
    selectizeInput(inputId ="genre", label="Genre:", choices=genre.list())
  })
  
  output$genreSelector2 <- renderUI({
    selectizeInput(inputId = "genre2", label="Genre:", choices = genre.list(), selected=NULL)
  })
  
   
  getGenre2 <- reactive({input$genre2})
  
  
  observeEvent(input$click, {
    newrow <-c(input$genre, input$artist, input$title, input$url)
    values$d <- rbind(values$d, newrow)
    
    write.csv( isolate(values$d), file=infile, na="NA", quote=FALSE, row.names=FALSE)
    updateTextInput(session, "artist", value = " ") 
    updateTextInput(session, "title", value = " ") 
    updateTextInput(session, "url", value = " ")}) 
  
 
  observeEvent(input$genre2, {
    cat(file=stderr(), "genre2:", getGenre2(), "\n")
    values$d2 <- values[['d']][values[['d']]$genre == getGenre2(),]
    htm <- ""
    for(i in 1:nrow(values$d2)){
      htm <- paste(htm, values$d2[i,"artist"], "&nbsp&nbsp&nbsp&nbsp&nbsp", "<a href=", values$d2[i,"url"], ">", values$d2[i,"title"], "</a><br>", sep="")
    }
    output$text1 <- renderText({ htm })
    
    artist.list <- unique(values$d2$artist)
    output$artistSelect <- renderUI({
      selectizeInput(inputId = "artist1", label="Artist:", choices = artist.list, selected=NULL)
    })
  })
  
    
  observeEvent(input$artist1, {
    d3 <- values$d2[values$d2$artist == input$artist1,]
    htm <- ""
    for(i in 1:nrow(d3)){
      htm <- paste(htm, d3[i,"artist"], "&nbsp&nbsp&nbsp&nbsp&nbsp", "<a href=", d3[i,"url"], ">", d3[i,"title"], "</a><br>", sep="")
    }
    output$text1 <- renderText({ htm })
    
  })
  
  
  observeEvent(input$backup, { 
    
    fileName <- sprintf("%s_%s.csv", as.integer(Sys.time()), digest::digest(data))
    # Write the file to the local system
    write.csv(
      values$d,
      file = paste("./", fileName, sep=""), 
      row.names = FALSE, quote = FALSE
    )
  
    output$backuptext <- renderText({ paste("File:", fileName, "written to disk.", sep=" ")})
    })
  
  output$table.output <- DT::renderDataTable(DT::datatable(values$d))
  
  
})