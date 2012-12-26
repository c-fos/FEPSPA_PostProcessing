# Aim:
#   plot all groups on the same figure
# input:
#   data.frame(
#     id,
#     time,
#     value,
#     factor)
# output:
#   plot
plot_all<-function(df){
  pd <- position_dodge(.2) # move them .05 to the left and right
  print(ggplot(data=df, aes(x=time, y=value, colour=filter, group=filter)) + 
    geom_point(position=pd, size=3, shape=21, fill="white") + # 21 is filled circle
    ggtitle("All points of one group.") +
    geom_smooth() +
    theme_bw() +
    theme(legend.justification=c(1,0), legend.position=c(1,0))) # Position legend in bottom right
  
}