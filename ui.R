
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(pageWithSidebar(
  
  headerPanel(""),
  
  sidebarPanel(
    uiOutput("choose_dataset"),
    
    uiOutput("choose_columns"),
    br(),
    a(href = "https://gist.github.com/4211337", "Source code")
  ),
  
  
  mainPanel(
    tableOutput("data_table")
  )
))