library(rvest)
library(tidyverse)

text_debate1 <- read_html("http://www.presidency.ucsb.edu/ws/index.php?pid=118971") %>% # load the first debate page
  html_nodes(".displaytext") %>% # isloate the text
  html_text() # get the text


getLines <- function(x, person){
  id <- unlist(str_extract_all(text, "[A-Z]+:")) # get the speaker
  Lines <- unlist(strsplit(text, "[A-Z]+:"))[-1] # split by speaker (and get rid of a pesky empty line)
  Lines[id %in% person] # retain speech by relevant speaker
}

ClintonLines <- lapply(FUN = person = "CLINTON:")
TrumpLines <- lapply(person = "TRUMP:")
?lapply
