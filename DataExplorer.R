df_raw - sesocoSQLquery(queryODP)

numeric_columns -  df_raw[1, ] %%
  na.omit() %%
  mutate_if(is.character, as.numeric) %%
  select_if(~ !any(is.na(.))) %%
  names()

df - mutate_at(df_raw, numeric_columns, ~(as.numeric(.))) 

plot_str(V)
introduce(V)
plot_intro(V)
plot_bar(V)
plot_histogram(V)   