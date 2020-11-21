ui <- fluidPage(
    
    h1("Typing Speed Test"),
    
    br(),
    
    htmlOutput(
        "example_code",
        container = pre
    ),
    
    br(),
    
    textAreaInput(
        "user_typing",
        "Type the code above",
        value = "",
        placeholder = "Start typing here")
    )
