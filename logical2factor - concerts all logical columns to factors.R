locical2factor <- function(df){
  
  options(warn=-1) # No warnings
  
  locical_columns <- df %>%
    head(1) %>% # Select the top column
    select_if(~ any(is.logical(.))) %>% # Drops all columns that now contain NA
    names() # Select only the column names in a list
  
  mutate_at(df, locical_columns, ~(as.factor(.)))
}