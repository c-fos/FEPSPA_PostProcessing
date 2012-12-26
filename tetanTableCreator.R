#задача: получить матрицу таблицу 100*n где были бы записаны\
#серии высокочастотной стимуляции(СВС) для n экспериментов

#для этого нужен view возвращающий СВС для определенного experiment id.
source("db_id.R")
source("db_data.R")
library("ggplot2")

hightTetan<-function(tags,secondFilter){
  #print(1)
  filtered_groups=lapply(tags,lowTetan, lowFilter=config$firstFilter)
  allGroupsDf<-ldply(filtered_groups,NULL)
  return(allGroupsDf)
}

lowTetan<-function(tag_vector,lowFilter){
  tagName<-paste(tag_vector,collapse=",")
  id_vector = db_read_id(tag_vector,config$db_conf)
  print(id_vector)
  dataFrameTetan <- normalize(id_vector)
  result<-cbind(dataFrameTetan,filter=rep(tagName,length=nrow(dataFrameTetan)))
  print(result)
  return(result)
}

normalize<-function(id_vector){
  tetanList<-lapply(id_vector,db_read_tetan,db_conf=config$db_conf)
  tetanListNorm<-lapply(tetanList,normalFunc)
  result<-ldply(tetanListNorm,NULL)
  return(result)
}

normalFunc<-function(df){
  df$ampl<-df$ampl/df$ampl[1]
  df$maxtomin<-df$maxtomin/df$maxtomin[1]
  df$length<-df$length/df$length[1]
  return(df)
}
startTetanProcessing<-function(){
higthLev<-hightTetan(config$tags,config$secondFilter)
str(higthLev)
print(qplot(number,delay,data=higthLev,colour=filter,xlim=c(0,30),ylim=c(0,10))+stat_smooth())
print(qplot(number,ampl,data=higthLev,colour=filter,xlim=c(0,30),ylim=c(0,5))+stat_smooth())
}