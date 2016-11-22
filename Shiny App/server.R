
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

library(shiny)
library(gtrendsR)
library(reshape2)
library(ggplot2)




##Loading libraries
library(rvest)
#library(tidyverse)
library(stringr)
library(tidytext)
library(gtrendsR)
library(dplyr)
library(tm)
library(SnowballC)
library(wordcloud)
library(lubridate)
library(RColorBrewer)
library(shiny)
library(shinydashboard)

ui <- fluidPage()
server <- function(input, output) {}
shinyApp(ui = ui, server = server)

