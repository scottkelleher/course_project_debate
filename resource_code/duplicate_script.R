
##Loading libraries
library(rvest)
library(tidyverse)
library(stringr)
library(tidytext)
library(gtrendsR)
library(tokenizers)
library(dplyr)
library(tm)
library(SnowballC)
library(wordcloud)

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


##Getting the chunks of text and assigning the speaker 
getLines <- function(person){
  text <- text_debate1 
  id <- unlist(stringr::str_extract_all(text, "[A-Z]+:")) # get the speaker
  Lines <- unlist(strsplit(text, "[A-Z]+:"))[-1]  # split by speaker (and get rid of a pesky empty line)
  Lines[id %in% person] # retain speech by relevant speaker
}

##Creating an object called debate_lines that has two parts, one for clinton and one for trump
debate_lines <- lapply(c("CLINTON:", "TRUMP:"), getLines)


##Created two separate objects with "chunks" of text in each one, one for clinton and one for trump
clinton_lines <- debate_lines[1]
trump_lines <- debate_lines[2]



##Option for getting lines the long way would be hard coding each line of text (not ideal)
##Example
clinton_text_example <- c("How are you, Donald? [applause]", #1
                          "Well, thank you, Lester, and thanks to Hofstra for hosting us.The central question in this election is really what kind of country we want to be and what kind of future we'll build together. Today is my granddaughter's second birthday, so I think about this a lot. First, we have to build an economy that works for everyone, not just those at the top. That means we need new jobs, good jobs, with rising incomes.I want us to invest in you. I want us to invest in your future. That means jobs in infrastructure, in advanced manufacturing, innovation and technology, clean, renewable energy, and small business, because most of the new jobs will come from small business. We also have to make the economy fairer. That starts with raising the national minimum wage and also guarantee, finally, equal pay for women's work.I also want to see more companies do profit-sharing. If you help create the profits, you should be able to share in them, not just the executives at the top.And I want us to do more to support people who are struggling to balance family and work. I've heard from so many of you about the difficult choices you face and the stresses that you're under. So let's have paid family leave, earned sick days. Let's be sure we have affordable child care and debt-free college.How are we going to do it? We're going to do it by having the wealthy pay their fair share and close the corporate loopholes.Finally, we tonight are on the stage together, Donald Trump and I. Donald, it's good to be with you. We're going to have a debate where we are talking about the important issues facing our country. You have to judge us, who can shoulder the immense, awesome responsibilities of the presidency, who can put into action the plans that will make your life better. I hope that I will be able to earn your vote on November 8th.",
                          "Well, I think that trade is an important issue. Of course, we are 5 percent of the world's population; we have to trade with the other 95 percent. And we need to have smart, fair trade deals.We also, though, need to have a tax system that rewards work and not just financial transactions. And the kind of plan that Donald has put forth would be trickle-down economics all over again. In fact, it would be the most extreme version, the biggest tax cuts for the top percent of the people in this country than we've ever had.I call it trumped-up trickle-down, because that's exactly what it would be. That is not how we grow the economy.We just have a different view about what's best for growing the economy, how we make investments that will actually produce jobs and rising incomes.I think we come at it from somewhat different perspectives. I understand that. You know, Donald was very fortunate in his life, and that's all to his benefit. He started his business with $14 million, borrowed from his father, and he really believes that the more you help wealthy people, the better off we'll be and that everything will work out from there.I don't buy that. I have a different experience. My father was a small-businessman. He worked really hard. He printed drapery fabrics on long tables, where he pulled out those fabrics and he went down with a silkscreen and dumped the paint in and took the squeegee and kept going.And so what I believe is the more we can do for the middle class, the more we can invest in you, your education, your skills, your future, the better we will be off and the better we'll grow. That's the kind of economy I want us to see again.",
                          "Well, let's stop for a second and remember where we were eight years ago. We had the worst financial crisis, the Great Recession, the worst since the 1930s. That was in large part because of tax policies that slashed taxes on the wealthy, failed to invest in the middle class, took their eyes off of Wall Street, and created a perfect storm.In fact, Donald was one of the people who rooted for the housing crisis. He said, back in 2006, \"Gee, I hope it does collapse, because then I can go in and buy some and make some money.\" Well, it did collapse.",
                          "Nine million people—nine million people lost their jobs. Five million people lost their homes. And $13 trillion in family wealth was wiped out.Now, we have come back from that abyss. And it has not been easy. So we're now on the precipice of having a potentially much better economy, but the last thing we need to do is to go back to the policies that failed us in the first place.Independent experts have looked at what I've proposed and looked at what Donald's proposed, and basically they've said this, that if his tax plan, which would blow up the debt by over $5 trillion and would in some instances disadvantage middle-class families compared to the wealthy, were to go into effect, we would lose 3.5 million jobs and maybe have another recession.They've looked at my plans and they've said, OK, if we can do this, and I intend to get it done, we will have 10 million more new jobs, because we will be making investments where we can grow the economy. Take clean energy. Some country is going to be the clean- energy superpower of the 21st century. Donald thinks that climate change is a hoax perpetrated by the Chinese. I think it's real.",
                          "etc")





#break into clinton lines
text_clinton <- data_frame(text_c = clinton_lines[[1]])
text_clinton


#break into trump lines
text_trump <- data_frame(text_t = trump_lines[[1]])
text_trump


##Breaking trump lines into individual words
trump_words <- text_trump %>%
  unnest_tokens(word, text_t)
trump_words

##Breaking clinton lines into individual words
clinton_words <- text_clinton %>%
  unnest_tokens(word, text_c)
clinton_words

