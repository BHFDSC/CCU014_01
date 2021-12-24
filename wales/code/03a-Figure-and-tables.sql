-----------------------------------------------------------
--Figure 1
--Flowchart showing selection of analytical datasets from WDDS 
-----------------------------------------------------------
SELECT * FROM (
	SELECT 
	'1' AS Row , 
	'Wales: WDDS All Dispensed medication' AS Description , 
	count(*) medication_count FROM SAILWWMCCV.CCU014_COHORT_DISPENSED

UNION 

	SELECT 
	'2' AS Row,
	'Wales: Valid ID & WOB; alive on 2018-01-04, gndr M or F'  AS description, 
	count(*) medication_count 
	FROM SAILWWMCCV.CCU014_COHORT_DISPENSED
	WHERE 
	alf_e IS NOT NULL 
	AND 
	wob IS NOT NULL 
	AND 
	(dod IS NULL OR dod > '2018-04-01')
	AND 
	gndr_cd IN ('1','2')

UNION 
	SELECT 
	'3' AS Row,
	'Wales: BNF Chapters 1-15'  AS description, 
	count(*) medication_count 
	FROM SAILWWMCCV.CCU014_COHORT_DISPENSED
	WHERE 
	alf_e IS NOT NULL 
	AND 
	wob IS NOT NULL 
	AND 
	(dod IS NULL OR dod > '2018-04-01')
	AND 
	gndr_cd IN ('1','2')	
	AND
	substr(bnf, 1, 2) IN ('01','02','03','04','05','06','07','08','09','10','11','12','13','14','15')
UNION 
	SELECT 
	'4' AS Row,
	'Wales: LOSA=W'  AS description, 
	count(*) medication_count 
	FROM SAILWWMCCV.CCU014_COHORT_DISPENSED
	WHERE 
	alf_e IS NOT NULL 
	AND 
	wob IS NOT NULL 
	AND 
	(dod IS NULL OR dod > '2018-04-01')
	AND 
	gndr_cd IN ('1','2')	
	AND
	substr(bnf, 1, 2) IN ('01','02','03','04','05','06','07','08','09','10','11','12','13','14','15')	
	AND 
	SUBSTRING(LSOA2011_INCEPTION,1,1) IN ('W')
UNION 
	SELECT 
	'5' AS Row,
	'Wales: >=18 & <112 years old'  AS description, 
	count(*) medication_count 
	FROM SAILWWMCCV.CCU014_COHORT_DISPENSED
	WHERE 
	alf_e IS NOT NULL 
	AND 
	wob IS NOT NULL 
	AND 
	(dod IS NULL OR dod > '2018-04-01')
	AND 
	gndr_cd IN ('1','2')	
	AND
	substr(bnf, 1, 2) IN ('01','02','03','04','05','06','07','08','09','10','11','12','13','14','15')	
	AND 
	SUBSTRING(LSOA2011_INCEPTION,1,1) IN ('W')
	AND 
	dispensed_age BETWEEN '18' AND '112'
UNION 	
	SELECT 
	'6' AS Row,
	'Wales: CVD medication'  AS description, 
	count(*) medication_count 
	FROM SAILWWMCCV.CCU014_COHORT_DISPENSED
	WHERE 
	alf_e IS NOT NULL 
	AND 
	wob IS NOT NULL 
	AND 
	(dod IS NULL OR dod > '2018-04-01')
	AND 
	gndr_cd IN ('1','2')	
	AND
	substr(bnf, 1, 2) IN ('01','02','03','04','05','06','07','08','09','10','11','12','13','14','15')	
	AND 
	SUBSTRING(LSOA2011_INCEPTION,1,1) IN ('W')
	AND 
	dispensed_age BETWEEN '18' AND '112'
	AND 
	key_group IS NOT NULL 
UNION 	
	SELECT 
	'7' AS Row,
	'Wales: incident medication'  AS description, 
	count(*) medication_count 
	FROM  SAILWWMCCV.CCU014_COHORT_DISPENSED_rows
	WHERE dt_prescribed >= '2019-03-01' and drug_seq=1 AND KEY_GROUP IS NOT NULL
)ORDER BY ROW;
	
