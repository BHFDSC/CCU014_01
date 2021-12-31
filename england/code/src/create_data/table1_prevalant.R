
setwd("~/dars_nic_391419_j3w9t_collab/CCU014/R")

source('./src/common_functions.R')

## run variables time stamp codes, output dir, analysis dates etc, overwrite here if you want
source('./src/run_variables.R')

sum_by_date_range = function(dt,start_date,end_date){
  
  sum_dt = 0
  
  temp_dt = dt[Date %between% list(start_date,end_date)]
  if(nrow(temp_dt) > 0){
    sum_dt = sum(temp_dt$count)
  }
  
  sum_dt
}


counts_all_key_groups = function(country,table,dt){
  
  counts = NULL
  
  dt <- add_date_col(dt)
  setkey(dt,year,month)
  
  for(mm in month_to_month){
    
    sum_dt = sum_by_date_range(dt,mm[2], mm[3])
    cat( country,mm[1], mm[2], mm[3], sum_dt,'\n')
    temp<-data.table(country=(country),src=c(table), grp=c('All'),date_range=c(mm[1]),count=c(sum_dt))
    counts<-rbind(counts, temp,fill=TRUE)
  }
  
  counts
  
}

counts_by_key_group = function(country,table,dt){
  
  counts = NULL
  dt <- add_date_col(dt)
  
  setkey(dt,year,month)
  
  for( g_name in names(key_groups_split )){
    
    dt_temp <- dt[key_group %in% key_groups_split [[g_name]] ]
    
    for(mm in month_to_month){
      
      sum_dt = sum_by_date_range(dt_temp,mm[2], mm[3])
      cat( country,g_name, mm[1], mm[2], mm[3], sum_dt,'\n')
      temp<-data.table(country=(country),src=c(table), grp=c(g_name),date_range=c(mm[1]),count=c(sum_dt))
      counts<-rbind(counts, temp,fill=TRUE)
    }
  }
  
  counts
  
}

add_year_counts <- function(output,type_code,dt,countries){
  
  for(c in countries){
    
    dt_temp <- dt[country == c]
    
    if(!is.null(dt_temp) && nrow(dt_temp) > 0 ){
      dt_temp_all <- dt_temp[, .(count=sum(count)), by=list(year,month)]
      output<-rbind(output, counts_all_key_groups(c,type_code,dt_temp_all),fill=TRUE)
      output<-rbind(output, counts_by_key_group(c,type_code,dt_temp),fill=TRUE)
    }
  }
  
  output
  
}


update_population_all <- function(dt,country_code,output,src_code,month_to_month,key_grp){
  
  for(mm in month_to_month){
    
    row = dt[ src == src_code & date_range == mm[1] & key_group == key_grp]
    
    if(nrow(row) == 1){
      
      ##output[ ( country == country_code & src==src_code & date_range == mm[1]), pop2 := row$pop_count]
      output[ ( country == country_code & src==src_code & date_range == mm[1] & grp == key_grp), pop := row$pop_count]
    }
    
  }
  
  output
  
}

update_population_key_groups <- function(dt,country_code,output,src_code,month_to_month){
  
  for( g_name in names(key_groups_split )){
    
    for(mm in month_to_month){
      row = dt[ src == src_code &  date_range == mm[1] & key_group == g_name]
      
      if(nrow(row) == 1){
        
        output[ ( country == country_code & src==src_code & date_range == mm[1] & grp == g_name), pop := row$pop_count]
      }
    }
    
  }
  
  output
  
}

output = NULL

dt <- fread(paste0(data_analysis_dir,'/dispensed_key_groups_prevalent_by_country.csv'))
output <- add_year_counts(output,'dispensed',dt,countries)

dt <- fread(paste0(data_analysis_dir,'/prescribed_key_groups_prevalent_by_country.csv'))
output <- add_year_counts(output,'prescribed',dt,countries)

output[,paste0('pop') :=0]
##output[,paste0('pop2') :=0]

for(c in countries){
  
  dt_pop <- load_country_data(c,'population.csv')
  
  if(!is.null(dt_pop)){
    
    output = update_population_all(dt_pop,c,output,'dispensed',month_to_month,'All')
    output = update_population_key_groups(dt_pop,c,output,'dispensed',month_to_month)
    
    output = update_population_all(dt_pop,c,output,'prescribed',month_to_month,'All')
    output = update_population_key_groups(dt_pop,c,output,'prescribed',month_to_month)
  }
  
}

output[, rate_pop:= (count/pop)]
##output[, rate_pop2:= (count/pop2)]


out_file_name = paste0(data_analysis_dir,'/table_1.csv')
save_dt_to_csv(output, out_file_name)
