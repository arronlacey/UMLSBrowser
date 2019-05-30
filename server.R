#setwd('/srv/shiny_server/umlsbrowser')
#deployApp()
rm(list = ls())
library(shiny)
library(dplyr)
library(DT)
umls <- dbConnect(drv=RSQLite::SQLite(), 
                  dbname="umls_browser.sqlite3")
licenseCode <- "NLM-407569992"


shinyServer(function(input, output) {
  
  source('ui1.R') #login page
  source('ui2.R') # UMLS page
  options(DT.options = list(iDisplayLength = 100, scrollX = TRUE))
  df<-NULL
  
  
  output$page <- renderUI({ ui1 })
  
  # code here from Untitled2
  observeEvent(input$login,{
    output$page <- renderUI({ ui1 })
    z<-system(paste("perl", "umls_auth.pl",
                    paste0("'",input$user,"'"), paste0("'",input$password,"'")),intern=TRUE)
    if (grepl("false",z[22])) {
      #output$page <- renderUI({ ui1 })
      renderText("Incorrect credentials")
    }
    if (grepl("true",z[22])) 
    {
      output$page <- renderUI({ ui2 })
      
      #output <- reactiveValues(table = NULL)
      
      observeEvent(input$do2, {
        if (input$rd == "exact"){
          df<<-as.data.frame(dbGetQuery(umls, 
                                        paste0("SELECT DISTINCT CUI, SAB, CODE, STR FROM MRCONSO
                                               WHERE STR ='", input$term ,"'",sep="")))
          output$table<-renderDT({as.data.frame(dbGetQuery(umls, 
                                                           paste0("SELECT DISTINCT CUI, SAB, CODE, STR FROM MRCONSO
                                                                  WHERE STR ='", input$term ,"'",sep="")))
            
          },class = "display nowrap compact",filter = "top",server=TRUE)
        }
      })
      
      observeEvent(input$do0, {
        inFile <- input$uploaded
        dat<-read.csv(inFile$datapath,header=FALSE)
        names(dat)<-"CODE"
        con <- dbConnect(SQLite())
        dbWriteTable(umls,"uploaded", dat,overwrite=TRUE)
        if (input$rd == "exact"){
          
          df<<-as.data.frame(dbGetQuery(umls, 
                                        paste0("SELECT DISTINCT c.CUI, c.SAB, a.CODE as MAPPED,b.CODE as ORIG, c.STR FROM uploaded b
                                               left join MRCONSO a
                                               on a.CODE = b.CODE
                                               left join MRCONSO C
                                               on a.CUI = c.CUI",sep="")))
          output$table<-renderDT({as.data.frame(dbGetQuery(umls, 
                                                           paste0("SELECT DISTINCT c.CUI, c.SAB, a.CODE as MAPPED,b.CODE as ORIG, c.STR FROM uploaded b
                                                                  left join MRCONSO a
                                                                  on a.CODE = b.CODE
                                                                  left join MRCONSO C
                                                                  on a.CUI = c.CUI",sep="")))
            
          },class = "display nowrap compact",filter = "top",server=TRUE)
        }
      })
      
      observeEvent(input$do1, {
        if (input$rd == "exact"){
          
          df<<-as.data.frame(dbGetQuery(umls, 
                                        paste0("SELECT DISTINCT CUI, SAB, CODE, STR FROM MRCONSO
                                               WHERE CUI ='", input$code ,"'",sep="")))
          output$table<-renderDT({as.data.frame(dbGetQuery(umls, 
                                                           paste0("SELECT DISTINCT CUI, SAB, CODE, STR FROM MRCONSO
                                                                  WHERE CUI ='", input$code ,"'",sep="")))
            
          },class = "display nowrap compact",filter = "top",server=TRUE)
        }
      })
      
      
      observeEvent(input$do2, {
        if (input$rd == "CHD" || input$rd == "PAR" || input$rd == "SIB"){
          
          df<<-as.data.frame(dbGetQuery(umls, 
                                        paste0("SELECT DISTINCT B.CUI2 as CUI, C.SAB, C.CODE, C.STR FROM MRCONSO A 
                                               INNER JOIN MRREL B ON A.CUI = B.CUI1 
                                               INNER JOIN MRCONSO C ON B.CUI2 = C.CUI 
                                               WHERE B.REL = '", input$rd ,"'","AND A.STR ='", input$term ,"'",sep="")))  
          output$table<-renderDT({as.data.frame(dbGetQuery(umls, 
                                                           paste0("SELECT DISTINCT B.CUI2 as CUI, C.SAB, C.CODE, C.STR FROM MRCONSO A 
                                                                  INNER JOIN MRREL B ON A.CUI = B.CUI1 
                                                                  INNER JOIN MRCONSO C ON B.CUI2 = C.CUI 
                                                                  WHERE B.REL = '", input$rd ,"'","AND A.STR ='", input$term ,"'",sep="")))
          },class = "display nowrap compact",filter = "top",server=TRUE)
          }
          })
      #output$table <- renderDT({res()})
      observeEvent(input$do1, {
        if (input$rd == "CHD" || input$rd == "PAR" || input$rd == "SIB"){
          
          df<<-as.data.frame(dbGetQuery(umls, 
                                        paste0("SELECT DISTINCT B.CUI2 as CUI, C.SAB, C.CODE, C.STR FROM MRCONSO A 
                                               INNER JOIN MRREL B ON A.CUI = B.CUI1 
                                               INNER JOIN MRCONSO C ON B.CUI2 = C.CUI 
                                               WHERE B.REL = '", input$rd ,"'","AND B.CUI1 ='", input$code ,"'",sep="")))  
          
          output$table<-renderDT({as.data.frame(dbGetQuery(umls, 
                                                           paste0("SELECT DISTINCT B.CUI2 as CUI, C.SAB, C.CODE, C.STR FROM MRCONSO A 
                                                                  INNER JOIN MRREL B ON A.CUI = B.CUI1 
                                                                  INNER JOIN MRCONSO C ON B.CUI2 = C.CUI 
                                                                  WHERE B.REL = '", input$rd ,"'","AND B.CUI1 ='", input$code ,"'",sep="")))
            #return(df)
            
          },class = "display nowrap compact",filter = "top",server=TRUE)
        }
      })
      
      observeEvent(input$do3, {
        if (input$rd == "exact" || input$rd == "CHD" || input$rd == "PAR" || input$rd == "PAR"){
          
          df<<-as.data.frame(dbGetQuery(umls, input$query,sep=""))
          output$table<-renderDT({as.data.frame(dbGetQuery(umls, input$query,sep=""))
            
          },class = "display nowrap compact",filter = "top",server=TRUE)
        }
      })
      
      observeEvent(input$extension, {
        if (input$extension == "csv"){
          output$downloadData <- downloadHandler(
            filename = function() { 
              paste(input$downloadData, "",".csv",sep="") 
            },
            content = function(file) {
              write.csv(df[input[["table_rows_all"]],],file,row.names=F)
            }
          ) 
        }
        
        else if (input$extension == "lst"){
          output$downloadData <- downloadHandler(
            filename = function() { 
              paste(input$downloadData, "",".lst",sep="") 
            },
            content = function(file) {
              fileConn<-file(file)
              writeLines(paste0(df[input[["table_rows_all"]],c("STR")],"\tCUI=",df[input[["table_rows_all"]],c("CUI")],
                                "\tPREF=",df[input[["table_rows_all"]],c("STR")]), fileConn)
              close(fileConn)
              
            }
          ) 
        }
      })
          }
        })
  
      })
