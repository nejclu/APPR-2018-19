library(rvest)
library(gsubfn)
library(readr)
library(dplyr)

link <- "https://en.wikipedia.org/wiki/List_of_countries_by_population_(United_Nations)"
stran <- html_session(link) %>% read_html()
tabela_preb <- stran %>% html_nodes(xpath="//table[@class='wikitable sortable plainrowheaders']") %>%
  .[[1]] %>% html_table() %>% transmute(Država=`Country or area` %>% strapplyc("^([^[]*)") %>% unlist(),
                                        prebivalstvo=`Population(1 July 2017)[3]` %>%
                                          parse_number(locale=locale(grouping_mark=",")))


#Preimenovanje drugega stolpca
names(tabela_preb)[names(tabela_preb)=="prebivalstvo"] <- "Število prebivalcev (2016)"

#Odstranitev prve vrstice (World)
tabela_preb <- tabela_preb[2:234,]
