 ##Loading libraries
library(rvest)
#library(tidyverse)
library(stringr)
library(tidytext)
library(gtrendsR)
library(tokenizers)
library(dplyr)
library(tm)
library(SnowballC)
library(wordcloud)
library(syuzhet)
library(lubridate)
library(ggplot2)
library(readr)
library(gtrendsR)
library(xml2)
library(shiny)
library(devtools)

#library(shinydashboard)
library(RTextTools)
library(googleVis)
#source("classify_emotion.R")

library(RTextTools)
library(googleVis)
library(DT)


#install_url("ftp://cran.r-project.org/pub/R/src/contrib/Archive/Rstem_0.4-1.tar.gz")
#install_url("http://cran.r-project.org/src/contrib/Archive/sentiment/sentiment_0.1.tar.gz")
#install_url("http://cran.r-project.org/src/contrib/Archive/sentiment/sentiment_0.2.tar.gz")

shinyServer(function(input, output){ 

  
  ###loop was here 
  reactive({
  if(input$Debate=="First Debate"){
      text <- text_debate1
    } else if (input$Debate=="Second Debate"){
      text<- text_debate2
    } else if (input$Debate=="Third Debate"){
      text<- text_debate3
    }
  })
  ##Getting the chunks of text and assigning the speaker, this just defines a function and we can place this actual code somewhere else later as long as we call the function 
  getLines <- function(person, text){
    
    id <- unlist(stringr::str_extract_all(text, "[A-Z]+:")) # get the speaker
    Lines <- unlist(strsplit(text, "[A-Z]+:"))[-1]  # split by speaker (and get rid of a pesky empty line)
    Lines[id %in% person] # retain speech by relevant speaker
  }
  
  ##Creating an object called debate_lines that has two parts, one for clinton and one for trump
  debate_lines <- lapply(c("CLINTON:", "TRUMP:"), getLines, text = text) 
  
  
  ##Created two separate objects with "chunks" of text in each one, one for clinton and one for trump
  
  
  clinton_lines <- debate_lines[1] 
  trump_lines <- debate_lines[2] 
  
  
  
  
  
  #break into clinton lines
  text_clinton <- data_frame(text_c = clinton_lines[[1]]) 
  
  
  #break into trump lines 
  text_trump <- data_frame(text_t = trump_lines[[1]]) 
  
  
  ##Breaking trump lines into individual words
  trump_words <- text_trump %>%
    unnest_tokens(word, text_t)  
  #trump_words  
  
  
  #filter out the stopwords, add which debate it was and the day and time
  trump_words_unique <- !(trump_words$word %in% stopwords())
  trump_words <- mutate(trump_words, elim = trump_words_unique)
  trump_words<- filter(trump_words, trump_words$elim == TRUE)
  trump_words <- select(trump_words, -elim)
  
  
  ##Breaking clinton lines into individual words
  clinton_words <- text_clinton %>%
    unnest_tokens(word, text_c)  
  #clinton_words
  
  #filter out the stopwords, add which debate it was and what day and time
  clinton_words_unique <- !(clinton_words$word %in% stopwords())
  clinton_words <- mutate(clinton_words, elim = clinton_words_unique)
  clinton_words<- filter(clinton_words, clinton_words$elim == TRUE)
  clinton_words <- select(clinton_words, -elim)
  
  
  
  ##Counting the number of times each word is said for clinton
  clinton_word_frequency <- table(clinton_words)
  
  
  ##Counting the number of times each word is said for trump
  trump_word_frequency <- table(trump_words)

  
  
 
  google_results <- reactive({
    gtrends(c(input$text1, input$text2, input$text3, input$text4), geo = "US", start_date = "2016-09-01", end_date = "2016-11-15")
  }) 

  
 output$term_plot <- renderPlot({
   plot(google_results()) + 
     ggtitle(paste0('Google searches for "', input$textg, '"'))
 }) 
  #should be filtered down to which candidate and which debate at this point
  #some_clinton_words <- gtrends(c("women", "undocumented", "security", "espionage"), geo = "US", start_date = "2016-09-01", end_date = "2016-11-15")
  #plot(some_clinton_words)
  
  top_used_words <- reactive({
    if(input$Speaker == "Donald Trump"){
      trump_word_frequency %>% tbl_df() %>% arrange(desc(n))
    } else if(input$Speaker == "Hilary Clinton"){
      clinton_word_frequency %>% tbl_df() %>% arrange(desc(n))
    }
  })
  
#   observeEvent(input$Speaker, ({
#   if(input$Speaker == "Hilary Clinton"){
#       top_used_words <- reactive({clinton_most_words %>% tbl_df() %>% arrange(desc(n))})
#     } else {
#       top_used_words <- reactive({trump_most_words %>% tbl_df() %>% arrange(desc(n))})
#     }
#   })
# )
  
  # ex <- renderText(clinton_most_words)
  

  output$high_frequency_words <- shiny::renderDataTable( 
    shiny::datatable(as.data.frame(top_used_words), options = list(pageLength = 10))
  ) 

  output$high_frequency_words <- DT::renderDataTable(
    DT::datatable(as.data.frame(top_used_words()),
                  options = list(pageLength = 10))
  )

  
  output$word_plot <- renderPlot({plot(as.data.frame(top_used_words()))})
  
 
  
}) 

