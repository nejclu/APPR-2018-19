library(shiny)

fluidPage(
  
  titlePanel("Stopnja sreče v Evropi"),
  
  tabPanel("Graf",
           sidebarPanel(
             selectInput("drzava", label = "Izberi državo",
                         choices = unique(tabela_2015$Country)),
             tableOutput("table1")),
           mainPanel(plotOutput("graf_sprem"))),
  
  tabPanel("Zemljevid",
           sidebarPanel(
             selectInput("type1",label="Izberi dejavnik",
                         choice=c("Splošno","Gospodarstvo","Družina","Pričakovana življenjska doba","Svoboda",
                                  "Radodarnost","(Odsotnost) korupcije"))
           ),
           mainPanel(plotOutput("box")
           ) 
  ))