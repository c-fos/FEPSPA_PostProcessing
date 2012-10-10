library("RMySQL")

db_exec<-function(query,db_conf){
  con <- dbConnect(MySQL(), user=db_conf$user, password=db_conf$pass,dbname=db_conf$name, host="localhost")
  tmp_data<- dbGetQuery(con, query)
  dbDisconnect(con)
  return(tmp_data)
}