
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(pageWithSidebar(
  
  headerPanel(""),
  
  sidebarPanel(
    uiOutput("choose_indicator"),
    
    uiOutput("choose_estado"),
    
    uiOutput("choose_cidade"),
    
    uiOutput("choose_columns"),
    
    uiOutput("choose_escola")
  ),
  
  
  mainPanel(
    tableOutput("data_table")
  )
))