
library(shiny)
library(ggplot2)

##start user interface
shinyUI(fluidPage(  
  titlePanel("By Term"),
  #sidebarLayout(   
    #sidebarPanel(  
    #selectInput(""),
    #helpText("Give one or more terms that you want R to retrieve data from the Google Trends API.
             #Use comma to separate terms"), 
    ##textInput('terms', ''),
       selectInput("Speaker", "Speaker", choices = c("Hillary_Clinton","Donald_Trump"),
       selectInput("Debate", "Debate", choices = c("First_Debate","Second_Debate", "Third_Debate"),
                              #textInput("termInput", 'terms', ''), 
  #####
  ##  Main Panel
    mainPanel(plotOutput("emotions") 
    )))))


#plotOutput("term_plot"), 
      #plotOutput("emotions") 
      ##plotOutput("high_frequency_words") 



# mainPanel(
#   #plotOutput("terms"),
#   tags$h1(submitButton("Update!"),
#           helpText("To get results, click the 'Update!' button"),
  
  #might need this as skeleton code later
#   server <- function(input, output, session){
# output$terms <- renderPlot({
#   plot(rnorm(input$speakerInput))
# 
    

 