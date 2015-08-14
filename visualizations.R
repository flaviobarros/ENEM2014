## Alguns gráficos
ggplot() +
  geom_histogram(aes(y = ..density..,x = ENEM_2014,fill = dep_administrativa),data=escolas,alpha = 0.5294) +
  facet_grid(facets = porte_escola ~ dep_administrativa)