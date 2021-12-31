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

def create_age_band(col,col_as):
  
  s = '''case when age_at_event = 0 then '0'
                     when {0} >= 1 and {0} <= 4 then '1-4'
                     when {0} >= 5 and {0} <= 9 then '5-9'
                     when {0} >= 10 and {0} <= 14 then '10-14'
                     when {0} >= 15 and {0} <= 19 then '15-19'
                     when {0} >= 20 and {0} <= 24 then '20-24'
                     when {0} >= 25 and {0} <= 29 then '25-29'
                     when {0} >= 30 and {0} <= 34 then '30-34'
                     when {0} >= 35 and {0} <= 39 then '35-39'
                     when {0} >= 40 and {0} <= 44 then '40-44'
                     when {0} >= 45 and {0} <= 49 then '45-49'
                     when {0} >= 50 and {0} <= 54 then '50-54'
                     when {0} >= 55 and {0} <= 59 then '55-59'
                     when {0} >= 60 and {0} <= 64 then '60-64'
                     when {0} >= 65 and {0} <= 69 then '65-69'
                     when {0} >= 70 and {0} <= 74 then '70-74'
                     when {0} >= 75 and {0} <= 79 then '75-79'   
                     when {0} >= 80 and {0} <= 84 then '80-84'
                     when {0} >= 85 and {0} <= 89 then '85-89'
                     when {0} >= 90 and {0} <= 94 then '90-94'
                     when {0} >=95 then  '95+' '''.format(col)
  return '''{} end as {}'''.format(s,col_as)
            

def create_age_band_binary(col,col_as):
  
  s = ''' case when {0} >= 0 and {0} <= 64 then '0-64'
                     when {0} >= 65 then '65+' '''.format(col)
    
  return '''{} end as {}'''.format(s,col_as)

def create_age_band_10(col,col_as):
  
  s =  '''case when {0} >= 18 and {0} <= 29 then '18-29'
                     when {0} >= 30 and {0} <= 39 then '30-39'
                     when {0} >= 40 and {0} <= 49 then '40-49'
                     when {0} >= 50 and {0} <= 59 then '50-59'
                     when {0} >= 60 and {0} <= 69 then '60-69'
                     when {0} >= 70 and {0} <= 79 then '70-79'  
                     when {0} >= 80 and {0} <= 89 then '80-89'
                     when {0} >=90 then  '90+' '''.format(col)
  
  return '''{} end as {}'''.format(s,col_as)


# COMMAND ----------

# create Tempoaray table used later and dropped! all the rows from Primary_meds table, limit columns to the ones we need, add some aliases to columns name to make common names
# if has a deid, left join skinny person details, calculate age_at event, age_at_death from skinny Date of Birth

def start_pmeds_table(create_table_name,pmeds_archive,pmeds_archive_batch_id,skinny_patient_archive,patient_archive_batch_id):

  drop_project_table(create_table_name)

  q = f'''CREATE TABLE IF NOT EXISTS {create_table_name} AS 

    WITH 
    
      archive (
        SELECT * 
        FROM {pmeds_archive}
        WHERE BatchId = '{pmeds_archive_batch_id}'
      ),
      patient_record AS (
          SELECT * 
          FROM {skinny_patient_archive} 
          WHERE BatchId = '{patient_archive_batch_id}'
        )
    SELECT a.PERSON_ID_DEID as NHS_NUMBER_DEID, a.PatientGender, a.PatientAge, a.PrescribedBNFCode,a.PrescribeddmdCode, a.ProcessingPeriodDate as Event_Date, 
            a.DispensedPharmacyLSOA as LSOA_VALUE, a.PrescribedQuantity,a.DispensedCountryCode,a.PrescribedBNFName,
            b.ETHNIC, b.SEX, b.DATE_OF_BIRTH, b.DATE_OF_DEATH,
            round(months_between(a.ProcessingPeriodDate,b.DATE_OF_BIRTH)/12,0) as age_at_event,
            round(months_between(b.DATE_OF_DEATH,b.DATE_OF_BIRTH)/12,0) as age_at_death

    FROM archive a
    LEFT JOIN patient_record b ON a.PERSON_ID_DEID = b.NHS_NUMBER_DEID  '''

  #print(q)
  spark.sql(q)

  alter_project_table(create_table_name)

# COMMAND ----------

# all combo of bnf/dmd from pmeds, where dmd is not null, ranked if dupe dmd codes

def create_codelist(create_table_name,from_table_name,use_bnf_table):
  
  q = f'''CREATE OR REPLACE GLOBAL TEMPORARY VIEW ccu014_codelist_temp AS 
  
          SELECT PrescribedBNFCode, PrescribeddmdCode, PrescribedBNFName, count(*) as pmeds_count
          FROM {from_table_name}
          WHERE PrescribeddmdCode is not null
          GROUP BY PrescribedBNFCode,  PrescribeddmdCode, PrescribedBNFName '''
          
  spark.sql(q)
  
  q = f'''CREATE OR REPLACE GLOBAL TEMPORARY VIEW ccu014_codelist_temp2 AS 
  
          SELECT *, row_number() OVER (PARTITION BY PrescribeddmdCode
                                              ORDER BY pmeds_count desc) as dmd_rank
          FROM global_temp.ccu014_codelist_temp '''
  
  spark.sql(q)
  
  drop_project_table(create_table_name)

  print(f' Create table {create_table_name}')

  q = f'''CREATE TABLE IF NOT EXISTS {create_table_name} AS 
          
          SELECT a.PrescribedBNFCode, a.PrescribeddmdCode, a.PrescribedBNFName,b.*
          from global_temp.ccu014_codelist_temp2  a
          left join {use_bnf_table} b ON a.PrescribedBNFCode = b.BNF_PRESENTATION_CODE
          WHERE a.dmd_rank = 1 '''

  #print(q)
  spark.sql(q)

  alter_project_table(create_table_name)
  

