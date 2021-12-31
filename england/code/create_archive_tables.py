# Databricks notebook source
# MAGIC %run ./create_base_table_functions

# COMMAND ----------

# set some initial values

project_code = 'dars_nic_391419_j3w9t_collab.ccu014_01'
table_stamp_code = 'rt_211217'

pmeds_archive = 'dars_nic_391419_j3w9t_collab.primary_care_meds_dars_nic_391419_j3w9t_archive'
gdppr_archive = 'dars_nic_391419_j3w9t_collab.gdppr_dars_nic_391419_j3w9t_archive'
skinny_patient_archive = 'dars_nic_391419_j3w9t_collab.curr302_patient_skinny_record_archive'

pmeds_archive_batch_id = '2298ab4b-f7fe-4d5d-8047-c47573157216'
project_pmeds_archive_date = 'rt_211126'

patient_archive_date = '2021-11-26 14:02:40.645948'
patient_archive_batch_id = '2298ab4b-f7fe-4d5d-8047-c47573157216'

gdppr_archive_batch_id = '06d86f6c-c3b1-4b71-b5e9-09c7bd529892'
project_gdppr_archive_date = 'rt_210729'

use_bnf_table = 'dars_nic_391419_j3w9t_collab.ccu014_01_bnf_info_rt_210616'


pmeds_temp_table_name = f'{project_code}_pmeds_archive_temp_{project_pmeds_archive_date}'
pmeds_table_name = f'{project_code}_pmeds_archive_{project_pmeds_archive_date}'

gdppr_temp_table_name = f'{project_code}_gdppr_archive_temp_{project_gdppr_archive_date}'
gdppr_table_name = f'{project_code}_gdppr_archive_{project_gdppr_archive_date}'

codelist_table_name = f'{project_code}_codelist_archive_{project_pmeds_archive_date}'

# COMMAND ----------

start_pmeds_table(pmeds_temp_table_name,pmeds_archive,pmeds_archive_batch_id,skinny_patient_archive,patient_archive_batch_id)

# COMMAND ----------

create_codelist(codelist_table_name,pmeds_temp_table_name,use_bnf_table)

# COMMAND ----------

start_gdppr_table(gdppr_temp_table_name,codelist_table_name,gdppr_archive,gdppr_archive_batch_id,skinny_patient_archive,patient_archive_batch_id)

# COMMAND ----------

add_extra_details('pmeds',pmeds_table_name,pmeds_temp_table_name,codelist_table_name)

# COMMAND ----------

add_extra_details('gdppr',gdppr_table_name,gdppr_temp_table_name,codelist_table_name)
