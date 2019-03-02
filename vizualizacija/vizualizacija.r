# 3. faza: Vizualizacija podatkov

#Uvoz knjižnic
library(ggplot2)
library(dplyr)
library(corrplot)
library(tidyr)
library(data.table)
library(reshape2)

#graf1 prikazuje države, ločene po kontinentih, in njihovo stopnjo veselja
graf1 <- ggplot(tabela_2017, aes(x=Continent, y=Happiness.Score, color=Continent)) + geom_point(show.legend = FALSE) + theme_bw() + 
  ggtitle("Stopnja sreče po kontinentih") + theme(axis.title = element_text(size = (9)), plot.title = element_text(size = (14)))
graf1 <- graf1 + xlab("Kontinent") + ylab("Stopnja sreče")

#graf2 prikazuje države, ločene po kontinentih, in njihovo stopnjo veselja - "violin plot"
graf2 <- ggplot(tabela_2017, aes(x=Continent, y=Happiness.Score)) +
  geom_violin(aes(fill=Continent), show.legend = FALSE) + theme_bw()
graf2 <- graf2 + ggtitle("Stopnja sreče po kontinentih") + theme(axis.title = element_text(size = (9)), plot.title = element_text(size = (14))) + 
  xlab("Kontinent") + ylab("Stopnja sreče")

#graf3 prikazuje stopnjo korelacije med stopnjo sreče in posameznimi dejavniki
data3 = cor(tabela_2017[c(5:12)])
#corrplot(data3, method = "number", title = "Korelacija med stopnjo srečo in dejavniki")

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

#Izrišemo graf korelacije med stopnjo sreče in številom prebivalstva ter prirastom ljudi
data4 = cor(tabela_2017_sprem[c(5,13,14)])
#corrplot(data4, method = "number", title = "Korelacija med stopnjo sreče in številom prebivalstva ter prirastom ljudi")

#Za naslednjo vizualizacijo nas bo zanimalo pri katerih državah je bilo gibanje stopnje sreče tekom treh let (2015 - 2017) največje, kje pa najmanjše
#Uredimo tabele za vsa tri leta po abecedi
tabela_2015_abc <- tabela_2015[order(tabela_2015$Country),]
tabela_2016_abc <- tabela_2016[order(tabela_2016$Country),]
tabela_2017_abc <- tabela_2017[order(tabela_2017$Country),]

#V tabelo s podatki za leto 2017 bomo dodali stolpec, ki predstavlja absolutno vrednost spremembe stopnje sreče v letih 2015 - 2017
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

hap_change_tb$Happiness.Change <- NULL
hap_change_tb <- melt(hap_change_tb, id.vars = "Country", measure.vars = colnames(hap_change_tb)[-1])
hap_change_tb$variable <- as.integer(gsub("\\D", "", hap_change_tb$variable))

#Preimenujemo stolpce
names(hap_change_tb)[2] <- "Year"
names(hap_change_tb)[3] <- "Change"

graf3 <- ggplot(hap_change_tb, aes(x=factor(Year), y=Change)) + geom_line(aes(group = Country), colour = "Black") + geom_point(aes(colour = Country), size = 2) + scale_color_discrete(name = "Države")
graf3 <- graf3 + ggtitle("Sprememba stopnje sreče v letih 2015 - 2017 (3 max & 3 min)") + theme(plot.title = element_text(size = (14))) +
  xlab("Leto") + ylab("Sprememba")

# #ZEMLJEVID
#Uvozi potrebne knjižnice
source("https://raw.githubusercontent.com/jaanos/APPR-2018-19/master/lib/uvozi.zemljevid.r")

zemljevid <- uvozi.zemljevid("http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_countries.zip",
                             "ne_50m_admin_0_countries", mapa = "zemljevidi", pot.zemljevida = "", encoding = "UTF-8") %>% 
  fortify() %>% filter(CONTINENT == "Europe" | SOVEREIGNT %in% c("Turkey", "Cyprus"), 
         long < 45 & long > -45 & lat > 30 & lat < 75)

