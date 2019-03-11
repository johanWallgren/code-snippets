# Requiers a data frame named df_raw 
numeric_columns <-  df_raw %>%
  na.omit() %>% # make sure that the top column doesn't have nay NA's
  head(1) %>% # Select the top column
  mutate_all(as.numeric) %>% # Converts all to numeric class
  select_if(~ !any(is.na(.))) %>% # Drops all columns that now contain NA
  names() # Select only the column names in a list

df <- mutate_at(df_raw, numeric_columns, ~(as.numeric(.))) # Converts all columns in numeric_columns to numeric class
