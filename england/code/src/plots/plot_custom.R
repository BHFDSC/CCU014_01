library(data.table)
setwd("~/dars_nic_391419_j3w9t_collab/CCU014/R")

source('./src/common_functions.R')
source('./src/plots/plot_functions.R')

## run variables time stamp codes, output dir, analysis dates etc, overwrite here if you want
source('./src/run_variables.R')


################################################
# for eng ethic only, with different categories
################################################

cn = 'GB-ENG'
strat_key = 'ETHNICITY_DESCRIPTION'

plot_dir = paste0(data_analysis_dir,'/plots/strat/dispensed')

dt <- load_country_data(cn,paste0('dispensed_key_groups_',strat_key,'.csv'))
dt[is.na(dt)] <- "Missing"
dt <- ethnic_desc_collapse_eng(dt)

# remove British
dt <- dt[strat_key != 'British']

for( g_name in names(key_groups_split )){
  
  ## filter for group
  dt_grp <- dt[key_group %in% key_groups_split [[g_name]]]
  dt_grp[,key_group:=NULL]
  dt_grp <- dt_grp[, .(count=sum(count)), by=list(year,month,strat_key)]
  dt_grp <- add_date_col(dt_grp)
  dt_grp <- dt_grp[Date %between% c(analysis_start_date, analysis_end_date)]
  
  
  out_file_name = paste0(plot_dir,'_',paste0(g_name,'_',strat_key,'2','_',cn),'.png')
  
  plot_count(dt_grp, out_file_name )
  
  dt_out <- run_pct_cal(dt_grp)
  
  out_file_name = paste0(plot_dir,'_',paste0(g_name,'_pct_',strat_key,'2','_',cn),'.png')
  
  plot_pct(dt_out,  out_file_name )
  
}


################################################
