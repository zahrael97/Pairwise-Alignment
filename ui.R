  library(shiny)
library(shinydashboard)
#library(msa)

sidebar <-   dashboardSidebar(
  collapsed = TRUE,
  sidebarMenu(
    menuItem("Pairwise Alignment", tabName = "main_app"),
    menuItem("Information", tabName = "information", icon = icon("info-circle"))
    
  )
)
information <- tabItem(
  tabName = "information",
  verticalLayout(
    box(width = NULL,
       
        p(span(strong("L algorithme de smith waterman"))," est un algorithme d alignment de sequences utilise notamment en bioinformatique. il a ete invente par Temple F.Smith et Michael S Waterman en 1981."),
        p(span(strong("L algorithme de smith waterman"))," est un algorithme optimal qui donne un alignement correspondant au meilleur score possible de correspondance entre les acides amines ou les nucleotides des deux sequences. Le calcul de ce score repose sur l utilisation de matrices de similarite ou matrices de substitution.")
         )
  )
)
main_app <- tabItem(
  tabName = "main_app",
  verticalLayout(
    
    # inputs
    box(
      title = " Choix 1 :", width = NULL,
      solidHeader = TRUE, status = "info", collapsible = TRUE,
      
      fluidRow(
        column(width = 6, fileInput("protein1",label = NULL,multiple = FALSE,accept =c( ".fasta"))),
        
        column(width = 6,fileInput( "protein2", label = NULL, multiple=FALSE, accept =c(".fasta")))
      ),
      verbatimTextOutput(outputId = "text"),
      plotOutput('plot1',height = "500px"),
      plotOutput('map',height = "500px")
      
     
    ),
    
    # outputs
    box( 
      
      title = "Choix 2 :", width = NULL,
      solidHeader = TRUE, status = "info",collapsible = TRUE,
      fluidRow(
        column(width = 6,textInput(inputId = "x",label = "Sequence1:")),
        
        column(width = 6,textInput(inputId = "y",  label = "Sequence2:"))
      ),
      
      actionButton("submit", "Submit"),

      verbatimTextOutput(outputId = "text2"),
      plotOutput('plot2',height = "500px"),
      plotOutput('map2',height = "500px")
      
      )
     
 
   
  )
)

body <- dashboardBody(
  tabItems(
    information, 
    main_app
  )
)


dashboardPage(skin = "blue",
              dashboardHeader(title = "Pairwise Alignment"),
              sidebar,
              body)

