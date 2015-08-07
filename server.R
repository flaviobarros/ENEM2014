
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
    
    cidades = escolas %>% select(UF, cidade) %>% 
      filter(UF == input$estado) %>% select(cidade) %>% distinct(cidade)
    
    selectInput('cidade', 'Cidade', multiple = T,
                choices = cidades, selected = 'SAO PAULO')
    
  })
  
  # Campo da escola
  output$choose_escola <- renderUI({
    
    escolas_cidade = escolas %>% select(escola, cidade, UF) %>%
                     filter(UF == input$estado) %>% filter(cidade == input$cidade) %>%
                     select(escola)
    selectInput('escola', 'Encontre sua escola:', multiple = T,
                choices = escolas_cidade)
    
  })
  
  # Check boxes
  output$choose_columns <- renderUI({
    # If missing input, return to avoid error later in function
    
    # Get the data set with the appropriate name
    # Obtendo colunas
    tipos = sapply(escolas, class)
    categorias = names(escolas)[!(tipos == 'numeric')]
    
    # Retirando as colunas UF, cidade e escola
    retirar = c('UF', 'cidade', 'escola')
    categorias = categorias[which(!(categorias %in% retirar))]
    
    # Create the checkboxes and select them all by default
    selectInput("columns", "Choose columns", multiple = T,
                choices  = categorias,
                selected = categorias[1])
  })
  
  
  # Output the data
  output$data_table <- renderTable({
    
    # Get the data set
    dat <- escolas
    
    # Pegando as colunas
    colunas <- c(input$columns, input$indicador)
    
    # Keep the selected columns
    dat <- dat[, colunas, drop = FALSE]
  
    # Seleciona escola
#     print(input$escola)
#     if((input$escola != '')) {
#       
#       dat = cbind(dat, escolas$escola)
#       dat = dat %>% filter(grepl(pattern = input$escola, x=escola)) %>%
#             select(which(colunas %in% colnames(dat)))
#     }
    
    # Tabela ordenada
    sorted_stats <- eval(substitute(dat %>% arrange(desc(col)), 
                                    list(col=as.symbol(input$indicador))))
    # Return first 20 rows
    head(sorted_stats, 20)
  })
})