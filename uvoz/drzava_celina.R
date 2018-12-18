drzave_kont <- read_csv("Countries-Continents.csv")

#Spremeni vrsti red stolpcev
drzave_kont <- drzave_kont[,c(2,1)]

#Preimenovanje določenih držav, da se ujema z imeni v prejšnjih tabelah
drzave_kont[168,1] <- "United States"
drzave_kont[13,1] <- "Congo (Kinshasa)"
drzave_kont[12,1] <- "Congo (Brazzaville)"