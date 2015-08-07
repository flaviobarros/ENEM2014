## Carregando pacotes
library(dplyr)

## Dados da minha escola
load('escolas.rda')

## Filtrando pela escola
horacio = filter(escolas, grepl(pattern = 'HORACIO AUGUSTO', x=escolas$'NOME DA ENTIDADE'))

## Obtendo as m�dias
medias = horacio[, grepl(pattern = 'M�DIA -', x = colnames(horacio))]
barplot(as.matrix(horacio[, grepl(pattern='M�DIA -', x = colnames(horacio))]))