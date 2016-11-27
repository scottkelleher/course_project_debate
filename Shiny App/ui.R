
library(shiny)
library(ggplot2)

##start user interface
shinyUI(fluidPage(
  titlePanel("By Term"),
  sidebarLayout(
    sidebarPanel(
    selectInput(" Search Term(s)", style = "text-align:center;color:#FFA319;font-size:150%"),
    helpText("Give one or more terms that you want R to retrieve data from the Google Trends API.
             Use comma to separate terms", style = "text-align:center"),
    
    textInput('terms', ''),
      selectInput("speakerInput", "Speaker", choices = c("Hillary_Clinton","Donald_Trump"),
                  selectInput("debateInput", "Debate", choices = c("First_Debate","Second_Debate", "Third_Debate"),
                              textInput("termInput", 'terms', ''),
                              mainPanel(
                              plotOutput("terms"),
        tags$h1(submitButton("Update!"), style = "text-align:center"),
        helpText("To get results, click the 'Update!' button", style = "text-align:center"),
  #####
  ##  Main Panel
    mainPanel(    
      h3(textOutput("Google Trends Analytics", align = "center"),
      plotOutput("term_plot"),
      plotOutput("emotions")
      ##plotOutput("high_frequency_words")
  ))
  )
  ))))


  
  #might need this as skeleton code later
#   server <- function(input, output, session){
# output$terms <- renderPlot({
#   plot(rnorm(input$speakerInput))
# })
# }
    
 