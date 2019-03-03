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
      
      #Zemljevid, ki prikazuje kolikšen pomen ima gospodarstvo na stopnjo sreče evropskih držav
      zems1 <- ggplot() + geom_polygon(data=left_join(zemljevid, ujemanjes1, by=c("NAME"="Country")),
                                       aes(x=long, y=lat, group=group, fill=center_economy)) +
        ggtitle("Vpliv gospodarstva(BDP) na stopnjo sreče (2017)") + xlab("") + ylab("") + scale_fill_gradient(low='#66FF66', high='#006600') +
        guides(fill=guide_colorbar(title="Vpliv gospodarstva\n[%]"))
      
      zems2 <- ggplot() + geom_polygon(data=left_join(zemljevid, ujemanjes1, by=c("NAME"="Country")),
                                       aes(x=long, y=lat, group=group, fill=center_family)) +
        ggtitle("Vpliv družine na stopnjo sreče (2017)") + xlab("") + ylab("") + 
        guides(fill=guide_colorbar(title="Vpliv družine [%]")) + scale_fill_gradient(low='#66FF66', high='#006600')
      
      zems3 <- ggplot() + geom_polygon(data=left_join(zemljevid, ujemanjes1, by=c("NAME"="Country")),
                                       aes(x=long, y=lat, group=group, fill=center_life_e)) +
        ggtitle("Vpliv pričakovane življenjske dobe na stopnjo sreče (2017)") + xlab("") + ylab("") +
        guides(fill=guide_colorbar(title="Vpliv pričakovane\nživljenjske dobe [%]")) + scale_fill_gradient(low='#66FF66', high='#006600')
      
      zems4 <- ggplot() + geom_polygon(data=left_join(zemljevid, ujemanjes1, by=c("NAME"="Country")),
                                       aes(x=long, y=lat, group=group, fill=center_freedom)) +
        ggtitle("Vpliv svobode na stopnjo sreče (2017)") + xlab("") + ylab("") +
        guides(fill=guide_colorbar(title="Vpliv svobode [%]")) + scale_fill_gradient(low='#66FF66', high='#006600')
      
      zems5 <- ggplot() + geom_polygon(data=left_join(zemljevid, ujemanjes1, by=c("NAME"="Country")),
                                       aes(x=long, y=lat, group=group, fill=center_generosity)) +
        ggtitle("Vpliv radodarnosti na stopnjo sreče (2017)") + xlab("") + ylab("") +
        guides(fill=guide_colorbar(title="Vpliv radodarnosti\n[%]")) + scale_fill_gradient(low='#66FF66', high='#006600')
      
      zems6 <- ggplot() + geom_polygon(data=left_join(zemljevid, ujemanjes1, by=c("NAME"="Country")),
                                       aes(x=long, y=lat, group=group, fill=center_trust)) +
        ggtitle("Vpliv (odsotnosti) korupcije na stopnjo sreče (2017)") + xlab("") + ylab("") +
        guides(fill=guide_colorbar(title="Vpliv (odsotnosti)\nkorupcije [%]")) + scale_fill_gradient(low='#66FF66', high='#006600')
      
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