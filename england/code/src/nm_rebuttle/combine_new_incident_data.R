library(data.table)

setwd("~/dars_nic_391419_j3w9t_collab/CCU014/R")

countries = list('GB-ENG','GB-SCT','GB-WLS')

dt_org <- NULL
dt_new <- NULL

for(c in countries){
  
  o <- paste0(getwd(),'/data/cvd_paper/data_by_country_rt_211230/',c,'/dispensed_key_groups_incident.csv')
  dt<-fread(o)
  
  dt_org <- rbind(dt_org,dt)
  
  n <- paste0(getwd(),'/data/cvd_paper/data_by_country_rt_220228/',c,'/dispensed_key_groups_incident_nm.csv')
  dt<-fread(n)
  
  dt_new <- rbind(dt_new,dt)
  
}

setkey(dt_org, key_group,year,month)
dt_org <- dt_org[, .(count=sum(count)), by=list(year,month,key_group)]

setkey(dt_new, key_group,year,month)
dt_new <- dt_new[, .(count=sum(count)), by=list(year,month,key_group)]

add_date_col <- function(dt){
  
  dt[is.na(dt)] <- 0
  dt$Date <-as.Date(with(dt,paste(year,month,'01',sep="-")),"%Y-%m-%d")
  dt
}

o <- paste0(getwd(),'/data/cvd_paper/analysis_rt_211230/dispensed_key_groups_incident_combined.csv')
dt_org <- add_date_col(dt_org)
write.csv(dt_org, o, row.names = FALSE)

o <- paste0(getwd(),'/data/cvd_paper/analysis_rt_220228/dispensed_key_groups_incident_combined.csv')
dt_new <- add_date_col(dt_new)
write.csv(dt_new, o, row.names = FALSE)





