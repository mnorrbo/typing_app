library(shiny)
library(tidyverse)
library(OpenRepGrid) # for typing examples before we find code
library(shinyWidgets)

code_place <- 1
code_chunks <-  c(
  'library(ggplot2)\nggplot(mpg, aes(displ, hwy, colour = class)) +\ngeom_point()',
  'ggplot(faithfuld, aes(waiting, eruptions)) +\ngeom_raster(aes(fill = density))',
  'install.packages("tidyverse")'
)

returnColouredText <- function(user_input, user_split, 
                               example_code, example_split, 
                               colors = c(red = "#edb6af", green = "#afedbd")) {

  if (user_input == "" | length(user_split) > length(example_split)) {
    
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
    
    if (str_detect(part_2, "NA")) {
      paste0(example_code)
    } else {
      paste0(part_1, part_2, collapse = "")
    }
    
  }
  
}
