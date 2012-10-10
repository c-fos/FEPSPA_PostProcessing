# Aim:
#   Download the raw data from the DB,data prepearing: filtering unnided records, normalization and so on.
# Input:
#   tag_vector = c(tag1,tag2,tag3)
#   firstFilter = list(
#     var = $characteristic of neuronal activity,
#     spike_num = $spikeNumber,
#     resp_num = $responseNumber)
#   
# Output:
#   expInstance = data.table(
#     time,
#     value,
#     exp_id)

source("db_id.R")
source("db_data.R")
source("plot_raw.R")
library("plyr")

lowLevelProc<-function(tag_vector,lowFilter){
  #creating a vector of experiments to be processed
  id_vector = db_read_id(tag_vector,config$db_conf) 
  df_list<-lapply(id_vector,singleExpFitting)
  expInstance<-ldply(df_list,NULL)
  #expInstance = data.frame(id_vector)
  return(expInstance)
}

singleExpFitting<-function(id){
  rawData<-db_read_data(id,config$db_conf,config$firstFilter)
  rawData$time<-as.numeric(strptime(rawData$time,"%H:%M:%S"))
  #plot raw data
  plot_raw(rawData,tag_vector)
  #filter unusefull rows and columns
  filteredData<-rawData[rawData$tagName==config$firstFilter$stage,]
  #time norm
  filteredData$time<-filteredData$time-filteredData$time[1]
  #value norm
  filteredData$value<-filteredData$value/filteredData$value[2]
  return(filteredData)
}