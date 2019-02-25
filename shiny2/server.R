library(shiny)

function(input, output) {
  output$graf_sprem <- renderPlot({
    graf_s <- ggplot(tabela_skupna %>% filter(Country == input$drzava)) +
      aes(x = Year, y = Happiness.Score) + geom_line() + geom_point() +
      labs(title="Sprememba stopnje sreče med leti 2015 in 2017") + theme(plot.title = element_text(hjust = 0.5)) +
      ylab("Stopnja sreče") + xlab("Čas") + ylim(2.5, 8)  
    print(graf_s)
    
    tabela_shiny_sub <- reactive({
      #tabela_shiny <- data.frame(tabela_shiny)
      a <- tabela_shiny[tabela_shiny$Country == as.character(input$drzava),]
      return(a)
    })
    
  output$table1 <- renderTable(tabela_shiny_sub())

  })
  
  
  
  
  
}