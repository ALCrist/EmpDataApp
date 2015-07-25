## 
## ui.R
##
## load libraries
library(shiny)
##
## Web page consists of 2 input values and 2 output values
##
shinyUI(fluidPage(
    titlePanel(h1("Top Ten Occupations", align = "center")),
    helpText(
        h5("Select an Educational Level to display mean average wage and top/bottom wages by occupation.  ",
            "Click on 'Highest Wages' to display a graph of occupations with the highest median wages.  ",
           "Click on 'Lowest Wages' to display a graph of occupations with the lowest median wages."
           
        )),
    
## Input for Education Level dropdown    
    uiOutput("ui"), 
 ##  Input for top/bottom selection 
    radioButtons(inputId = "HiLo",
                 label = NULL,
                 choices = list("Highest Wages" = 1,"Lowest Wages"=2),
                                inline = TRUE),
## Output for mean wage for selected Education Level    
    mainPanel(
        h5("Mean Wage for Selected Educational Level: "),
              verbatimTextOutput("gm"),
## Output for plot of median wages for top/bottom 10 occupations
              plotOutput("plot"))
))
