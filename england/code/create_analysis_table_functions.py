# Databricks notebook source
spark.conf.set("spark.sql.legacy.allowCreatingManagedTableUsingNonemptyLocation","true")

# COMMAND ----------

def drop_project_table(table_name):
  q = f'''DROP TABLE IF EXISTS {table_name}'''
  print(q)
  spark.sql(q)

# COMMAND ----------

def alter_project_table(table_name):
  q = f'''ALTER TABLE {table_name} OWNER TO dars_nic_391419_j3w9t_collab'''
  print(q)
  spark.sql(q)

# COMMAND ----------

# all the rows from Primary_meds or gdppr table we wish to use, limit to the drugs we are interested in, use key_groups
# join extra bnf_info

def create_start_tables(table_source_code,project_code,use_pmeds_table,use_gdppr_table,use_key_group_table):
  
  # which table to use, default
  use_source_table = use_pmeds_table
  
  if table_source_code == 'prescribed':
    use_source_table = use_gdppr_table
  
  create_table_name = f'''{project_code}_{table_source_code}_{table_stamp_code}'''

  drop_project_table(create_table_name)
  
  print(f' Create table {create_table_name}')
  
  q = f'''CREATE TABLE IF NOT EXISTS {create_table_name} AS 

    WITH 
      drug_codes as (
          SELECT DISTINCT(BNF_PRESENTATION_CODE) distinct_code
          FROM {use_key_group_table}
        ),
      key_groups_list AS (
        select * from {use_key_group_table}
      )
    SELECT a.*, key_groups_list.key_group

    FROM {use_source_table} a
    LEFT SEMI JOIN drug_codes ON a.PrescribedBNFCode = distinct_code -- so keep only records where record has specified drug code
    LEFT JOIN key_groups_list ON key_groups_list.BNF_PRESENTATION_CODE = a.PrescribedBNFCode '''

  #print(q)
  spark.sql(q)

  alter_project_table(create_table_name)
  

# COMMAND ----------

def create_box_key_groups(table_source,project_code,table_stamp_code,death_date,age_col,min_age,max_age):
  
  create_table_name = f'{project_code}_{table_source}_key_groups_{table_stamp_code}'
  from_table_name = f'{project_code}_{table_source}_{table_stamp_code}'

  drop_project_table(create_table_name)
  
  print(f' Create table {create_table_name}')
  
  q = f'''CREATE TABLE IF NOT EXISTS {create_table_name} AS 

    SELECT *, row_number() OVER (PARTITION BY NHS_NUMBER_DEID
                                      ORDER BY Event_Date asc) as deid_rank,
              row_number() OVER (PARTITION BY NHS_NUMBER_DEID , key_group
                                      ORDER BY Event_Date asc) as key_group_rank 
    FROM {from_table_name} 
    WHERE NHS_NUMBER_DEID is not null
    AND (SEX in (1,2) )
    AND DATE_OF_BIRTH is not null 
    AND (DATE_OF_DEATH is null or DATE_OF_DEATH > '{death_date}')
    AND LSOA_VALUE like 'E%'
    AND {age_col} BETWEEN {min_age} AND {max_age}  '''

  #print(q)
  spark.sql(q)

  alter_project_table(create_table_name)

# COMMAND ----------

# all linked and unlinked entries
# use PatientAge and LSOA filters

def create_box_key_groups_raw(table_source,project_code,table_stamp_code,min_age,max_age):
  
  create_table_name = f'{project_code}_{table_source}_key_groups_raw_{table_stamp_code}'
  from_table_name = f'{project_code}_{table_source}_{table_stamp_code}'

  drop_project_table(create_table_name)
  
  print(f' Create table {create_table_name}')
  
  q = f'''CREATE TABLE IF NOT EXISTS {create_table_name} AS 

    SELECT *
    FROM {from_table_name}
    WHERE (PatientAge is null OR PatientAge between {min_age} AND {max_age} )
    AND LSOA_Value LIKE 'E%' '''

  #print(q)
  spark.sql(q)

  alter_project_table(create_table_name)
  
