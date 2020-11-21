source("global.R")

server <- function(input, output, session){
    
    code_split <- eventReactive(input$user_typing, {
        str_split(code_chunks[code_place], "") %>% flatten_chr()
    })
    
    user_split <- eventReactive(input$user_typing, {
        str_split(input$user_typing, "") %>% flatten_chr()
    })
    
    # output$results = renderPrint({
    #     input$mydata
    # })
    # 
    
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
    
    # example_coloured <- reactive({
    #     autoInvalidate()
    #     returnColouredText(user_input = input$user_typing,
    #                        user_split = user_split(),
    #                        example_code = code_chunks[code_place],
    #                        example_split = code_split())
    #     
    # })
    
    output$example_code <- renderText({
        returnColouredText(user_input = input$user_typing,
                           user_split = user_split(),
                           example_code = code_chunks[code_place],
                           example_split = code_split())
    })
}
    
# 
# string_1 <- "this is my first string"
# split_1 <- str_split(string_1, "") %>% flatten_chr()
# string_2 <- "this is my first string plop"
# split_2 <- str_split(string_2, "") %>% flatten_chr()
# 
# intersect(split_1, split_2)
# 
# which(split_1 != split_2)
# 
# setdiff(split_1, split_2)
# 
# all(split_1 == split_2)
# 
# 
# all(split_1 == split_2[1:length(split_1)])
