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
library(lubridate)

##Loading debate texts
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

#dates of debate
db1 <- ymd_hms(160927020000, tz = "UTC")
db2 <- ymd_hms(161009020000, tz = "UTC")
db3 <-ymd_hms(161029020000, tz = "UTC")
date_time <-c(db1, db2, db3)

for (i in (1:3)){    
  
  ##Getting the chunks of text and assigning the speaker, this just defines a function and we can place this actual code somewhere else later as long as we call the function 
  getLines <- function(person){
    text <- w[i]
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
  text_clinton 
  
  
  #break into trump lines 
  text_trump <- data_frame(text_t = trump_lines[[1]]) 
  text_trump 
  
  
  ##Breaking trump lines into individual words
  trump_words <- text_trump %>%
    unnest_tokens(word, text_t)  
  #trump_words  
  
  
  #filter out the stopwords, add which debate it was and the day and time
  trump_words_unique <- !(trump_words$word %in% stopwords())
  trump_words <- mutate(trump_words, elim = trump_words_unique, debate = i, date = date_time[i])
  trump_words<- filter(trump_words, trump_words$elim == TRUE)
  trump_words <- select(trump_words, -elim)
  if(i == 1){
    all_debate_words_trump<- trump_words
  } else{
    all_debate_words_trump <- bind_rows(all_debate_words_trump, trump_words)
  }
  
  
  ##Breaking clinton lines into individual words
  clinton_words <- text_clinton %>%
    unnest_tokens(word, text_c)  
  #clinton_words
  
  
  
  #filter out the stopwords, add which debate it was and what day and time
  clinton_words_unique <- !(clinton_words$word %in% stopwords())
  clinton_words <- mutate(clinton_words, elim = clinton_words_unique, debate = i, date = date_time[i])
  clinton_words<- filter(clinton_words, clinton_words$elim == TRUE)
  clinton_words <- select(clinton_words, -elim)
  
  if(i == 1){
    all_debate_words_clinton<- clinton_words
  } else{
    all_debate_words_clinton <- bind_rows(all_debate_words_clinton, clinton_words)
  } 
  }
  
  
  ##Counting the number of times each word is said for clinton
  clinton_word_frequency <- table(clinton_words)
  
  
  ##Counting the number of times each word is said for trump
  trump_word_frequency <- table(trump_words)
  
  ##Object that has word frequencies sorted from least to most for clinton
  clinton_most_words <- sort(clinton_word_frequency)
  
  
  ##Object that has word frequencies sorted from least to most for trump
  trump_most_words <- sort(trump_word_frequency)
  
  #making data frame
  clinton_word_frequency <- as.data.frame(clinton_word_frequency)
  
  clinton_word_top <- clinton_word_frequency %>%
  filter(Freq > 10) %>%
  select(word, debate, Freq)
