##Installing new libraries
install.packages("tidytext")
install.packages("gtrendsR")

##Loading libraries
library(rvest)
library(tidyverse)
library(stringr)
library(tidytext)
library(gtrendsR)
library(dplyr)

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

##Creating a function to assign names to their speech
getLines <- function(person){
  text <- text_debate1 
  id <- unlist(stringr::str_extract_all(text, "[A-Z]+:")) # get the speaker
  Lines <- unlist(strsplit(text, "[A-Z]+:"))[-1]  # split by speaker (and get rid of a pesky empty line)
  Lines[id %in% person] # retain speech by relevant speaker
}

##Prints out a function that has everything clinton said and everything trump said
debate_lines <- lapply(c("CLINTON:", "TRUMP:"), getLines)


##Made two vectors for each speaker
clinton_lines <- debate_lines[1]
trump_lines <- debate_lines[2]








