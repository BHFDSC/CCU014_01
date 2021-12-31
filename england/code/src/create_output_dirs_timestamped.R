library(data.table)
setwd("~/dars_nic_391419_j3w9t_collab/CCU014/R")

## run variables time stamp codes, output dir, analysis dates etc, overwrite here if you want
source('./src/run_variables.R')

check_and_create_dir <- function(dir_path){
  
  if (dir.exists(dir_path)){
    
    cat('Already EXISTS ! ',dir_path,'\n')

  } else {
    cat('Creating ! ',dir_path,'\n')
    dir.create(dir_path)
    
  }
  
}

create_sub_dirs <- function(subs){
  
  for(sd in subs){
    sub_dir = paste0(main_dir,sd,'/')
    check_and_create_dir(sub_dir)
  }
  
}

data_base = paste0(getwd(),'/data/',project_name,'/')
check_and_create_dir(data_base)

#if not exists create by_country data folders for run_analysis_timestamp
main_dir = file.path(paste0(data_base,'data_by_country_',run_analysis_timestamp,'/'))
check_and_create_dir(main_dir)

create_sub_dirs(countries)


#if not exists create output for analysis (paper) data folders for run_analysis_timestamp
main_dir = file.path(paste0(data_base,'analysis_',run_analysis_timestamp,'/'))
check_and_create_dir(main_dir)

main_dir = file.path(paste0(data_base,'analysis_',run_analysis_timestamp,'/plots/'))
check_and_create_dir(main_dir)

create_sub_dirs(list('incident','prevalent','strat'))

