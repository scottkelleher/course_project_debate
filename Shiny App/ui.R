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

textInput("textg", label = h3("show me Google"), value = "deplorables"),
hr(),
fluidRow(column(3, verbatimTextOutput("value"))),
      
  ##  Main Panel
    mainPanel( 
              DT::dataTableOutput("high_frequency_words"), 
              plotOutput("word_plot"),
              plotOutput("term_plot")
             
    ))) 





 