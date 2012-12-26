# Aim:
#   to plot data by time steps with errors and significances
# Input:
#   data.frame(
#     time,
#     value,
#     filter,
#     time_factor),
# output:
#   plot()
library("ggplot2")
library("outliers")

processSingleTimePoint<-function(frame){
  groups<-split(frame,frame$filter)
  print(groups)
  groupSummary<-ldply(groups,statAnalysis)
  return(groupSummary)
}

stderr <- function(x) sqrt(var(x)/length(x))

statAnalysis<-function(df){
  #filteredGroups<-split(df,df$filter)
  #print(1)
  #function fo creation of df with simple stat characteristics
  
  processing<-function(groupDf){
    ##simple outlier filtration
    tmpSample<-groupDf$value
    print("outliers")
    print(length(tmpSample))
    if (length(tmpSample)>3 & length(tmpSample)<30 & var(tmpSample)!=0){
        if(dixon.test(tmpSample)$p.value<0.01){tmpSample<-rm.outlier(tmpSample)}
        if(dixon.test(tmpSample)$p.value<0.01){tmpSample<-rm.outlier(tmpSample)}
    }
    me<-mean(tmpSample)
    med<-median(tmpSample)
    se<-stderr(tmpSample)
    filter<-groupDf$filter[1]
    time_factor<-as.integer(as.character(groupDf$time_factor[1]))
    return(data.frame(time_factor=time_factor,mean=me,median=med,SE=se,filter=filter))
  }
  #results<-ldply(filteredGroups,processing)
  result<-processing(df)
  return(result)
}

myfont="Helvetica"
plotTheData<-function(df){
  #print(df)
  df$SE<-df$SE*100
  df$time_factor<-df$time_factor*config$secondFilter$time_step
  #df$mean[c(1,4)]=0
  #df$median[c(1,4)]=0
  #df$SE[c(1,4)]=0
  #df<-rbind(df[1:4,],df)
  #df$time_factor[c(1,4)]=-5
  df$mean<-(df$mean)*100
  #df$mean[64]<-df$mean[64]+10
  #df$mean[61]<-df$mean[61]-10
  #print(df)
  pd <- position_dodge(.2) # move them .05 to the left and right
  print(ggplot(data=df, aes(x=time_factor, y=mean, colour=filter, group=filter)) + 
    geom_errorbar(aes(ymin=mean-SE, ymax=mean+SE), colour="black", width=15, position=pd) +
    #geom_line(position=pd) +
    stat_smooth(se=F)+
    geom_point(position=pd, size=3, shape=21, fill="white") + # 21 is filled circle
    scale_colour_hue(name="Группы", # Legend label, use darker colors
                     breaks=c("1","2"),
                     labels=c("IL-6", "Контроль"),
                     l=40) +                  # Use darker colors, lightness=40
    #ggtitle("All groups. Mean with SE") +
    #scale_x_continuous(limits=c(0, max(df$time_factor)),    # Set y range
    #                      breaks=0:*30, labels=c(0,0,0,30,0,0,60,0,0,90,0,0,120,0,0,150)) +                       
# Set tick every 4
    theme_bw() +
    theme(
            legend.justification=c(0.8,1),
            legend.position=c(0.8,1),
            axis.text.x=element_text(family = myfont,face = "bold",size=20),
            axis.text.y=element_text(family = myfont, angle=90,face = "bold",size=20),
            axis.title.x=element_text(family = myfont, face = "bold",size=25,vjust = 0.3),
            axis.title.y=element_text(family = myfont, angle=90, face = "bold",size=25,vjust = 0.3),
            #legend.position="top",
            legend.text=element_text(family = myfont, face = "bold",size=18),
            legend.title=element_text(family = myfont, face = "bold",size=20),
            #legend.background = element_rect(),
            panel.border=element_rect(colour="black",size=0.5),
            panel.background=element_rect(fill = "white"),
            #panel.grid.major = theme_line(colour = "black"),
            #panel.grid.minor = theme_line(colour = "black"),
            legend.position=c(0,0)
		) +
      labs(
            x="t, c",
            y="Амплитуда п-спайка, %"
          )
          ) # Position legend in bottom right
}

statTest<-function(df){
  filteredGroups<-split(df$value,df$filter)
  if(length(filteredGroups)>=2){
  pValue<-kruskal.test(filteredGroups)
  return(data.frame(time=df$time_factor[1],pValue=pValue$p.value))
  }
  else return("there is only one group")
}

plot_p_values<-function(df){
  step_list<-split(df,df$time_factor)
  dfForPlot<-ldply(step_list,processSingleTimePoint)
  print(dfForPlot)
  pValues<-ldply(step_list,statTest)
  print(pValues)
  plotTheData(dfForPlot)
  #save(dfForPlot,file="/home/pilat/tmpFile")
}
