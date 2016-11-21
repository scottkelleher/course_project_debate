
library(shiny)
library(ggplot2)
library(shinydashboard)

##start user interface
ui <- dashboardPage(
  dashboardHeader(title = "By Term"),
  dashboardSidebar(
    br(),
    h6(" Search Term(s)",style="text-align:center;color:#FFA319;font-size:150%"),
    helpText("Give one or more terms that you want R to retrieve data from the Google Trends API.
             Use comma to separate terms", style="text-align:center"),
    
    textInput('terms', ''),
      selectInput("speakerInput", "Speaker", choices = c("Hillary Clinton","Donald Trump"),
                  selectInput("debateInput", "Debate", choices = c("First_Debate","Second_Debate", "Third_Debate"),
                              textInput("termInput", 'terms', ''),
                              mainPanel(
                                plotOutput("terms"),
        tags$h1(submitButton("Update!"),style="text-align:center"),
        helpText("To get results, click the 'Update!' button",style="text-align:center"),
                                br(),
                                br(),
                                br(),
                                br(),
                                br(),
                                br())),
  
  #####
  ##  Main Panel
  dashboardBody(    
    fluidRow(
      br(),
      h5(em(strong("Google Trends Analytics", style="color:darkblue;font-size:210%")),align = "center"),
      
      plotOutput("term_plot"),
      br(),
      plotOutput("emotion_plot"),
      plotOutput("myplot2")
  ))
  )
  ))


  
  



  #might need this as skeleton code later
  server <- function(input, output, session){
output$terms <- renderPlot({
  plot(rnorm(input$speakerInput))
})
}
    
 