
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Linear Regressions on Mtcars dataset"),

  # Sidebar with a slider input for slope and intercept
  # and list selection for choosing variables from dataset
  sidebarLayout(
    sidebarPanel(
      fluidRow(
        
      ),
      fluidRow(
      column(5,
      selectInput("y",label="y axis",
                  choices=names(mtcars),
                 selected="mpg")),
      column(5,
      selectInput("x",label="x axis",
                  choices=names(mtcars),
                  selected="wt"))
    ),
    
    fluidRow(
    uiOutput("slope_slider")  
    ),
    fluidRow(
    uiOutput("intercept_slider")  
    ),
    fluidRow(
      checkboxInput("checkbox",label="Show line of best fit",value=FALSE)
    ),
    fluidRow(
      helpText("Mean squared Error:"),
      textOutput("mseText")
    ),
    fluidRow(
      helpText("Best Fit mean Squared Error:"),
      textOutput("bfmseText")
    )
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
    fluidRow(
      textOutput("documentation")  
    ),
    fluidRow(  
      plotOutput("VaRPlot")
    ),
    fluidRow(
      textOutput("description")
    ),
    fluidRow(
      textOutput("var_des1")
    ),
    fluidRow(
      textOutput("var_des2")
    )
    )
  )
))
