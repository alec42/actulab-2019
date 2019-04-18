## Alec James van Rassel, Ian Shaink, Nicolas Gagnon
## Actulab 2019: Problématique Cooperators
### Mise en oeuvre d'algorithme de web scrapping pour déterminer des probabilités sur si des compagnies sont des coopéartives
### importation des packages
library(shiny)
source("global.R")
source("functions.R")

ui <- fluidPage(
    tabsetPanel( #nous créons deux onglets pour le user input et pour un fichier CSV
        tabPanel("User Input", fluid = T,
    sidebarPanel(textInput("cie", "Function:", ""),
                 actionButton("process", label = "Enter")),
    mainPanel(
        h4("Probabilité qu'une compagnie soit une coopérative"),
        tableOutput(outputId = "view")
    )
    
        ),
    tabPanel("CSV File", fluid = T,
             titlePanel("Uploading Files"),
             sidebarLayout(
                 sidebarPanel(
                     fileInput('file1', 'Choose file to upload',
                               accept = c(
                                   'text/csv',
                                   'text/comma-separated-values',
                                   'text/tab-separated-values',
                                   'text/plain',
                                   '.csv',
                                   '.tsv'
                               )
                     ),
                     tags$hr(),
                     checkboxInput('header', 'Header', TRUE),
                     radioButtons('sep', 'Separator',
                                  c(Comma=',',
                                    Semicolon=';',
                                    Tab='\t'),
                                  ';'),
                     radioButtons('quote', 'Quote',
                                  c(None='',
                                    'Double Quote'='"',
                                    'Single Quote'="'"),
                                  '"'),
                     
                     actionButton("processCSV", label = "Enter"),
                     tags$hr(),
                     p("À noter que l'application peut traiter jusqu'à environ un maximum de 300 données avant d'être bloquée (temporairement) par Google. Également, il utilise l'API de Google Maps qui est limité à 25 000 requêtes gratuites par jour. Ces problèmes peuvent être réglés en payant Google pour leur API de recherche.")
                 ),
                 mainPanel(
                     tableOutput('contents')
                 )
             ))
))

server <- function(input, output) {
    # render la table pour le user input
    output$view <- renderTable({
        input$process
        runall(isolate(input$cie))
    })
    # rennder la table pour le fichier CSV
    output$contents <- renderTable({
        input$processCSV
        
        inFile <- isolate(input$file1)
        
        if (is.null(inFile))
            return(NULL)
        
        data <- read.csv(inFile$datapath, header = input$header,
                 sep = input$sep, quote = input$quote)
        runallvec(as.matrix(data[, 1]))
        
    })
    
    
}

shinyApp(ui = ui, server = server)