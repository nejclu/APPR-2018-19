library(shiny)

shinyUI(fluidPage(
  titlePanel("Stopnja sreče ljudi v Evropi"), 
  sidebarLayout(
    sidebarPanel(
      selectInput("type1",label="Indikator",
                  choice=c("Gospodarstvo","Družina","Pričakovana življenjska doba","Svoboda",
                           "Radodarnost","(Odsotnost) korupcije"))
    ),
    mainPanel(plotOutput("box")
    ) 
  )))