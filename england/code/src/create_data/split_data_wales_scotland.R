
setwd("~/dars_nic_391419_j3w9t_collab/CCU014/R")

source('./src/common_functions.R')

## run variables time stamp codes, output dir, analysis dates etc, overwrite here if you want
source('./src/run_variables.R')


save_country_data <- function(dt,country_code,file_name){
  
  file_path = paste0(data_base_dir,'data_by_country_',run_analysis_timestamp,'/',country_code,'/',file_name)
  cat(file_path,'\n')
  save_dt_to_csv(dt,file_path)
  
}

## start with sco prevalent file
dt_sco <- load_country_data('GB-SCT','subgrp_dispensed.csv')

## wales prevalent file
dt_wales <- load_country_data('GB-WLS','cvd_dispensed.csv')

################################################
########   prevalent counts 
################################################

if(!is.null(dt_sco)){
  
  dt_sco_temp <- dt_sco[strat_key == '']
  dt_sco_temp[,category:=NULL]
  dt_sco_temp[,strat_key:=NULL]
  
  save_country_data(dt_sco_temp,'GB-SCT','dispensed_key_groups.csv')
}

if(!is.null(dt_wales)){
  
  dt_wales_temp <- dt_wales[strat_key == 'sex']
  dt_wales_temp <- dt_wales_temp[, .(count=sum(count)), by=list(year,month,key_group)]
  
  save_country_data(dt_wales_temp,'GB-WLS','dispensed_key_groups.csv')
  
}

################################################
########   update SEX counts 
################################################

if(!is.null(dt_sco)){
  
    dt_sco_temp <- dt_sco[strat_key == 'sex']
    dt_sco_temp[,strat_key:=NULL]
    setnames(dt_sco_temp, "category", "strat_key")
    
    save_country_data(dt_sco_temp,'GB-SCT','dispensed_key_groups_SEX.csv')
    
}

if(!is.null(dt_wales)){
  
    dt_wales_temp <- dt_wales[strat_key == 'sex']
    dt_wales_temp[,strat_key:=NULL]
    setnames(dt_wales_temp, "category", "strat_key")
    
    save_country_data(dt_wales_temp,'GB-WLS','dispensed_key_groups_SEX.csv')
    
}

################################################
########  update region_name counts
################################################


if(!is.null(dt_sco)){
  
  dt_sco_temp <-dt_sco[strat_key == '']
  dt_sco_temp[,strat_key:=NULL]
  dt_sco_temp[,category:=NULL]
  dt_sco_temp <- dt_sco_temp[,paste0("strat_key"):="Scotland"]
  
  save_country_data(dt_sco_temp,'GB-SCT','dispensed_key_groups_region_name.csv')
  
}

if(!is.null(dt_wales)){
  
  dt_wales_temp <- dt_wales[strat_key == 'sex']
  dt_wales_temp<- dt_wales_temp[, .(count=sum(count)), by=list(year,month,key_group)]
  dt_wales_temp <- dt_wales_temp[,paste0("strat_key"):="Wales"]
  
  save_country_data(dt_wales_temp,'GB-WLS','dispensed_key_groups_region_name.csv')
  
}

################################################
########  update age_band_10 counts
################################################

if(!is.null(dt_sco)){
  
  dt_sco_temp <- dt_sco[strat_key == 'age_band_10']
  dt_sco_temp[,strat_key:=NULL]
  setnames(dt_sco_temp, "category", "strat_key")
  
  save_country_data(dt_sco_temp,'GB-SCT','dispensed_key_groups_age_band_10.csv')
  
}

if(!is.null(dt_wales)){
  
  dt_wales_temp <- dt_wales[strat_key == 'age_band']
  dt_wales_temp[,strat_key:=NULL]
  setnames(dt_wales_temp, "category", "strat_key")
  
  save_country_data(dt_wales_temp,'GB-WLS','dispensed_key_groups_age_band_10.csv')
  
}


################################################
########  update ETHNICITY_DESCRIPTION
################################################


if(!is.null(dt_wales)){
  
  dt_wales_temp <- dt_wales[strat_key == 'Ethnicity']
  dt_wales_temp[,strat_key:=NULL]
  setnames(dt_wales_temp, "category", "strat_key")
  dt_wales_temp <- ethnic_desc_collapse(dt_wales_temp)
  
  save_country_data(dt_wales_temp,'GB-WLS','dispensed_key_groups_ETHNICITY_DESCRIPTION.csv')
  
}


################################################
########   incident counts 
################################################


## wales prevalent file
dt <- load_country_data('GB-WLS','ind_dispensed.csv')

if(!is.null(dt)){
  
  dt$year_month = as.Date(paste0(dt$year_month,'-01'), "%Y-%m-%d")
  dt = transform(dt, month = as.numeric(format(year_month, "%m")), year = format(year_month, "%Y"))
  dt[,year_month:=NULL]
  
  save_country_data(dt,'GB-WLS','dispensed_key_groups_incident.csv')
  
}

## wales prevalent file
dt <- load_country_data('GB-SCT','incidence_dispensed.csv')

if(!is.null(dt)){
  
  save_country_data(dt,'GB-SCT','dispensed_key_groups_incident.csv')
  
}

################################################
