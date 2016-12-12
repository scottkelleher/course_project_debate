getwd()
usr <- ("535rprogram@gmail.com")
psw <- ("groupproject")
ch <- gconnect(usr, psw)

#enter data frame and save as
  some_trump_words <- gtrends(c("deals", "catastrophically", "borders", "amendment"), geo = "US", start_date = "2016-09-01", end_date = "2016-11-15")
  plot(some_trump_words)

  
some_clinton_words <- gtrends(c("women", "undocumented", "security", "espionage"), geo = "US", start_date = "2016-09-01", end_date = "2016-11-15")
plot(some_clinton_words)
    
# https://www.r-bloggers.com/intro-to-text-analysis-with-r/
#library(RTextTools)
#install.packages("devtools")
#require(devtools)
#install_url("http://www.omegahat.org/Rstem/Rstem_0.4-1.tar.gz")
#install_url("http://cran.r-project.org/src/contrib/Archive/sentiment/sentiment_0.1.tar.gz")
#install_url("http://cran.r-project.org/src/contrib/Archive/sentiment/sentiment_0.2.tar.gz")
data <- trump_lines
#data <- readLines("https://www.r-bloggers.com/wp-content/uploads/2016/01/vent.txt") # from: http://www.wvgazettemail.com/
        
df <- data.frame(trump_lines)
#f <- colnames(df)
#df <- rename(df, # data = f)
#textdata <- df[df, ] 
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
detach("package:sentiment", unload=TRUE)                
pdf(file.pdf,width=6,height=4,paper='special') 
ggplot(sent_df, aes(x=emotion)) +
geom_bar(aes(y=..count.., fill=emotion)) +
scale_fill_brewer(palette="Dark2") +
labs(x="emotion categories", y="", title = paste0("trump_words_from_debate_",i))
dev.off()