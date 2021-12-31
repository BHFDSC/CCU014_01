setwd("~/dars_nic_391419_j3w9t_collab/CCU014/R")

source('./src/common_functions.R')

## run variables time stamp codes, output dir, analysis dates etc, overwrite here if you want
source('./src/run_variables.R')

add_counts_from_query <- function(counts,q,type_occur,do_box){
  
  res = dbGetQuery(con,q)
  
  val<-res[1,]
  temp<-data.table(src=c(type_occur),box = c(do_box), count=c(val))
  counts<-rbind(counts, temp,fill=TRUE)
  
}


## dt to hold all counts
counts = NULL

q = paste0("SELECT count(*) as count FROM ", tre_project_prefix,"pmeds_archive_rt_211126
           WHERE Event_Date BETWEEN '",analysis_start_date,"' AND '",analysis_end_date,"'")

counts <- add_counts_from_query(counts,q,'dispensed','all')

q = paste0("SELECT count(*) as count FROM ", tre_project_prefix,"dispensed_key_groups_",tre_table_stamp_code)

counts <- add_counts_from_query(counts,q,'dispensed','key_groups')

q = paste0("SELECT count(*) as count FROM ", tre_project_prefix,"dispensed_key_groups_",tre_table_stamp_code,
           " WHERE key_group_rank = 1")

counts <- add_counts_from_query(counts,q,'dispensed','key_groups_incident')

q = paste0("SELECT count(*) as count FROM ", tre_project_prefix,"dispensed_key_groups_raw_",tre_table_stamp_code)

counts <- add_counts_from_query(counts,q,'dispensed','key_groups_raw')

for( g_name in names(key_groups_split )){
  
  grp_str = paste0(shQuote(key_groups_split [[g_name]]), collapse=",")
  
  q = paste0("SELECT count(*) as count FROM ", tre_project_prefix,"dispensed_key_groups_raw_",tre_table_stamp_code,
             " WHERE key_group in (",grp_str,")")
  
  counts <- add_counts_from_query(counts,q,'dispensed',paste0('key_groups_raw_',g_name))
}

out_file <- eng_data_path_counts(data_base_dir,'table_counts','')
save_dt_to_csv(counts, out_file)

