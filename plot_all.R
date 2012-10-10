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
  scatterplot(value~time|filter,data=df)
}