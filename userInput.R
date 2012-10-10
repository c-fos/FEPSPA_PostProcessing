
#Aim: 
#   Прием данных от пользователя, проверка и передача данных управляющиму модулю
#
#Input: None (или словарь из Python`a)
#
#Output:
#     list(
#            db_conf = list(
#              name = $dbName,
#              user = $dbUserName,
#              pass = $dbUserPass),
#            firstFilter = list(
#              var = $characteristic of neuronal activity,
#              spike_num = $spikeNumber,
#              resp_num = $responseNumber),
#            secondFilter = list(
#              time = c(
#                start = $start,
#                stop = $stop),
#              time_step = $sepOfTimeSplit,
#              stage = $staeOfExp),
#            tags = list(
#              c(tag1,tag2,tag3),
#              c(tag2,tag3,tag4),
#              ...)
#          )
configList<-list(
             db_conf = list(
               name = "filterdb",
               user = "filteruser_local",
               pass = "filter123"),
             firstFilter = list(
               var = "ampl",
               spike_num = as.integer(1),
               resp_num = as.integer(1),
               stage = "тетанизация"),
             secondFilter = list(
               time = c(
                 0,
                 3600),
               time_step = as.integer(200)),
             tags = list(
               c("'dmso'","'control'"),
               c("'dmso'","'exo1'"))
           )

getConfig<-function(){
  
  return(configList)
}

