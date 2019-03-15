# If all data is as char but some should be numeric
# Requiers library(tidyverse)

char2integer <- function(df){
  
  options(warn=-1) # No warnings
  
  numeric_columns <-  df %>%
    na.omit() %>% # make sure that the top column doesn't have nay NA's
    head(1) %>% # Select the top column
    mutate_all(as.numeric) %>% # Converts all to numeric class
    select_if(~ !any(is.na(.))) %>% # Drops all columns that now contain NA
    names() # Select only the column names in a list
  
  mutate_at(df, numeric_columns, ~(as.numeric(.))) # Converts all columns in numeric_columns to numeric class
}
