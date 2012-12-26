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
  print(id)
  print(rawData)
  rawData$time<-as.numeric(strptime(rawData$time,"%H:%M:%S"))
  #plot raw data
  plot_raw(rawData,tag_vector)
  #filter unusefull rows and columns
  filteredData<-rawData[rawData$tagName==config$firstFilter$stage,]
  #time norm
  filteredData$time<-filteredData$time-filteredData$time[1]
  #value norm
  #filteredData$value<-filteredData$value/filteredData$value[1]
  filteredData$value<-filteredData$value-filteredData$value[1]
  #normPoint<-max(filteredData$value[filteredData$time<150])
  normPoint<-filteredData$value[2]
  filteredData$value<-filteredData$value/normPoint#
  striped_groups<-stripByTime(filteredData,config$secondFilter$time)
  result<-time_split_for_one(striped_groups)
  return(result)
}

time_split_for_one<-function(df){
  tmpTimeFactors<-df$time[2:length(df$time)]%/%config$secondFilter$time_step
  if (tmpTimeFactors[1]==0) tmpTimeFactors<-tmpTimeFactors+1
  if (tmpTimeFactors[1]==2) tmpTimeFactors<-tmpTimeFactors-1
  time_factor<-as.factor(c(0,tmpTimeFactors))
  result<-cbind(df,time_factor=time_factor)
  print(result)
  return(result)
}

stripByTime<-function(df,time_vect){
  tmp<-df[df$time>=time_vect[1] & df$time<=time_vect[2],]
  return(tmp)
}
