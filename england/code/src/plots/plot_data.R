library(data.table)
setwd("~/dars_nic_391419_j3w9t_collab/CCU014/R")

source('./src/common_functions.R')
source('./src/plots/plot_functions.R')

## run variables time stamp codes, output dir, analysis dates etc, overwrite here if you want
source('./src/run_variables.R')


create_plot_file_name <- function(g_name,do_pct,country_code,strat_key){
  
  temp_list = list()
  
  if(g_name != ''){
    temp_list <- append(temp_list,g_name)
  }
  
  if(do_pct){
    temp_list <- append(temp_list,'pct')
  }
  
  if(strat_key != ''){
    temp_list <- append(temp_list,strat_key)
  }
  
  if(country_code != ''){
    temp_list <- append(temp_list,country_code)
  }
  
  l = paste0(temp_list,collapse = '_')
  
}

collapse_and_sum_by_strat_key <- function(dt_grp){
  
  dt_grp[,key_group:=NULL]
  dt_grp <- dt_grp[, .(count=sum(count)), by=list(year,month,strat_key)]
  dt_grp <- add_date_col(dt_grp)
  dt_grp <- dt_grp[Date %between% c(analysis_start_date, analysis_end_date)]
}

sort_and_plot <- function(dt,type_occur,do_pct,cnt_code,strat_key,do_sum=FALSE){
  
  ## loop cvd groups
  for( g_name in names(key_groups_split )){
    
    ## filter for group
    dt_grp <- dt[key_group %in% key_groups_split [[g_name]]]
    
    if(do_sum){
      
      dt_grp <- collapse_and_sum_by_strat_key(dt_grp)
      
    }else{
      setnames(dt_grp, "key_group", "strat_key")
    }
    
    
    temp_file_name = paste0(plot_dir,type_occur)
    
    out_file_name = create_plot_file_name(g_name,FALSE,cnt_code,strat_key)
      
    plot_count(dt_grp, paste0(temp_file_name,'_',out_file_name,'.png') )
    
    ## cal Percentage change yr on yr if do_pct
    
    if(do_pct){
        
        dt_out <- run_pct_cal(dt_grp)
        
        out_file_name = create_plot_file_name(g_name,do_pct,cnt_code,strat_key)
        
        plot_pct(dt_out,  paste0(temp_file_name,'_',out_file_name,'.png') )
    }
    
  }
  
}


################################################
## load combined data

plot_dir = paste0(data_analysis_dir,'/plots/prevalent/')

file_name = paste0(data_analysis_dir,'/dispensed_key_groups_prevalent_raw_combined.csv')
dt <- fread(file_name)
dt <- dt[Date %between% c(analysis_start_date, analysis_end_date)]

sort_and_plot(dt,'dispensed',TRUE,'','')

file_name = paste0(data_analysis_dir,'/dispensed_key_groups_prevalent_raw_by_country.csv')

dt <- fread(file_name)
dt <- dt[Date %between% c(analysis_start_date, analysis_end_date)]


for(cn in countries){
  
  dt_temp <- dt[country == cn]
  
  if(!is.null(dt_temp) && nrow(dt_temp) > 0 ){
  
    sort_and_plot(dt_temp,'dispensed',TRUE,cn,'')
  }
}

################################################


plot_dir = paste0(data_analysis_dir,'/plots/incident/')

file_name = paste0(data_analysis_dir,'/dispensed_key_groups_incident_combined.csv')
dt <- fread(file_name)
dt <- dt[Date %between% c(plot_start_date_incident, analysis_end_date_incident)]

sort_and_plot(dt,'dispensed',FALSE,'','')

file_name = paste0(data_analysis_dir,'/dispensed_key_groups_incident_by_country.csv')

dt <- fread(file_name)
dt <- dt[Date %between% c(plot_start_date_incident, analysis_end_date_incident)]


for(cn in countries){
  
  dt_temp <- dt[country == cn]
  
  if(!is.null(dt_temp) && nrow(dt_temp) > 0 ){
    
    sort_and_plot(dt_temp,'dispensed',FALSE,cn,'')
  }
}

################################################


################################################
# for each strat_key, plot combined data
################################################


plot_dir = paste0(data_analysis_dir,'/plots/strat/')

for(strat_key in strat_keys ){
  
  file_name = paste0(data_analysis_dir,'/dispensed_key_groups_',strat_key,'_combined.csv')
  
  dt <- fread(file_name)
  
  
  sort_and_plot(dt,'dispensed',TRUE,'',strat_key,TRUE)
  
}

################################################
# for each strat_key, loop each country and plot
################################################

plot_dir = paste0(data_analysis_dir,'/plots/strat/')

for(strat_key in strat_keys ){
  
  file_name = paste0(data_analysis_dir,'/dispensed_key_groups_',strat_key,'_by_country.csv')
  
  dt <- fread(file_name)
  
  for(cn in countries){
    
    dt_temp <- dt[country == cn]
    
    if(!is.null(dt_temp) && nrow(dt_temp) > 0 ){
      
      sort_and_plot(dt_temp,'dispensed',FALSE,cn,strat_key,TRUE)
    }
    
  }
  
}

