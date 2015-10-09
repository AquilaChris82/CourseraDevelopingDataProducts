
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

des_lookup <- function(var_name){
  switch(var_name,
         mpg="mpg: Miles/(US) gallon",
         cyl="cyl: Number of cylinders",
         disp="disp: Displacement (cu.in.)",
         hp="hp: Gross horsepower",
         drat="drat: Rear axle ratio",
         wt="wt: Weight (lb/1000)",
         qsec="qsec: 1/4 mile time",
         vs="vs: V/S",
         am="am: Transmission (0 = automatic, 1 = manual)",
         gear="gear: Number of forward gears",
         carb="carb: Number of carburetors")
}

shinyServer(function(input, output) {
  data(mtcars)
  
  output$slope_slider <- renderUI({
    slide_min <- -(max(mtcars[[input$y]])/max(mtcars[[input$x]]))*1.5 
    slide_max <- (max(mtcars[[input$y]])/max(mtcars[[input$x]]))*1.5 
    sliderInput("slope",label="slope",min=slide_min,max=slide_max, 
                step=0.01,value=(slide_max/2))  
  })
  
  output$intercept_slider <- renderUI({
    slide_min <- -max(mtcars[[input$y]])*1.5 
    slide_max <- max(mtcars[[input$y]])*1.5
    sliderInput("intercept",label="intercept",min=slide_min,max=slide_max, 
                step=0.01,value=(slide_max/2))  
  })
  
  xlim <- reactive({c(min(mtcars[[input$x]]),max(mtcars[[input$x]]))})
  ylim <- reactive({c(min(mtcars[[input$x]]),max(mtcars[[input$x]]))})
  
  mse<-reactive({mean(
    (mtcars[[input$y]]-((mtcars[[input$x]]*input$slope)+input$intercept))^2
  )})
  
  bfmse<-reactive({
    this_model<-lm(mtcars[[input$y]]~mtcars[[input$x]])
    mean(
    (mtcars[[input$y]]-((mtcars[[input$x]]*this_model$coefficients[2])+this_model$coefficients[1]))^2
  )
    })
  
  output$mseText<-renderText({
    mse()
  })
  
  output$bfmseText<-renderText({
    if (input$checkbox==TRUE){
      bfmse()
    }
  })
  
  var_des1<-reactive({des_lookup(input$x)})
  var_des2<-reactive({des_lookup(input$y)})
  
  output$documentation <- renderText({
    paste("This application lets the user develop intuition
for linear regression using R's 'mtcars' dataset.", 
          "You can select different
combinations of variables for the x-axis (independent) and y-axis (dependent)
using the drop down lists.", 
          "Then adjust the sliders to change the 
slope and intercept of a line fit through the points. Using
mean-squared error as a guide, try to find the line of best fit.",
          "Then click the checkbox button below left for the solution", sep="\n")
  })
  
  output$description<-renderText({
    "The data was extracted from the 1974 Motor Trend US magazine, 
    and comprises fuel consumption and 10 aspects of automobile 
    design and performance for 32 automobiles (1973–74 models)."
  })
  
  output$var_des1<-renderText({
    var_des1()
  })
  
  output$var_des2<-renderText({
    var_des2()
  })
  
  output$VaRPlot <- renderPlot({
    
    # scatterplot with variables input
    plot(x=mtcars[[input$x]],y=mtcars[[input$y]],xlab=input$x,ylab=input$y)
    abline(input$intercept,input$slope,col="dark blue")
    if (input$checkbox==TRUE){
    abline(lm(mtcars[[input$y]]~mtcars[[input$x]]),col="red")
    }
  }
  )
  
  
})
