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
  
    uiOutput("start_button"),
  
    uiOutput("user_typing"),

    # textAreaInput(
    #     "user_typing",
    #     "Type the code above",
    #     value = "",
    #     placeholder = "Start typing here"),
  
    # textOutput('stateMessage'),
    # actionButton('timerButton', "Start Challenge!"),
  
    # textOutput("mistakes_indicator"),
    # 
    # textOutput("speed_feedback"),
  
    tableOutput("feedback"),
  
    textOutput("debugger"),

    img(src="hand_mascot.gif"),
  
    br(),
  
    br(),
  
    actionButton("toggleSidebar", "Options"),
    
    br(), 
  
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
               
               checkboxGroupButtons('packageSelect',
                                    "Packages:",
                                    choices = c("jsonlite",
                                                "ggplot2",
                                                "vctrs",
                                                "rlang"),
                                    selected = c("rlang")
               ),
               
               textInput("otherPackage", "Other (optional):", placeholder = "Enter any CRAN package name"),
               
               actionButton('packageButton', 'use this package')
  
    )),
  
    br()
  
)


