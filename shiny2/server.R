library(shiny)

function(input, output) {
  output$graf_sprem <- renderPlot({
    graf_s <- ggplot(tabela_skupna %>% filter(Country == input$drzava), aes(x = factor(Year), y = Happiness.Score)) +
      geom_line(aes(group=Country)) + geom_point() + labs(title="Sprememba stopnje sreče med leti 2015 in 2017") + 
      theme(plot.title = element_text(hjust = 0.5)) + ylab("Stopnja sreče") + xlab("Čas") + ylim(2.5, 8)  
    print(graf_s)
#Če pr geom_line nism dodal aes(group=Country), ni telo povezat točk (po tem ko sm dau x=factor(Year)    
    tabela_shiny_sub <- reactive({
      a <- tabela_shiny[tabela_shiny$Država == as.character(input$drzava),]
      return(a[,2:3])
    })
#pri a-ju ni potrebno da vrnemo 1. stolpec, ker je ime države razvidna že iz zgornje izbire    
    output$table1 <- renderTable(tabela_shiny_sub())
    
  })
  
  {
    output$box <- renderPlot({
      
      if(input$type1 == "Splošno"){print(zem)}
      else if(input$type1 == "Gospodarstvo"){print(zems1)}
      else if(input$type1 == "Družina"){print(zems2)}
      else if(input$type1 == "Pričakovana življenjska doba"){print(zems3)}
      else if(input$type1 == "Svoboda"){print(zems4)}
      else if(input$type1 == "Radodarnost"){print(zems5)}
      else if(input$type1 == "(Odsotnost) korupcije"){print(zems6)}
    })
  }
  
  
  
  
}