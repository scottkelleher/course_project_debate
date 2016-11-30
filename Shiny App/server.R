
if(!require(shiny)){
  install.packages('shiny')
}
if(!require(gtrendsR)){
  install.packages('gtrendsR')
}
if(!require(reshape2)){
  install.packages('reshape2')
}
if(!require(ggplot2)){
  install.packages('ggplot2')
}

if(!require(rvest)){
  install.packages('rvest')
}
if(!require(gtrendsR)){
  install.packages('gtrendsR')
}
if(!require(stringr)){
  install.packages('stringr')
}
if(!require(dplyr)){
  install.packages('dplyr')
}
if(!require(tm)){
  install.packages('tm')
}
if(!require(lubridate)){
  install.packages('lubridate')
}
if(!require(RColorBrewer)){
  install.packages('RColorBrewer')
}
#if(!require(shinydashbaord)){
 # install.packages('shinydashboard')
#}
if(!require(tokenizers)){
  install.packages('tokenizers')
}
if(!require(tidytext)){
  install.packages('tidytext')
}
if(!require(xml2)){
  install.packages('tokenizers')
}
if(!require(RTextTools)){
  install.packages('RTextTools')
}
if(!require(devtools)){
  install.packages('devtools')
}
if(!require(googleVis)){
  install.packages('googleVis')
} 
 
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
library(ggplot2)
library(readr)
library(gtrendsR)
#library(xml2)
library(shiny)
library(devtools)
ls("package:gtrendsR")

#library(shinydashboard)
library(RTextTools)
library(googleVis)
library(sentimentr)
source("classify_emotion.R")

library(RTextTools)
library(googleVis)
library(DT)


#install_url("http://www.omegahat.org/Rstem/Rstem_0.4-1.tar.gz")
#install_url("http://cran.r-project.org/src/contrib/Archive/sentiment/sentiment_0.1.tar.gz")
#install_url("http://cran.r-project.org/src/contrib/Archive/sentiment/sentiment_0.2.tar.gz")