ggplot() + geom_polygon(data=zemljevid, aes(x=long, y=lat, group=group, fill=id)) +
  guides(fill=FALSE)

#Tabela, v kateri so samo evropske države in njihova vrednost stonje sreče
tabela_evropske <- tabela_2017_sprem[tabela_2017_sprem[, 2] == "Europe",]
tabela_evropske[6:14] <- NULL
tabela_evropske[2:4] <- NULL

drzave <- unique(zemljevid$NAME)
drzave <- as.data.frame(drzave, stringsAsFactors=FALSE)
names(drzave) <- "Country"
tabela_evropske[14,1] <- "Czechia"
tabela_evropske[36,1] <- "Bosnia and Herz."

k <- kmeans(tabela_evropske[-1], 6)
tabela_evropske$center <- k$centers[k$cluster, ]

ujemanje <- left_join(drzave, tabela_evropske, by="Country")

zem <- ggplot() + geom_polygon(data=left_join(zemljevid, ujemanje, by=c("NAME"="Country")),
                        aes(x=long, y=lat, group=group, fill=center)) +
  ggtitle("Stopnja sreče po evropskih državah (2017)") + xlab("") + ylab("") +
  guides(fill=guide_colorbar(title="Stopnja sreče [1-10]"))

#Dodane oznake za državi z najvišjo in najnižjo vrednostjo + vrednost za Slovenijo
zem1 <- zem + geom_point(aes(x=30, y=50)) + geom_text(aes(x=30, y=49), label = "4.096")
zem1 <- zem1 + geom_point(aes(x=9, y=62)) + geom_text(aes(x=9, y=61), label = "7.537")
zem1 <- zem1 + geom_point(aes(x=14.4, y=46)) + geom_text(aes(x=14, y=45), label = "5.758")

#Tabela s podatki za Evropo za leto 2017
tabela_evropa <- tabela_2017_sprem[tabela_2017_sprem[, 2] == "Europe",]
tabela_evropa[14,1] <- "Czechia"
tabela_evropa[36,1] <- "Bosnia and Herz."

tabela_evropa$Economy.Procent <- with(tabela_evropa, Economy / Happiness.Score *100)
k1 <- kmeans(tabela_evropa[,"Economy.Procent"], 6)
tabela_evropa$center_economy <- k1$centers[k1$cluster, ]

tabela_evropa$Family.Procent <- with(tabela_evropa, Family / Happiness.Score *100)
k2 <- kmeans(tabela_evropa[,"Family.Procent"], 6)
tabela_evropa$center_family <- k2$centers[k2$cluster, ]

tabela_evropa$Life.Expectancy.Procent <- with(tabela_evropa, Life.Expectancy / Happiness.Score *100)
k3 <- kmeans(tabela_evropa[,"Life.Expectancy.Procent"], 6)
tabela_evropa$center_life_e <- k3$centers[k3$cluster, ]

tabela_evropa$Freedom.Procent <- with(tabela_evropa, Freedom / Happiness.Score *100)
k4 <- kmeans(tabela_evropa[,"Freedom.Procent"], 6)
tabela_evropa$center_freedom <- k4$centers[k4$cluster, ]

tabela_evropa$Generosity.Procent <- with(tabela_evropa, Generosity / Happiness.Score *100)
k5 <- kmeans(tabela_evropa[,"Generosity.Procent"], 6)
tabela_evropa$center_generosity <- k5$centers[k5$cluster, ]

tabela_evropa$Trust.Procent <- with(tabela_evropa, Trust / Happiness.Score *100)
k6 <- kmeans(tabela_evropa[,"Trust.Procent"], 6)
tabela_evropa$center_trust <- k6$centers[k6$cluster, ]

tabela_evropa$Dystopia.Residual.Procent <- with(tabela_evropa, Dystopia.Residual / Happiness.Score *100)

#Zbrišemo stolpca s podatki o letu in kontinentu
tabela_evropa[2:3] <- NULL

ujemanjes1 <- left_join(drzave, tabela_evropa, by="Country")

