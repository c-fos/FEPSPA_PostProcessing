# Aim:
#   to plot raw data with stages depicted and service information added
# Input:
#   data.frame(
#     id,
#     name,
#     stage,
#     time,value),
#   tag_vector
# output:
#   plot()
plot_raw<-function(df,tag_vector){
  plot(df$time,df$value,type="p")
  points(df$time[df$tagName=="гипоксия"],df$value[df$tagName=="гипоксия"],col="red")
  points(df$time[df$tagName=="реоксигенация"],df$value[df$tagName=="реоксигенация"],col="orange")
  points(df$time[df$tagName=="инкубация"],df$value[df$tagName=="инкубация"],col="blue")
  points(df$time[df$tagName=="тетанизация"],df$value[df$tagName=="тетанизация"],col="green")
  serviceText<-sprintf("Id=%i,\n ExpName=%s",df$idexperiment[1],df$experimentName[1])
  mtext(serviceText)
}
