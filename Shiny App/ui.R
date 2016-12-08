library(shiny)
library(ggplot2)
library(DT)
library(gtrendsR)
library(stringr)
load("big_word_frame.RData")

load("big_word_frame.RData")
usr <- ("535rprogram@gmail.com")
psw <- ("groupproject")
ch <- gconnect(usr, psw)



 ##start user interface
 shinyUI(fluidPage( 
   theme = "bootstrap.css",
   
   #application title
   titlePanel("Google Trends"),
 
 #Sidebar with options
 
   sidebarLayout(   
     sidebarPanel(
       selectInput("Debate", "Debate", choices = c("1",
                                                   "2",
                                                   "3")),
       selectInput("Speaker", "Speaker", choices = c("Clinton",
                                                     "Trump"), 
                   selected = "Donald Trump"),
 
 textInput("text1", label = h1("Enter word or phrase to display Google Trends"), value = "deplorables"),
 textInput("text2", label = h1(""), value = "clinton foundation"),
 textInput("text3", label = h1(""), value = "border wall"),
 textInput("text4", label = h1(""), value = "bigly"),
 textInput("state", label = h1("Google search by state"), value = "bigly"),
 textInput("state", label = h1(""), value = "bigly"),
 hr(),
 fluidRow(column(3, verbatimTextOutput("value")))),
       
     ##  Main Panel
     mainPanel( 
       tabPanel("Frequency of Words", 
               DT::dataTableOutput("high_frequency_words")
               )
    #   tabPanel("Google Trends",
    #            plotOutput("term_plot")
    #           ),
    #   tabPanel("State",
    #            plotOutput("states_plot")
    #            )
    #           #plotOutput("word_plot"),
    #           #plotOutput("term_plot"),
    #           #plotOutput("states_plot")
    #          
     ))))
 






 