#Zemljevid, ki prikazuje kolikšen pomen ima gospodarstvo na stopnjo sreče evropskih držav
zems1 <- ggplot() + geom_polygon(data=left_join(zemljevid, ujemanjes1, by=c("NAME"="Country")),
                                 aes(x=long, y=lat, group=group, fill=center_economy)) +
  ggtitle("Vpliv gospodarstva(BDP) na stopnjo sreče (2017)") + xlab("") + ylab("") +
  guides(fill=guide_colorbar(title="Vpliv gospodarstva\n[%]"))
#print(zems1)

zems2 <- ggplot() + geom_polygon(data=left_join(zemljevid, ujemanjes1, by=c("NAME"="Country")),
                                 aes(x=long, y=lat, group=group, fill=center_family)) +
  ggtitle("Vpliv družine na stopnjo sreče (2017)") + xlab("") + ylab("") +
  guides(fill=guide_colorbar(title="Vpliv družine [%]"))
#print(zems2)

zems3 <- ggplot() + geom_polygon(data=left_join(zemljevid, ujemanjes1, by=c("NAME"="Country")),
                                 aes(x=long, y=lat, group=group, fill=center_life_e)) +
  ggtitle("Vpliv pričakovane življenjske dobe na stopnjo sreče (2017)") + xlab("") + ylab("") +
  guides(fill=guide_colorbar(title="Vpliv pričakovane\nživljenjske dobe [%]"))
#print(zems3)

zems4 <- ggplot() + geom_polygon(data=left_join(zemljevid, ujemanjes1, by=c("NAME"="Country")),
                                 aes(x=long, y=lat, group=group, fill=center_freedom)) +
  ggtitle("Vpliv svobode na stopnjo sreče (2017)") + xlab("") + ylab("") +
  guides(fill=guide_colorbar(title="Vpliv svobode [%]"))
#print(zems4)

zems5 <- ggplot() + geom_polygon(data=left_join(zemljevid, ujemanjes1, by=c("NAME"="Country")),
                                 aes(x=long, y=lat, group=group, fill=center_generosity)) +
  ggtitle("Vpliv radodarnosti na stopnjo sreče (2017)") + xlab("") + ylab("") +
  guides(fill=guide_colorbar(title="Vpliv radodarnosti\n[%]"))
#print(zems5)

zems6 <- ggplot() + geom_polygon(data=left_join(zemljevid, ujemanjes1, by=c("NAME"="Country")),
                                 aes(x=long, y=lat, group=group, fill=center_trust)) +
  ggtitle("Vpliv (odsotnosti) korupcije na stopnjo sreče (2017)") + xlab("") + ylab("") +
  guides(fill=guide_colorbar(title="Vpliv (odsotnosti)\nkorupcije [%]"))
#print(zems6)

#Potrebujemo samo podatke  iz prvih treh stolpec tabele "tabela_skupna"
tabela_shiny <- tabela_skupna[,c(1,2,3)]
tabela_shiny$Year <- as.integer(tabela_shiny$Year)

#Prevodi iz angleščine v slovenščino
names(tabela_shiny)[1]<-"Država"
names(tabela_shiny)[2]<-"Leto"
names(tabela_shiny)[3]<-"Mesto[/148]"


# Uvozimo zemljevid.
# zemljevid <- uvozi.zemljevid("http://baza.fmf.uni-lj.si/OB.zip", "OB",
#                              pot.zemljevida="OB", encoding="Windows-1250")
# levels(zemljevid$OB_UIME) <- levels(zemljevid$OB_UIME) %>%
#   { gsub("Slovenskih", "Slov.", .) } %>% { gsub("-", " - ", .) }
# zemljevid$OB_UIME <- factor(zemljevid$OB_UIME, levels=levels(obcine$obcina))
# zemljevid <- fortify(zemljevid)

# Izračunamo povprečno velikost družine
# povprecja <- druzine %>% group_by(obcina) %>%
#   summarise(povprecje=sum(velikost.druzine * stevilo.druzin) / sum(stevilo.druzin))
