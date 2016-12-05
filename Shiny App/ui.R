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
      selectInput("Debate", "Debate", choices = c("First_Debate","Second_Debate", "Third_Debate")),
      selectInput("Speaker", "Speaker", choices = c("Hillary_Clinton","Donald_Trump")),

textInput("textg", label = h3("show me Google"), placeholder = "Enter text..."),

hr(),
fluidRow(column(3, verbatimTextOutput("value"))),
      
  ##  Main Panel
    mainPanel( 
              DT::dataTableOutput("high_frequency_words"), 
              plotOutput("word_plot"),
              plotOutput("term_plot")
             
    ))) 





 