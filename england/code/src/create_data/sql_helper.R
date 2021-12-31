library(DBI)

########################
## 

sql_year_month_counts_by_key_group = function(res_set,box,incident){
  
  incident_sql = ''
  if (incident){
    incident_sql = paste0(" WHERE key_group_rank = 1 ")
  }
  
  q = paste0(
    "SELECT Year(Event_Date) as year, MONTH(Event_Date) as month, key_group, count(*) as count
        FROM ", tre_project_prefix ,res_set,"_",box,"_",tre_table_stamp_code, incident_sql,
    " GROUP BY Year(Event_Date), MONTH(Event_Date), key_group ")
  
}



########################
## 

sql_strat_year_month_counts_by_key_group = function(res_set,box,strat_key){
  
  q = paste0(
    "SELECT Year(Event_Date) as year, MONTH(Event_Date) as month,",strat_key," as strat_key, key_group, count(*) as count 
      FROM ", tre_project_prefix ,res_set,"_",box,"_",tre_table_stamp_code,
    " GROUP BY Year(Event_Date), MONTH(Event_Date), key_group, ",strat_key
  )
  
}


########################
## 

sql_raw_year_month_counts_by_key_group = function(res_set,box){

    q = paste0("
        select Year(Event_Date) as year, MONTH(Event_Date) as month, count(*) as count, key_group
        FROM ", tre_project_prefix ,res_set,"_",box,"_",tre_table_stamp_code,
        " GROUP BY Year(Event_Date), MONTH(Event_Date), key_group")

}


########################
##

sql_year_month_week_counts = function(res_set,box){
  
  q = paste0(
    "SELECT Year(Event_Date) as year, MONTH(Event_Date) as month, weekofyear(Event_Date) as weekofyear, 
        count(*) as count 
        FROM ", tre_project_prefix ,res_set,"_",box,"_",tre_table_stamp_code,
    " GROUP BY Year(Event_Date), MONTH(Event_Date), weekofyear(Event_Date) "
  )
  
}

########################
##

sql_year_week_counts = function(res_set,box){
  
  q = paste0(
    "SELECT Year(Event_Date) as year,  weekofyear(Event_Date) as weekofyear, 
        count(*) as count 
        FROM ", tre_project_prefix ,res_set,"_",box,"_",tre_table_stamp_code,
    " GROUP BY Year(Event_Date), weekofyear(Event_Date) "
  )
  
}

########################
##

sql_year_month_week_counts_by_key_group = function(res_set,box){
  
  q = paste0(
    "SELECT Year(Event_Date) as year, MONTH(Event_Date) as month, weekofyear(Event_Date) as weekofyear, 
        key_group, count(*) as count 
        FROM ", tre_project_prefix ,res_set,"_",box,"_",tre_table_stamp_code,
    " GROUP BY Year(Event_Date), MONTH(Event_Date), weekofyear(Event_Date), key_group"
  )
  
}

########################

sql_population_counts <- function(res_set,box,start_date,end_date,grp_str){
  
  q = paste0(
    
    "SELECT count(DISTINCT(NHS_NUMBER_DEID)) as pop_count
        FROM ", tre_project_prefix ,res_set,"_",box,"_",tre_table_stamp_code,
    "   WHERE Event_date BETWEEN '",start_date,"' AND '",end_date,"' "
  )
  
  if(grp_str != ''){
    q = paste0(q , " AND key_group in (",grp_str,")")
  }
  
  q
}
