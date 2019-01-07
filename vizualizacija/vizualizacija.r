# 3. faza: Vizualizacija podatkov

#Uvoz knjižnic
library(ggplot2)
library(dplyr)
library(corrplot)

#graf1 prikazuje države, ločene po kontinentih, in njihovo stopnjo veselja
graf1 <- ggplot(tabela_2017, aes(x=Continent, y=Happiness.Score, color=Continent)) + geom_point() + theme_bw() + 
  ggtitle("Stopnja sreče po kontinentih") + theme(axis.title = element_text(size = (9)), 
  panel.background=element_rect(fill="#CCFFE5"), plot.title = element_text(size = (14)))

print(graf1)

#graf2 prikazuje države, ločene po kontinentih, in njihovo stopnjo veselja - "violin plot"
graf2 <- ggplot(tabela_2017, aes(x=Continent, y=Happiness.Score)) +
  geom_violin(aes(fill=Continent)) + theme_bw() + ggtitle("Stopnja sreče po kontinentih") +
  theme(axis.title = element_text(size = (9)), panel.background=element_rect(fill="#CCFFE5"), plot.title = element_text(size = (14)))

print(graf2)

#graf3 prikazuje stopnjo korelacije med stopnjo sreče in posameznimi dejavniki
data3 = cor(tabela_2017[c(5:12)])
corrplot(data3, method = "number", title = "Korelacija med stopnjo srečo in dejavniki")

#Za naslednji graf bomo potrebovali ujemanje imen držav v tabeli "tabela_2017" in "tabela_preb", saj bomo dodajali stolpce iz ene tabele v drugo.
#Ročno je potrebno spremeniti imena petih držav (Problem: Kosovo in Severni Ciper - podatka bom izpustil)

tabela_preb[56,1] <- "Taiwan Province of China"
tabela_preb[147,1] <- "Macedonia"
tabela_preb[121,1] <- "Palestinian Territories"
tabela_preb[17,1] <- "Congo (Kinshasa)"
tabela_preb[119,1] <- "Congo (Brazzaville)"

#Dodamo stolpec "Population" k tabeli "tabela_2017"
tabela_2017$"Population(2016)" <- tabela_preb$`Population(2016)`[match(tabela_2017$Country, tabela_preb$Country)]

#Dodan stolpec za prirast prebivalstva k tabeli "tabela_2017"
tabela_2017$"Change(2016/2017)" <- tabela_preb$`Change(2016/2017)`[match(tabela_2017$Country, tabela_preb$Country)]

#Iz tabele odstranimo 2 državi, za katere nimamo podatkov
tabela_2017 <- tabela_2017[-c(60,77),]

#Izrišemo graf korelacije med stopnjo sreče in številom prebivalstva
data4 = cor(tabela_2017[c(5,13)])
corrplot(data4, method = "number", title = "Korelacija med stopnjo sreče in številom prebivalstva")

# Uvozimo zemljevid.
zemljevid <- uvozi.zemljevid("http://baza.fmf.uni-lj.si/OB.zip", "OB",
                             pot.zemljevida="OB", encoding="Windows-1250")
levels(zemljevid$OB_UIME) <- levels(zemljevid$OB_UIME) %>%
  { gsub("Slovenskih", "Slov.", .) } %>% { gsub("-", " - ", .) }
zemljevid$OB_UIME <- factor(zemljevid$OB_UIME, levels=levels(obcine$obcina))
zemljevid <- fortify(zemljevid)

# Izračunamo povprečno velikost družine
povprecja <- druzine %>% group_by(obcina) %>%
  summarise(povprecje=sum(velikost.druzine * stevilo.druzin) / sum(stevilo.druzin))
