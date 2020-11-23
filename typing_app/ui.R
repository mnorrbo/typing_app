ui <- fluidPage(
    useShinyjs(),
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

    img(src="hand_mascot.gif"),
  
    actionButton("toggleSidebar", "Options"),
    
    br(), 
  
    hidden(div(id ="options",
               style = "background-color: #b0d6d4;
                        border-color: #99c4c1;,
                        border-style: solid;
                        border-radius: 20px;
                        width: 500px;
                        padding: 20px;
                        margin-left: auto;
                        margin-right: auto;",
               
               checkboxGroupButtons('packageSelect1',
                                    "Packages:",
                                    choices = c("ggplot2",
                                                "dplyr",
                                                "tidyr",
                                                "readr"),
                                    selected = c("ggplot2", "dplyr")
               ),
               
               checkboxGroupButtons('packageSelect2',
                                    "",
                                    choices = c("purrr",
                                                "tibble",
                                                "stringr",
                                                "forcats"),
                                    selected = ""),
               
               textInput("otherPackage", "Other (optional):", placeholder = "Enter any CRAN package name"),
               
               actionButton('packageButton', 'use this package')
  
    ))
  
)


