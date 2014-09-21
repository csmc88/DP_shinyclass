library(shiny)

shinyUI(
  pageWithSidebar(
    
    #App Title
    headerPanel("Extrapolation with Linear Models - Example with mtcars"),
    
    #Inputs
    sidebarPanel(
      #numericInput(inputId = 'carWeight', label = 'Car Weight in lbs', 
                   #3200, min = 1500, max = 4000, step = 50)
      sliderInput('carWeight', 'Car Weight in lbs', value = 3200, min = -50, max = 7000, step = 50)
    ),
    #checkboxGroupInput('regressor', 'Choose main regressor',
     #                  c('Total Weight' = '1',
      #                   'Transmission Type' = '2',
       #                  'Acceleration' = '3')),
    mainPanel(
      tabsetPanel(
        
        tabPanel("Documentation", helpText("Documentation of Shiny App"),
                 includeHTML("documentation.html"), 
                 value=1
        ),
        
        tabPanel("App Output",  helpText("Output of Shiny App"),
                 
                 p('Welcome to this lecture in linear models. This is part of the app suite for Data Analysis Online Classes (DAOC) developed by IMAGINARY PRODUCTS Inc. '),
                 
                 p('The model used to show the results below is described in the documentation tab. Please make sure to read the complete documentation for any doubts.'),
                 
                 p('To the left you should see a slider widget. To explore the effects of extrapolation please move the slider to a desired value. Additional text might appear as you play with the widget.'),
                 
                 p('It is recommended that you play with both limits of the slider as well. '),
                 
                 p('The results of the model and some additional class explanations appear below.'),
                 
                 p('Enjoy this interactive class!'),
                 
                 h3('With a car weighting...'),
                 textOutput('wtText'),
                 
                 h3('And the following plot...'),
                 plotOutput('simplePlot'),
                 
                 h3('You can expect...'),
                 textOutput('predText'),
                 
                 h3('We can conclude...'),
                 textOutput('conclusion'),
                 
                 value=2
        ),
    id = "conditionedPanels")
    
        #h3('With a car weighting...'),
        #textOutput('wtText'),
        #
        #h3('And the following plot...'),
        #plotOutput('simplePlot'),
        #
        #h3('You can expect...'),
        #textOutput('predText'),
        #
        #h3('We can conclude...'),
        #textOutput('conclusion')
    )
  )
)