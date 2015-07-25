##
## server.R
##
## Preliminary Stuff
## Load libraries 
library(shiny)
library(ggplot2)
library(stringr)
library(ggplot2)
library(RColorBrewer)
##
## Initialize column headings
##
emp_names <- c("Soc.Code","X2012","X2022","Delta","Delta.Percent",
               "GrowthReplaceOpennings","MedianWage.X2012","Education")
soc_names <- c("Soc.Code", "Soc.Major","Soc.Minor","Broad.Occ","Detail.Occ","Soc.Title")
##
## Load data and set variable names
##
emp_data <- read.csv("data/Employment Projections.csv", stringsAsFactors=FALSE,
                     na.strings = "N/A")[,2:9]
soc_data <- read.csv("data/soc_2010_definitions.csv",stringsAsFactors=FALSE,
                     na.strings = "N/A")[,1:6]
names(emp_data) <- emp_names; names(soc_data) <- soc_names
##
## Merge the Employment data with the Employment Descriptions.
##
emp_data <- merge(emp_data, soc_data)
emp_data <- emp_data[!is.na(emp_data$MedianWage.X2012),]
emp_data$Soc.Title <- as.factor(emp_data$Soc.Title) 
##
## Clean Median Wage variable and convert to numeric for calculations
##
emp_data$MedianWage.X2012 <- gsub(">=","",emp_data$MedianWage.X2012)
emp_data$MedianWage.X2012 <- as.numeric(gsub(",","",emp_data$MedianWage.X2012))
##
## Arrange data by MedianWage for doing top/bottom selection calculations.
##
emp_data <- emp_data[order(emp_data$MedianWage.X2012,decreasing = TRUE, na.last = FALSE),]
##
##  Create Education Level list for application dropdown.
##
Education.Level <- sort(unique(emp_data$Education))
##
##
##  Shiny Server app section
##
## 
shinyServer(
    function(input,output,session) {
##  Define list for Education Level Drop down
                output$ui <- renderUI({selectInput(inputId="EdLvl",
                               label = strong("Select the Education Level and Wage Type"),
                               choices = Education.Level)})
##  Plot top/botton list of 10 Occupations for selected Education Level         
       output$plot <- reactivePlot(function(){
              category <- input$EdLvl
                        if(input$HiLo == 1) {
                  df <- head(emp_data[emp_data$Education== category,],10)
              }    else   {
                  df <- tail(emp_data[emp_data$Education== category,],10)
                 }        
          
                g <- ggplot(df,aes(x = reorder(Soc.Title, MedianWage.X2012), 
                             y = MedianWage.X2012, fill = factor(Soc.Title))) + 
                      geom_bar(stat = "identity") + 
                      scale_fill_brewer(palette = "Set3") +
                      theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1)) +
                      labs(x= "",y = "Median Wage (Dollars)") +
                      guides(fill = FALSE) +
                      ggtitle(category) 
                print(g)              
          
      })
##  Calculate wage mean for selected Education Level        
       output$gm <- renderPrint(function(){
           gm <- mean(emp_data[emp_data$Education== input$EdLvl,
                                 "MedianWage.X2012"])
           print(gm)
           
       })  
       
       
 })

