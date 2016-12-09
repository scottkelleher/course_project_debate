
library(RTextTools)
library(googleVis)
library(DT)
library(dplyr)
library(choroplethr)
#will need to wrap the "this makes the data sets to put in shiny" file into a function or something and then load at the beginning here
#load("big_word_frame.RData")


<<<<<<< HEAD
#install_url("ftp://cran.r-project.org/pub/R/src/contrib/Archive/Rstem_0.4-1.tar.gz")
#install_url("http://cran.r-project.org/src/contrib/Archive/sentiment/sentiment_0.1.tar.gz")
#install_url("http://cran.r-project.org/src/contrib/Archive/sentiment/sentiment_0.2.tar.gz")

shinyServer(function(input, output){ 

  usr <- ("535rprogram@gmail.com")
  psw <- ("groupproject")
  ch <- gconnect(usr, psw)

  text_debate1 <- read_html("http://www.presidency.ucsb.edu/ws/index.php?pid=118971") # load the first debate page
  text_debate2 <- read_html("http://www.presidency.ucsb.edu/ws/index.php?pid=119038")  # load the second debate page
  text_debate3 <- read_html("http://www.presidency.ucsb.edu/ws/index.php?pid=119039")# load the third debate page 
  
  text_debate1 <- html_nodes(text_debate1, ".displaytext") %>% # isloate the text
    html_text() # get the text
  
  text_debate2 <- html_nodes(text_debate2, ".displaytext") %>% # isloate the text
    html_text() # get the text
  
  text_debate3 <- html_nodes(text_debate3, ".displaytext") %>% # isloate the text
    html_text() # get the text
  
  
  #dates of debate
  db1 <- ymd_hms(160927020000, tz = "UTC")
  db2 <- ymd_hms(161009020000, tz = "UTC")
  db3 <-ymd_hms(161029020000, tz = "UTC")
  date_time <-c(db1, db2, db3)
  
  
  ###loop was here 
  text <- reactive({
    if(input$Debate == "First Debate"){ 
      text_debate1 
    } else if(input$Debate == "Second Debate"){
      text_debate2
    } else {
      text_debate3
      }
  })

  
  ##Getting the chunks of text and assigning the speaker, this just defines a function and we can place this actual code somewhere else later as long as we call the function 
  getLines <- function(person, text){
    
    id <- unlist(stringr::str_extract_all(text, "[A-Z]+:")) # get the speaker
    Lines <- unlist(strsplit(text, "[A-Z]+:"))[-1]  # split by speaker (and get rid of a pesky empty line)
    Lines[id %in% person] # retain speech by relevant speaker
  }
  
  ##Creating an object called debate_lines that has two parts, one for clinton and one for trump
  debate_lines <- reactive({lapply(c("CLINTON:", "TRUMP:"), getLines, text = text())})
  
  
  ##Created two separate objects with "chunks" of text in each one, one for clinton and one for trump
  
  
  clinton_lines <- reactive({debate_lines()[1]})
  trump_lines <- reactive({debate_lines()[2]})
  
  
  
  
  
  #break into clinton lines
  text_clinton <- reactive({data_frame(text_c = clinton_lines()[[1]])})
  
  
  #break into trump lines 
  text_trump <- reactive({data_frame(text_t = trump_lines()[[1]])})
  
  
  ##Breaking trump lines into individual words
  trump_words <- reactive({
    text_trump() %>%
    unnest_tokens(word, text_t)  
  })
  #trump_words  
=======
shinyServer(function(input, output){  
>>>>>>> upstream/master
  
  google_results <- reactive({
    gtrends(c(input$text1, input$text2, input$text3, input$text4), geo = "US", start_date = "2016-09-01", end_date = "2016-11-15")
  }) 
  
  
  output$term_plot <- renderPlot({
    plot(google_results()) + 
      ggtitle(paste0('Google searches for "', input$textg, '"'))
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
  
  output$high_frequency_words <- DT::renderDataTable( 
    DT::datatable(as.data.frame(top_used_words()),
                  options = list(pageLength = 10))
  ) 
  
  
 output$word_plot <- renderPlot({plot(as.data.frame(top_used_words))})
  
  
   google_breakdown <- reactive({ gtrends(input$state, geo = "US", start_date = "2016-09-01", end_date = "2016-11-15")
   })
   by_state1 <- reactive({
     google_breakdown()$Top.subregions.for.United.States %>%
       mutate(Subregion = tolower(Subregion)) %>%
       rename(c(Subregion = "region", `United.States` = "value"))
     })

   output$states_plot <- renderPlot({state_choropleth(by_state1())
   })

})     

