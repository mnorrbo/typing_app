code_chunk <-  "normal text on one line"
code_split <- str_split(code_chunk, "") %>% flatten_chr()


server <- function(input, output){
    
    user_split <- reactive(str_split(input$user_typing, "") %>% flatten_chr())
    
    output$example_code <- renderText({
        
        if (input$user_typing == ""){
            return(code_chunk)}
        
        else if (all(user_split() == code_split[1:length(user_split())])){
            
            return(paste0('<span style=\"color:green\">', str_sub(code_chunk, 1, length(user_split())), '</span>', 
                          str_sub(code_chunk, length(user_split())+ 1)))}
            
        
        else {
            return(paste0('<span style=\"color:red\">', str_sub(code_chunk, 1, length(user_split())), '</span>', 
                          str_sub(code_chunk, length(user_split())+ 1)))
        }
        
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
