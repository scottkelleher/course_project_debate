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
      selectInput("Debate", "Debate", choices = c("1",
                                                  "2",
                                                  "3")),
      selectInput("Speaker", "Speaker", choices = c("clinton",
                                                    "trump"), 
                  selected = "Donald Trump"),

textInput("text1", label = h1("Enter a word or phrase you would like to google in each line"), value = "deplorables"),
textInput("text2", label = h1(""), value = "clinton foundation"),
textInput("text3", label = h1(""), value = "border wall"),
textInput("text4", label = h1(""), value = "bigly"),
textInput("state", label = h1("google search broken down by state, please input phrase"), value = "trump tower"),

hr(),
fluidRow(column(3, verbatimTextOutput("value"))),
      
  ##  Main Panel
    mainPanel( 
              DT::dataTableOutput("high_frequency_words"), 
              #plotOutput("word_plot"),
              plotOutput("term_plot")
             
    ))) 





 