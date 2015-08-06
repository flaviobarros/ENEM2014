## Carreganfo os pacotes necessários
library(readxl)
library(dplyr)

## Lendo os dados da planilha
dados = read_excel(path = 'enem_escola_2014.xlsx', sheet = 1,
                     skip = 1)

## Retirando as linhas vazias da planilha
dados = dados[!is.na(dados$'CÓDIGO DA ENTIDADE'),]

## Criando a primeira tabela com as escolas
escolas = dados[,1:18]

## Juntando as notas de linguagens e códigos
lc = dados[,19:20]
colnames(lc) = c('MÉDIA DOS 30 MELHORES - LC', 'MÉDIA - LC')

## Juntado as colunas nas escolas
escolas = cbind(escolas, lc)

## Varrendo as outras planilhas e incluindo as colunas 
## das notas em outras disciplinas
disciplinas = c('RED', 'MAT', 'CH', 'CN')
for (i in 2:5) {
  
  ## Lendo a planilha i
  dados = read_excel(path = 'enem_escola_2014.xlsx', sheet = i,
                     skip = 1)
  
  ## Retirando as linhas vazias da planilha
  dados = dados[!is.na(dados$'CÓDIGO DA ENTIDADE'),]
  
  ## Separando só as notas
  dados = dados[,19:20]
  
  ## Definindo os nomes das colunas
  coluna1 = paste('MÉDIA DOS 30 MELHORES -', disciplinas[i-1])
  coluna2 = paste('MÉDIA -', disciplinas[i-1])
  colnames(dados) = c(coluna1, coluna2)
  
  ## Juntando os dados
  escolas = cbind(escolas, dados)
}

## Calculando a médias das disciplinas
medias = select(escolas, which(grepl(pattern = 'MÉDIA -',
                                     x = colnames(escolas)))) %>%
medias = medias[,-2]
escolas$ENEM2014 = rowMeans(medias)

save('escolas', file = 'escolas.rda')