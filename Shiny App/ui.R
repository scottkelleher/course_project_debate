
library(shiny)
library(ggplot2)

##start user interface
shinyUI(fluidPage(  
  
  #application title
  titlePanel("Google Trends"),

#Sidebar with options
  #sidebarLayout(   
    #sidebarPanel(
      selectInput("Debate", "Debate", choices = c("First_Debate","Second_Debate", "Third_Debate"),
      selectInput("Speaker", "Speaker", choices = c("Hillary_Clinton","Donald_Trump"),
    #helpText("Give one or more terms that you want R to retrieve data from the Google Trends API. Use comma to separate terms")
    ##textInput('terms', ''),

  ##  Main Panel, show the plots
  mainPanel(
    plotOutput("emotions")
    #plotOutput("term_plot"))
    )))))



# mainPanel(
#   #plotOutput("terms"),
#   tags$h1(submitButton("Update!"),
#           helpText("To get results, click the 'Update!' button"),
  
  #might need this as skeleton code later
#   server <- function(input, output, session){
# output$terms <- renderPlot({
#   plot(rnorm(input$speakerInput))
# 
    

 