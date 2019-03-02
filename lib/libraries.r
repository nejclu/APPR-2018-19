library(knitr)
library(rvest)
library(gsubfn)
library(reshape2)
library(shiny)
library(readr)
library(dplyr)
library(ggplot2)
library(corrplot)
library(tidyr)
library(data.table)

# Uvozimo funkcije za pobiranje in uvoz zemljevida.
source("lib/uvozi.zemljevid.r", encoding="UTF-8")
