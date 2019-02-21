library(shiny)

function(input, output) {
  output$graf_sprem <- renderPlot({
    graf_s <- ggplot(tabela_skupna %>% filter(Country == input$drzava)) +
      aes(x = Year, y = Happiness.Score) + geom_line() +
      labs(title="blabal") + theme(plot.title = element_text(hjust = 0.5)) +
      ylab("nekineki") + xlab("šeneki") + ylim(2.5, 8)  
    print(graf_s)

  })
  
  
  
  
  
}