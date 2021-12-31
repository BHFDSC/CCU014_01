## SET time stamp codes for tables and output files

tre_project_prefix = 'dars_nic_391419_j3w9t_collab.ccu014_01_'

tre_table_stamp_code = 'rt_211230'

run_analysis_timestamp = 'rt_211230'

project_name = 'cvd_paper'

analysis_start_date = "2018-04-01"
analysis_end_date = "2021-07-31"

analysis_start_date_incident = "2019-01-01"
analysis_end_date_incident = "2021-07-31"

analysis_start_date_incident_limit = "2020-03-01"
analysis_end_date_incident_limit = "2021-07-31"
analysis_incident_previous_year = 2019

plot_start_date_incident = "2019-03-01"



data_base_dir = paste0(getwd(),'/data/',project_name,'/')
data_analysis_dir = paste0(data_base_dir,'analysis_',run_analysis_timestamp)

################################################

countries = list('GB-ENG','GB-SCT','GB-WLS')

strat_keys = list('SEX','ETHNICITY_DESCRIPTION','region_name', 'age_band_10')


month_to_month = list( c('mar_2018_2019','2018-03-01','2019-02-28'),
                       c('mar_2019_2020','2019-03-01', '2020-02-29'),
                       c('mar_2020_2021','2020-03-01', '2021-02-28')
)

key_groups = list('insulin',
                  'angina',
                  'anticoagulant_DOAC',
                  'anticoagulant_warfarins',
                  'antiplatelets_secondary',
                  'type_2_diabetes',
                  'lipid_lowering',
                  'antihypertensives',
                  'heart_failure',
                  'anticoagulants_heparins',
                  'AF')

key_groups_split = list(
  
  cvd_group_a = c('antihypertensives','lipid_lowering','insulin','type_2_diabetes'),
  
  cvd_group_b =  c(
    'angina',
    'anticoagulant_DOAC',
    'anticoagulant_warfarins',
    'antiplatelets_secondary',
    'heart_failure',
    'anticoagulants_heparins',
    'AF')
)
