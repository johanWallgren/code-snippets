# Convert all char columns to factor
library(tidyverse)

# Requiers a data frame named df_raw 
char_columns <- df_raw %>%
  na.omit() %>% # make sure that the top column doesn't have nay NA's
  head(1) %>% # Select the top column
  mutate_all(as.numeric) %>% # Converts all to numeric class
  select_if(~ any(is.na(.))) %>% # Drops all columns that now contain NA
  names() # Select only the column names in a list

df <- mutate_at(df_raw, char_columns, ~(as.factor(.)))