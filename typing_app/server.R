source("global.R")

server <- function(input, output, session){
    
    code_split <- eventReactive(input$user_typing, {
        str_split(code_chunks[code_place], "") %>% flatten_chr()
    })
    
    user_split <- reactive(str_split(input$user_typing, "") %>% flatten_chr())
    
    observeEvent(input$user_typing, {
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
    
    
    
    example_coloured <- eventReactive(input$user_typing, {
        
            returnColouredText(user_input = input$user_typing,
                               user_split = user_split(),
                               example_code = code_chunks[code_place],
                               example_split = code_split())
        
    })
    
    output$example_code <- renderText({
        example_coloured()
    })
    
    
    
    
    # output$example_code <- renderText({
    #     
    #     if (input$user_typing == ""){
    #         return(code_chunk)}
    #     
    #     else if (all(user_split() == code_split[1:length(user_split())])){
    #         
    #         return(paste0('<span style=\"color:green\">', str_sub(code_chunk, 1, length(user_split())), '</span>', 
    #                       str_sub(code_chunk, length(user_split())+ 1)))}
    #         
    #     
    #     else {
    #         return(paste0('<span style=\"color:red\">', str_sub(code_chunk, 1, length(user_split())), '</span>', 
    #                       str_sub(code_chunk, length(user_split())+ 1)))
    #     }
    #     
    #     })
    #     
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