-----------------------------------------------------------
--Table 1
-----------------------------------------------------------
SELECT * FROM (
	SELECT DISTINCT 
	'a-0' AS ROW, 
	'All CVD medicines' AS description, NULL AS Number_of_dispensed_items, NULL AS Patient_population
	FROM 	
	SAILWWMCCV.CCU014_COHORT_DISPENSED
UNION 
	SELECT 
	'b-1' AS ROW, 
	'March 2018-2019' AS description, count(*) AS cnt, count(DISTINCT alf_e) AS ALF
	FROM 	
	SAILWWMCCV.CCU014_COHORT_DISPENSED
	WHERE dt_prescribed BETWEEN '2018-03-01' AND '2019-03-01'
UNION 
	SELECT 
	'c-2' AS ROW, 
	'March 2019-2020' AS description, count(*) AS cnt, count(DISTINCT alf_e) AS ALF
	FROM 	
	SAILWWMCCV.CCU014_COHORT_DISPENSED
	WHERE dt_prescribed BETWEEN '2019-03-01' AND '2020-03-01'
UNION 
	SELECT 
	'd-3' AS ROW, 
	'March 2020-2021' AS description, count(*) AS cnt, count(DISTINCT alf_e) AS ALF
	FROM 	
	SAILWWMCCV.CCU014_COHORT_DISPENSED
	WHERE dt_prescribed BETWEEN '2020-03-01' AND '2021-03-01'
UNION	
---4 CVD MEDICINES
	SELECT DISTINCT 
	'e-4' AS ROW, 
	'4 CVD medicines - antihypertensive, lipid-lowering, type-2 diabetes, insulin' AS description, NULL AS Number_of_dispensed_items, NULL AS Patient_population
	FROM 	
	SAILWWMCCV.CCU014_COHORT_DISPENSED
UNION 
	SELECT 
	'f-5' AS ROW, 
	'March 2018-2019' AS description, count(*) AS cnt, count(DISTINCT alf_e) AS ALF
	FROM 	
	SAILWWMCCV.CCU014_COHORT_DISPENSED
	WHERE dt_prescribed BETWEEN '2018-03-01' AND '2019-03-01'
	AND key_group IN ('insulin','antihypertensives','lipid_lowering','type_2_diabetes')
UNION 
	SELECT 
	'g-6' AS ROW, 
	'March 2019-2020' AS description, count(*) AS cnt, count(DISTINCT alf_e) AS ALF
	FROM 	
	SAILWWMCCV.CCU014_COHORT_DISPENSED
	WHERE dt_prescribed BETWEEN '2019-03-01' AND '2020-03-01'
	AND key_group IN ('insulin','antihypertensives','lipid_lowering','type_2_diabetes')
UNION 
	SELECT 
	'h-7' AS ROW, 
	'March 2020-2021' AS description, count(*) AS cnt, count(DISTINCT alf_e) AS ALF
	FROM 	
	SAILWWMCCV.CCU014_COHORT_DISPENSED
	WHERE dt_prescribed BETWEEN '2020-03-01' AND '2021-03-01'	
	AND key_group IN ('insulin','antihypertensives','lipid_lowering','type_2_diabetes')
UNION
---7 CVD MEDICINES
	SELECT DISTINCT 
	'i-8' AS ROW, 
	'7 CVD medicines - AF, angina, DOACs,warfarins,heparins,antiplatelets,heart_failure' AS description, NULL AS Number_of_dispensed_items, NULL AS Patient_population
	FROM 	
	SAILWWMCCV.CCU014_COHORT_DISPENSED
UNION 
	SELECT 
	'j-9' AS ROW, 
	'March 2018-2019' AS description, count(*) AS cnt, count(DISTINCT alf_e) AS ALF
	FROM 	
	SAILWWMCCV.CCU014_COHORT_DISPENSED
	WHERE dt_prescribed BETWEEN '2018-03-01' AND '2019-03-01'
	AND key_group IN ('AF','angina','anticoagulant_DOAC','anticoagulant_warfarins','anticoagulants_heparins','antiplatelets_secondary','heart_failure')	
UNION 
	SELECT 
	'k-10' AS ROW, 
	'March 2019-2020' AS description, count(*) AS cnt, count(DISTINCT alf_e) AS ALF
	FROM 	
	SAILWWMCCV.CCU014_COHORT_DISPENSED
	WHERE dt_prescribed BETWEEN '2019-03-01' AND '2020-03-01'
	AND key_group IN ('AF','angina','anticoagulant_DOAC','anticoagulant_warfarins','anticoagulants_heparins','antiplatelets_secondary','heart_failure')	
UNION 
	SELECT 
	'l-11' AS ROW, 
	'March 2020-2021' AS description, count(*) AS cnt, count(DISTINCT alf_e) AS ALF
	FROM 	
	SAILWWMCCV.CCU014_COHORT_DISPENSED
	WHERE dt_prescribed BETWEEN '2020-03-01' AND '2021-03-01'	
	AND key_group IN ('AF','angina','anticoagulant_DOAC','anticoagulant_warfarins','anticoagulants_heparins','antiplatelets_secondary','heart_failure')	
) ORDER BY row;


