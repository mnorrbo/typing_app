source("global.R")

server <- function(input, output, session) {
    
    # Find which packages to use for examples
    packages <- eventReactive(list(input$packageSelect, input$packageButton), {
        if (input$otherPackage != "") {
            c(input$packageSelect, input$otherPackage)
        } else {
            input$packageSelect
        }
    })
    
    # Extract examples from package documentation
    code_chunks <- reactive({
        tryCatch(
            unlist(purrr::map(packages(), get_examples))
        )
    })
    
    # Read user input and split it into a character vector
    # e.g., "Hello" -> "H" "e" "l" "l" "o"
    user_split <- eventReactive(input$user_typing, {
        str_split(input$user_typing, "") %>% flatten_chr()
    })
    
    # Whenever user types, split the example code
    # into a character vector
    code_split <- eventReactive(input$user_typing, {
        str_split(code_chunks()[code_place], "") %>% flatten_chr()
    })
    
    # When user has typed something the same length as the example
    # change example and reset input
    observe({
        if (length(user_split()) >= length(code_split())) {

            code_place <<- sample(1:length(code_chunks()), 1)

            updateTextAreaInput(
                session,
                "user_typing",
                "Type the code above",
                value = "",
                placeholder = "Start typing here")
            

        }
    })
    
    current_mistakes <- reactive(
        find_mistakes(user_input = input$user_typing,
                      user_split = user_split(),
                      example_code = code_chunks()[code_place],
                      example_split = code_split())
    )
    
    observeEvent(input$user_typing,
                 {
                     
                     # count new mistakes 
                     # based on current mistakes and previous mistakes
                     update_mistakes(current_mistakes(), old_mistakes)

                     # display mistake count
                     output$mistakes_indicator <- renderText(paste(
                         "Mistakes:", mistakes
                         ))
                     
                 })
    
    # When user makes an input, colour the code to indicate accuracy
    # also count mistakes, for use when code chunk is completed
    output$example_code <- renderText({
        mistake_feedback(true_false = current_mistakes(),
                         user_split = user_split(),
                         user_input = input$user_typing,
                         example_code = code_chunks()[code_place],
                         example_split = code_split())
    })
    
    output$stateMessage <- renderText({
        "You are in free-typing mode, press the button below to start recording your performance."
    })
    
    observeEvent(input$toggleSidebar, {
        shinyjs::toggle(id = "options",
                        anim = TRUE)
    })
}
