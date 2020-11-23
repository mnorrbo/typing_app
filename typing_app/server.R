source("global.R")

server <- function(input, output, session){
    
    # Read user input and split it into a character vector
    # e.g., "Hello" -> "H" "e" "l" "l" "o"
    user_split <- eventReactive(input$user_typing, {
        str_split(input$user_typing, "") %>% flatten_chr()
    })
    
    # Whenever user types, split the example code
    # into a character vector
    code_split <- eventReactive(input$user_typing, {
        str_split(code_chunks[code_place], "") %>% flatten_chr()
    })
    
    # When user has typed something the same length as the example
    # change example and reset input
    observe({
        if (length(user_split()) >= length(code_split())) {

            code_place <<- sample(1:length(code_chunks), 1)

            updateTextAreaInput(
                session,
                "user_typing",
                "Type the code above",
                value = "",
                placeholder = "Start typing here")

        }
    })
    
    output$example_code <- renderText({
        returnColouredText(user_input = input$user_typing,
                           user_split = user_split(),
                           example_code = code_chunks[code_place],
                           example_split = code_split())
    })
}
