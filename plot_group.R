# Aim: 
#   to plot the group of experiments on the same figure
# Input:
#   data.frame(
#     time,
#     value),
# output:
#   plot()
library("car")
plot_group<-function(df){
  scatterplot(df$time,df$value)
}