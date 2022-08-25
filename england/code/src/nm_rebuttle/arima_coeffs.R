library(data.table)
library(forecast)
library(ggplot2)

################################
#### Figure out arima coefficents to use in stat ITS script
################################

setwd("~/dars_nic_391419_j3w9t_collab/CCU014/R")

#### set key groups as list
key_groups = list(
  
  'antihypertensives',
  'insulin',
  'anticoagulant_DOAC',
  'anticoagulant_warfarins',
  'antiplatelets_secondary',
  'type_2_diabetes',
  'lipid_lowering',
  'heart_failure'
)


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
  dt
}



add_time_counter <- function(dt, model_name, sv=0){
  dt <- dt[, time_counter := .I + sv]
  ##dt <- dt[, key_group := kg]
  setnames(dt,"V1", model_name)
  dt
  
}


model_arima <- function(dt,train_tc,start_year,start_month,predict_months){
  
  f<- 52.179
  f <- 12
  
  dt_train <- dt[time_counter <= train_tc]
  data_ts <- ts(dt_train[,4], frequency=f , start=c(start_year,start_month))
  summary(data_ts)
  
  m <- auto.arima(data_ts)
  summary(m)
  print(m)
  
  pred = predict(m,n.ahead=predict_months)
  
  print(pred)
  pred
  
}

#### load in new data counts

n <- paste0(getwd(),'/data/cvd_paper/analysis_rt_211230/dispensed_key_groups_incident_combined.csv')
dt_org <-fread(n)

n <- paste0(getwd(),'/data/cvd_paper/analysis_rt_220228/dispensed_key_groups_incident_combined.csv')
dt_new <-fread(n)

### use new data first
data = list( dt_new)

data_order = list('old','new')

dt_stack <- NULL

for(d in data ){
  
  data_run <- 'new'
  
  #### start looping key groups
  
  for(k in key_groups){
    
    cat(k,'\n')
    
    #### filter for group
    dt <- d[key_group == k]
    
    data_t1 = '2018-09-01'
    data_t2 = '2021-07-31'
    
    dt <- limit_dates(dt,data_t1,data_t2)
    setkey(dt, year,month)
    dt <- dt[, time_counter := 1:.N]
    
    dt_m <- dt
    
    am_t1 = '2018-10-01'
    am_t2 = '2021-07-31'
    predict_months <- 16
    train_tc_am <- 19
    am_start_year <-2018
    am_start_month <- 10
    
    dt_am_data <- limit_dates(dt,am_t1,am_t2)
    
    setkey(dt_am_data, year,month)
    
    am <- model_arima(dt_am_data,train_tc_am , am_start_year , am_start_month ,predict_months)
    dt_am <- as.data.table(am$pred)
    dt_am <- dt_am[, time_counter := .I + train_tc_am]
    setnames(dt_am,'x','arima_pred')
    dt_m  <- merge( dt_m,dt_am,  by = 'time_counter', all = TRUE)
    
    dt_stack <- rbind(dt_stack, dt_m)
    
  }
  
}


