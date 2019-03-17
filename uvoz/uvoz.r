#Tabela s številom prebivalstva
link <- "https://en.wikipedia.org/wiki/List_of_countries_by_population_(United_Nations)"
stran <- html_session(link) %>% read_html()
tabela_preb <- stran %>% html_nodes(xpath="//table[@class='wikitable sortable plainrowheaders']") %>%
  .[[1]] %>% html_table() %>% transmute(Country=`Country or area` %>% strapplyc("^([^[]*)") %>% unlist(),
                                        Population=`Population(1 July 2017)[3]` %>%
                                          parse_number(locale=locale(grouping_mark=",")))

#Preimenovanje drugega stolpca
names(tabela_preb)[2] <- "Population(2016)"

#Odstrani prvo vrstico (podatek za svet), ker je ne potrebujemo
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
names(tabela_preb)[3] <- "Change(2016/2017)"


###2015###
tabela_2015 <- read_csv("podatki/2015_changed.csv", locale=locale(encoding="Windows-1250"))

#Zbriše stolpce, ki jih ne potrebujemo
tabela_2015$`Standard Error` <- NULL
tabela_2015$Region <- NULL

#Doda stolpec za leto
tabela_2015$Year <- 2015

#Spremeni vrstni red stolpcev (leto damo na drugo mesto)
tabela_2015 <- tabela_2015[,c(1,11,2,3,4,5,6,7,8,9,10)]

#Uredi rank države (Nekaj manjkajočih držav je bilo odstranjenih iz datoteke že pred uvozom)
tabela_2015$`Happiness Rank` <- 1:148

#Preimenujemo stolpce v katerih so presledki
names(tabela_2015)[3] <- "Happiness.Rank"
names(tabela_2015)[4] <- "Happiness.Score"
names(tabela_2015)[5] <- "Economy"
names(tabela_2015)[7] <- "Life.Expectancy"
names(tabela_2015)[9] <- "Trust"
names(tabela_2015)[11] <- "Dystopia.Residual"

###2016###
tabela_2016 <- read_csv("podatki/2016_changed.csv", locale=locale(encoding="Windows-1250"))

tabela_2016$`Lower Confidence Interval` <- NULL
tabela_2016$`Upper Confidence Interval` <- NULL
tabela_2016$Region <- NULL

tabela_2016$Year <- 2016
tabela_2016 <- tabela_2016[,c(1,11,2,3,4,5,6,7,8,9,10)]
tabela_2016$`Happiness Rank` <- 1:148

#Preimenujemo stolpce v katerih so presledki
names(tabela_2016)[3] <- "Happiness.Rank"
names(tabela_2016)[4] <- "Happiness.Score"
names(tabela_2016)[5] <- "Economy"
names(tabela_2016)[7] <- "Life.Expectancy"
names(tabela_2016)[9] <- "Trust"
names(tabela_2016)[11] <- "Dystopia.Residual"

###2017###
tabela_2017 <- read_csv("podatki/2017_changed.csv", locale=locale(encoding="Windows-1250"))

tabela_2017$`Whisker high` <- NULL
tabela_2017$`Whisker low` <- NULL

tabela_2017$Year <- 2017
tabela_2017 <- tabela_2017[,c(1,11,2,3,4,5,6,7,8,9,10)]
tabela_2017$`Happiness Rank` <- 1:148

#Preimenujemo stolpce v katerih so presledki
names(tabela_2017)[3] <- "Happiness.Rank"
names(tabela_2017)[4] <- "Happiness.Score"
names(tabela_2017)[5] <- "Economy"
names(tabela_2017)[7] <- "Life.Expectancy"
names(tabela_2017)[10] <- "Trust"
names(tabela_2017)[11] <- "Dystopia.Residual"

###Združi vse tri tabele##
tabela_skupna <- rbind(tabela_2015, tabela_2016, tabela_2017)

#Odstrani stolpec "Happiness score", ker se ga da dobiti kot vsoto ostalih stolpcev
tabela_skupna$`Happiness Score` <- NULL

#v tabelo s podatki za leto 2017 bomo dodali stolpec "Continent"
tabela_2017$Continent <- NA
tabela_2017$Continent[(tabela_2017$Country %in% c("Israel", "United Arab Emirates", "Singapore", "Thailand", "Taiwan", "Qatar", 
                                                       "Saudi Arabia", "Kuwait", "Bahrain", "Malaysia", "Uzbekistan", "Japan", "South Korea", "Turkmenistan", 
                                                       "Kazakhstan", "Turkey", "Hong Kong", "Philippines",
                                                       "Jordan", "China", "Pakistan", "Indonesia", "Azerbaijan", "Lebanon", "Vietnam",
                                                       "Tajikistan", "Bhutan", "Kyrgyzstan", "Nepal", "Mongolia", "Palestinian Territories",
                                                       "Iran", "Bangladesh", "Myanmar", "Iraq", "Sri Lanka", "Armenia", "India", "Georgia",
                                                       "Cambodia", "Afghanistan", "Yemen", "Syria"))] <- "Asia"

