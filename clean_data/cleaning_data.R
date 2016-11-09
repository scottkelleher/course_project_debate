library(rvest)
library(tidyverse)
library(stringr)
library(tidytext)

getLines <- function(person){
  text <- text_debate1 
  id <- unlist(stringr::str_extract_all(text, "[A-Z]+:")) # get the speaker
  Lines <- unlist(strsplit(text, "[A-Z]+:"))[-1]  # split by speaker (and get rid of a pesky empty line)
  Lines[id %in% person] # retain speech by relevant speaker
}

debate_lines <- lapply(c("CLINTON:", "TRUMP:"), getLines)

#trying to break whole text into individual words
library(tidytext)
library(tokenizers)

clinton_lines <- debate_lines[1]
trump_lines <- debate_lines[2]


