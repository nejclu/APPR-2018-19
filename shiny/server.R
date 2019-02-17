library(shiny)
library(datasets)

shinyServer(function(input, output) {
  output$box <- renderPlot({
    
    if(input$type1 == "Gospodarstvo"){print(zems1)}
    else if(input$type1 == "Družina"){print(zems2)}
    else if(input$type1 == "Pričakovana življenjska doba"){print(zems3)}
    else if(input$type1 == "Svoboda"){print(zems4)}
    else if(input$type1 == "Radodarnost"){print(zems5)}
    else if(input$type1 == "(Odsotnost) korupcije"){print(zems6)}
  })
}
)