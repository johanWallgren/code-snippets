# Requiers a data frame named df_raw 
numeric_columns <-  df_raw %>%
  na.omit() %>%
  head(1) %>%
  mutate_if(is.character, as.numeric) %>%
  select_if(~ !any(is.na(.))) %>%
  names()

df <- mutate_at(df_raw, numeric_columns, ~(as.numeric(.))) 
