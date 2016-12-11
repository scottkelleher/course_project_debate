This is the server logic for a Shiny web application.
You can find out more about building applications with Shiny here:
 http://shiny.rstudio.com
library(gtrendsR)
#making gtrends plots
getwd()
usr <- ("tulsigompo@gmail.com")
psw <- ("9841977137")
ch <- gconnect(usr, psw)

-library(shiny)
+#enter data frame and save as
  
shinyServer(function(input, output) {
some_trump_words <- gtrends(c("deals", "catastrophically", "borders", "amendment"), geo = "US", start_date = "2016-09-01", end_date = "2016-11-15")
plot(some_trump_words)

output$distPlot <- renderPlot({
  # generate bins based on input$bins from ui.R
  x <- faithful[, 2]
bins <- seq(min(x), max(x), length.out = input$bins + 1)
some_clinton_words <- gtrends(c("women", "undocumented", "security", "espionage"), geo = "US", start_date = "2016-09-01", end_date = "2016-11-15")
plot(some_clinton_words)
        
 # draw the histogram with the specified number of bins
   hist(x, breaks = bins, col = 'darkgray', border = 'white')
  # https://www.r-bloggers.com/intro-to-text-analysis-with-r/