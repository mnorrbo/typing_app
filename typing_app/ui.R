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
    
    # htmlOutput("results"),
    
  #   tags$script('
  #   $(document).on("shiny:idle", function (e) {
  #      Shiny.onInputChange("mydata", Math.random());
  #   });
  # '),

    br(),

    textAreaInput(
        "user_typing",
        "Type the code above",
        value = "",
        placeholder = "Start typing here"),

    img(src="hand_mascot.gif")

    )
