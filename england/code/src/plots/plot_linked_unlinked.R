library(data.table)
setwd("~/dars_nic_391419_j3w9t_collab/CCU014/R")

source('./src/common_functions.R')
source('./src/plots/plot_functions.R')

## run variables time stamp codes, output dir, analysis dates etc, overwrite here if you want
source('./src/run_variables.R')


dt <- load_country_data('GB-ENG','linked_unlinked.csv')
dt <- add_date_col(dt)
dt <- dt[Date %between% c(analysis_start_date, analysis_end_date)]

out_file_name = paste0(data_analysis_dir,'/plots/prevalent/dispensed_linked_unlinked.png')

plot_count(dt, out_file_name )