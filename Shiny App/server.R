
library(RTextTools)
library(googleVis)
library(DT)
library(dplyr)
library(choroplethr)
<<<<<<< HEAD
#will need to wrap the "this makes the data sets to put in shiny" file into a function or something and then load at the beginning here
#load("big_word_frame.RData")
=======
load("big_word_frame3.RData")
>>>>>>> upstream/master

shinyServer(function(input, output){  
  
  google_results <- reactive({
    gtrends(c(input$text1, input$text2, input$text3, input$text4), geo = "US", start_date = "2016-09-01", end_date = "2016-11-15")
  }) 
  
  
  output$term_plot <- renderPlot({
    plot(google_results()) + 
      ggtitle(paste0('Google searches', input$textg, ' '))
  }) 

  

  words_speaker_debate <-   reactive({
    big_word_frame %>%
      dplyr::filter(speaker == input$Speaker & debate == input$Debate) 
      })

  

  frequency1 <- reactive({table(words_speaker_debate())})
  top_used_words <- reactive({frequency1() %>% tbl_df() %>% arrange(desc(n)) %>%
      dplyr::select(word, n)})
  
  # the below function was developed from 
  #http://www.rdatascientists.com/2016/08/intro-to-text-analysis-with-r.html
  

  #still need to trim down columns to eliminate unnecesary columns in shiny table
  
  # dd <- reactive ({as.data.frame(top_used_words())})
  # ddd <- reactive({select(dd(), word, n)})
  # output$high_frequency_words <- DT::renderDataTable( 
  #   DT::datatable(ddd,
  #                 options = list(pageLength = 10))
  # )  
  
  
  output$high_frequency_words <- DT::renderDataTable( 
    DT::datatable(as.data.frame(top_used_words()),
                  options = list(pageLength = 10))
  )  
  
 output$word_plot <- renderPlot({plot(as.data.frame(top_used_words))})
  
  
   google_breakdown <- reactive({gtrends(input$state, geo = "US", start_date = "2016-09-01", end_date = "2016-11-15")
   })
   by_state1 <- reactive({
     google_breakdown()$Top.subregions.for.United.States %>%
       mutate(Subregion = tolower(Subregion)) %>%
       plyr::rename(c(Subregion = "region", `United.States` = "value"))
     })

   output$states_plot <- renderPlot({state_choropleth(by_state1())
   })

})     

