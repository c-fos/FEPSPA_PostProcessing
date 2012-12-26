#Aim:
# download the data.table from the DB by experiment id
# input:
#   id = $id <numeric>
#   db_conf = list(
#     db_name,
#     db_user,
#     db_pass)
#   
# output:
#    rawDataFrame = data.frame(
#      time,
#      value,
#      id,
#      stage,
#      )

source("db_interface.R")

db_read_data<-function(id,db_conf,firstFilter){
  dataQuery<-sprintf("SELECT `idexperiment`, `experimentName`, `tagName`, `time`, `%s` AS `value` FROM `oneFullExpTmp` WHERE `idexperiment` = %s AND `number` = %i",firstFilter$var,id,firstFilter$spike_num)
  tmp_dataFrame<- db_exec(dataQuery,db_conf)
  return(tmp_dataFrame)
}

db_read_tetan<-function(id,db_conf){
  idStr<-paste(id,collapse=",")
  dataQuery<-sprintf("SELECT * FROM `tetanView` WHERE idexperiment IN (%s)",idStr)
  tmp_dataFrame<- db_exec(dataQuery,db_conf)
  return(tmp_dataFrame)
}