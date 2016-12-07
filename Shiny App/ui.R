library(shiny)
library(ggplot2)
library(DT)

##start user interface
shinyUI(fluidPage(  
  
  #application title
  titlePanel("Google Trends"),

#Sidebar with options

  #sidebarLayout(   
    #sidebarPanel(
      selectInput("Debate", "Debate", choices = c("First Debate",
                                                  "Second Debate",
                                                  "Third Debate")),
      selectInput("Speaker", "Speaker", choices = c("Hillary Clinton",
                                                    "Donald Trump"), 
                  selected = "Donald Trump"),

textInput("text1", label = h1("Enter a word or phrase you would like to google in each line"), value = "deplorables"),
textInput("text2", label = h1(""), value = "clinton foundation"),
textInput("text3", label = h1(""), value = "border wall"),
textInput("text4", label = h1(""), value = "bigly"),

hr(),
fluidRow(column(3, verbatimTextOutput("value"))),
      
  ##  Main Panel
    mainPanel( 
              DT::dataTableOutput("high_frequency_words"), 
              plotOutput("word_plot"),
              plotOutput("term_plot")
             
    ))) 





 