COMMIT; 

-----------------------------------------
--data file
-----------------------------------------
SELECT * FROM (
	SELECT DISTINCT 
	key_group, 
	year(dt_prescribed) YR,
	month(dt_prescribed) MNTH,
	'sex' AS strat_key,
	gndr_cd AS  category, 
	count(*) AS counts
FROM 
	SAILWWMCCV.CCU014_COHORT_DISPENSED
	WHERE 
	alf_e IS NOT NULL 
	AND 
	wob IS NOT NULL 
	AND 
	(dod IS NULL OR dod > '2018-03-01')
	AND 
	gndr_cd IN ('1','2')	
	AND
	substr(bnf, 1, 2) IN ('01','02','03','04','05','06','07','08','09','10','11','12','13','14','15')	
	AND 
	SUBSTRING(LSOA2011_INCEPTION,1,1) IN ('W')
	AND 
	dispensed_age BETWEEN '18' AND '112'
	AND 
	key_group IS NOT NULL 
GROUP BY 
key_group, 
year(dt_prescribed),
month(dt_prescribed),
gndr_cd

UNION 

SELECT DISTINCT 
key_group, 
year(dt_prescribed) YR,
month(dt_prescribed) MNTH,
'Ethnicity' AS strat_key,
ETHNICITY_ONS_DESC AS  category, 
count(*) AS counts
FROM 
	SAILWWMCCV.CCU014_COHORT_DISPENSED
	WHERE 
	alf_e IS NOT NULL 
	AND 
	wob IS NOT NULL 
	AND 
	(dod IS NULL OR dod > '2018-03-01')
	AND 
	gndr_cd IN ('1','2')	
	AND
	substr(bnf, 1, 2) IN ('01','02','03','04','05','06','07','08','09','10','11','12','13','14','15')	
	AND 
	SUBSTRING(LSOA2011_INCEPTION,1,1) IN ('W')
	AND 
	dispensed_age BETWEEN '18' AND '112'
	AND 
	key_group IS NOT NULL 
GROUP BY 
key_group, 
year(dt_prescribed),
month(dt_prescribed),
ETHNICITY_ONS_DESC

UNION 

SELECT DISTINCT 
key_group, 
year(dt_prescribed) YR,
month(dt_prescribed) MNTH,
'age_band' AS strat_key,
CASE
WHEN dispensed_age BETWEEN '18' AND '29' THEN '18-29'
WHEN dispensed_age BETWEEN '30' AND '39' THEN '30-39'
WHEN dispensed_age BETWEEN '40' AND '49' THEN '40-49'
WHEN dispensed_age BETWEEN '50' AND '59' THEN '50-59'
WHEN dispensed_age BETWEEN '60' AND '69' THEN '60-69'
WHEN dispensed_age BETWEEN '70' AND '79' THEN '70-79'
WHEN dispensed_age BETWEEN '80' AND '89' THEN '80-89'
WHEN dispensed_age >= 90 THEN '90+' ELSE NULL END 
AS  category, 
count(*) AS counts
FROM 
	SAILWWMCCV.CCU014_COHORT_DISPENSED
	WHERE 
	alf_e IS NOT NULL 
	AND 
	wob IS NOT NULL 
	AND 
	(dod IS NULL OR dod > '2018-03-01')
	AND 
	gndr_cd IN ('1','2')	
	AND
	substr(bnf, 1, 2) IN ('01','02','03','04','05','06','07','08','09','10','11','12','13','14','15')	
	AND 
	SUBSTRING(LSOA2011_INCEPTION,1,1) IN ('W')
	AND 
	dispensed_age BETWEEN '18' AND '112'
	AND 
	key_group IS NOT NULL 
GROUP BY 
key_group, 
year(dt_prescribed),
month(dt_prescribed),
CASE
WHEN dispensed_age BETWEEN '18' AND '29' THEN '18-29'
WHEN dispensed_age BETWEEN '30' AND '39' THEN '30-39'
WHEN dispensed_age BETWEEN '40' AND '49' THEN '40-49'
WHEN dispensed_age BETWEEN '50' AND '59' THEN '50-59'
WHEN dispensed_age BETWEEN '60' AND '69' THEN '60-69'
WHEN dispensed_age BETWEEN '70' AND '79' THEN '70-79'
WHEN dispensed_age BETWEEN '80' AND '89' THEN '80-89'
WHEN dispensed_age >= 90 THEN '90+' ELSE NULL END 

)
ORDER BY key_group, yr, mnth, strat_key, category;

