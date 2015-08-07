
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(dplyr)

load('escolas.rda')

shinyServer(function(input, output) {
  
  # Obtendo colunas
  tipos = sapply(escolas, class)
  indicadores = as.list(colnames(escolas)[tipos == 'numeric'])
  
  # Drop-down selection box for which data set
  output$choose_indicator <- renderUI({
    selectInput("indicador", "Selecione indicador", indicadores)
  })
  
  # Check boxes
  output$choose_columns <- renderUI({
    # If missing input, return to avoid error later in function
    
    # Get the data set with the appropriate name
    # Obtendo colunas
    tipos = sapply(escolas, class)
    categorias = names(escolas)[!(tipos == 'numeric')]
    
    # Create the checkboxes and select them all by default
    selectInput("columns", "Choose columns", multiple = T,
                       choices  = categorias,
                       selected = categorias[1])
  })
  
  # Campo da escola
  output$choose_escola <- renderUI({
    
    textInput('escola', 'Encontre sua escola:')
    
  })
  
  
  # Output the data
  output$data_table <- renderTable({
    
    # Get the data set
    dat <- escolas
    
    # Pegando as colunas
    colunas <- c(input$columns, input$indicador)
    
    # Keep the selected columns
    dat <- dat[, colunas, drop = FALSE]
    print(is.null(input$escola))
    print(input$escola)
    # Seleciona escola
    if(!is.null(output$escola)) {
      
      dat = cbind(dat, escolas$escola)
      dat = dat %>% filter(grepl(pattern = input$escola))
    }
    
    # Tabela ordenada
    sorted_stats <- eval(substitute(dat %>% arrange(desc(col)), 
                                    list(col=as.symbol(input$indicador))))
    # Return first 20 rows
    head(sorted_stats, 20)
  })
})