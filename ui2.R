# load umls MRCONSO and MRREL tables
library(shinythemes)
library(DT)
ui2<-  shinyUI(fluidPage(theme = shinytheme("cerulean"),
                         
                         # Application title
                         titlePanel("UMLS Browser"),
                         paste0("UMLS tables when querying this browser:"),
                         a("MRCONSO", 
                           href="https://www.ncbi.nlm.nih.gov/books/NBK9685/table/ch03.T.concept_names_and_sources_file_mr/",target="_blank"),
                         paste0("and"),
                         a("MRREL", 
                           href="https://www.ncbi.nlm.nih.gov/books/NBK9685/table/ch03.T.related_concepts_file_mrrel_rrf/?report=objectonly",target="_blank"),
                         
                         # Sidebar with a slider input for number of bins 
                         sidebarLayout(
                           sidebarPanel(tags$head(
                             tags$style(type="text/css", "select { max-width: 180px; }"),
                             tags$style(type="text/css", ".span4 { max-width: 430px; }"),
                             tags$style(type="text/css", ".well { max-width: 430px; }")
                           ), style = "position:fixed;width:inherit;",
                           radioButtons("rd",
                                        label = "Query type:",
                                        choices = list("Exact" = "exact",
                                                       "Child of" = "CHD",
                                                       "Parent of" = "PAR",
                                                       "Sibling of" = "SIB"),
                                        selected = "exact"),
                           tags$style(HTML('#q1 {margin-top: 30px}')),
                           splitLayout(cellWidths = c("75%", "25%"), 
                                       fileInput("uploaded", "Map csv/txt file of codes (exact mode only)",
                                                 multiple = TRUE,
                                                 accept = c("text/csv",
                                                            "text/comma-separated-values,text/plain",
                                                            ".csv")),
                                       actionButton("do0", "Map")
                           ),
                           
                           splitLayout(cellWidths = c("70%", "30%"), 
                                       textInput("code",NULL,""),
                                       actionButton("do1", "Search Code")
                           ),
                           
                           splitLayout(cellWidths = c("70%", "30%"), 
                                       textInput("term",NULL,""),
                                       actionButton("do2", "Search Term")
                           ),
                           
                           splitLayout(cellWidths = c("70%", "30%"), 
                                       textInput("query",NULL,""),
                                       actionButton("do3", "Custom Query")
                           ),
                           
                           textInput("downloadData","",value="mydata"),
                           
                           splitLayout(cellWidths = c("50%", "50%"),
                                       downloadButton('downloadData','Save my file!'),
                                       radioButtons("extension",
                                                    label = "File type",
                                                    choices = list(".csv" = "csv",
                                                                   ".lst" = "lst"))
                           ),
                           
                           
                           tags$style(type='text/css', "#uploaded { width:100%; margin-top: 25px;}"),
                           tags$style(type='text/css', "#do0 { width:100%; margin-top: 25px;}")
                           
                           ),
                           mainPanel(tags$head(
                             tags$style(type="text/css", "select { max-width: 180px; }"),
                             tags$style(type="text/css", ".span4 { max-width: 1170px; }"),
                             tags$style(type="text/css", ".well { max-width: 1170px; }")
                           ),
                           
                           DTOutput("table")
                           #tableOutput("table2")
                           
                           )
                         )
)
)