shinyServer(function(input, output) { 

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
  reactive({
  if(input$Debate=="First_Debate"){text <- text_debate1
  words_t <-c("trump")
  words_c <- c("clinton")}
  else if (input$Debate=="Second_Debate"){text<- text_debate2
  words_t <- c("trump")
  words_c <- c("clinton")}
  else if (input$Debate=="Third_Debate"){text<- text_debate3
  words_t <- c("trump")
  words_c <- c("clinton")}
  })
  ##Getting the chunks of text and assigning the speaker, this just defines a function and we can place this actual code somewhere else later as long as we call the function 
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
  
  ##Object that has word frequencies sorted from least to most for clinton
  clinton_most_words <- sort(clinton_word_frequency)
  
  
  ##Object that has word frequencies sorted from least to most for trump
  trump_most_words <- sort(trump_word_frequency)
  
  # reactive({
  #   
  #   if(input$Speaker== "Donald_Trump" & input$Debate == "First_Debate"){google_words <- c("Mexico","piggy","sophisticated","tremendously","renegotiate","Secretary","Michigan","NAFTA","red tape","bureaucratic","onerous","braggadocious","squander",
  #                                                                                         "tunnels","bridges","airport security","shooting","vigilant","Lester Holt","Hisapnic","Bloomberg","lawsuit","African American","Cyber","Doable")}
  #   else if (input$Speaker=="Hilary_Clinton" & input$Debate == "First_Debate"){google_words <- c("adversaries","abyss","commander in chief","Profit sharing","transactions","recession","superpower","hoax","perpetrated","ISIS",
  #                                                                                                "repartriation","trickle-down","bait and switch","prohibition","dishwashers","Charlotte","Vibrancy","touted","Kurdish","Caliphate","Al Qaida","Propagada")}
  #   
  #   else if (input$Speaker=="Donald_Trump" & input$Debate == "Second_Debate"){google_words <- c("make America great again","Obamacare", "terrorist state","trade deficit","Inner cities","locker room talk","ISIS chopping off heads","Medieval times","respect for women","Kathey Shelton","Paula Jhones",
  #                                                                                               "own an apology","Wikileaks","Deborah Wasserman Schultz","super delegates","special prosecuter","clinton email scandal","daughter's wedding",
  #                                                                                               "United States congress","monopolies","Johnathan Gurber","Islamphobia",
  #                                                                                               "Trojan Horse","San baernandino","Radical Islamic terrorist","Muslim ban","extreme vetting",
  #                                                                                               "criminal illegal aliens","Warren buffett","massive co-operation","Hillary as a senator","George soros","disaster as senator","Libya with gadhafi","Raqqua and Mosul","Sex Tape","people deplorable","Ambassador Steves",
  #                                                                                               "EPA killing companies","20 trillion debt")}
  #   
  #   else if (input$Speaker=="Hilary_Clinton" & input$Debate == "Second_Debate"){google_words <- c("Michelle Obama","preschool education","Captain Khan","personal emails","prescription drugs","health Insurance","Small businessman","our grandchildren",
  #                                                                                                 "Donald about women","embarras women on TV and twitter","targeted immigrants","gold star family",
  #                                                                                                 "demagogic rhetoric","American Muslims","Homeland security","violent Jihadist terrorist",
  #                                                                                                 "religious freedom and liberty","terrorist sites","intelligence community","Entanglement","foster care system",
  #                                                                                                 "Bipartisan worker","Syria is catastrophic","aggressiveness of Russia","American Forces in syria","Kurdish Peshmerga fighters","Children defense fund","Texas registering Latinos",
  #                                                                                                 "Great Depression","Wealthy American","Supreme court","Second Amendment","Gun show loopholes","Donald children")}
  #   
  #   else if (input$Speaker=="Donald_Trump" & input$Debate == "Third_Debate"){google_words <-  c("aleppo","African American rights","aligned","amendment","amnesty","arabia","beneficiary","border security","businesses","campaign","catastrophe",
  #                                                                                               "china company","congressional","corrupt","crosstalk","depreciation","gdp","ginsburg","gun","haiti","hombres", "humanitarian", "illegal immigrants","imperative","isis","islamic terrorist",
  #                                                                                               "Hilary for jail","unemployment","latinos","macarthur","mexico","migration","nafta","nasty woman","nightmare Trump")}
  #   
  #   else if (input$Speaker=="Hilary_Clinton" & input$Debate == "Third_Debate"){google_words <- c("aleppo","alicia","apprenticeships","Citizenship","Chinese","Catastrophic","Crocodile","Criminals","Cyberattacks","Denigrating","deportation","Discrimination","foundation","Espionage","Heartbreaking","Hurricanes","immigrants","Iranians","Jeopardy",
  #                                                                                                "Laughingstock","Lgbt","mischaracterization","Negotiation","putin","Racketeering","Radicalization","Reagan","Recession",
  #                                                                                                "Republicans","Russian","Saudi", "Steelworkers","Sunni","terrorism","Vladimir","Wikileaks")}
  #   
  #   
  # })    
  
 
  textr <-renderPrint({ input$text})
  output$value <- renderPrint({ input$text })
  google_results <- gtrends(c("trump"), geo = "US", start_date = "2016-09-01", end_date = "2016-11-15")
  
 output$term_plot <- renderPlot({
   plot(google_results)
 }) 
  #should be filtered down to which candidate and which debate at this point
  #some_clinton_words <- gtrends(c("women", "undocumented", "security", "espionage"), geo = "US", start_date = "2016-09-01", end_date = "2016-11-15")
  #plot(some_clinton_words)
  
  reactive({
  
  if(input$Speaker== "Donald_Trump"){top_used_words <- trump_most_words}
  else if (input$Speaker=="Hilary_Clinton"){top_used_words<- clinton_most_words}

  })

  
  
  output$high_frequency_words <- DT::renderDataTable( 
    DT::datatable(as.data.frame(top_used_words), options = list(pageLength = 25))
  ) 
  
  output$word_plot <- renderPlot({plot(top_used_words)})
  
  
  # https://www.r-bloggers.com/intro-to-text-analysis-with-r/
  
  
  
  #library(RTextTools)
  
  #install.packages("devtools")
  #require(devtools)
  #install_url("http://www.omegahat.org/Rstem/Rstem_0.4-1.tar.gz")
  #install_url("http://cran.r-project.org/src/contrib/Archive/sentiment/sentiment_0.1.tar.gz")
  #install_url("http://cran.r-project.org/src/contrib/Archive/sentiment/sentiment_0.2.tar.gz")
  
  
  #data <- readLines("https://www.r-bloggers.com/wp-content/uploads/2016/01/vent.txt") # from: http://www.wvgazettemail.com/
  # the below function was developed from 
  #http://www.rdatascientists.com/2016/08/intro-to-text-analysis-with-r.html
  
  reactive({
  if(input$Speaker=="Donald_Trump"){lines_go <- trump_lines
  words_gtrends <- words_t}
  else if (input$Debate=="Hilary_Clinton"){lines_go<- clinton_lines
  words_gtrends <- words_c}
  })
  df <- data.frame(lines_go)
  colnames(df) <- c("col1")
  textdata <- df[df$col1, ] 
  textdata = gsub("[[:punct:]]", "", textdata) 
  
  textdata = gsub("[[:punct:]]", "", textdata)
  textdata = gsub("[[:digit:]]", "", textdata)
  textdata = gsub("http\\w+", "", textdata)
  textdata = gsub("[ \t]{2,}", "", textdata)
  textdata = gsub("^\\s+|\\s+$", "", textdata)
  try.error = function(x)
  {
    y = NA
    try_error = tryCatch(tolower(x), error=function(e) e)
    if (!inherits(try_error, "error"))
      y = tolower(x)
    return(y) 
  }
  textdata = sapply(textdata, try.error)
  textdata = textdata[!is.na(textdata)]
  names(textdata) = NULL
  
  class_emo = classify_emotion(textdata, algorithm="bayes", prior=1.0)
  emotion = class_emo[,7]
  emotion[is.na(emotion)] = "unknown"
  
  download.file("http://cran.r-project.org/src/contrib/Archive/sentiment/sentiment_0.2.tar.gz", "sentiment.tar.gz")
  install.packages("sentiment.tar.gz", repos=NULL, type="source")
  library(sentiment)
  class_pol = classify_polarity(textdata, algorithm="bayes")
  polarity = class_pol[,4]
  
  
  sent_df = data.frame(text=textdata, emotion=emotion,
                       polarity=polarity, stringsAsFactors=FALSE)
  sent_df = within(sent_df,
                   emotion <- factor(emotion, levels=names(sort(table(emotion), decreasing=TRUE))))
  
 # detach("package:sentiment", unload=TRUE)                
  
  # pdf(plots.pdf) 
  output$emotions <- renderPlot({
    
    ggplot(sent_df, aes(x=emotion)) +
    geom_bar(aes(y=..count.., fill=emotion)) +
    scale_fill_brewer(palette="Dark2") +
    labs(x="emotion categories", y = "")
  # dev.off()
  })
  
}) 