tabela_2017$Continent[(tabela_2017$Country %in% c("Norway", "Denmark", "Iceland", "Switzerland", "Finland",
                                                         "Netherlands", "Sweden", "Austria", "Ireland", "Germany",
                                                         "Belgium", "Luxembourg", "United Kingdom", "Czech Republic",
                                                         "Malta", "France", "Spain", "Slovakia", "Poland", "Italy",
                                                         "Russia", "Lithuania", "Latvia", "Moldova", "Romania",
                                                         "Slovenia", "North Cyprus", "Cyprus", "Estonia", "Belarus",
                                                         "Serbia", "Hungary", "Croatia", "Kosovo", "Montenegro",
                                                         "Greece", "Portugal", "Bosnia and Herzegovina", "Macedonia",
                                                         "Bulgaria", "Albania", "Ukraine"))] <- "Europe"

tabela_2017$Continent[(tabela_2017$Country %in% c("Canada", "Costa Rica", "United States", "Mexico",  
                                                       "Panama","Trinidad and Tobago", "El Salvador", "Belize", "Guatemala",
                                                       "Jamaica", "Nicaragua", "Dominican Republic", "Honduras",
                                                       "Haiti"))] <- "North America"

tabela_2017$Continent[(tabela_2017$Country %in% c("Chile", "Brazil", "Argentina", "Uruguay",
                                                       "Colombia", "Ecuador", "Bolivia", "Peru",
                                                       "Paraguay", "Venezuela"))] <- "South America"

tabela_2017$Continent[(tabela_2017$Country %in% c("Australia", "New Zealand"))] <- "Australia"

tabela_2017$Continent[(is.na(tabela_2017$Continent))] <- "Africa"

#Premik stolpca "Continent" na drugo mesto v tabeli
tabela_2017 <- tabela_2017[,c(1,12,2,3,4,5,6,7,8,9,10,11)]

###
#Tabele v tidydata
pomozna_tidy <- tabela_skupna[-3:-4]
names(pomozna_tidy)[1] <- "Država"
names(pomozna_tidy)[2] <- "Leto"

tidy_economy <- pomozna_tidy[,c(1,2,3)]
tidy_family <- pomozna_tidy[,c(1,2,4)]
tidy_life.expectancy <- pomozna_tidy[,c(1,2,5)]
tidy_freedom <- pomozna_tidy[,c(1,2,6)]
tidy_trust <- pomozna_tidy[,c(1,2,7)]
tidy_generosity <- pomozna_tidy[,c(1,2,8)]
tidy_residual <- pomozna_tidy[,c(1,2,9)]

names(tidy_economy)[3] <- "BDP"
names(tidy_family)[3] <- "Družina"
names(tidy_life.expectancy)[3] <- "Pričakovana.življenjska.doba"
names(tidy_freedom)[3] <- "Svoboda"
names(tidy_trust)[3] <- "(Odsotnost).korupcije"
names(tidy_generosity)[3] <- "Radodarnost"
names(tidy_residual)[3] <- "Dystopia.Preostanek"

tidy_preb <- tabela_preb[-3]
tidy_prir <- tabela_preb[-2]

names(tidy_preb)[1] <- "Država"
names(tidy_preb)[2] <- "Število.prebivalcev(2016)"
names(tidy_prir)[1] <- "Država"
names(tidy_prir)[2] <- "Prirast(2016/2017)"

create_empty_table <- function(num_rows, num_cols) {
  frame <- data.frame(matrix(NA, nrow = num_rows, ncol = num_cols))
  return(frame)
}

prazna <- create_empty_table(233,2)
tidy_prebivalstvo <- prazna
tidy_prebivalstvo$X1 <- tidy_preb$Država
tidy_prebivalstvo$X2 <- tidy_preb$`Število.prebivalcev(2016)`
names(tidy_prebivalstvo)[1] <- "Država"
names(tidy_prebivalstvo)[2] <- "Število.prebivalcev(2016)"

tidy_prirast <- prazna
tidy_prirast$X1 <- tidy_prir$Država
tidy_prirast$X2 <- tidy_prir$`Prirast(2016/2017)`
names(tidy_prirast)[1] <- "Država"
names(tidy_prirast)[2] <- "Prirast(2016/2017)"
###
