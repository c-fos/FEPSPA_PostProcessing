require("RMySQL")
require("ggplot2")
require("nnet")
require("neuralnet")
require("outliers")
require("stats")
require("plyr")

db_conf = list(
  name = "filterdb",
  user = "filteruser_local",
  pass = "filter123")

db_exec<-function(query,db_conf){
  con <- dbConnect(MySQL(), user=db_conf$user, password=db_conf$pass,dbname=db_conf$name, host="localhost")
  tmp_data<- dbGetQuery(con, query)
  dbDisconnect(con)
  return(tmp_data)
}


db_spikes<-function(db_conf){
  #dataQuery<-sprintf("SELECT DISTINCT * FROM stimProperties where number=0")
  dataQuery<-sprintf("SELECT DISTINCT * FROM stimProperties")
  tmp_dataFrame<- db_exec(dataQuery,db_conf)
  return(tmp_dataFrame)
}


rawTable<-db_spikes(db_conf)
#rawTable$std<-rawTable$std/10.0
#rawTable$ptp<-rawTable$ptp/10.0
#rawTable$length<-rawTable$length/10.0
effectivTable<-rawTable[,c(-1,-11)]
ptp_base_ptp<-rawTable$ptp/rawTable$base_ptp
#median_std<-rawTable$median/rawTable$std
median_baseMedian<-(rawTable$median-rawTable$base_median)
#mean_baseMean<-rawTable$mean-rawTable$base_mean
med_ptp<-abs(rawTable$median-rawTable$base_median)/rawTable$base_ptp
#length_std<-rawTable$length/rawTable$std
#delay_length<-rawTable$delay/rawTable$length
#amplLength_delay<-rawTable$ampl*rawTable$length/rawTable$delay
#effectivTable<-cbind(effectivTable,median_std,median_baseMedian,mean_baseMean,length_std,med_ptp)
effectivTable<-cbind(effectivTable,median_baseMedian,med_ptp,ptp_base_ptp)
#clearTable<-effectivTable
clearTable<-as.data.frame(apply(effectivTable,2,function(x){
  x[is.infinite(x)]=NA
  tmp<-as.numeric(x)
  while(grubbs.test(tmp, type = 10)$p.value<1.0e-16){
    print(grubbs.test(tmp, type = 10)$p.value)
    tmp[tmp==outlier(tmp)]=NA
  }
  return(tmp)
}))
#print(ncol(clearTable))
clearTable<-clearTable[complete.cases(clearTable),]
#print(ncol(clearTable))
#rawStimTable<-data.frame(length=clearTable$length,std=clearTable$std,median_std=clearTable$median_std,median_baseMedian=clearTable$median_baseMedian,mean_baseMean=clearTable$mean_baseMean,length_std=clearTable$length_std,status=clearTable$status)
rawStimTable<-clearTable
#qplot(y=rawSpikeTable[order(rawSpikeTable$delay),2],x=seq(length(rawSpikeTable$delay)),xlim=c(0,2500),ylim=c(0,1000))
#qplot(y=rawSpikeTable[order(rawSpikeTable$delay),2],x=seq(length(rawSpikeTable$delay)))
#precise<-rawSpikeTable[(rawSpikeTable$delay>200 & rawSpikeTable$delay<1200),]
#factor2<-kmeans(x=precise[,c(-3,-1)],centers=2,nstart=100)
#qplot(precise$maxtomin,precise$length, colour=factor2$cluster) # <500 - fibre, > 800 - AP

#learningDf<-rawSpikeTable[((rawSpikeTable$delay<700 | rawSpikeTable$delay>800) & (rawSpikeTable$delay<5000 & rawSpikeTable$delay>0)),]
learningDf<-rawStimTable
#fibreFactor<-as.factor(kmeans(x=learningDf[,c(1,3)],centers=2,nstart=10)$cluster)#learningDf$delay<700
#summary(fibreFactor)
learningDf<-cbind(learningDf[,-10],as.factor(learningDf[,10]))
names(learningDf)[17]<-c("status")
set.seed(10)
x=seq(nrow(learningDf))
y=sample(x)
#learningDf<-learningDf[y,-2]
learningDf<-learningDf[y,]
#qplot(learningDf$length,learningDf$maxtomin, colour=learningDf$AP) # <500 - fibre, > 800 - AP
learn<-learningDf[1:2500,]
learn<-learn[complete.cases(learn),]
check<-learningDf[2501:4000,]
check<-check[complete.cases(check),]
print(summary(learn$status))
print(summary(check$status))

#net <- neuralnet(AP~length+angles+printmaxtomin, data=learn)

#neuroModel<-nnet(AP~.,data=learningDf,size=15,rang = 0.5,decay=5e-4, maxit = 1000)
rm(.Random.seed)
runif(1)
neuroModel<-nnet(status~. ,data=learn,size=17,maxit=1500)
save(neuroModel,file="~/workspace/fEPSP-analyser/filter_script/root/.RStimNeuroModel11")
# 
result<-predict(neuroModel,check[,1:16])
result2<-cbind(result,as.numeric(as.character(check$status)))
miss<-0
false<-0
for (i in seq(length(result2[,1]))){
  if (result2[i,2]==-1) result2[i,2]=0
  if (result2[i,2]==0 & result2[i,1]>0.5) false=false+1
  if (result2[i,2]==1 & result2[i,1]<=0.5) miss=1+miss
}
missPerc<-100*miss/length(check[check$status==1,17])
falsePerc<-100*false/length(check[check$status==0,17])
print(list("miss:",missPerc,"false:",falsePerc))
#print(result)
#qplot(median-base_median,std-base_std, data=effectivTable,colour=ptp/base_ptp) + scale_colour_gradient(limits=c(0,4),low="red",high="blue")
#qplot(median-base_median,std-base_std, data=effectivTable,colour=abs(median-base_median)/base_ptp) + scale_colour_gradient(limits=c(-3,3),low="red",high="blue")
#qplot(median-base_median,length, data=effectivTable,colour=status,xlim=c(-20,5),ylim=c(0,5)) + scale_colour_gradient(low="red",high="blue")
