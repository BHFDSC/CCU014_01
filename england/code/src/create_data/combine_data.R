
setwd("~/dars_nic_391419_j3w9t_collab/CCU014/R")

source('./src/common_functions.R')

## run variables time stamp codes, output dir, analysis dates etc, overwrite here if you want
source('./src/run_variables.R')

source('./src/create_data/combine_functions.R')

combine_prevalent_data('dispensed_key_groups',TRUE)
combine_prevalent_data('dispensed_key_groups',FALSE)
combine_prevalent_data('prescribed_key_groups',FALSE)

combine_incident_data('dispensed_key_groups_incident')


################################################
########   for each stratification
################################################


for(strat_key in strat_keys){
  
  list_dts <- c()
  list_dts_with_cc <- c()
  
  for( c in countries){
    
    dt <- load_country_data(c,paste0('dispensed_key_groups_',strat_key,'.csv'))
    
    if(!is.null(dt) && nrow(dt) > 0){
      
      if(strat_key == 'SEX'){
        dt <- sex_label_change(dt)
      }
      
      if(strat_key == 'ETHNICITY_DESCRIPTION'){
        dt <- ethnic_desc_collapse(dt)
      }
      
      if(strat_key == 'region_name'){
        dt[is.na(dt)] <- "Missing"
      }
      
      list_dts <- append(list_dts,list(dt))
      
      dt <- add_country_code(dt,c)
      list_dts_with_cc <- append(list_dts_with_cc,list(dt))
      
    }
  }
  
  ## combine dts and save prevalent
  
  out_file_name = paste0(data_analysis_dir,'/dispensed_key_groups_',strat_key,'_combined.csv')
  combine_and_sum_and_save(list_dts,out_file_name,strat_key)
  
  ## combine dts with country codes and save prevalent
  out_file_name = paste0(data_analysis_dir,'/dispensed_key_groups_',strat_key,'_by_country.csv')
  combine_and_save(list_dts_with_cc,out_file_name)
  
}
