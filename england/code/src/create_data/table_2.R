library(data.table)
setwd("~/dars_nic_391419_j3w9t_collab/CCU014/R")

source('./src/common_functions.R')

## run variables time stamp codes, output dir, analysis dates etc, overwrite here if you want
source('./src/run_variables.R')

cal_sum_missing <- function(dt){
  
  dt_out = NULL
  
  for( i in 1:nrow(dt)){
    
    r <- dt[i,]
    ##cat(i, r$year, r$month, r$strat_key, r$count ,'\n')
    
    temp = dt[year == analysis_incident_previous_year & month == r$month & strat_key == r$strat_key]
    
    c = 0
    pct = 0
    
    if(nrow(temp) > 0){
      ##cat('FOUND PREV YEAR ', r$count ,' - ', temp$count,'\n')
      c = temp$count
      diff = (c - r$count)
    }
    
    r$previous_year = c
    r$diff = diff
    
    dt_out<-rbind(dt_out, r,fill=TRUE)
  }
  
  dt_out
}

dt <- fread(paste0(data_analysis_dir,'/dispensed_key_groups_incident_combined.csv'))

dt <- add_date_col(dt)
dt <- dt[Date %between% c(analysis_start_date_incident, analysis_end_date_incident)]
setnames(dt, "key_group", "strat_key")

dt_all <- data.table(Date = seq(as.Date(analysis_start_date_incident_limit), as.Date(analysis_end_date_incident_limit), by="month"))
dt_all = transform(dt_all, year = format(Date, "%Y"), month = as.numeric(format(Date, "%m")))

for( g_name in key_groups){
  
  dt_temp<- dt[strat_key == g_name]
  dt_temp <- cal_sum_missing(dt_temp)
  dt_temp <- dt_temp[Date >= as.Date(analysis_start_date_incident_limit)]
  setkey(dt_temp,year,month)
  dt_all[, paste0(g_name) := dt_temp$diff ]

  dt_out_sum <- dt_temp[Date >= as.Date(analysis_start_date_incident_limit)]
  cat('SUM FOR ',g_name, ' == ', sum(dt_out_sum$diff), '\n')
}

dt_all[,Date := NULL]
x = data.table( t(colSums(dt_all[, 3:ncol(dt_all)])) )
dt_all = rbind(dt_all,x,fill=TRUE)

out_file_name = paste0(data_analysis_dir,'/table_2.csv')
save_dt_to_csv(dt_all, out_file_name)
