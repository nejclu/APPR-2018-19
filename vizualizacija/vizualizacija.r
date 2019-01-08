# 3. faza: Vizualizacija podatkov

#Uvoz knjižnic
library(ggplot2)
library(dplyr)
library(corrplot)
library(tidyr)
library(data.table)

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
tabela_2017_sprem <- tabela_2017[-c(60,77),]

#Izrišemo graf korelacije med stopnjo sreče in številom prebivalstva
data4 = cor(tabela_2017_sprem[c(5,13)])
corrplot(data4, method = "number", title = "Korelacija med stopnjo sreče in številom prebivalstva")

#Za naslednjo vizualizacijo nas bo zanimalo pri katerih državah je bilo gibanje stopnje sreče tekom treh let (2015 - 2017) največje, kje pa najmanjše
#Uredimo tabele za vsa tri leta po abecedi
tabela_2015_abc <- tabela_2015[order(tabela_2015$Country),]
tabela_2016_abc <- tabela_2016[order(tabela_2016$Country),]
tabela_2017_abc <- tabela_2017[order(tabela_2017$Country),]

#V tabelo s podatki za leto 2017 bomo dodali stolpec, ki predstavlja absolutno vrednost spremembe v letih 2015 - 2017
tabela_2017_abc$Happiness.Change <- abs(tabela_2015_abc$Happiness.Score - tabela_2016_abc$Happiness.Score) + abs(tabela_2016_abc$Happiness.Score - tabela_2017_abc$Happiness.Score)

#Naredimo tabelo s podatki relevantnimi za to vizualizacijo
hap_change <- tabela_2017_abc
hap_change[2:14] <- list(NULL)
hap_change$Happiness.Score.2015 <- tabela_2015_abc$Happiness.Score
hap_change$Happiness.Score.2016 <- tabela_2016_abc$Happiness.Score
hap_change$Happiness.Score.2017 <- tabela_2017_abc$Happiness.Score

#Razvrstimo države naraščajoe glede na velikost spremembe stopnje sreče
hap_change <- hap_change[order(hap_change$Happiness.Change),]

#Izberemo samo 3 države z največjim gibanjem in 3 z najmanjšim
hap_change_tb <- hap_change[c(1,2,3,146,147,148),]
# p1 <- ggplot(hap_change_tb) + geom_point(aes(x=Happiness.Score.2015, y=Country)) + geom_point(aes(x=Happiness.Score.2016, y=Country)) + geom_point(aes(x=Happiness.Score.2017, y=Country)) + geom_line(aes(x, y=Country))
# print(p1)

hap_change_tb$Happiness.Change <- NULL
hap_change_tbt <- as.data.frame(t(hap_change_tb[,-1]))
colnames(hap_change_tbt) <- hap_change_tb$Country
colnames(hap_change_tbt)[3] <- "Trinidad.and.Tobago"

# setDT(hap_change_tbt, keep.rownames = TRUE)[]
# graf6 <- ggplot(data=hap_change_tbt, aes(x=rn, y=Burundi, group=1)) + geom_line() + geom_point()
# graf6 <- graf6 + geom_point(data=hap_change_tbt, aes(x=rn, y=Trinidad.and.Tobago, group=1), color="#ffff1a") + geom_line(data=hap_change_tbt, aes(x=rn, y=Trinidad.and.Tobago, group=1), color="#ffff1a")
# graf6 <- graf6 + geom_point(data=hap_change_tbt, aes(x=rn, y=Denmark, group=1), color="#e60000") + geom_line(data=hap_change_tbt, aes(x=rn, y=Denmark, group=1), color="#e60000")
# graf6 <- graf6 + geom_point(data=hap_change_tbt, aes(x=rn, y=Liberia, group=1), color="#1aff1a") + geom_line(data=hap_change_tbt, aes(x=rn, y=Liberia, group=1), color="#1aff1a")
# graf6 <- graf6 + geom_point(data=hap_change_tbt, aes(x=rn, y=Algeria, group=1), color="#004d99") + geom_line(data=hap_change_tbt, aes(x=rn, y=Algeria, group=1), color="#004d99")
# graf6 <- graf6 + geom_point(data=hap_change_tbt, aes(x=rn, y=Venezuela, group=1), color="#ff8c1a") + geom_line(data=hap_change_tbt, aes(x=rn, y=Venezuela, group=1), color="#ff8c1a")
# graf6 <- graf6 + xlab("Leto meritve") + ylab("Stopnja sreče") + ggtitle("Sprememba vrednosti stopnje sreče")
# 
# print(graf6)
data_tidy <- gather(hap_change_tbt, Country, Vrednost)
data_tidy1 <- data_tidy[-c(1,2,3),]
data_tidy1$Leto <- c("2015", "2016", "2017","2015", "2016", "2017","2015", "2016", "2017","2015", "2016", "2017","2015", "2016", "2017","2015", "2016", "2017")
data_tidy1$Vrednost <- as.numeric(data_tidy1$Vrednost)

ggplot(data_tidy1, aes(Leto, Vrednost)) + geom_line(aes(group = Country), colour = "Black") + geom_point(aes(colour = Country))

# #ZEMLJEVID
# setwd("E:/APPR-2018-19/vizualizacija")
# source("https://raw.githubusercontent.com/jaanos/APPR-2018-19/master/lib/uvozi.zemljevid.r")
# zemljevid <- uvozi.zemljevid(url, "Europe", pot.zemljevida="EU", encoding="Windows-1250") %>% fortify()


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
