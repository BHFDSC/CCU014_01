
combine_and_sum_and_save <- function(list_of_dts,out_file_name,strat_key=NULL){
  
  ## combine and collapse
  
  ##cat(out_file_name,'\n')
  dt_plus = rbindlist(list_of_dts,fill=TRUE)
  
  if(is.null(strat_key)){
      dt_plus <- dt_plus[, .(count=sum(count)), by=list(year,month,key_group)]
  }else{
      dt_plus <- dt_plus[, .(count=sum(count)), by=list(year,month,key_group,strat_key)]
  }
  dt_plus <- add_date_col(dt_plus)
  ##setkey(dt_plus,year,month,key_group)
  
  save_dt_to_csv(dt_plus, out_file_name)
}

combine_and_save <- function(list_of_dts,out_file_name){
  
  ##cat(out_file_name,'\n')
  dt_plus = rbindlist(list_of_dts,fill=TRUE)
  ##setkey(dt_plus,year,month,key_group)
  dt_plus <- add_date_col(dt_plus)
  
  save_dt_to_csv(dt_plus, out_file_name)
  
}


combine_prevalent_data <- function(file_prefix,use_raw){
  
  list_dts <- c()
  list_dts_with_cc <- c()
  
  for( c in countries){
    
    file_name = paste0(file_prefix,'.csv')
    
    ## change for ENG, need all linked and unlinked
    if( use_raw &&  c == 'GB-ENG'){
      file_name = paste0(file_prefix,'_raw.csv')
    }
    
    dt <- load_country_data(c,file_name)
    
    if(!is.null(dt) && nrow(dt) > 0 ){
      
      dt[is.na(dt)] <- 'none'
      dt <- dt[key_group != 'none']
      
      list_dts <- append(list_dts,list(dt))
      
      dt <- add_country_code(dt,c)
      list_dts_with_cc <- append(list_dts_with_cc,list(dt))
      
    }
  }
  
  file_name_out = paste0(file_prefix,'_prevalent')
  if( use_raw ){
    file_name_out = paste0(file_prefix,'_prevalent_raw')
  }
  
  ##cat('file_out = ',file_name_out,'\n')
  
  out_file_name = paste0(data_analysis_dir,'/',file_name_out,'_combined.csv')
  combine_and_sum_and_save(list_dts,out_file_name)
  
  ## combine dts with country codes and save prevalent
  out_file_name = paste0(data_analysis_dir,'/',file_name_out,'_by_country.csv')
  combine_and_save(list_dts_with_cc,out_file_name)
  
  
}

combine_incident_data <- function(file_prefix){
  
  list_dts <- c()
  list_dts_with_cc <- c()
  
  for( c in countries){
    
    file_name = paste0(file_prefix,'.csv')
    
    dt <- load_country_data(c,file_name)
    if(!is.null(dt) && nrow(dt) > 0 ){
      
      list_dts <- append(list_dts,list(dt))
      
      dt <- add_country_code(dt,c)
      list_dts_with_cc <- append(list_dts_with_cc,list(dt))
      
    }
  }
  
  out_file_name = paste0(data_analysis_dir,'/',file_prefix,'_combined.csv')
  combine_and_sum_and_save(list_dts,out_file_name)
  
  ## combine dts with country codes and save prevalent
  out_file_name = paste0(data_analysis_dir,'/',file_prefix,'_by_country.csv')
  combine_and_save(list_dts_with_cc,out_file_name)
  
  
}
