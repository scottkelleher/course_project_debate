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

clinton_lines <- debate_lines[1]
trump_lines <- debate_lines[2]

#trying to break whole text into individual words
library(tidytext)
library(tokenizers)

library(dplyr)
text_df <- data_frame(text_c = clinton_lines[[1]])
text_df

text_debate1 %>%
  unnest_tokens(word, text_c)
text_debate1




library(dplyr)
library(stringr)

text_debate1 %>%
  dplyr::group_by(clinton_lines) %>%
  mutate(linenumber = row_number()) %>%
  ungroup()
text_debate1




