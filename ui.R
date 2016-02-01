library(shiny)

# Define UI for application that plots random distributions 
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("mtcars Explorer"),
  
  # Sidebar with controls to select a dataset and specify the number
  # of observations to view
  sidebarPanel(
    uiOutput("variableControl"),
    uiOutput("sliderControl")
  ),
  
  
  # Show a plot of the generated distribution
  mainPanel(
    h3(textOutput("mu")),
    h3(textOutput("mse")),
    plotOutput("distPlot")
  )
))
