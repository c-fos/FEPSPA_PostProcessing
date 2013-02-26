library("RMySQL")

db_exec<-function(query,db_conf){
  #print(c(db_conf$user,db_conf$name))
  #print("before con initialization")
  #print(db_conf$user)
  #print(db_conf$pass)
  #print(db_conf$name)
  con <- dbConnect(MySQL(), user=db_conf$user, password=db_conf$pass,dbname=db_conf$name, host="localhost")
  tmp<-dbGetQuery(con, "SET NAMES utf8") 
  #con<-dbConnect(MySQL(),user='filter_user',password='filter123',dbname='filterdb',host='localhost')
  #print("after con initialization")
  tmp_data<- dbGetQuery(con, query)
  #print(tmp_data)
  dbDisconnect(con)
  return(tmp_data)
}
