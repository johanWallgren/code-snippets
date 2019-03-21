# example_query <- "
# SELECT TOP(1000) *
# FROM database..table
# WHERE filter_column > 10
# "

getSQLquery <- function(query_str){
  require(odbc)
  conn <- odbc::dbConnect(odbc::odbc(),
                          Driver   = "SQL Server",
                          Server   = "server_name",
                          Trusted_Connection = "yes")
  
  df <-  as_tibble(odbc::dbGetQuery(conn, query_str))
  odbc::dbDisconnect(conn)
  return(df)
}