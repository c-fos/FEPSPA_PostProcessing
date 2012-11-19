
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
                 240),
               time_step = as.integer(30)),
             tags = list(
               #c("'il6+cof'","'with_il6'","'control'"),
               #c("'il6+cof'","'with_il6'","'0.5mM_cofein'"),
               #c("'il6+cof'","'with_il6'","'1mM_cofein'"),
               #c("'il6+cof'","'with_il6'","'10mM_cofein'"),
               #c("'il6+cof'","'without_il6'","'control'"),
               #c("'il6+cof'","'without_il6'","'0.5mM_cofein'"),
               #c("'il6+cof'","'without_il6'","'1mM_cofein'"))#,
               #c("'il6+cof'","'without_il6'","'10mM_cofein'"))#,
               #c("'hight_bfa'"))
               #c("'test'","'manual'"))
               #c("'vesicular'","'clear'"),
               #c("'vesicular'","'5mkg'"),
               #c("'vesicular'","'0.1mkg'"),
               #c("'vesicular'","'1mkg'"))
               c("'control'","'detail'"))
           )

getConfig<-function(){
  return(configList)
}

