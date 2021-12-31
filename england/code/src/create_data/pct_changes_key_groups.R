library(data.table)
setwd("~/dars_nic_391419_j3w9t_collab/CCU014/R")

source('./src/common_functions.R')

## run variables time stamp codes, output dir, analysis dates etc, overwrite here if you want
source('./src/run_variables.R')


## load combined data

dt_data <- fread(paste0(data_analysis_dir,'/dispensed_key_groups_prevalent_raw_combined.csv'))

dt_data <- add_date_col(dt_data)
dt_data <- dt_data[Date %between% c(analysis_start_date, analysis_end_date)]

dt_all <- dt_data[, .(count=sum(count)), by=list(year,month)]
dt_all[, paste0('strat_key') := 'dummy']
dt_out <- run_pct_cal(dt_all)
dt_out[,strat_key:=NULL]

out_file_name = paste0(data_analysis_dir,'/dispensed_key_groups_pct_change.csv')
save_dt_to_csv(dt_out, out_file_name)

for( g_name in names(key_groups_split )){
  
  dt<- dt_data[key_group %in% key_groups_split [[g_name]]]
  dt<- dt[, .(count=sum(count)), by=list(year,month)]
  dt <- add_date_col(dt)
  
  dt[, paste0('strat_key') := 'dummy']
  dt_out <- run_pct_cal(dt)
  dt_out[,strat_key:=NULL]
  
  out_file_name = paste0(data_analysis_dir,'/dispensed_key_groups_pct_change_',g_name,'.csv')
  save_dt_to_csv(dt_out, out_file_name)
  
}


