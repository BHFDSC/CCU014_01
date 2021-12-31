
setwd("~/dars_nic_391419_j3w9t_collab/CCU014/R")

source('./src/common_functions.R')
source('./src/create_data/sql_helper.R')


## run variables time stamp codes, output dir, analysis dates etc, overwrite here if you want
source('./src/run_variables.R')

## function to loop various tables and queries
run_query_by_key_groups = function (tables,do_boxes,incident){
  
  for (t in tables){
    
    for(do_box in do_boxes){
      
      out_name = do_box
      if(incident){
        out_name = paste0(do_box,"_incident")
      }
      
      q = sql_year_month_counts_by_key_group(t,do_box,incident)
      out_file <- eng_data_path_counts(data_base_dir,t,out_name)
      query_to_csv(q,out_file)
    }
  }
}

################################################
########  year month counts by key groups for table/boxes
################################################

tables = list('dispensed','prescribed')
do_boxes = list('key_groups')
run_query_by_key_groups(tables,do_boxes,FALSE)

tables = list('dispensed')
do_boxes = list('key_groups')
run_query_by_key_groups(tables,do_boxes,TRUE)


################################################
########  by key_group stratification counts
################################################

tables = list('dispensed')
do_boxes = list('key_groups')

for (t in tables){
  
  for(do_box in do_boxes){
    
    for (do_key in strat_keys){
      
      q = sql_strat_year_month_counts_by_key_group(t,do_box,do_key)
      out_file <- eng_data_path_counts(data_base_dir,t,do_box,do_key)
      query_to_csv(q,out_file)
    }
  }
}


################################################
########  all linked and unlinked
################################################

q = sql_raw_year_month_counts_by_key_group('dispensed','key_groups_raw')
out_file <-  eng_data_path_counts(data_base_dir,'dispensed','key_groups_raw')
query_to_csv(q,out_file)


################################################
########  year month week counts for prescibed
################################################


tables = list('prescribed')
do_boxes = list('key_groups')

for (t in tables){
  
  for(do_box in do_boxes){
    
    q = sql_year_month_week_counts(t,do_box)
    out_file <- eng_data_path_counts(data_base_dir,t,paste0(do_box,'_year_month_weeks'))
    query_to_csv(q,out_file)
    
    q = sql_year_week_counts(t,do_box)
    out_file <- eng_data_path_counts(data_base_dir,t,paste0(do_box,'_year_weeks'))
    query_to_csv(q,out_file)
    
    q = sql_year_month_week_counts_by_key_group(t,do_box)
    out_file <- eng_data_path_counts(data_base_dir,t,paste0(do_box,'_year_month_weeks_by_group'))
    query_to_csv(q,out_file)
    
  }
}

################################################
########  population counts
################################################

population_run_count <- function(q,t,b,kg,dr,counts_out){
  
  cat(q,'\n')
  res = dbGetQuery(con,q)
  val<-res[1,]
  temp <-data.table(src=c(t),box = c(b), key_group=c(kg), date_range=c(dr),pop_count=c(val))
  counts_out<-rbind(counts_out, temp,fill=TRUE)
  counts_out
  
}

## table codes
tables = list('dispensed','prescribed')
boxes = list('key_groups')

counts_out = NULL

for (t in tables){
  
  for (b in boxes){
    
    for(mm in month_to_month){
      
      q = sql_population_counts(t,b, mm[2],mm[3],'')
      counts_out <- population_run_count(q,t,b,'All',mm[1],counts_out)
      
      for( g_name in names(key_groups_split )){
        
        grp_str = paste0(shQuote(key_groups_split [[g_name]]), collapse=",")
        
        q = sql_population_counts(t,b, mm[2],mm[3],grp_str)
        
        counts_out <- population_run_count(q,t,b,g_name,mm[1],counts_out)
        
      }
    }
    
  }
  
}

out_file <- eng_data_path_counts(data_base_dir,'population','')
save_dt_to_csv(counts_out, out_file)

################################################


