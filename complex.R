# Aim:
#   Agregation, grouping and systematization distinct records for different groups
# 
# Input:
#   list(
#     tags=list(
#       c(tag1,tag2,tag3),
#       c(tag2,tag3,tag4)),
#     secondFilter = list(
#       time = c(
#         0,
#         60),
#       time_step = as.integer(20),
#       stage = "testStep"),
#     
#   )
# 
# Output:
#   ErrorCode = int(0 | 1)
source("individual.R")
source("plot_group.R")
source("plot_all.R")
source("plot_p_values.R")

hightLevelProc<-function(tags,secondFilter){
  #print(1)
  ErrorCode = 0
  filtered_groups=lapply(tags,lowLevelProc, lowFilter=config$firstFilter)
  for(i in seq(length(filtered_groups))){
    filtered_groups[[i]]<-cbind(filtered_groups[[i]],filter=rep(i,length=nrow(filtered_groups[[i]])))
  }
  #print(2)
  #plot all groups separately
  lapply(filtered_groups,plot_group)
  #strip the df by the time interval
  #print(3)
  #striped_groups<-lapply(filtered_groups,stripByTime,secondFilter$time)
  #striped_groups2<-lapply(striped_groups,time_split_for_one)
  #to accumulate all data in one table
  allGroupsDf<-ldply(filtered_groups,NULL)
  #allGroupsDf<-complete.cases(allGroupsDf)
  #plot_all
  allGroupsDf$filter<-as.factor(allGroupsDf$filter)
  plot_all(allGroupsDf)
  #time_split
  #split allGroups bu groups
  
  #allGroupsDf<-cbind(allGroupsDf,time_factor=time_split(allGroupsDf$time))
  #plot the graph with errorbars and significance values
  plot_p_values(allGroupsDf)
  #print(allGroupsDf)
  return(ErrorCode)
}

#time_split<-function(time){
#  tmpTimeFactors<-time[3:length(time)]%/%config$secondFilter$time_step
#  if (tmpTimeFactors[1]==0) tmpTimeFactors<-tmpTimeFactors+1
#  if (tmpTimeFactors[1]==2) tmpTimeFactors<-tmpTimeFactors-1
#  time_factor<-as.factor(c(0,0,tmpTimeFactors))
#  return(time_factor)
#}

