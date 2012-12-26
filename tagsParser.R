myfun<-function(x){
  tmp<-unlist(strsplit(x,","))
  tmp<-paste("'",tmp,"'",sep="")
  return(tmp)
}
tmp<-unlist(strsplit(wtag,";"))
wtags<-lapply(tmp,myfun)
