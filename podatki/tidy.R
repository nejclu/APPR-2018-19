tabela1_tidy <- melt(tabela_skupna, id.vars = c("Country","Year"), measure.vars = names(tabela_skupna)[-2:-1], variable.name="Spremenljivka", value.name="Vrednost")
names(tabela1_tidy)[names(tabela1_tidy)=="Country"] <- "Država"
names(tabela1_tidy)[names(tabela1_tidy)=="Year"] <- "Leto"

tabela2_tidy <- melt(tabela_preb, id.vars = "Country", measure.vars = names(tabela_preb)[-1], variable.name = "Spremenljivka", value.name = "Vrednost")

write.csv(tabela1_tidy, file = "tabela1.csv")
write.csv(tabela2_tidy, file = "tabela2.csv")