-------------------------------
--figure 2
-------------------------------
	SELECT DISTINCT 
	substring(dt_prescribed,1,7) yr_mnth,
	count(*) AS counts
	FROM 
	SAILWWMCCV.CCU014_COHORT_DISPENSED
	WHERE 
	alf_e IS NOT NULL 
	AND 
	wob IS NOT NULL 
	AND 
	(dod IS NULL OR dod > '2018-03-01')
	AND 
	gndr_cd IN ('1','2')	
	AND
	substr(bnf, 1, 2) IN ('01','02','03','04','05','06','07','08','09','10','11','12','13','14','15')	
	AND 
	SUBSTRING(LSOA2011_INCEPTION,1,1) IN ('W')
	AND 
	dispensed_age BETWEEN '18' AND '112'
	AND 
	key_group IS NOT NULL 
	GROUP BY 
	substring(dt_prescribed,1,7);
----------------------------------
--figure 3
----------------------------------
	SELECT DISTINCT 
	key_group, 
	substring(dt_prescribed,1,7) yr_mnth,
	count(*) AS counts
	FROM 
	SAILWWMCCV.CCU014_COHORT_DISPENSED
	WHERE 
	alf_e IS NOT NULL 
	AND 
	wob IS NOT NULL 
	AND 
	(dod IS NULL OR dod > '2018-03-01')
	AND 
	gndr_cd IN ('1','2')	
	AND
	substr(bnf, 1, 2) IN ('01','02','03','04','05','06','07','08','09','10','11','12','13','14','15')	
	AND 
	SUBSTRING(LSOA2011_INCEPTION,1,1) IN ('W')
	AND 
	dispensed_age BETWEEN '18' AND '112'
	AND 
 key_group IN ('insulin','antihypertensives','lipid_lowering','type_2_diabetes')
	GROUP BY 
	key_group,
	substring(dt_prescribed,1,7);
	
----------------------------------
--figure 4
----------------------------------
	SELECT DISTINCT 
	key_group, 
	substring(dt_prescribed,1,7) yr_mnth,
	count(*) AS counts
	FROM 
	SAILWWMCCV.CCU014_COHORT_DISPENSED_rows
	WHERE 
	dt_prescribed >= '2019-03-01' 
	and 
	drug_seq=1	
	AND 
	key_group IN ('insulin','antihypertensives','lipid_lowering','type_2_diabetes')
	GROUP BY 
	key_group,
	substring(dt_prescribed,1,7);
----------------------------------
--figure 5a
----------------------------------
	SELECT DISTINCT 
	substring(dt_prescribed,1,7) YR_MNTH,
	CASE
	WHEN dispensed_age BETWEEN '18' AND '29' THEN '18-29'
	WHEN dispensed_age BETWEEN '30' AND '39' THEN '30-39'
	WHEN dispensed_age BETWEEN '40' AND '49' THEN '40-49'
	WHEN dispensed_age BETWEEN '50' AND '59' THEN '50-59'
	WHEN dispensed_age BETWEEN '60' AND '69' THEN '60-69'
	WHEN dispensed_age BETWEEN '70' AND '79' THEN '70-79'
	WHEN dispensed_age BETWEEN '80' AND '89' THEN '80-89'
	WHEN dispensed_age >= 90 THEN '90+' ELSE NULL END AS age_band, 
	count(*) AS counts
FROM 
	SAILWWMCCV.CCU014_COHORT_DISPENSED
	WHERE 
	alf_e IS NOT NULL 
	AND 
	wob IS NOT NULL 
	AND 
	(dod IS NULL OR dod > '2018-03-01')
	AND 
	gndr_cd IN ('1','2')	
	AND
	substr(bnf, 1, 2) IN ('01','02','03','04','05','06','07','08','09','10','11','12','13','14','15')	
	AND 
	SUBSTRING(LSOA2011_INCEPTION,1,1) IN ('W')
	AND 
	dispensed_age BETWEEN '18' AND '112'
	AND 
	key_group IN ('insulin','antihypertensives','lipid_lowering','type_2_diabetes')
GROUP BY 
	substring(dt_prescribed,1,7),
	case
	WHEN dispensed_age BETWEEN '18' AND '29' THEN '18-29'
	WHEN dispensed_age BETWEEN '30' AND '39' THEN '30-39'
	WHEN dispensed_age BETWEEN '40' AND '49' THEN '40-49'
	WHEN dispensed_age BETWEEN '50' AND '59' THEN '50-59'
	WHEN dispensed_age BETWEEN '60' AND '69' THEN '60-69'
	WHEN dispensed_age BETWEEN '70' AND '79' THEN '70-79'
	WHEN dispensed_age BETWEEN '80' AND '89' THEN '80-89'
	WHEN dispensed_age >= 90 THEN '90+' ELSE NULL END;
