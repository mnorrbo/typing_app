library(shiny)
library(tidyverse)
library(OpenRepGrid) # for typing examples before we find code

code_chunks <-  randomSentences(100, 10)

code_place <- 1

returnColouredText <- function(user_input, user_split, example_code, example_split, colors = c("red", "green")) {
  
  if (user_input == "") {
    
    return(example_code)
    
  } else { 
    
    true_false <- example_split[1:length(user_split)] == user_split
    
    colors_for_spans <- vector()
    
    for (i in 1:length(user_split)) {
      colors_for_spans[i] <- colors[as.numeric(true_false[i])+1]
    }
    
    part_1 <- paste0(
      '<span style = \"background-color:', colors_for_spans, '\">', example_split[1:length(user_split)], '</span>',
      collapse = ""
    )
    
    part_2 <- paste0(
      example_split[(length(user_split)+1):length(example_split)], collapse = ""
    )
    
    paste0(part_1, part_2, collapse = "")
    
  }
  
}
