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
  ErrorCode = 0
  filtered_groups=lapply(tags,lowLevelProc, lowFilter=config$firstFilter)
  for(i in seq(length(filtered_groups))){
    filtered_groups[[i]]<-cbind(filtered_groups[[i]],filter=rep(i,length=nrow(filtered_groups[[i]])))
  }
  #plot all groups separately
  lapply(filtered_groups,plot_group)
  #strip the df by the time interval
  striped_groups<-lapply(filtered_groups,stripByTime,secondFilter$time)
  print(head(striped_groups))
  #to accumulate all data in one table
  allGroupsDf<-ldply(striped_groups,NULL)
  #plot_all
  plot_all(allGroupsDf)
  #time_split
  allGroupsDf<-cbind(allGroupsDf,time_factor=time_split(allGroupsDf$time))
  #plot the graph with errorbars and significance values
  plot_p_values(allGroupsDf)
  print(allGroupsDf)
  return(ErrorCode)
}

time_split<-function(time){
  time_factor<-as.factor(time%/%config$secondFilter$time_step)
  return(time_factor)
}

stripByTime<-function(df,time_vect)return(df[df$time>=time_vect[1] & df$time<=time_vect[2],])
