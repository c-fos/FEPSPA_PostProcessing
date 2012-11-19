# Aim: 
#   to plot the group of experiments on the same figure
# Input:
#   data.frame(
#     time,
#     value),
# output:
#   plot()
library("ggplot2")
plot_group<-function(df){
  print(3)
  print(df)
  pd <- position_dodge(.2) # move them .05 to the left and right
  print(ggplot(data=df, aes(x=time, y=value)) + 
    geom_point(position=pd, size=3, shape=21, fill="white") + # 21 is filled circle
    ggtitle("All points of one group.") +
    geom_smooth() + 
    theme_bw() +
    theme(legend.justification=c(1,0), legend.position=c(1,0))) # Position legend in bottom right
  
}