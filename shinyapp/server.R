library(shiny)

#Used Functions
myPlot <- function(mtcars, weight, model){
  
  # Modification of Plot Limits
  lowerX <- min(min(mtcars$wt),weight)
  higherX <- max(weight, max(mtcars$wt))
  
  answer <- GetAnswer(model,weight)
  lowerY <- min(min(mtcars$mpg), answer)
  higherY <- max(answer, max(mtcars$mpg))
  
  # Plotting Elements
  plot(mpg ~ wt, mtcars,
       col = 'blue', pch = 16, lwd = 3,
       xlim = c(lowerX,higherX), ylim = c(lowerY,higherY),
       xlab = 'Weight (lbs/1000)', ylab = 'MPG', main = 'Miles per Gallon ~ Weight')
  abline(model, col = 'green', lwd = 5)
  points(x = weight, y = answer, lwd = 5, col = 'red', pch = 3)
  legend('topright', c('Studied Cars','Linear Model','Your Car'), pch = 16, col = c('blue','green','red'))
  
  # Impossible Physical Scenarios
  newLegend <- FALSE
  if(weight <= 0){
    abline(v = 0, col = 'black', lwd = 2)
    newLegend <- TRUE
  }
  if(answer <= 0){
    abline(h = 0, col = 'black', lwd = 2)
    newLegend <- TRUE    
  }
  if(newLegend == TRUE){
    legend('bottomleft', 'Linear Model Limits', lty = 1, col = 'black', lwd = 3)
  }
}

# Obtain Model Estimation
GetAnswer <- function(model, wt){
  return(as.vector(predict(model, data.frame(wt = wt))))
}

# Prepare Output Text
PrepAns <- function(answer,weight){
  answer <- round(answer,2)
  output <- paste0('An average of ', answer, ' miles per Gallon')
  
  if(weight <= 0){
    output <- paste0(output, ' ... on a IMAGINARY CAR!?')
  }else if(answer <= 0){
    output <- paste0(output, '... YOU OWE MPG!? 0_o')
  }
  
  return(output)
}

PrepAdvice <- function(model,weight){
  answer <- GetAnswer(model, weight)
  
  if(weight <= 0){
    return('You can eliminate the intercept but be careful of how the beta estimate should be interpreted. This scenario of lower interpolation of the x variable is easy to spot, but difficult to solve. Most importantly, using a value of X below the minimum of the sampled data should be done carefully as that is a case of extrapolation. The closer to the original range the better. ')
  }else if(answer <= 0){
    return('You should consider changing the model (using asymptote limits or curve fitting) if a negative predicted value makes no sense for the dependent variable. This is an extreme case of upper extrapolation. For the given scenario it is easy to think that a car can be as big as the resources allow, but the linear model fails to observe this logic. Extrapolation should be performed carefully. The closer to the studied range the better')
  }else{
    return("Linear prediction is assumed to be correct within the studied range. Extrapolation on the X - axis should be done carefully. The confidence range of the extrapolation widens as the tested value gets farther from the original data. Demonstration will be shown in a future app.")
  }
}

# Funny Additions
CheckWeight <- function(model, weight){
  output <- paste0(weight, ' lbs')
  answer <- GetAnswer(model, weight/1000)
  
  if(weight <= 0){
    return(paste0(output, " ... Lightest car known is 1045 lbs"))
  }else if(answer <= 0){
    return(paste0(output, " ... Heaviest car known is 6129 lbs"))
  }else{
    return(output)
  }
}

#Compute Model at Start, to avoid recomputation
data(mtcars)
model <- lm(mpg ~ wt, mtcars)



# SHINY SERVER FUNCTION
# I tried to avoid multiple GetAnswer() calls but there was a Shiny Error I could not solve
shinyServer(
  function(input, output){
    x <- reactive({input$carWeight/1000})
    
    output$wtText <- renderText({CheckWeight(model, input$carWeight)})
    output$simplePlot <- renderPlot({myPlot(mtcars, x(), model)})
    output$predText <- renderText({PrepAns(GetAnswer(model, x()),x())})
    output$conclusion <- renderText({PrepAdvice(model, x())})
  }
)