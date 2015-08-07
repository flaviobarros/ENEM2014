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

## Definindo bons nomes de colunas
colnames(escolas) = c('id', 'escola', 'UF', 'cidade', 
                      'dep_administrativa', 'local', 'num_alunos',
                      'porte_escola', 'participantes_enem', 'taxa_particip',
                      'num_necessidades_especiais', 'ind_permanencia',
                      'ind_nivel_socioeconomico', 'faixa', 'ind_form_docente',
                      'taxa_aprovacao', 'taxa_reprovacao', 'taxa_abandono',
                      'media_30_LC', 'media_LC',
                      'media_30_RED', 'media_RED',
                      'media_30_MAT', 'media_MAT',
                      'media_30_CH', 'media_CH',
                      'media_30_CN', 'media_CN', 'ENEM_2014')

save('escolas', file = 'escolas.rda')
