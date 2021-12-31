setwd("~/dars_nic_391419_j3w9t_collab/CCU014/R")

source('./src/common_functions.R')

## run variables time stamp codes, output dir, analysis dates etc, overwrite here if you want
source('./src/run_variables.R')



## dt to hold all counts
counts = NULL

sql_where = list(c('linked','not null'), c('unlinked','null'))

for(sw in sql_where){
  
  q = paste0(
    "SELECT Year(Event_Date) as year, MONTH(Event_Date) as month, '",sw[1],"' as strat_key, count(*) as count
        FROM ", tre_project_prefix ,"dispensed_key_groups_raw_",tre_table_stamp_code,
    " WHERE NHS_NUMBER_DEID is ",sw[2],"
      GROUP BY Year(Event_Date), MONTH(Event_Date) ")
  
  res = dbGetQuery(con,q)
  counts<-rbind(counts, setDT(res),fill=TRUE)
  
}


dt_temp <- counts[, .(count=sum(count)), by=list(year,month)]
dt_temp[,paste0('strat_key') :='linked+unlinked']
counts<-rbind(counts, dt_temp,fill=TRUE)

out_file <- eng_data_path_counts(data_base_dir,'linked_unlinked','')
save_dt_to_csv(counts, out_file)
