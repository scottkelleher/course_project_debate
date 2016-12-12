# text debates source file
text_debate1 <- read_html("http://www.presidency.ucsb.edu/ws/index.php?pid=118971") # load the first debate page
text_debate2 <- read_html("http://www.presidency.ucsb.edu/ws/index.php?pid=119038")  # load the second debate page
text_debate3 <- read_html("http://www.presidency.ucsb.edu/ws/index.php?pid=119039")# load the third debate page 

text_debate1 <- html_nodes(text_debate1, ".displaytext") %>% # isloate the text
  html_text() # get the text

text_debate2 <- html_nodes(text_debate2, ".displaytext") %>% # isloate the text
  html_text() # get the text

text_debate3 <- html_nodes(text_debate3, ".displaytext") %>% # isloate the text
  html_text() # get the text