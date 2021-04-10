source("global.R")

server <- function(input, output, session) {
    
    # CONTROL UI BASED ON STATE
    #######
    
    # default message
    output$example_code <- renderText({
        "<p>Welcome to the <code>R</code> typing test.</p><p>Press the 'Start' button to begin.</p><p>The timer will start immediately!</p>"
    })
    
    # remove/insert button and text input depending on state
    observeEvent(input$start_button, {
        output$start_button <- renderUI(
            {
                switch(
                    state,
                    "before" = {actionButton("start_button", "Start")},
                    "during" = {},
                    "after" = {actionButton("start_button", "Start")}
                )
            }
        )
        
        output$user_typing <- renderUI(
            {
                switch(
                    state,
                    "before" = {},
                    "during" = textAreaInput(
                        "user_typing",
                        "Type the code above",
                        value = "",
                        placeholder = "Start typing here"),
                    "after" = {}
                )
            }
        )
    },
    ignoreNULL = FALSE)
    
    
    
    # HANDLE EXAMPLE CODE AND USER INPUT CODE
    #######
    
    # Find which packages to use for examples
    packages <- eventReactive(list(input$packageButton), {
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
    
    observeEvent(input$start_button, {
        # change state and handle timing
        switch(state,
               "before" = {state <<- "during"
                           t_1 <<- Sys.time()},
               "during" = {},
               "after" = {state <<- "during"}
               )
    })
    
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
                         if (nrow(scores) > 0 & nrow(scores) < 5) {
                             scores <<- scores %>% 
                                 add_row(Speed = (speed*60)/4.79, 
                                         Accuracy = scales::percent(
                                             (1 - mistakes/length(code_split())),
                                             accuracy = 2
                                             ),
                                         .before = 1)
                         } else {
                             scores <<- data.frame(Speed = (speed*60)/4.79, 
                                                   Accuracy = scales::percent(
                                                       (1 - mistakes/length(code_split())),
                                                       accuracy = 2
                                                   ))
                             state <<- "after"
                             output$start_button <- renderUI(actionButton("start_button", "Start"))
                             output$user_typing <- renderUI({})
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
