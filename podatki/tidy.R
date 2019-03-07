#Za tidy data ne potrebujemo stolpcev Happiness.Rank in Happiness.Score, saj jih lahko naračunamo iz ostalih podatkov
pomozna_tidy <- tabela_skupna[-3:-4]
names(pomozna_tidy)[names(pomozna_tidy)=="Country"] <- "Država"
names(pomozna_tidy)[names(pomozna_tidy)=="Year"] <- "Leto"

tidy_economy <- pomozna_tidy[,c(1,2,3)]
tidy_family <- pomozna_tidy[,c(1,2,4)]
tidy_life.expectancy <- pomozna_tidy[,c(1,2,5)]
tidy_freedom <- pomozna_tidy[,c(1,2,6)]
tidy_trust <- pomozna_tidy[,c(1,2,7)]
tidy_generosity <- pomozna_tidy[,c(1,2,8)]
tidy_residual <- pomozna_tidy[,c(1,2,9)]

names(tidy_economy)[names(tidy_economy)=="Economy"] <- "BDP"
names(tidy_family)[names(tidy_family)=="Family"] <- "Družina"
names(tidy_life.expectancy)[names(tidy_life.expectancy)=="Life.Expectancy"] <- "Pričakovana.življenjska.doba"
names(tidy_freedom)[names(tidy_freedom)=="Freedom"] <- "Svoboda"
names(tidy_trust)[names(tidy_trust)=="Trust"] <- "(Odsotnost).korupcije"
names(tidy_generosity)[names(tidy_generosity)=="Generosity"] <- "Radodarnost"
names(tidy_residual)[names(tidy_residual)=="Dystopia.Residual"] <- "Dystopia.Preostanek"

tabela2_tidy <- melt(tabela_preb, id.vars = "Country", measure.vars = names(tabela_preb)[-1], variable.name = "Spremenljivka", value.name = "Vrednost")

write.csv(tidy_economy, file = "tidy_economy.csv")
write.csv(tidy_family, file = "tidy_family.csv")
write.csv(tidy_life.expectancy, file = "tidy_life.expectancy.csv")
write.csv(tidy_trust, file = "tidy_trust.csv")
write.csv(tidy_generosity, file = "tidy_generosity.csv")
write.csv(tidy_residual, file = "tidy_residual")
write.csv(tidy_residual, file = "tidy_residual.csv")
write.csv(tabela2_tidy, file = "tabela2.csv")
