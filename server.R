
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
    selectInput("indicador", "Selecione indicador", indicadores, 
                selected = indicadores[length(indicadores)])
  })
  
  # Campo da estado
  output$choose_estado <- renderUI({
    
    estados = c('AC', 'AL', 'AM', 'AP', 'BA', 'CE', 'DF',
                'ES', 'GO', 'MA', 'MG', 'MS', 'MT', 'PA',
                'PB', 'PE', 'PI', 'PR', 'RJ', 'RN', 'RO',
                'RR', 'RS', 'SC', 'SE', 'SP', 'TO')
    
    selectInput('estado', 'Estado:', multiple = T, 
                choices = estados,
                selected = 'SP')
    
  })
  
  # Campo da cidade
  output$choose_cidade <- renderUI({
    
    if(is.null(input$estado)) {
      return()
    }
 
      
      cidades = escolas %>% select(UF, cidade) %>% 
        filter(UF == input$estado) %>% select(cidade) %>% distinct(cidade)
   
    selectInput('cidade', 'Cidade', multiple = T,
                choices = cidades, selected = 'SAO PAULO')
    
  })
  
  # Campo da escola
  output$choose_escola <- renderUI({
    
    if (is.null(input$cidade)) {
      
      return()
    } else if (is.null(input$estado)) {
      
      return()
    }
      
      escolas_cidade = escolas %>% select(escola, cidade, UF) %>%
        filter(UF == input$estado) %>% filter(cidade == input$cidade) %>%
        select(escola)

    selectInput('escola', 'Encontre sua escola:', multiple = T,
                choices = escolas_cidade)
    
  })
  
  # Output the data
  output$data_table <- renderTable({
    
    # Consultando a tabela
    if (is.null(input$estado) || is.null(input$cidade)) {
      
      return()
    }
    
    if (is.null(input$columns)) {
      
      dat = escolas %>% select(escola, cidade, UF, RANKING) %>%
        filter(UF == input$estado) %>% filter(cidade == input$cidade) %>%
        select(escola, RANKING)
      
        head(dat, 20)
    
    } else  if (is.null(input$escola)) {
      
      # Keep the selected columns
      dat <- subset(escolas, select = c('escola', 'cidade', 'UF', input$columns), drop = F)
      
      # Filtrando cidade e estado
      dat <- dat %>% 
        filter(UF == input$estado) %>% filter(cidade == input$cidade) 
      
      head(dat, 20)
      
    } else {
      
      # Keep the selected columns
      dat <- subset(escolas, select = c('escola', 'cidade', 'UF', input$columns), drop = F)
      
      dat = dat %>% 
        filter(UF == input$estado) %>% filter(cidade == input$cidade) %>%
        filter(escola %in% input$escola)
      
    }
    
      
      
    

  })
  
  # Check boxes
  output$choose_columns <- renderUI({
    
    if (is.null(input$cidade)) {
      
      return()
      
    } else {
      
      tipo = sapply(escolas, class)
      colunas = colnames(escolas)[tipo == 'numeric']
      
      # Create the checkboxes and select them all by default
      checkboxGroupInput("columns", "Escolha os indices:", 
                         choices  = colunas,
                         selected = colunas[length(colunas)])
    }
      
  })
})