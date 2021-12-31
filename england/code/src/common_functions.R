library(data.table)
library(DBI)


#save output to csv
save_dt_to_csv <- function(res,out_file){
  
  ## write without index use row.names = FALSE
  write.csv(res, out_file, row.names = FALSE)
}

#save output from sql query to csv
query_to_csv <- function(q,out_file){
  
  cat('run query : \n',q,'\n')
  cat('write file to ',out_file,'\n')
  res = dbGetQuery(con,q)
  ## write without index use row.names = FALSE
  write.csv(res, out_file, row.names = FALSE)
}


#output full path to ENG data
eng_data_path_counts = function(base_dir,t,b='',strat_key=''){
  
  temp_list = list()
  
  if(t != ''){
    temp_list <- append(temp_list,t)
  }
  
  if(b != ''){
    temp_list <- append(temp_list,b)
  }
  
  if(strat_key != ''){
    temp_list <- append(temp_list,strat_key)
  }
  
  l = paste0(temp_list,collapse = '_')
  
  paste0(base_dir,'data_by_country_',run_analysis_timestamp,'/GB-ENG/',l,'.csv')
  
}


load_country_data <- function(country_code,file_name){
  
  dt = NULL
  file_path = paste0(data_base_dir,'data_by_country_',run_analysis_timestamp,'/',country_code,'/',file_name)
  
  if(file.exists(file_path)){
    dt <- fread(file_path)
  }
  
  dt
}

limit_dates <- function(dt, start_date,end_date){
  
  if(! "Date" %in% colnames(dt))
  {
    dt <- add_date_col(dt)
  }
  
  
  dt <- dt[Date %between% c(start_date,end_date)]
}

## FIXING DATES FOR PLOTTING
add_date_col <- function(dt){
  
  dt[is.na(dt)] <- 0
  dt$Date <-as.Date(with(dt,paste(year,month,'01',sep="-")),"%Y-%m-%d")
  setkey(dt,year,month)
  dt
}

run_pct_cal <- function(dt){
  
  dt_out <- cal_pct_change(dt)
  dt_out <- add_date_col(dt_out)
  dt_out <- dt_out[ pct != 0.00 ]
  dt_out
}

cal_pct_change = function(dt){
  
  
  dt_out = NULL
  
  for( i in 1:nrow(dt)){
    
    r <- dt[i,]
    ##cat(i, r$year, r$month, r$strat_key, r$count, '\n')
    
    temp = dt[year == (r$year-1) & month == r$month & strat_key == r$strat_key]
    
    c = 0
    pct = 0
    
    if(nrow(temp) > 0){
      c = temp$count
      pct = ((r$count - c)/c)*100
    }
    
    r$previous_year = c
    r$pct = pct
    
    dt_out<-rbind(dt_out, r,fill=TRUE)
  }
  
  dt_out
  
}


add_country_code <- function(dt,code){
  
  dt$country <- code
  if( "key_group" %in% colnames(dt)){
    dt$key_group_country <- paste0( dt$key_group,' - ',code)
  }
  dt
}


ethnic_desc_collapse = function(dt){
  
  dt <- dt[is.na(strat_key), strat_key := 'Missing']
  dt <- dt[strat_key == 'Not stated', strat_key := 'Missing']
  dt <- dt[strat_key == '', strat_key := 'Missing']
  
  dt <- dt[strat_key == "Any other ethnic group", strat_key := 'Other']
  dt <- dt[strat_key == "Arab", strat_key := 'Other']
  
  dt <- dt[strat_key == "Any other mixed background", strat_key := 'Mixed']
  dt <- dt[strat_key == "White and Black African", strat_key := 'Mixed']
  dt <- dt[strat_key == "White and Black Caribbean", strat_key := 'Mixed']
  dt <- dt[strat_key == "White and Asian", strat_key := 'Mixed']
  
  dt <- dt[strat_key == "Indian", strat_key := 'Asian']
  dt <- dt[strat_key == "Chinese", strat_key := 'Asian']
  dt <- dt[strat_key == "Pakistani", strat_key := 'Asian']
  dt <- dt[strat_key == "Bangladeshi", strat_key := 'Asian']
  dt <- dt[strat_key == "Any other Asian background", strat_key := 'Asian']
  
  dt <- dt[strat_key == "African", strat_key := 'Black']
  dt <- dt[strat_key == "Caribbean", strat_key := 'Black']
  dt <- dt[strat_key == "Any other Black background", strat_key := 'Black']
  
  dt <- dt[strat_key == "Irish", strat_key := 'White']
  dt <- dt[strat_key == "British", strat_key := 'White']
  dt <- dt[strat_key == "Traveller", strat_key := 'White']
  dt <- dt[strat_key == "Any other White background", strat_key := 'White']
  
  
  dt
  ##dt <- dt[, .(count=sum(count)), by=list(year,month,strat_key)]
  
}


ethnic_desc_collapse_eng = function(dt){
  
  
  dt <- dt[is.na(strat_key), strat_key := 'Missing']
  dt <- dt[strat_key == 'Not stated', strat_key := 'Missing']
  dt <- dt[strat_key == '', strat_key := 'Missing']
  dt <- dt[strat_key == "Any other mixed background", strat_key := 'Mixed background']
  dt <- dt[strat_key == "Any other ethnic group", strat_key := 'Any other']
  dt <- dt[strat_key == "Traveller", strat_key := 'Any other White background']
  dt <- dt[strat_key == "Arab", strat_key := 'Any other']
  dt <- dt[strat_key == "White and Black African", strat_key := 'Mixed background']
  dt <- dt[strat_key == "White and Black Caribbean", strat_key := 'Mixed background']
  dt <- dt[strat_key == "White and Asian", strat_key := 'Mixed background']
  
  dt
  ##dt <- dt[, .(count=sum(count)), by=list(year,month,strat_key)]
  
}


ethnic_label_change_eng = function(dt){
  
  dt <- dt[strat_key == 'Any other', strat_key := 'Other background']
  dt <- dt[strat_key == 'Any other Asian background', strat_key := 'Other Asian background']
  dt <- dt[strat_key == 'Any other Black background', strat_key := 'Other Black background']
  dt <- dt[strat_key == 'Any other White background', strat_key := 'Other White background']
  
}



sex_label_change = function(dt){
  
  dt$strat_key <- as.character(dt$strat_key)
  dt <- dt[strat_key == 1, strat_key := 'male']
  dt <- dt[strat_key == 2, strat_key := 'female']
  dt
}

