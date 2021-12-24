-------------------------------------------------------------
--Project number: CCU014
--Lead analyst: fatemeh.torabi@swansea.ac.uk
--Date: 11-11-2021
-----------------
--Specifications:
----------------- 
--prescribed cohort: base WLGP 
--Start date: 1st April 2018
--End date:   31st May 2021

--age between 18 and 112 at the date of prescription/dispensed
-------------------------------------------------------------

SELECT YR, 	CASE
	WHEN MNTH=1 THEN 'Jan'
	WHEN MNTH=2 THEN 'Feb'
	WHEN MNTH=3 THEN 'Mar'
	WHEN MNTH=4 THEN 'Apr'
	WHEN MNTH=5 THEN 'May'
	WHEN MNTH=6 THEN 'Jun'
	WHEN MNTH=7 THEN 'Jul'
	WHEN MNTH=8 THEN 'Aug'
	WHEN MNTH=9 THEN 'Sep'
	WHEN MNTH=10 THEN 'Oct'
	WHEN MNTH=11 THEN 'Nov'
	WHEN MNTH=12 THEN 'Dec'
	END AS MNTHS
	,MNTH, READ_CHAPTER ,
	CASE
	WHEN READ_CHAPTER = 'a' THEN 'GI_DRUGS'
	WHEN READ_CHAPTER = 'b' THEN 'CV_DRUGS'
	WHEN READ_CHAPTER = 'c' THEN 'RESP_DRUGS'
	WHEN READ_CHAPTER = 'd' THEN 'CNS_DRUGS'
	WHEN READ_CHAPTER = 'e' THEN 'DRUGS_INFECTION'
	WHEN READ_CHAPTER = 'f' THEN 'ENDOCRINE_DRUGS'
	WHEN READ_CHAPTER = 'g' THEN 'OBS_GYNAE_URI_DRUGS'
	WHEN READ_CHAPTER = 'h' THEN 'CHEMO_IMMUNO_DRUGS'
	WHEN READ_CHAPTER = 'i' THEN 'HAEMATOLOGY_DIETETIC_DRUGS'
	WHEN READ_CHAPTER = 'j' THEN 'MSK_DRUGS'
	WHEN READ_CHAPTER = 'k' THEN 'EYE_DRUGS'
	WHEN READ_CHAPTER = 'l' THEN 'ENT_DRUGS'
	WHEN READ_CHAPTER = 'm' THEN 'SKIN_DRUGS'
	ELSE READ_CHAPTER END AS READ_CHAPTER_NAME, TOTAL_ITEMS
FROM (
	SELECT DISTINCT yr,read_chapter,mnth, count(*) as total_items FROM
	(
		SELECT DISTINCT EVENT_CD,EVENT_DT ,ALF_E,YEAR(EVENT_DT) YR, month(EVENT_DT) mnth, LEFT(EVENT_CD ,1) READ_CHAPTER
		FROM SAIL0911V.WLGP_GP_EVENT_CLEANSED
		WHERE
			ALF_E IN (SELECT DISTINCT ALF_E FROM  SAILW0911V.FT_WDDS_CLEANED WHERE ALF_E IN (SELECT DISTINCT ALF_E FROM SAILW0911V.C19_COHORT20))
			AND
			LEFT(EVENT_CD,1) IN ('a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z')
			AND
			YEAR(event_dt)= 2020
			AND
			EVENT_DT < CURRENT_DATE
	)
	GROUP BY yr,read_chapter,mnth
	)



SELECT
	alf_e,
	event_cd AS read_code,
	LEFT(EVENT_CD ,1) AS read_chapter
FROM
	sail0911v.wlgp_gp_event_cleansed
WHERE
	REGEXP_LIKE (event_cd, '^[a-z]{1}')
LIMIT 10;