----------------------------------
--figure 5b
---------------------------------
	SELECT DISTINCT 
	substring(dt_prescribed,1,7) YR_MNTH,
	CASE 
	WHEN gndr_cd=1 THEN 'male'
	WHEN gndr_cd=2 THEN 'female' ELSE NULL END AS sex, 
	count(*) AS counts
FROM 
	SAILWWMCCV.CCU014_COHORT_DISPENSED
	WHERE 
	alf_e IS NOT NULL 
	AND 
	wob IS NOT NULL 
	AND 
	(dod IS NULL OR dod > '2018-03-01')
	AND 
	gndr_cd IN ('1','2')	
	AND
	substr(bnf, 1, 2) IN ('01','02','03','04','05','06','07','08','09','10','11','12','13','14','15')	
	AND 
	SUBSTRING(LSOA2011_INCEPTION,1,1) IN ('W')
	AND 
	dispensed_age BETWEEN '18' AND '112'
	AND 
	key_group IN ('insulin','antihypertensives','lipid_lowering','type_2_diabetes')
GROUP BY 
	substring(dt_prescribed,1,7),
	CASE 
	WHEN gndr_cd=1 THEN 'male'
	WHEN gndr_cd=2 THEN 'female' ELSE NULL END;
	
-----------------------------------------
--5c - BY region same AS figure 2
-----------------------------------------
----------------------------------------
--5d - BY ethnicity
----------------------------------------
	SELECT DISTINCT 
	substring(dt_prescribed,1,7) YR_MNTH,
	CASE 
	WHEN ETHNICITY_ONS_DESC IS NOT NULL THEN ETHNICITY_ONS_DESC
	ELSE 'UNKNOWN' END AS ethnicity, 
	count(*) AS counts
FROM 
	SAILWWMCCV.CCU014_COHORT_DISPENSED
	WHERE 
	alf_e IS NOT NULL 
	AND 
	wob IS NOT NULL 
	AND 
	(dod IS NULL OR dod > '2018-03-01')
	AND 
	gndr_cd IN ('1','2')	
	AND
	substr(bnf, 1, 2) IN ('01','02','03','04','05','06','07','08','09','10','11','12','13','14','15')	
	AND 
	SUBSTRING(LSOA2011_INCEPTION,1,1) IN ('W')
	AND 
	dispensed_age BETWEEN '18' AND '112'
	AND 
	key_group IN ('insulin','antihypertensives','lipid_lowering','type_2_diabetes')
GROUP BY 
	substring(dt_prescribed,1,7),
	CASE 
	WHEN ETHNICITY_ONS_DESC IS NOT NULL THEN ETHNICITY_ONS_DESC
	ELSE 'UNKNOWN' END;
	
-----------------------------------
--exploration for sensitivity on quantity of items
	SELECT DISTINCT 
	key_group, 
	bnf, 
	BNF_DESC ,
	year(dt_prescribed) YR,
	month(dt_prescribed) MNTH,	 
	count(*) AS counts, 
	count(DISTINCT ALF_E) AS alf_counts, 
	ROUND(AVG(QTY_PRESCRIBED_VAL),2) average_qty_prescribed,
	sum(QTY_PRESCRIBED_VAL)	total_qty_prescribed
FROM 
	SAILWWMCCV.CCU014_COHORT_DISPENSED
	WHERE 
	alf_e IS NOT NULL 
	AND 
	wob IS NOT NULL 
	AND 
	(dod IS NULL OR dod > '2018-03-01')
	AND 
	gndr_cd IN ('1','2')	
	AND
	substr(bnf, 1, 2) IN ('01','02','03','04','05','06','07','08','09','10','11','12','13','14','15')	
	AND 
	SUBSTRING(LSOA2011_INCEPTION,1,1) IN ('W')
	AND 
	dispensed_age BETWEEN '18' AND '112'
	AND 
	key_group IS NOT NULL 
	AND 
	BNF IN ('0212000B0AAACAC','0212000Y0AAADAD')
GROUP BY 
key_group, 
year(dt_prescribed),
month(dt_prescribed), 
BNF ,BNF_DESC
ORDER BY 
key_group, 
year(dt_prescribed),
month(dt_prescribed), 
BNF ,BNF_DESC; 
