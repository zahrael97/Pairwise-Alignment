require(Biostrings)
#-----------------------
library(seqinr)
library(Biostrings)
library(msa)
library(plyr)
#library(dplyr)
library(stringr)
library(ggplot2)
#library(jn.general)
library(data.table)
library(shiny)

shinyServer(function(input, output) {  
  #files
  
  seq1 <- eventReactive(input$protein1, {
    req(paste(read.fasta(input$protein1$datapath,seqtype = "AA", as.string = TRUE),collapse = ",")) })
  seq2 <- eventReactive(input$protein2, {
    req(paste(read.fasta(input$protein2$datapath, seqtype = "AA", as.string = TRUE),collapse = ",")) })
  
  output$text <- renderPrint({
    
    print(seq1())
    print(seq2())
    data("BLOSUM62")
    p<-pairwiseAlignment(pattern = seq1(), subject = seq2(),substitutionMatrix = "BLOSUM62",
                         gapOpening = 0, gapExtension = -8,scoreOnly = FALSE,type="local")
    
    print(p)
  })
  
  output$plot1<-renderPlot({
    split_word <- function(word) str_split(word, boundary("character"))[[1]]
    
    split_x <- split_word( paste0(seq1()) )
    split_y <- split_word( paste0(seq2()) )
    print(split_x)
    print(split_y)
    dotPlot(split_x,split_y,xlab = seq1(), ylab = seq2(),col = c("sky blue","blue"))
  })
  #MAP
  output$map<-renderPlot({
    
    split_word <- function(word) str_split(word, boundary("character"))[[1]]
    
    split_x <- split_word( paste0(seq1()) )
    split_y <- split_word( paste0(seq2()) )
    print(split_x)
    print(split_y)
    s <- BLOSUM62[split_y,split_x]; 
    d <- 8 ;
    mtr <- matrix(data=NA,nrow=(length(split_y)+1),ncol=(length(split_x)+1)); 
    mtr[1,] <- 0 ; 
    mtr[,1] <- 0 ; 
    rownames(mtr) <- c("",split_y); 
    colnames(mtr) <- c("",split_x) ;
    for (i in 2:(nrow(mtr))) 
      for (j in 2:(ncol(mtr))) 
      {
        mtr[i,j] <- max(c(0,mtr[i-1,j-1]+s[i-1,j-1],mtr[i-1,j]-d,mtr[i,j-1]-d)) 
      }
    #HEATMAP
    redgreen <- c("blue", "yellow") 
    pal <- colorRampPalette(redgreen)(100)
    heatmap(mtr, Rowv=NA, Colv=NA, col = pal, scale="column", margins=c(5,0))
  })
  
  #text------------------------------------------------------------------------------------------------------------------
  #text
  sequence1<-eventReactive(input$submit, {
    req(s2c(paste(input$x, collapse = "")))
    })
  
  sequence2 <- eventReactive(input$submit, {
    req(s2c(paste(input$y, collapse = "")))
  })
  output$text2 <- renderPrint({
    
    print(sequence1())
    print(sequence2())
    data("BLOSUM62")
    p<-pairwiseAlignment(pattern = sequence1(), subject = sequence2(),substitutionMatrix = "BLOSUM62",
                         gapOpening = 0, gapExtension = -8,scoreOnly = FALSE,type="local")
    
    print(p)
  })
  
  output$plot2 <- renderPlot({
  
   print(sequence1())
   print(sequence2())
   
   dotPlot(sequence1(), sequence2(),col = c("sky blue", "blue"))
  })
  
  #tttttttttt----------------------------------------xxxxxxxxxxxxxxxxxxxx-------------------tttttttttttttttttttttttttttt
  
  
  
  
  
  
  
  
  
})
 