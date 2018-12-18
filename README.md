# Analiza podatkov s programom R, 2018/19

Repozitorij z gradivi pri predmetu APPR v študijskem letu 2018/19

* [![Shiny](http://mybinder.org/badge.svg)](http://beta.mybinder.org/v2/gh/nejclu/APPR-2018-19/master?urlpath=shiny/APPR-2018-19/projekt.Rmd) Shiny
* [![RStudio](http://mybinder.org/badge.svg)](http://beta.mybinder.org/v2/gh/nejclu/APPR-2018-19/master?urlpath=rstudio) RStudio

## Analiza stopnje sreče ljudi v državah po svetu

V projektu bom analiziral stopnjo sreče ljudi po posameznih državah v svetu med letoma 2015 in 2017. Za vsako izmed 148 držav je podano število na lestvici od 1 do 10, ki predstavlja mero sreče ljudi v državi, ta pa je seštevek sedmih komponent – šestih glavnih (BDP države, pričakovana življenjska  doba, svoboda, radodarnost, korupcija, pomen družine) in dodatne komponente, ki je seštevek rezultata izmišljene države z najmanj srečnimi državljani (»Dystopia«) in ocene napake pri končnem rezultatu vsake države, ki jo da prvih 6 spremenljivk. Pri tem bom skušal ugotoviti kateri izmed faktorjev so najpomembnejši za srečnejše življenje, koliko se stopnja sreče ljudi po državah spreminja tekom treh let (2015 – 2017) in če je katera izmed držav doživela velik skok ali padec v stopnji sreče v tem obdobju. Kot dodatni spremenljivki sem si izbral število in prirast prebivalcev določene države, zanimalo pa me bo ali obstaja kakšna korelacija med stopnjo sreče ljudi in številom ljudi, ki živi v določeni državi oziroma njegovim prirastom.

Za vir podatkov bom uporabil spletno stran Kaggle (https://www.kaggle.com/unsdsn/world-happiness v obliki .csv) in Wikipedio (https://en.wikipedia.org/wiki/List_of_countries_by_population_(United_Nations) v obliki .html). Na spletni strani Kaggle so objavljene 3 tabele, za vsako leto svoja, ki pa jih nameravam združiti v eno.


## Podatki v tabelah
`Tabela 1`: Stopnja sreče ljudi
- `Država` - parameter: država, ki jo preučujemo
-	`Leto` - parameter: leto, katerega so bile opravljene meritve
-	`Regija` - parameter: regija sveta, v katero jo uvrščamo
-	`Mesto na lestvici` - meritev
-	`Rezultat stopnje sreče` - meritev: Rezultat, podan na lestvici od 1 – 10
-	`BDP` - spremenljivka: V kolikšni meri BDP določene države vpliva na izračun stopnje sreče ljudi 
- `Družina` – spremenljivka: V kolikšni meri pomen družine vpliva na izračun stopnje sreče ljudi
-	`Pričakovana življenjska doba` - spremenljivka: V kolikšni meri pričakovana življenjska doba vpliva na izračun stopnje sreče ljudi 
-	`Svoboda` - spremenljivka: V kolikšni meri svoboda odločanja vpliva na izračun stopnje sreče ljudi
-	`Korupcija` - spremenljivka: V kolikšni meri korupcija (oziroma njena odsotnost) vpliva na izračun stopnje sreče ljudi 
-	`Radodarnost` - spremenljivka: V kolikšni meri radodarnost ljudi vpliva na izračun stopnje sreče
-	`Dystopia + residual` - spremenljivka: V kolikšni meri rezultat države »Dystopia« in ocena napake prejšnjih meritev vpliva na izračun stopnje sreče ljudi

`Tabela 2`: Število ljudi po državah
-	`Država` - parameter: Država, ki jo preučujemo
-	`Št. ljudi (2016)` - spremenljivka: Število ljudi, ki živi v državi (merjeno 1. julija 2016)
-	`Št. ljudi (2017)` - spremenljivka: Število ljudi, ki živi v državi (merjeno 1. julija 2017)
-	`Razlika med letoma` - spremenljivka: Razlika med številom ljudi, ki živi v državi med letoma 2016 in 2017 (izraženo v procentih)


## Program

Glavni program in poročilo se nahajata v datoteki `projekt.Rmd`.
Ko ga prevedemo, se izvedejo programi, ki ustrezajo drugi, tretji in četrti fazi projekta:

* obdelava, uvoz in čiščenje podatkov: `uvoz/uvoz.r`
* analiza in vizualizacija podatkov: `vizualizacija/vizualizacija.r`
* napredna analiza podatkov: `analiza/analiza.r`

Vnaprej pripravljene funkcije se nahajajo v datotekah v mapi `lib/`.
Podatkovni viri so v mapi `podatki/`.
Zemljevidi v obliki SHP, ki jih program pobere,
se shranijo v mapo `../zemljevidi/` (torej izven mape projekta).

## Potrebni paketi za R

Za zagon tega vzorca je potrebno namestiti sledeče pakete za R:

* `knitr` - za izdelovanje poročila
* `rmarkdown` - za prevajanje poročila v obliki RMarkdown
* `shiny` - za prikaz spletnega vmesnika
* `DT` - za prikaz interaktivne tabele
* `rgdal` - za uvoz zemljevidov
* `digest` - za zgoščevalne funkcije (uporabljajo se za shranjevanje zemljevidov)
* `readr` - za branje podatkov
* `rvest` - za pobiranje spletnih strani
* `reshape2` - za preoblikovanje podatkov v obliko *tidy data*
* `dplyr` - za delo s podatki
* `gsubfn` - za delo z nizi (čiščenje podatkov)
* `ggplot2` - za izrisovanje grafov
* `mosaic` - za pretvorbo zemljevidov v obliko za risanje z `ggplot2`
* `maptools` - za delo z zemljevidi
* `extrafont` - za pravilen prikaz šumnikov (neobvezno)

## Binder

Zgornje [povezave](#analiza-podatkov-s-programom-r-201819)
omogočajo poganjanje projekta na spletu z orodjem [Binder](https://mybinder.org/).
V ta namen je bila pripravljena slika za [Docker](https://www.docker.com/),
ki vsebuje večino paketov, ki jih boste potrebovali za svoj projekt.

Če se izkaže, da katerega od paketov, ki ji potrebujete, ni v sliki,
lahko za sprotno namestitev poskrbite tako,
da jih v datoteki [`install.R`](install.R) namestite z ukazom `install.packages`.
Te datoteke (ali ukaza `install.packages`) **ne vključujte** v svoj program -
gre samo za navodilo za Binder, katere pakete naj namesti pred poganjanjem vašega projekta.

Tako nameščanje paketov se bo izvedlo pred vsakim poganjanjem v Binderju.
Če se izkaže, da je to preveč zamudno,
lahko pripravite [lastno sliko](https://github.com/jaanos/APPR-docker) z želenimi paketi.

Če želite v Binderju delati z git,
v datoteki `gitconfig` nastavite svoje ime in priimek ter e-poštni naslov
(odkomentirajte vzorec in zamenjajte s svojimi podatki) -
ob naslednjem.zagonu bo mogoče delati commite.
Te podatke lahko nastavite tudi z `git config --global` v konzoli
(vendar bodo veljale le v trenutni seji).
