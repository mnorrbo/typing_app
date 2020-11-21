library(shiny)

ui <- shinyUI(fluidPage(
  titlePanel("Reactive"),
  sidebarLayout(
    sidebarPanel(
      helpText("Variables!"),
      selectInput("var", 
                  label = "Choose Variable",
                  choices = c("red", "blue",
                              "green", "black"),
                  selected = "Rojo"),
      sliderInput("range", 
                  label = "Range:",
                  min = 0, max = 100, value = c(0, 100))
    ),
    mainPanel(
      textOutput("text1"),
      textOutput("text2"),
      htmlOutput("text3"),
      textOutput("text4")
    )
  )
))

server <- function(input, output) {
  output$text1 <- renderText({ 
    paste("You have selected variable:", input$var)
  })
  
  output$text2 <- renderText({ 
    paste("You have selected range:", paste(input$range, collapse = "-"))
  })
  
  output$text3 <- renderText({
    paste('<span style=\"color:', input$var, 
          '\">This is "', input$var, 
          '" written ', input$range[2], 
          ' - ', input$range[1], 
          ' = ', input$range[2] - input$range[1], 
          ' times</span>', sep = "")
  })
  
  output$text4 <- renderText({ 
    rep(input$var, input$range[2] - input$range[1])
  })
}

# Run the application 
shinyApp(ui = ui, server = server)