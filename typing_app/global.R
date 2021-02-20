library(shiny)
library(shinyjs)
library(tidyverse)
library(shinyWidgets)
# library(OpenRepGrid) # for english examples
library(pdftools)

# Function to extract examples
get_examples <- function(package, limit = 7, include_comments = FALSE) {
  
  ggplot2_text <- pdf_text(pdf = paste0("https://cran.r-project.org/web/packages/", 
                                        package, "/", 
                                        package, ".pdf"))
  
  ggplot2_lines <- read_lines(ggplot2_text)
  
  eg_locations <- str_detect(ggplot2_lines, "Examples")
  eg_indexes <- which(eg_locations)
  
  desc_locations <- str_detect(ggplot2_lines, "Description")
  desc_indexes <- which(desc_locations)
  
  # Finding indexes of 'Description' that follow 'Example'
  desc_indexes_cor <- vector(length = length(eg_indexes))
  
  for (i in 1:length(eg_indexes)) {
    
    temp <- desc_indexes[desc_indexes > eg_indexes[i]]
    
    desc_indexes_cor[i] <- temp[1]
    
  }
  
  examples <- vector(length = length(eg_indexes))
  
  for (i in 1:(length(eg_indexes)-1)) {
    
    # Extract lines between (and including) the words 
    # 'Examples' and 'Description'
    temp <- ggplot2_lines[eg_indexes[i]:desc_indexes_cor[i]]
    
    # If examples are too long, shorten them
    if (length(temp) > limit) {
      temp <- temp[-c((limit+1):length(temp))]
    }
    
    if (include_comments == FALSE) {
      # Find location of the key words and comments (#)
      temp_remove <- str_detect(temp, "Examples|Description|#")
    } else {
      # Find location of the key words
      temp_remove <- str_detect(temp, "Examples|Description")
    }
    
    # Find location of functions (i.e., where there is code)
    temp_keep <- str_detect(temp, "[A-z][(]|^[)]|^[}]")
    
    # Keep lines that do not contain 'Examples' or 'Description'
    # and DO contain brackets
    temp <- temp[!temp_remove & temp_keep]
    
    # Turn vector into single character
    # and add linebreaks instead of three/four spaces
    temp <- str_replace_all(paste0(temp, collapse = ""),
                            "    |  ", "\n")
    
    # Remove first linebreaks
    temp <- str_remove(temp, "\\n+")
    
    # Replace double linebreaks with single linebreaks
    temp <- str_replace_all(temp, fixed("\n\n"), "\n")
    
    # Remove whitespace after \n
    temp <- str_replace_all(temp, "\\n[ ]+", "\n")
    
    # Remove whitespace at start of examples
    temp <- str_remove_all(temp, pattern = "^ +")
    
    # Save example into vector
    examples[i] <- temp
    
  }
  
  return(examples)
  
}

# Default code chunks

code_chunks <- function() {
  return(unlist(purrr:map(c("ggplot2", "dplyr"), get_examples)))
}

# Default selection
code_place <- sample(1:100, 1)

# Function
returnColouredText <- function(user_input, user_split, 
                               example_code, example_split, 
                               colours = c(red = "#edb6af", green = "#afedbd")) {
  
  mistakes <<- 0
  
  if (user_input == "") {
    # If the user has not typed anything, then display example code as plain text
    # and give 100% accuracy
    
    mistakes <<- 1
    
    
    paste0('<div style = "text-align: left;">', 
           example_code,
           '</div>')
    
  } else { 
    # if the user has typed something
    
    # See if the letters are correct
    true_false <- example_split[1:length(user_split)] == user_split
    
    # Calculate accuracy
    mistakes <<- 1 - (length(true_false) - sum(true_false))/length(user_split)
    
    # create vector to contain colours to show correctness
    colours_for_spans <- vector()
    
    # Fill that vector with either red or green:
    # colours[1] = red, and colours[2] = green
    # TRUE = 1 and FALSE = 0
    # so +1 to true_false vector
    # correct = 2, incorrect = 1
    # colours[2] = green, colours[1] = red
    for (i in 1:length(user_split)) {
      colours_for_spans[i] <- colours[as.numeric(true_false[i])+1]
    }
    
    # Creating HTML to display letters with highlighting (background-color:)
    letters_typed <- paste0(
      '<span style = \"background-color:', 
      colours_for_spans, '\">', 
      example_split[1:length(user_split)], 
      '</span>',
      collapse = ""
    )
    
    if ((length(user_split)+1) <= length(example_split)) { 
      # If all user has typed fewer letters than the example contains
      
      # find all untyped letters and paste them as plain text (no highlighting) 
      letters_untyped <- paste0(
        example_split[(length(user_split)+1):length(example_split)], collapse = ""
      )
      
      # paste typed letters with highlighting followed by untyped letters
      paste0('<div style = "text-align: left">', 
             letters_typed, letters_untyped, 
             '</div>', collapse = "")
      
    } else {
      # if user has typed enough letters (including whitespace)
      
      # paste only typed letters
      paste0('<div style = "text-align: left"', 
           letters_typed, 
           '</div>', collapse = "")
      
    }
    
  }
  
}
