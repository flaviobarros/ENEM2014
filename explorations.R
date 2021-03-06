## Carregando pacotes
library(dplyr)

## Dados da minha escola
load('escolas.rda')

## Filtrando pela escola
horacio = filter(escolas, grepl(pattern = 'HORACIO AUGUSTO', x=escolas$'NOME DA ENTIDADE'))

## Obtendo as m�dias
medias = horacio[, grepl(pattern = 'M�DIA -', 
                         x = colnames(horacio))]
barplot(as.matrix(horacio[, grepl(pattern='M�DIA -', 
                                  x = colnames(horacio))]))

## Exemplo de consulta: Indicador ENEM2014, UF = SP
resultado = select(escolas, escola, UF, cidade, dep_administrativa, ENEM_2014) %>%
            filter(UF == 'SP') %>%
            arrange(desc(ENEM_2014))
