###########################################################################
##R Shiny App to plot basketball data
##Justin Post - Spring 2015
###########################################################################

library(shiny)
library(png)
library(DT)
library(dplyr)

PlayerNames<-read.csv("PlayerNames.csv",header=TRUE)[,2]

  shinyUI(fluidPage(
    
    # Application title
    titlePanel("Shot Chart App"),
    
    # Sidebar with options for the data set
    sidebarLayout(
      sidebarPanel(
        h3("Select your player from the drop down list below:"),
        selectizeInput("player","Player:",selected="LeBron James",choices=levels(PlayerNames)),
        br(),
        checkboxInput("color",h4("Color Code Made/Missed",style="color:red;")),
        br(),
        sliderInput("time", "Time of Shots During Game",
                    min = 0, max = 63, value = c(0,63)),
        br(),
        br()
      ),
      
      # Show plots
      mainPanel(
        plotOutput("shotChart"),
        dataTableOutput("observations"))
    )
  ))
  


