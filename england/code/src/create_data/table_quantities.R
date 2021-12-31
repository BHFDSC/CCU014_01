library(data.table)
setwd("~/dars_nic_391419_j3w9t_collab/CCU014/R")

source('./src/common_functions.R')

## run variables time stamp codes, output dir, analysis dates etc, overwrite here if you want
source('./src/run_variables.R')

x <- function(dt,c,drug_code,drug_name){
  
  temp = NULL
  
  for(mm in month_to_month){
    
    temp_dt = dt[Date %between% list(mm[2], mm[3])]
    
    sum_year = 0
    sum_count = 0
    
    if(nrow(temp_dt) > 0){
      sum_year = sum(temp_dt$total_quantity)
      sum_count = sum(temp_dt$count)
    }
    
    cat( c, mm[1], mm[2], mm[3], sum_year, sum_count,'\n')
    temp <-rbind(temp, data.table(drug =(drug_name), country=(c),date_range=c(mm[1]),
                      dispensed_items=c(sum_count),dispensed_total=c(sum_year),
                      avg=(sum_year/sum_count)))
    
  }
  
  temp
}

bnf_codes = list(c('0212000B0AAACAC','Atorvastatin 40mg tablets'),
                 c('0212000Y0AAADAD','Simvastatin 40mg tablets'))

countries = list('GB-ENG','GB-SCT','GB-WLS')

dt_out = NULL

for( c in countries){
  
  file_name = paste0('dispensed_quantities.csv')
  
  dt <- load_country_data(c,file_name)
  
  
  if(!is.null(dt) && nrow(dt) > 0 ){
    
    dt <- add_date_col(dt)
    
    for(bnf in bnf_codes){
      
      dt_temp <- dt[bnf_presentation_code == bnf[1] ] 
      temp <- x(dt_temp,c,bnf[1],bnf[2])
      dt_out <- rbind(dt_out,temp,fill=TRUE)
    }
  }
}

out_file_name = paste0(data_analysis_dir,'/table_quantities.csv')
save_dt_to_csv(dt_out, out_file_name)

