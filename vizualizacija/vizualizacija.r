# 3. faza: Vizualizacija podatkov

#graf1 prikazuje države, ločene po kontinentih, in njihovo stopnjo veselja
graf1 <- ggplot(tabela_2017, aes(x=Continent, y=Happiness.Score, 
                                 color=Continent)) + geom_point() + theme_bw() +
  theme(axis.title = element_text(family = "Helvetica", size = (8)), panel.background=element_rect(fill="#CCFFE5"))

print(graf1)


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
