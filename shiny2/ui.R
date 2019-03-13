library(shiny)

fluidPage(
  
  titlePanel("Stopnja sreče v Evropi"),
  
  tabPanel("Graf",
           sidebarPanel(
             selectInput("drzava", label = "Izberi državo",
                         choices = sort(unique(tabela_2015$Country))),
             tableOutput("table1")),
           mainPanel(plotOutput("graf_sprem"))),
  
  tabPanel("Zemljevid",
           sidebarPanel(
             selectInput("dejavniki",label="Izberi dejavnik",
                         choice=c("Splošno","Gospodarstvo (BDP)","Družina","Pričakovana življenjska doba","Svoboda",
                                  "Radodarnost","(Odsotnost) korupcije"))
           ),
           mainPanel(plotOutput("dejavniki_zem")
           ) 
  ))