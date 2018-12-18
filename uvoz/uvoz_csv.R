#Tabela shranjena v mapi "podatki"
setwd("E:/APPR-2018-19/podatki")

library(readr)

###2015###
tabela_2015 <- read_csv("2015_changed.csv", locale=locale(encoding="Windows-1250"))

#Zbriše stolpce, ki jih ne potrebujemo
tabela_2015$`Standard Error` <- NULL
tabela_2015$Region <- NULL

#Doda stolpec za leto
tabela_2015$Year <- 2015

#Spremeni vrstni red stolpcev (leto damo na drugo mesto)
tabela_2015 <- tabela_2015[,c(1,11,2,3,4,5,6,7,8,9,10)]

#Uredi rank države
tabela_2015$`Happiness Rank` <- 1:148

###2016###
tabela_2016 <- read_csv("2016_changed.csv", locale=locale(encoding="Windows-1250"))

tabela_2016$`Lower Confidence Interval` <- NULL
tabela_2016$`Upper Confidence Interval` <- NULL
tabela_2016$Region <- NULL

tabela_2016$Year <- 2016
tabela_2016 <- tabela_2016[,c(1,11,2,3,4,5,6,7,8,9,10)]
tabela_2016$`Happiness Rank` <- 1:148

###2017###
tabela_2017 <- read_csv("2017_changed.csv", locale=locale(encoding="Windows-1250"))

tabela_2017$`Whisker high` <- NULL
tabela_2017$`Whisker low` <- NULL

tabela_2017$Year <- 2017
tabela_2017 <- tabela_2017[,c(1,11,2,3,4,5,6,7,8,9,10)]
tabela_2017$`Happiness Rank` <- 1:148

###Združi vse tri tabele##
tabela_skupna <- rbind(tabela_2015, tabela_2016, tabela_2017)

#Odstrani stolpec "Happiness score", ker se ga da dobiti kot vsoto ostalih stolpcev
tabela_skupna$`Happiness Score` <- NULL