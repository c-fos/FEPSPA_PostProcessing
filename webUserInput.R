
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
               name = wname,
               user = wuser,
               pass = wpass),
             firstFilter = list(
               var = wvar,
               spike_num = as.numeric(wspike_num),
               resp_num = as.numeric(wresp_num),
               stage = wstage,
               analysis = wanalyserType),
             secondFilter = list(
               time = c(
                 as.numeric(wtime_start),
                 as.numeric(wtime_stop)),
               time_step = as.numeric(wtime_step)),
             tags = wtags
           )

getConfig<-function(){
  return(configList)
}

