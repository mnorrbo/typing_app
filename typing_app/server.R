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
    
    current_mistakes <- reactive(
        find_mistakes(user_input = input$user_typing,
                      user_split = user_split(),
                      example_code = code_chunks()[code_place],
                      example_split = code_split())
    )
    
    observeEvent(input$user_typing,
                 {
                     # When user makes an input, colour the code to indicate accuracy
                     output$example_code <- renderText({
                         mistake_feedback(true_false = current_mistakes(),
                                          user_split = user_split(),
                                          user_input = input$user_typing,
                                          example_code = code_chunks()[code_place],
                                          example_split = code_split())
                     })
                     
                     # control code based on completion of typing
                     if (length(user_split()) < length(code_split()) | 
                         sum(!current_mistakes(), na.rm = TRUE) > 0) {
                         # count new mistakes 
                         # based on current mistakes and previous mistakes
                         update_mistakes(current_mistakes(), old_mistakes)
                         
                         # display mistake count
                         output$mistakes_indicator <- renderText(paste(
                             "Mistakes:", mistakes
                         ))
                         
                     } else {
                         
                         # calculate typing speed
                         calc_speed(t_1, Sys.time(), length(user_split()))
                         
                         # save speed and mistakes
                        
                         # clear user input
                         updateTextAreaInput(
                             session,
                             "user_typing",
                             "Type the code above",
                             value = "",
                             placeholder = "Start typing here")
                         
                         # choose new example
                         code_place <<- sample(1:length(code_chunks()), 1)
                         
                         # update feedback table
                         if (nrow(scores) > 0) {
                             scores <<- scores %>% 
                                 add_row(Speed = speed, Accuracy = mistakes,
                                         .before = 1)
                         } else {
                             scores <<- data.frame(Speed = speed, Accuracy = mistakes)
                         }
                         
                         output$feedback <- renderTable(
                             scores
                         )
                         
                         # reset mistake count
                         mistakes <<- 0
                         
                     }
                     
                     # display speed feedback
                     output$speed_feedback <- renderText({
                         paste("Speed:", round(speed, 3), "characters per second")
                     })
                     
                     
                 })
    
    
    
    output$stateMessage <- renderText({
        "You are in free-typing mode, press the button below to start recording your performance."
    })
    
    observeEvent(input$toggleSidebar, {
        shinyjs::toggle(id = "options",
                        anim = TRUE)
    })

}
