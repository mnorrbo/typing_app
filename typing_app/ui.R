library(shiny)
library(shinyWidgets)
library(tidyverse)

ui <- fluidPage(
    
    align = "center",
    
    setBackgroundColor(
        color = "#bcd3f2"
    ),
    
    theme = "stylesheet.css",
    
    titlePanel(
        tags$h1("Typing accuracy test")
    ),
    
    br(),
    
    htmlOutput(
        "example_code",
        container = pre
    ),
    
    br(),
    
    textInput(
        "user_typing",
        "Type the code above",
        value = "",
        placeholder = "Start typing here"),
    
    img(src="hand_mascot.gif")
    
    )
