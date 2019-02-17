library(rvest)
library(gsubfn)
library(readr)
library(dplyr)

#Tabela s številom prebivalstva
link <- "https://en.wikipedia.org/wiki/List_of_countries_by_population_(United_Nations)"
stran <- html_session(link) %>% read_html()
tabela_preb <- stran %>% html_nodes(xpath="//table[@class='wikitable sortable plainrowheaders']") %>%
  .[[1]] %>% html_table() %>% transmute(Country=`Country or area` %>% strapplyc("^([^[]*)") %>% unlist(),
                                        prebivalstvo=`Population(1 July 2017)[3]` %>%
                                          parse_number(locale=locale(grouping_mark=",")))


#Preimenovanje drugega stolpca
names(tabela_preb)[names(tabela_preb)=="prebivalstvo"] <- "Population(2016)"

#Odstrani prvo vrstico (podatek za svet)
tabela_preb <- tabela_preb[-1,]

#Tabela z naravnim prirastom
tabela_prir <- stran %>% html_nodes(xpath="//table[@class='wikitable sortable plainrowheaders']") %>%
  .[[1]] %>% html_table() %>% transmute(Country=`Country or area` %>% strapplyc("^([^[]*)") %>% unlist(),
                                        Change=gsub("\u2212", "-", Change) %>%
                                          parse_number(locale=locale(grouping_mark=",")))

#Odstrani prvo vrstico (podatek za svet)
tabela_prir <- tabela_prir[-1,]

#Tabeli s podatki o prebivalstvu dodamo stolpec o prirastu
tabela_preb$Change <- tabela_prir$Change

#Preimenovan tretji stolpec
names(tabela_preb)[names(tabela_preb)=="Change"] <- "Change(2016/2017)"


###2015###
tabela_2015 <- read_csv("podatki/2015_changed.csv", locale=locale(encoding="Windows-1250"))

#Zbriše stolpce, ki jih ne potrebujemo
tabela_2015$`Standard Error` <- NULL
tabela_2015$Region <- NULL

#Doda stolpec za leto
tabela_2015$Year <- 2015

#Spremeni vrstni red stolpcev (leto damo na drugo mesto)
tabela_2015 <- tabela_2015[,c(1,11,2,3,4,5,6,7,8,9,10)]

#Uredi rank države
tabela_2015$`Happiness Rank` <- 1:148

#Preimenujemo stolpce v katerih so presledki
names(tabela_2015)[names(tabela_2015)=="Happiness Rank"] <- "Happiness.Rank"
names(tabela_2015)[names(tabela_2015)=="Happiness Score"] <- "Happiness.Score"
names(tabela_2015)[names(tabela_2015)=="Economy (GDP per Capita)"] <- "Economy"
names(tabela_2015)[names(tabela_2015)=="Health (Life Expectancy)"] <- "Life.Expectancy"
names(tabela_2015)[names(tabela_2015)=="Trust (Government Corruption)"] <- "Trust"
names(tabela_2015)[names(tabela_2015)=="Dystopia Residual"] <- "Dystopia.Residual"

###2016###
tabela_2016 <- read_csv("podatki/2016_changed.csv", locale=locale(encoding="Windows-1250"))

tabela_2016$`Lower Confidence Interval` <- NULL
tabela_2016$`Upper Confidence Interval` <- NULL
tabela_2016$Region <- NULL

tabela_2016$Year <- 2016
tabela_2016 <- tabela_2016[,c(1,11,2,3,4,5,6,7,8,9,10)]
tabela_2016$`Happiness Rank` <- 1:148

#Preimenujemo stolpce v katerih so presledki
names(tabela_2016)[names(tabela_2016)=="Happiness Rank"] <- "Happiness.Rank"
names(tabela_2016)[names(tabela_2016)=="Happiness Score"] <- "Happiness.Score"
names(tabela_2016)[names(tabela_2016)=="Economy (GDP per Capita)"] <- "Economy"
names(tabela_2016)[names(tabela_2016)=="Health (Life Expectancy)"] <- "Life.Expectancy"
names(tabela_2016)[names(tabela_2016)=="Trust (Government Corruption)"] <- "Trust"
names(tabela_2016)[names(tabela_2016)=="Dystopia Residual"] <- "Dystopia.Residual"

