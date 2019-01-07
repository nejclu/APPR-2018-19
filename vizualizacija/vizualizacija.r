# 3. faza: Vizualizacija podatkov

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
library(corrplot)
data3 = cor(tabela_2017[c(5:12)])
corrplot(data3, method = "number", title = "Korelacija med stopnjo srečo in dejavniki")

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
