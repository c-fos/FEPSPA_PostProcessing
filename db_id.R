# Aim:
#   return identificators of that experiments which satisfy all the tags.
# 
# input:
#   tag_vector = c(tag1,tag2,tag3) <char>
#   db_conf = list(
#     db_name,
#     db_user,
#     db_pass)
#   
# output:
#   id_vector = c(id1,id2,id3,id4) <int>

source("db_interface.R")

db_read_id<-function(tag_vector,db_conf){
  read_id<-function(tag){
    IdQuery<-sprintf("SELECT `experiment`.`idexperiment` FROM `filterdb`.`experimentTags` AS `experimentTags`, `filterdb`.`experiment` AS `experiment`, `filterdb`.`tagTable` AS `tagTable` WHERE `experimentTags`.`experiment_idexperiment` = `experiment`.`idexperiment` AND `experimentTags`.`tagTable_tagId` = `tagTable`.`tagId` AND `tagTable`.`tagName` = %s",tag)
    tmp_id_vector<- db_exec(IdQuery,db_conf)
    return(tmp_id_vector)
  }
  all_id<-sapply(tag_vector,read_id)
  id_vector<-Reduce(intersect, all_id)
  return(id_vector)
}