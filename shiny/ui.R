library(shiny)

shinyUI(fluidPage(
  titlePanel("Stopnja sreče ljudi v Evropi - vpliv posameznih dejavnikov"),
  sidebarLayout(
    sidebarPanel(
      selectInput("type1",label="Izberi dejavnik",
                  choice=c("Splošno","Gospodarstvo","Družina","Pričakovana življenjska doba","Svoboda",
                           "Radodarnost","(Odsotnost) korupcije"))
    ),
    mainPanel(plotOutput("box")
    ) 
  )))