###2017###
tabela_2017 <- read_csv("podatki/2017_changed.csv", locale=locale(encoding="Windows-1250"))

tabela_2017$`Whisker high` <- NULL
tabela_2017$`Whisker low` <- NULL

tabela_2017$Year <- 2017
tabela_2017 <- tabela_2017[,c(1,11,2,3,4,5,6,7,8,9,10)]
tabela_2017$`Happiness Rank` <- 1:148

#Preimenujemo stolpce v katerih so presledki
names(tabela_2017)[names(tabela_2017)=="Happiness Rank"] <- "Happiness.Rank"
names(tabela_2017)[names(tabela_2017)=="Happiness Score"] <- "Happiness.Score"
names(tabela_2017)[names(tabela_2017)=="Economy (GDP per Capita)"] <- "Economy"
names(tabela_2017)[names(tabela_2017)=="Health (Life Expectancy)"] <- "Life.Expectancy"
names(tabela_2017)[names(tabela_2017)=="Trust (Government Corruption)"] <- "Trust"
names(tabela_2017)[names(tabela_2017)=="Dystopia Residual"] <- "Dystopia.Residual"

###Združi vse tri tabele##
tabela_skupna <- rbind(tabela_2015, tabela_2016, tabela_2017)

#Odstrani stolpec "Happiness score", ker se ga da dobiti kot vsoto ostalih stolpcev
tabela_skupna$`Happiness Score` <- NULL

#v tabelo s podatki za leto 2017 bomo dodali stolpec "Continent"
tabela_2017$Continent <- NA
tabela_2017$Continent[which(tabela_2017$Country %in% c("Israel", "United Arab Emirates", "Singapore", "Thailand", "Taiwan", "Qatar", 
                                                       "Saudi Arabia", "Kuwait", "Bahrain", "Malaysia", "Uzbekistan", "Japan", "South Korea", "Turkmenistan", 
                                                       "Kazakhstan", "Turkey", "Hong Kong", "Philippines",
                                                       "Jordan", "China", "Pakistan", "Indonesia", "Azerbaijan", "Lebanon", "Vietnam",
                                                       "Tajikistan", "Bhutan", "Kyrgyzstan", "Nepal", "Mongolia", "Palestinian Territories",
                                                       "Iran", "Bangladesh", "Myanmar", "Iraq", "Sri Lanka", "Armenia", "India", "Georgia",
                                                       "Cambodia", "Afghanistan", "Yemen", "Syria"))] <- "Asia"

tabela_2017$Continent[which(tabela_2017$Country %in% c("Norway", "Denmark", "Iceland", "Switzerland", "Finland",
                                                         "Netherlands", "Sweden", "Austria", "Ireland", "Germany",
                                                         "Belgium", "Luxembourg", "United Kingdom", "Czech Republic",
                                                         "Malta", "France", "Spain", "Slovakia", "Poland", "Italy",
                                                         "Russia", "Lithuania", "Latvia", "Moldova", "Romania",
                                                         "Slovenia", "North Cyprus", "Cyprus", "Estonia", "Belarus",
                                                         "Serbia", "Hungary", "Croatia", "Kosovo", "Montenegro",
                                                         "Greece", "Portugal", "Bosnia and Herzegovina", "Macedonia",
                                                         "Bulgaria", "Albania", "Ukraine"))] <- "Europe"

tabela_2017$Continent[which(tabela_2017$Country %in% c("Canada", "Costa Rica", "United States", "Mexico",  
                                                       "Panama","Trinidad and Tobago", "El Salvador", "Belize", "Guatemala",
                                                       "Jamaica", "Nicaragua", "Dominican Republic", "Honduras",
                                                       "Haiti"))] <- "North America"

tabela_2017$Continent[which(tabela_2017$Country %in% c("Chile", "Brazil", "Argentina", "Uruguay",
                                                       "Colombia", "Ecuador", "Bolivia", "Peru",
                                                       "Paraguay", "Venezuela"))] <- "South America"

tabela_2017$Continent[which(tabela_2017$Country %in% c("Australia", "New Zealand"))] <- "Australia"

tabela_2017$Continent[which(is.na(tabela_2017$Continent))] <- "Africa"

#Premik stolpca "Continent" na drugo mesto v tabeli
tabela_2017 <- tabela_2017[,c(1,12,2,3,4,5,6,7,8,9,10,11)]
