library(shiny)

fluidPage(
  
  titlePanel("Sreča-3leta"),
  
  tabPanel("Graf",
           sidebarPanel(
             selectInput("drzava", label = "Izberi državo",
                         choices = unique(tabela_2015$Country)),
             tableOutput("table1")),
           mainPanel(plotOutput("graf_sprem"))))