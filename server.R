
library(shiny)
library(datasets)
data(mtcars)

# Define server logic required to generate and plot a random distribution
shinyServer(function(input, output) {

  # Create dynamic selectInput control based on column names of mtcars
  output$variableControl <- renderUI({
    selectInput("variable", "Choose a variabe:", 
                choices = colnames(mtcars))
  })

  # Return the requested column
  variableInput <- reactive(input$variable)
  
  muInput <- reactive(input$mu)

  # Create a dynamic "selectInput"mu" slider based on the mean, min and max of the selected column 
  output$sliderControl <- renderUI({
    if (!is.null(variableInput())) {
      variable_mean <<- mean(as.numeric(mtcars[ , variableInput()]), na.rm = TRUE)
      variable_min <<- min(as.numeric(mtcars[ , variableInput()]), na.rm = TRUE)
      variable_max <<- max(as.numeric(mtcars[ , variableInput()]), na.rm = TRUE)
    } else {
      # used when initializing slider to avoid error messages
      variable_mean <<- mean(as.numeric(mtcars[ , 1]), na.rm = TRUE)
      variable_min <<- min(as.numeric(mtcars[ , 1]), na.rm = TRUE)
      variable_max <<- max(as.numeric(mtcars[ , 1]), na.rm = TRUE)
    }
    step_size <- (variable_max - variable_min) / 100
    sliderInput('mu', 'Guess at the mean',value = variable_mean, min = variable_min, max = variable_max, step = step_size)
  })
#  }
  # Return the column
  output$var <- renderText({
    variableInput()
  })

  
  output$distPlot <- renderPlot({

    if (!is.null(variableInput())) {
      # used when variableInput() is set
      dist <- as.numeric(mtcars[ ,variableInput()])
      hist(dist, xlab=variableInput(), col='lightblue', main='Histogram')
      lines(c(muInput(), muInput()), c(0, 200),col="red",lwd=5)
    } else {
      # used when initializing server.R before columnInput() is set to avoid error messages
      dist <- as.numeric(mtcars[ , 1])
      hist(dist, col='lightblue', main='Histogram')
      mse <<- mean((as.numeric(mtcars[ , 1]) - muInput())^2)
    }
  })
  
  # Return the mean, min and max a caption
  output$mu <- renderText({
    paste("mu = ", toString(muInput())) 
  })
  
  output$mse <- renderText({
    mse <- mean((as.numeric(mtcars[ , variableInput()]) - muInput())^2)
    paste("MSE = ", toString(round(mse, 2)))
  })
})
