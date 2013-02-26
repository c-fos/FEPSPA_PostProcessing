#Aim:
#    To control the process of analisys, transfering the data from one module to another.
#
#
#
#Input:
#     list(
#            db_conf = list(
#              name = $dbName,
#              user = $dbUserName,
#              pass = $dbUserPass),
#            firstFilter = list(
#              var = $characteristic of neuronal activity,
#              spike_num = $spikeNumber,
#              resp_num = $responseNumber,
#              stage = $stageOfExp),
#            secondFilter = list(
#              time = c(
#                start = $start,
#                stop = $stop),
#              time_step = $sepOfTimeSplit),
#            tags = list(
#              c(tag1,tag2,tag3),
#              c(tag2,tag3,tag4),
#              ...)
#          )
source('/home/pilat/workspace/PostProcessing_v.2/tagsParser.R')
source('/home/pilat/workspace/PostProcessing_v.2/webUserInput.R')
source('/home/pilat/workspace/PostProcessing_v.2/complex.R')
source('/home/pilat/workspace/PostProcessing_v.2/tetanTableCreator.R')
config<-getConfig()
print(config$firstFilter$analysis)
if (config$firstFilter$analysis == "individualStim"){
  higthLev<-hightLevelProc(config$tags,config$secondFilter)
}
if (config$firstFilter$analysis == "tetan"){
  startTetanProcessing()#higthLev<-hightTetan(config$tags,config$secondFilter)
}
