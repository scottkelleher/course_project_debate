
library(shiny)

##example from gtrends shiny app- we should work on using this as a template
library(shinydashboard)

usr <- ("535rprogram@gmail.com")
psw <- ("groupproject")
ch <- gconnect(usr, psw)

ui <- fluidPage(
  titlePanel("Google Trends"),
  sidebarLayout(
    sidebarPanel("Please select from the following options"),
    mainPanel("results go here")),
    selectInput("speakerInput", "Speaker", choices = c("Hilary Clinton","Donald Trump"),
    selectInput("debateInput", "Debate", choices = c("First debate","Second Debate", "Third Debate"),
    textInput("termInput", 'terms', ''))),

    selectInput("geography", 
            label = tags$h4(strong(em("Geography")),style="text-align:center;color:#FFA319;font-size:150%"),
            choices = c("Worldwide","Afghanistan","Albania","Algeria","Angola","Argentina","Armenia","Australia",
                        "Austria",  "Azerbaijan","Bahamas","Bahrain","Bangladesh","Belarus","Belgium","Botswana", 
                        "Brazil","Bulgaria","Burkina Faso","Burundi","Cambodia","Cameroon","Canada","Chad","Chile",
                        "China","Colombia","Cuba","Cyprus","Czech Republic","Denmark","Djibouti","Ecuador","Egypt",
                        "Equatorial Guinea","Eritrea","Estonia","Ethiopia","Finland","France","Gabon","Gambia",
                        "Georgia","Germany","Ghana","Greece","Hong Kong","Hungary","Iceland","India","Indonesia",
                        "Iran","Iraq","Ireland","Israel","Italy","Jamaica","Japan","Jordan","Kazakhstan","Kenya",
                        "Kiribati","Korea (North)","Korea (South)","Kuwait","Kyrgyzstan","Lebanon","Liberia","Libya",
                        "Macedonia","Madagascar","Malawi","Malaysia","Mali","Malta","Mexico","Morocco","Mozambique",
                        "Namibia","Nepal","Netherlands","New Zealand","Niger","Nigeria","Norway","Oman","Pakistan",
                        "Paraguay","Peru","Philippines","Poland","Portugal","Qatar","Romania","Russian Federation","
                        Rwanda","Saudi Arabia","Senegal","Serbia","Sierra Leone","Singapore","Somalia","South Africa",
                        "Spain","Sudan","Swaziland","Sweden","Switzerland","Syria","Taiwan","Tajikistan","Tanzania",
                        "Thailand","Togo","Tunisia","Turkey","Turkmenistan","Uganda","Ukraine","United Arab Emirates",
                        "United Kingdom","United States","Uzbekistan","Venezuela","Viet Nam","Yemen","Zaire","Zambia","Zimbabwe"))
)

  server <- function(input, output, session){}
shinyApp(ui = ui, server = server)
    
 