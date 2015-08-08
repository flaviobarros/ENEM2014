
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(pageWithSidebar(
  
  headerPanel(""),
  
  sidebarPanel(
    uiOutput("choose_indicador"),
    
    uiOutput("choose_estado"),
    
    uiOutput("choose_cidade"),
    
    uiOutput("choose_escola"),
    
    uiOutput("choose_columns")
  ),
  
  
  mainPanel(
    tableOutput("data_table")
  )
))