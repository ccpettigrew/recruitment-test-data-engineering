
library(tidyverse)
library(jsonlite)
library(RMySQL)

# connect to the database
db_connect <- dbConnect(RMySQL::MySQL(), user = 'codetest', password = 'swordfish', dbname = 'codetest', host = 'database')

#flush the table
dbSendStatement(db_connect, "DELETE FROM people;")

# read the CSV data file into the table

people_data <- read.csv(file = "/data/people.csv")

# insert people data
insert_people <- function(row, connection){
  row <- paste0(row, collapse = "', '")
  row <- paste0("'", row, "'")
  sql_statement <- paste0("INSERT INTO people VALUES (", row, ")")
  dbSendStatement(conn = connection, statement = sql_statement)
}
  
# apply to dataframe
apply(X = people_data, MARGIN = 1, FUN = insert_people, connection = db_connect)

# output the table to a JSON file
res <- dbSendQuery(db_connect, "select * from people")
output = dbFetch(res)
dbClearResult(res)

write_json(output, '/data/people_r.json', pretty = FALSE)
