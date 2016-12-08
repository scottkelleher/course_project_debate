


## specify inputs
Speaker <- "Hilary_Clinton"  # enter Donald_Trump or Hilary_Clinton
Debate = "Second_Debate"   # enter First_Debate or Second_Debate or Third_Debate
google_these_words = c("Melania", "email scandal", "bigly", "nasty woman", "benghazi")  # enter up to five phrases to google in gtrends andresults
# enter one phrase you would like to see broken down by state
google_states = c("bigly")

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
library(sentimentr)
library(lubridate)
library(ggplot2)
library(readr)
library(gtrendsR)
library(xml2)
#library(shiny)
library(devtools)
ls("package:gtrendsR")
library(RTextTools)
library(googleVis)
library(syuzhet)


library(RTextTools)
library(googleVis)
library(DT)
library(choroplethr)
library(choroplethrMaps)
library(syuzhet)

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

w <- c(text_debate1, text_debate2, text_debate3)

db1 <- ymd_hms(160927020000, tz = "UTC")
db2 <- ymd_hms(161009020000, tz = "UTC")
db3 <-ymd_hms(161029020000, tz = "UTC")
date_time <-c(db1, db2, db3)



for (i in (1:3)) {     
  
  ##Getting the chunks of text and assigning the speaker, this just defines a function and we can place this actual code somewhere else later as long as we call the function 
  text <- w[i]
  getLines <- function(person){
    
    id <- unlist(stringr::str_extract_all(text, "[A-Z]+:")) # get the speaker
    Lines <- unlist(strsplit(text, "[A-Z]+:"))[-1]  # split by speaker (and get rid of a pesky empty line)
    Lines[id %in% person] # retain speech by relevant speaker
  }
  
  ##Creating an object called debate_lines that has two parts, one for clinton and one for trump
  debate_lines <- lapply(c("CLINTON:", "TRUMP:"), getLines) 
  
  
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
  trump_words <- mutate(trump_words, speaker = "trump", elim = trump_words_unique, debate = i, date = date_time[i])
  trump_words<- filter(trump_words, trump_words$elim == TRUE)
  trump_words <- select(trump_words, -elim)
  if(i == 1){
    all_debate_words_trump<- trump_words
  }   
  if(i == 2){
    all_debate_words_trump2 <- trump_words
  } 
  if(i == 3){
    all_debate_words_trump3<- trump_words
  } 
  
  
  ##Breaking clinton lines into individual words
  clinton_words <- text_clinton %>%
    unnest_tokens(word, text_c)  
  #clinton_words
  
  
  
  #filter out the stopwords, add which debate it was and what day and time
  clinton_words_unique <- !(clinton_words$word %in% stopwords())
  clinton_words <- mutate(clinton_words, speaker = "clinton", elim = clinton_words_unique, debate = i, date = date_time[i])
  clinton_words<- filter(clinton_words, clinton_words$elim == TRUE)
  clinton_words <- select(clinton_words, -elim)
  
  if(i == 1){
    all_debate_words_clinton<- clinton_words
  }   
  if(i == 2){
    all_debate_words_clinton2 <- clinton_words
  } 
  if(i == 3){
    all_debate_words_clinton3<- clinton_words
  } 
  
  
  sentiment_clinton <- get_sentiment(as.vector(clinton_words$word))
  sentiment_trump <- get_sentiment(as.vector(trump_words$word))
  
  pwdw <- round(length(sentiment_clinton)*.1)
  clinton_rolled <- zoo::rollmean(sentiment_clinton, k=pwdw)
  bwdw <- round(length(sentiment_trump)*.1)
  trump_rolled <- zoo::rollmean(sentiment_trump, k=bwdw)
  ###############this is a good comparison between the candidates, not really smoothed much 
  clinton_list_getting <- rescale_x_2(clinton_rolled)
  #clinton_list$x <- mutate(clinton_list$x, debate = i)
  trump_list_getting <- rescale_x_2(trump_rolled)
  #trump_list$x <- mutate(trump_list$x, debate = 1)
  
  nrc_data_c <- get_nrc_sentiment(as.vector(clinton_words$word))
  nrc_data_t <- get_nrc_sentiment(as.vector(trump_words$word))
  
  
  if(i == 1){ 
    clinton_x_getting <- as.data.frame(clinton_list_getting$x)
    clinton_x <- mutate(clinton_x_getting, debate = i)
    clinton_y_getting <- as.data.frame(clinton_list_getting$z)
    clinton_y <- mutate(clinton_y_getting, debate = i)
    
    trump_x_getting <- as.data.frame(trump_list_getting$x)
    trump_x <- mutate(trump_x_getting, debate = i)
    trump_y_getting <- as.data.frame(trump_list_getting$z)
    trump_y <- mutate(trump_y_getting, debate = i)
    
    clinton_emo <- as.data.frame(colSums(prop.table(nrc_data_c[, 1:8])))
    clinton_emo <- mutate(clinton_emo, debate = i)
    trump_emo <- as.data.frame(colSums(prop.table(nrc_data_t[, 1:8])))
    trump_emo <- mutate(trump_emo, debate = i)
    
    names11 <- as.data.frame(rownames(trump_emo))
    names22 <- as.data.frame(rownames(clinton_emo))
    trump_emo <- bind_cols(trump_emo, names11)
    clinton_emo <- bind_cols(clinton_emo, names22)
    
    
    
    
  } else{  
    clinton_x_getting <- as.data.frame(clinton_list_getting$x)
    clinton_x2 <- mutate(clinton_x_getting, debate = i)
    clinton_x <- bind_rows(clinton_x, clinton_x2)
    
    clinton_y_getting <- as.data.frame(clinton_list_getting$z)
    clinton_y2 <- mutate(clinton_y_getting, debate = i)
    clinton_y <- bind_rows(clinton_y, clinton_y2)
    
    trump_x_getting <- as.data.frame(trump_list_getting$x)
    trump_x2 <- mutate(trump_x_getting, debate = i)
    trump_x <- bind_rows(trump_x, trump_x2)
    
    trump_y_getting <- as.data.frame(trump_list_getting$z)
    trump_y2 <- mutate(trump_y_getting, debate = i)
    trump_y <- bind_rows(trump_y, trump_y2)
    
    clinton_emo2 <- as.data.frame(colSums(prop.table(nrc_data_c[, 1:8])))
    clinton_emo2 <- mutate(clinton_emo2, debate = i)
    trump_emo2 <- as.data.frame(colSums(prop.table(nrc_data_t[, 1:8])))
    trump_emo2 <- mutate(trump_emo2, debate = i)
    
    
    names2 <- as.data.frame(rownames(trump_emo2))
    names3 <- as.data.frame(rownames(clinton_emo2))
    trump_emo2 <- bind_cols(trump_emo2, names2)
    trump_emo2 <- rename(trump_emo2, c(`rownames(trump_emo2)` = "rownames(trump_emo)"))
    clinton_emo2 <- bind_cols(clinton_emo2, names3) 
    clinton_emo2 <- rename(clinton_emo2, c(`rownames(clinton_emo2)` = "rownames(clinton_emo)")) 
    
    clinton_emo <-  bind_rows(clinton_emo, clinton_emo2)  
    trump_emo <- bind_rows(trump_emo, trump_emo2)
    
    
  }  
  
  
  print(i)
}