# COMMAND ----------

# create Tempoaray table used later and dropped! all the rows from gdppr table, limit columns to the ones we need, add some aliases to columns name to make common names
# if has a deid, left join skinny person details, calculate age_at event, age_at_death from skinny Date of Birth

def start_gdppr_table(create_table_name,codelist_table_name,gdppr_archive,gdppr_archive_batch_id,skinny_patient_archive,patient_archive_batch_id):
  
  drop_project_table(create_table_name)

  q = f'''CREATE TABLE IF NOT EXISTS {create_table_name} AS 

    WITH 
    
      archive (
        SELECT * 
        FROM {gdppr_archive}
        WHERE BatchId = '{gdppr_archive_batch_id}'
      ),
      
      drug_codes as (
          SELECT DISTINCT(PrescribeddmdCode) distinct_dmd 
          FROM {codelist_table_name}
          WHERE PrescribeddmdCode is not null
        ),
      patient_record AS (
          SELECT * 
          FROM {skinny_patient_archive}
          WHERE BatchId = '{patient_archive_batch_id}'
        )
    SELECT a.NHS_NUMBER_DEID, a.CODE as PrescribeddmdCode, a.Date as Event_Date, a.PRACTICE, a.LSOA as LSOA_VALUE, a.EPISODE_PRESCRIPTION,a.VALUE1_PRESCRIPTION, a.VALUE2_PRESCRIPTION,
            b.ETHNIC, b.SEX, b.DATE_OF_BIRTH, b.DATE_OF_DEATH,
            round(months_between(a.Date,b.DATE_OF_BIRTH)/12,0) as age_at_event,
            YEAR(a.Date)-YEAR(b.DATE_OF_BIRTH) as age_at_event_year,
            round(months_between(b.DATE_OF_DEATH,b.DATE_OF_BIRTH)/12,0) as age_at_death

    FROM archive a
    LEFT SEMI JOIN drug_codes ON a.CODE = distinct_dmd -- so keep only records where gp record has specified drug code
    LEFT JOIN patient_record b ON a.NHS_NUMBER_DEID = b.NHS_NUMBER_DEID '''

  #print(q)
  spark.sql(q)

  alter_project_table(create_table_name)

# COMMAND ----------

# create new table from temp tables above,
# join  ethnic, region lookup, and add age band columns
# then drop the from above

def add_extra_details(table_source,create_table_name,from_table_name,codelist_table_name):
  
  age_band = create_age_band('age_at_event','age_band' )
  age_band_binary = create_age_band_binary('age_at_event','age_binary' )
  age_band_10 = create_age_band_10('age_at_event','age_band_10' )
  age_band_10_death = create_age_band_10('age_at_death','age_band_10_death' )
  
  bnf_cols = ''
  if table_source == 'gdppr':
    bnf_cols = 'bnf.PrescribedBNFCode, bnf.PrescribedBNFName, '
  
  bnf_sql = f''' {bnf_cols} cast(left(bnf.PrescribedBNFCode, 2) as int) as BNF_CHAPTER_NUM, 
                left(bnf.PrescribedBNFCode, 4) as BNF_SECTION_CODE, left(bnf.PrescribedBNFCode, 6) as BNF_PARAGRAPH_CODE, left(bnf.PrescribedBNFCode, 7) as BNF_SUBPARAGRAPH_CODE,
                left(bnf.PrescribedBNFCode, 9) as BNF_CHEMICAL_SUBSTANCE_CODE,  left(bnf.PrescribedBNFCode, 11) as BNF_PRODUCT_CODE '''
  
  drop_project_table(create_table_name)

  q = f'''CREATE TABLE IF NOT EXISTS {create_table_name} AS 
          WITH
          bnf as (
            SELECT {bnf_sql}
            FROM {codelist_table_name}
          )
          SELECT a.*, b.lsoa_name,b.region_name, c.Label as ETHNICITY_DESCRIPTION, {age_band}, {age_band_binary}, {age_band_10}, {age_band_10_death}, {bnf_sql}
          FROM {from_table_name} a
          LEFT JOIN dars_nic_391419_j3w9t_collab.curr901a_lsoa_region_lookup b ON b.lsoa_code = a.LSOA_VALUE
          LEFT JOIN dss_corporate.gdppr_ethnicity c ON  c.Value = a.ETHNIC 
          LEFT JOIN {codelist_table_name} bnf ON bnf.PrescribeddmdCode = a.PrescribeddmdCode '''

  #print(q)
  spark.sql(q)

  alter_project_table(create_table_name)
  
  # drop the temp table we created from
  drop_project_table(from_table_name)
  
  #print("done add_extra_details")
