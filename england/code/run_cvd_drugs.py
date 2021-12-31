# Databricks notebook source
# set some initial values

project_code = 'dars_nic_391419_j3w9t_collab.ccu014_01'

table_stamp_code = 'rt_211230'

filter_date_of_death = '2018-04-01'

filter_age_min = 18
filter_age_max = 112

# Which arcgive tables to use, which drugs list groups table

use_pmeds_table = 'dars_nic_391419_j3w9t_collab.ccu014_01_pmeds_archive_rt_211126'
use_gdppr_table = 'dars_nic_391419_j3w9t_collab.ccu014_01_gdppr_archive_rt_210729'

use_key_group_table = f'{project_code}_cvd_drugs_rt_210616'

# COMMAND ----------

# MAGIC %run ./create_analysis_table_functions

# COMMAND ----------

# create start table with all linked and unlinked rows, limit to drugs we are interested in
create_start_tables('dispensed',project_code,use_pmeds_table,use_gdppr_table,use_key_group_table)

# COMMAND ----------

# create start table with all linked and unlinked rows, limit to drugs we are interested in
create_start_tables('prescribed',project_code,use_pmeds_table,use_gdppr_table,use_key_group_table)

# COMMAND ----------

# create key_group table, from start tables with filters and ranking
create_box_key_groups('dispensed',project_code,table_stamp_code,filter_date_of_death,'age_at_event',filter_age_min,filter_age_max)

# COMMAND ----------

# create key_group table, from start tables with filters and ranking
create_box_key_groups('prescribed',project_code,table_stamp_code,filter_date_of_death,'age_at_event',filter_age_min,filter_age_max)

# COMMAND ----------

# create key_group_raw table (linked and unlinked), from start tables with filters, pmeds only
create_box_key_groups_raw('dispensed',project_code,table_stamp_code,filter_age_min,filter_age_max)

# COMMAND ----------