##Counting the number of times each word is said for clinton
clinton_word_frequency <- table(clinton_words)


##Counting the number of times each word is said for trump
trump_word_frequency <- table(trump_words)

clinton_x <- rename(clinton_x, c(`clinton_list_getting$x` = "score"))
clinton_y <- rename(clinton_y, c(`clinton_list_getting$z` = "score"))

trump_x <- rename(trump_x, c(`trump_list_getting$x` = "score"))
trump_y <- rename(trump_y, c(`trump_list_getting$z` = "score"))

df_c <- data.frame(clinton_x, clinton_y)
names(df_c) <- c("clinton_plot_x", "debate", "clinton_plot_y")

df_t <- data.frame(trump_x, trump_y)
names(df_t) <- c("trump_plot_x", "debate", "trump_plot_y")


all_donaldtrump_words <- rbind(all_debate_words_trump, all_debate_words_trump2, all_debate_words_trump3)
all_hilaryclinton_words <- rbind(all_debate_words_clinton, all_debate_words_clinton2, all_debate_words_clinton3)

big_word_frame <- rbind(all_donaldtrump_words, all_hilaryclinton_words)

<<<<<<< HEAD

=======
save(big_word_frame, file = "big_word_frame.RData")
>>>>>>> dcc080633d110c238c80c6289506be7b19c32fdb
