-------------------------------------------------------------
--Project number: CCU014
--Lead analyst: fatemeh.torabi@swansea.ac.uk
--Date: 11-11-2021
-----------------
--Specifications:
-----------------
--dispensed cohort: base WDDS 
--Start date: 1st April 2018
--End date:   31st May 2021

--age between 18 and 112 at the date of prescription/dispensed
-------------------------------------------------------------
--provided BNF code lists
SELECT DISTINCT key_group FROM  SAILWWMCCV.CCU014_CD_BNF_CD_ALL;

SELECT count(*) FROM  SAILWWMCCV.CCU014_CD_BNF_CD_ALL;
SELECT count(*) FROM SAILWWMCCV.CCU014_CD_BNF_CD_IN_BOTH; --402



-------------------------------------------------------------
--block 1: all cohort
-------------------------------------------------------------

CALL FNC.DROP_IF_EXISTS ('SAILWWMCCV.CCU014_COHORT_DISPENSED');

CREATE TABLE SAILWWMCCV.CCU014_COHORT_DISPENSED AS 
(
	SELECT 
	 DISTINCT 
 			ROW_NUMBER() OVER(PARTITION BY a.ALF_E,d.key_group ORDER BY a.dt_prescribed) DRUG_SEQ,
			a.alf_e, 
			round((days(a.dt_prescribed)-days(b.wob))/365.25) AS dispensed_age,
			b.wob,
			b.gndr_cd,b.dod, b.LSOA2011_INCEPTION , 
			b.wimd2019_quintile_inception,
			b.wimd2019_quintile_desc_inception,
			c.EHRD_EC_ONS  ETHNICITY_ONS,
			c.EC_ONS_DESC ETHNICITY_ONS_DESC,
			a.dt_prescribed, 
			a.dmdcode_prescribed, 
			a.product_prescribed, 
			a.bnf_combined AS bnf,
			a.bnf_combined_desc AS bnf_desc,
			d.key_group,
			a.prac_cd_e,
			a.qty_prescribed, 
			a.qty_prescribed_val, 
			a.qty_uom_code, 
			a.dispenser_id, 
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort20_20210603) THEN 1 ELSE 0 END AS c20,
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort16) THEN 1 ELSE 0 END AS c16
	FROM SAILWWMCCV.CCU014_RRDA_WDDS a
	LEFT JOIN 
	SAILWWMCCV.ccu014_c20_c16 b 
	ON 
	a.alf_e=b.alf_e
	LEFT JOIN 
	SAILWWMCCV.WMCC_COMB_ETHN_EHRD c 
	ON 
	a.ALF_E =c.ALF_E 
	LEFT JOIN 
	SAILWWMCCV.CCU014_CD_BNF_CD_ALL d
	ON 
	a.bnf_combined=d.bnf_code
	WHERE a.DT_PRESCRIBED BETWEEN '2018-03-01' AND '2021-05-31'
)WITH NO DATA; 

ALTER TABLE SAILWWMCCV.CCU014_COHORT_DISPENSED ACTIVATE NOT LOGGED INITIALLY;

--inserting for each month
INSERT INTO SAILWWMCCV.CCU014_COHORT_DISPENSED 
	SELECT 
	 DISTINCT 
 			'1' as  DRUG_SEQ,
			a.alf_e, 
			round((days(a.dt_prescribed)-days(b.wob))/365.25) AS dispensed_age,
			b.wob,
			b.gndr_cd,b.dod, b.LSOA2011_INCEPTION , 
			b.wimd2019_quintile_inception,
			b.wimd2019_quintile_desc_inception,
			c.EHRD_EC_ONS  ETHNICITY_ONS,
			c.EC_ONS_DESC ETHNICITY_ONS_DESC,
			a.dt_prescribed, 
			a.dmdcode_prescribed, 
			a.product_prescribed, 
			a.bnf_combined AS bnf,
			a.bnf_combined_desc AS bnf_desc,
			d.key_group,
			a.prac_cd_e,
			a.qty_prescribed, 
			a.qty_prescribed_val, 
			a.qty_uom_code, 
			a.dispenser_id, 
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort20_20210603) THEN 1 ELSE 0 END AS c20,
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort16) THEN 1 ELSE 0 END AS c16
	FROM SAILWWMCCV.CCU014_RRDA_WDDS a
	LEFT JOIN 
	SAILWWMCCV.ccu014_c20_c16 b 
	ON 
	a.alf_e=b.alf_e
	LEFT JOIN 
	SAILWWMCCV.WMCC_COMB_ETHN_EHRD c 
	ON 
	a.ALF_E =c.ALF_E 
	LEFT JOIN 
	SAILWWMCCV.CCU014_CD_BNF_CD_ALL d
	ON 
	a.bnf_combined=d.bnf_code
	WHERE a.DT_PRESCRIBED BETWEEN '2018-03-01' AND '2021-05-31'
	AND 
	YEAR(a.DT_PRESCRIBED)='2018' AND MONTH(a.DT_PRESCRIBED)=3; 
INSERT INTO SAILWWMCCV.CCU014_COHORT_DISPENSED 
	SELECT 
	 DISTINCT 
 			'1' as  DRUG_SEQ,
			a.alf_e, 
			round((days(a.dt_prescribed)-days(b.wob))/365.25) AS dispensed_age,
			b.wob,
			b.gndr_cd,b.dod, b.LSOA2011_INCEPTION , 
			b.wimd2019_quintile_inception,
			b.wimd2019_quintile_desc_inception,
			c.EHRD_EC_ONS  ETHNICITY_ONS,
			c.EC_ONS_DESC ETHNICITY_ONS_DESC,
			a.dt_prescribed, 
			a.dmdcode_prescribed, 
			a.product_prescribed, 
			a.bnf_combined AS bnf,
			a.bnf_combined_desc AS bnf_desc,
			d.key_group,
			a.prac_cd_e,
			a.qty_prescribed, 
			a.qty_prescribed_val, 
			a.qty_uom_code, 
			a.dispenser_id, 
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort20_20210603) THEN 1 ELSE 0 END AS c20,
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort16) THEN 1 ELSE 0 END AS c16
	FROM SAILWWMCCV.CCU014_RRDA_WDDS a
	LEFT JOIN 
	SAILWWMCCV.ccu014_c20_c16 b 
	ON 
	a.alf_e=b.alf_e
	LEFT JOIN 
	SAILWWMCCV.WMCC_COMB_ETHN_EHRD c 
	ON 
	a.ALF_E =c.ALF_E 
	LEFT JOIN 
	SAILWWMCCV.CCU014_CD_BNF_CD_ALL d
	ON 
	a.bnf_combined=d.bnf_code
	WHERE a.DT_PRESCRIBED BETWEEN '2018-03-01' AND '2021-05-31'
	AND 
	YEAR(a.DT_PRESCRIBED)='2018' AND MONTH(a.DT_PRESCRIBED)=4; 
INSERT INTO SAILWWMCCV.CCU014_COHORT_DISPENSED 
		SELECT 
	 DISTINCT 
 			'1' as  DRUG_SEQ,
			a.alf_e, 
			round((days(a.dt_prescribed)-days(b.wob))/365.25) AS dispensed_age,
			b.wob,
			b.gndr_cd,b.dod, b.LSOA2011_INCEPTION , 
			b.wimd2019_quintile_inception,
			b.wimd2019_quintile_desc_inception,
			c.EHRD_EC_ONS  ETHNICITY_ONS,
			c.EC_ONS_DESC ETHNICITY_ONS_DESC,
			a.dt_prescribed, 
			a.dmdcode_prescribed, 
			a.product_prescribed, 
			a.bnf_combined AS bnf,
			a.bnf_combined_desc AS bnf_desc,
			d.key_group,
			a.prac_cd_e,
			a.qty_prescribed, 
			a.qty_prescribed_val, 
			a.qty_uom_code, 
			a.dispenser_id, 
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort20_20210603) THEN 1 ELSE 0 END AS c20,
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort16) THEN 1 ELSE 0 END AS c16
	FROM SAILWWMCCV.CCU014_RRDA_WDDS a
	LEFT JOIN 
	SAILWWMCCV.ccu014_c20_c16 b 
	ON 
	a.alf_e=b.alf_e
	LEFT JOIN 
	SAILWWMCCV.WMCC_COMB_ETHN_EHRD c 
	ON 
	a.ALF_E =c.ALF_E 
	LEFT JOIN 
	SAILWWMCCV.CCU014_CD_BNF_CD_ALL d
	ON 
	a.bnf_combined=d.bnf_code
	WHERE a.DT_PRESCRIBED BETWEEN '2018-03-01' AND '2021-05-31'
	AND 
	YEAR(a.DT_PRESCRIBED)='2018' AND MONTH(a.DT_PRESCRIBED)=5; 
INSERT INTO SAILWWMCCV.CCU014_COHORT_DISPENSED 
		SELECT 
	 DISTINCT 
 			'1' as  DRUG_SEQ,
			a.alf_e, 
			round((days(a.dt_prescribed)-days(b.wob))/365.25) AS dispensed_age,
			b.wob,
			b.gndr_cd,b.dod, b.LSOA2011_INCEPTION , 
			b.wimd2019_quintile_inception,
			b.wimd2019_quintile_desc_inception,
			c.EHRD_EC_ONS  ETHNICITY_ONS,
			c.EC_ONS_DESC ETHNICITY_ONS_DESC,
			a.dt_prescribed, 
			a.dmdcode_prescribed, 
			a.product_prescribed, 
			a.bnf_combined AS bnf,
			a.bnf_combined_desc AS bnf_desc,
			d.key_group,
			a.prac_cd_e,
			a.qty_prescribed, 
			a.qty_prescribed_val, 
			a.qty_uom_code, 
			a.dispenser_id, 
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort20_20210603) THEN 1 ELSE 0 END AS c20,
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort16) THEN 1 ELSE 0 END AS c16
	FROM SAILWWMCCV.CCU014_RRDA_WDDS a
	LEFT JOIN 
	SAILWWMCCV.ccu014_c20_c16 b 
	ON 
	a.alf_e=b.alf_e
	LEFT JOIN 
	SAILWWMCCV.WMCC_COMB_ETHN_EHRD c 
	ON 
	a.ALF_E =c.ALF_E 
	LEFT JOIN 
	SAILWWMCCV.CCU014_CD_BNF_CD_ALL d
	ON 
	a.bnf_combined=d.bnf_code
	WHERE a.DT_PRESCRIBED BETWEEN '2018-03-01' AND '2021-05-31'
	AND 
	YEAR(a.DT_PRESCRIBED)='2018' AND MONTH(a.DT_PRESCRIBED)=6; 
INSERT INTO SAILWWMCCV.CCU014_COHORT_DISPENSED 
		SELECT 
	 DISTINCT 
 			'1' as  DRUG_SEQ,
			a.alf_e, 
			round((days(a.dt_prescribed)-days(b.wob))/365.25) AS dispensed_age,
			b.wob,
			b.gndr_cd,b.dod, b.LSOA2011_INCEPTION , 
			b.wimd2019_quintile_inception,
			b.wimd2019_quintile_desc_inception,
			c.EHRD_EC_ONS  ETHNICITY_ONS,
			c.EC_ONS_DESC ETHNICITY_ONS_DESC,
			a.dt_prescribed, 
			a.dmdcode_prescribed, 
			a.product_prescribed, 
			a.bnf_combined AS bnf,
			a.bnf_combined_desc AS bnf_desc,
			d.key_group,
			a.prac_cd_e,
			a.qty_prescribed, 
			a.qty_prescribed_val, 
			a.qty_uom_code, 
			a.dispenser_id, 
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort20_20210603) THEN 1 ELSE 0 END AS c20,
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort16) THEN 1 ELSE 0 END AS c16
	FROM SAILWWMCCV.CCU014_RRDA_WDDS a
	LEFT JOIN 
	SAILWWMCCV.ccu014_c20_c16 b 
	ON 
	a.alf_e=b.alf_e
	LEFT JOIN 
	SAILWWMCCV.WMCC_COMB_ETHN_EHRD c 
	ON 
	a.ALF_E =c.ALF_E 
	LEFT JOIN 
	SAILWWMCCV.CCU014_CD_BNF_CD_ALL d
	ON 
	a.bnf_combined=d.bnf_code
	WHERE a.DT_PRESCRIBED BETWEEN '2018-03-01' AND '2021-05-31'
	AND 
	YEAR(a.DT_PRESCRIBED)='2018' AND MONTH(a.DT_PRESCRIBED)=7; 
INSERT INTO SAILWWMCCV.CCU014_COHORT_DISPENSED 
		SELECT 
	 DISTINCT 
 			'1' as  DRUG_SEQ,
			a.alf_e, 
			round((days(a.dt_prescribed)-days(b.wob))/365.25) AS dispensed_age,
			b.wob,
			b.gndr_cd,b.dod, b.LSOA2011_INCEPTION , 
			b.wimd2019_quintile_inception,
			b.wimd2019_quintile_desc_inception,
			c.EHRD_EC_ONS  ETHNICITY_ONS,
			c.EC_ONS_DESC ETHNICITY_ONS_DESC,
			a.dt_prescribed, 
			a.dmdcode_prescribed, 
			a.product_prescribed, 
			a.bnf_combined AS bnf,
			a.bnf_combined_desc AS bnf_desc,
			d.key_group,
			a.prac_cd_e,
			a.qty_prescribed, 
			a.qty_prescribed_val, 
			a.qty_uom_code, 
			a.dispenser_id, 
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort20_20210603) THEN 1 ELSE 0 END AS c20,
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort16) THEN 1 ELSE 0 END AS c16
	FROM SAILWWMCCV.CCU014_RRDA_WDDS a
	LEFT JOIN 
	SAILWWMCCV.ccu014_c20_c16 b 
	ON 
	a.alf_e=b.alf_e
	LEFT JOIN 
	SAILWWMCCV.WMCC_COMB_ETHN_EHRD c 
	ON 
	a.ALF_E =c.ALF_E 
	LEFT JOIN 
	SAILWWMCCV.CCU014_CD_BNF_CD_ALL d
	ON 
	a.bnf_combined=d.bnf_code
	WHERE a.DT_PRESCRIBED BETWEEN '2018-03-01' AND '2021-05-31'
	AND 
	YEAR(a.DT_PRESCRIBED)='2018' AND MONTH(a.DT_PRESCRIBED)=8; 
INSERT INTO SAILWWMCCV.CCU014_COHORT_DISPENSED 
		SELECT 
	 DISTINCT 
 			'1' as  DRUG_SEQ,
			a.alf_e, 
			round((days(a.dt_prescribed)-days(b.wob))/365.25) AS dispensed_age,
			b.wob,
			b.gndr_cd,b.dod, b.LSOA2011_INCEPTION , 
			b.wimd2019_quintile_inception,
			b.wimd2019_quintile_desc_inception,
			c.EHRD_EC_ONS  ETHNICITY_ONS,
			c.EC_ONS_DESC ETHNICITY_ONS_DESC,
			a.dt_prescribed, 
			a.dmdcode_prescribed, 
			a.product_prescribed, 
			a.bnf_combined AS bnf,
			a.bnf_combined_desc AS bnf_desc,
			d.key_group,
			a.prac_cd_e,
			a.qty_prescribed, 
			a.qty_prescribed_val, 
			a.qty_uom_code, 
			a.dispenser_id, 
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort20_20210603) THEN 1 ELSE 0 END AS c20,
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort16) THEN 1 ELSE 0 END AS c16
	FROM SAILWWMCCV.CCU014_RRDA_WDDS a
	LEFT JOIN 
	SAILWWMCCV.ccu014_c20_c16 b 
	ON 
	a.alf_e=b.alf_e
	LEFT JOIN 
	SAILWWMCCV.WMCC_COMB_ETHN_EHRD c 
	ON 
	a.ALF_E =c.ALF_E 
	LEFT JOIN 
	SAILWWMCCV.CCU014_CD_BNF_CD_ALL d
	ON 
	a.bnf_combined=d.bnf_code
	WHERE a.DT_PRESCRIBED BETWEEN '2018-03-01' AND '2021-05-31'
	AND 
	YEAR(a.DT_PRESCRIBED)='2018' AND MONTH(a.DT_PRESCRIBED)=9; 
INSERT INTO SAILWWMCCV.CCU014_COHORT_DISPENSED 
		SELECT 
	 DISTINCT 
 			'1' as  DRUG_SEQ,
			a.alf_e, 
			round((days(a.dt_prescribed)-days(b.wob))/365.25) AS dispensed_age,
			b.wob,
			b.gndr_cd,b.dod, b.LSOA2011_INCEPTION , 
			b.wimd2019_quintile_inception,
			b.wimd2019_quintile_desc_inception,
			c.EHRD_EC_ONS  ETHNICITY_ONS,
			c.EC_ONS_DESC ETHNICITY_ONS_DESC,
			a.dt_prescribed, 
			a.dmdcode_prescribed, 
			a.product_prescribed, 
			a.bnf_combined AS bnf,
			a.bnf_combined_desc AS bnf_desc,
			d.key_group,
			a.prac_cd_e,
			a.qty_prescribed, 
			a.qty_prescribed_val, 
			a.qty_uom_code, 
			a.dispenser_id, 
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort20_20210603) THEN 1 ELSE 0 END AS c20,
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort16) THEN 1 ELSE 0 END AS c16
	FROM SAILWWMCCV.CCU014_RRDA_WDDS a
	LEFT JOIN 
	SAILWWMCCV.ccu014_c20_c16 b 
	ON 
	a.alf_e=b.alf_e
	LEFT JOIN 
	SAILWWMCCV.WMCC_COMB_ETHN_EHRD c 
	ON 
	a.ALF_E =c.ALF_E 
	LEFT JOIN 
	SAILWWMCCV.CCU014_CD_BNF_CD_ALL d
	ON 
	a.bnf_combined=d.bnf_code
	WHERE a.DT_PRESCRIBED BETWEEN '2018-03-01' AND '2021-05-31'
	AND 
	YEAR(a.DT_PRESCRIBED)='2018' AND MONTH(a.DT_PRESCRIBED)=10; 
INSERT INTO SAILWWMCCV.CCU014_COHORT_DISPENSED 
		SELECT 
	 DISTINCT 
 			'1' as  DRUG_SEQ,
			a.alf_e, 
			round((days(a.dt_prescribed)-days(b.wob))/365.25) AS dispensed_age,
			b.wob,
			b.gndr_cd,b.dod, b.LSOA2011_INCEPTION , 
			b.wimd2019_quintile_inception,
			b.wimd2019_quintile_desc_inception,
			c.EHRD_EC_ONS  ETHNICITY_ONS,
			c.EC_ONS_DESC ETHNICITY_ONS_DESC,
			a.dt_prescribed, 
			a.dmdcode_prescribed, 
			a.product_prescribed, 
			a.bnf_combined AS bnf,
			a.bnf_combined_desc AS bnf_desc,
			d.key_group,
			a.prac_cd_e,
			a.qty_prescribed, 
			a.qty_prescribed_val, 
			a.qty_uom_code, 
			a.dispenser_id, 
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort20_20210603) THEN 1 ELSE 0 END AS c20,
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort16) THEN 1 ELSE 0 END AS c16
	FROM SAILWWMCCV.CCU014_RRDA_WDDS a
	LEFT JOIN 
	SAILWWMCCV.ccu014_c20_c16 b 
	ON 
	a.alf_e=b.alf_e
	LEFT JOIN 
	SAILWWMCCV.WMCC_COMB_ETHN_EHRD c 
	ON 
	a.ALF_E =c.ALF_E 
	LEFT JOIN 
	SAILWWMCCV.CCU014_CD_BNF_CD_ALL d
	ON 
	a.bnf_combined=d.bnf_code
	WHERE a.DT_PRESCRIBED BETWEEN '2018-03-01' AND '2021-05-31'
	AND 
	YEAR(a.DT_PRESCRIBED)='2018' AND MONTH(a.DT_PRESCRIBED)=11; 
INSERT INTO SAILWWMCCV.CCU014_COHORT_DISPENSED 
		SELECT 
	 DISTINCT 
 			'1' as  DRUG_SEQ,
			a.alf_e, 
			round((days(a.dt_prescribed)-days(b.wob))/365.25) AS dispensed_age,
			b.wob,
			b.gndr_cd,b.dod, b.LSOA2011_INCEPTION , 
			b.wimd2019_quintile_inception,
			b.wimd2019_quintile_desc_inception,
			c.EHRD_EC_ONS  ETHNICITY_ONS,
			c.EC_ONS_DESC ETHNICITY_ONS_DESC,
			a.dt_prescribed, 
			a.dmdcode_prescribed, 
			a.product_prescribed, 
			a.bnf_combined AS bnf,
			a.bnf_combined_desc AS bnf_desc,
			d.key_group,
			a.prac_cd_e,
			a.qty_prescribed, 
			a.qty_prescribed_val, 
			a.qty_uom_code, 
			a.dispenser_id, 
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort20_20210603) THEN 1 ELSE 0 END AS c20,
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort16) THEN 1 ELSE 0 END AS c16
	FROM SAILWWMCCV.CCU014_RRDA_WDDS a
	LEFT JOIN 
	SAILWWMCCV.ccu014_c20_c16 b 
	ON 
	a.alf_e=b.alf_e
	LEFT JOIN 
	SAILWWMCCV.WMCC_COMB_ETHN_EHRD c 
	ON 
	a.ALF_E =c.ALF_E 
	LEFT JOIN 
	SAILWWMCCV.CCU014_CD_BNF_CD_ALL d
	ON 
	a.bnf_combined=d.bnf_code
	WHERE a.DT_PRESCRIBED BETWEEN '2018-03-01' AND '2021-05-31'
	AND 
	YEAR(a.DT_PRESCRIBED)='2018' AND MONTH(a.DT_PRESCRIBED)=12;
---2019
INSERT INTO SAILWWMCCV.CCU014_COHORT_DISPENSED 
		SELECT 
	 DISTINCT 
 			'1' as  DRUG_SEQ,
			a.alf_e, 
			round((days(a.dt_prescribed)-days(b.wob))/365.25) AS dispensed_age,
			b.wob,
			b.gndr_cd,b.dod, b.LSOA2011_INCEPTION , 
			b.wimd2019_quintile_inception,
			b.wimd2019_quintile_desc_inception,
			c.EHRD_EC_ONS  ETHNICITY_ONS,
			c.EC_ONS_DESC ETHNICITY_ONS_DESC,
			a.dt_prescribed, 
			a.dmdcode_prescribed, 
			a.product_prescribed, 
			a.bnf_combined AS bnf,
			a.bnf_combined_desc AS bnf_desc,
			d.key_group,
			a.prac_cd_e,
			a.qty_prescribed, 
			a.qty_prescribed_val, 
			a.qty_uom_code, 
			a.dispenser_id, 
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort20_20210603) THEN 1 ELSE 0 END AS c20,
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort16) THEN 1 ELSE 0 END AS c16
	FROM SAILWWMCCV.CCU014_RRDA_WDDS a
	LEFT JOIN 
	SAILWWMCCV.ccu014_c20_c16 b 
	ON 
	a.alf_e=b.alf_e
	LEFT JOIN 
	SAILWWMCCV.WMCC_COMB_ETHN_EHRD c 
	ON 
	a.ALF_E =c.ALF_E 
	LEFT JOIN 
	SAILWWMCCV.CCU014_CD_BNF_CD_ALL d
	ON 
	a.bnf_combined=d.bnf_code
	WHERE a.DT_PRESCRIBED BETWEEN '2018-03-01' AND '2021-05-31'
	AND 
	YEAR(a.DT_PRESCRIBED)='2019' AND MONTH(a.DT_PRESCRIBED)=1; 

INSERT INTO SAILWWMCCV.CCU014_COHORT_DISPENSED 
		SELECT 
	 DISTINCT 
 			'1' as  DRUG_SEQ,
			a.alf_e, 
			round((days(a.dt_prescribed)-days(b.wob))/365.25) AS dispensed_age,
			b.wob,
			b.gndr_cd,b.dod, b.LSOA2011_INCEPTION , 
			b.wimd2019_quintile_inception,
			b.wimd2019_quintile_desc_inception,
			c.EHRD_EC_ONS  ETHNICITY_ONS,
			c.EC_ONS_DESC ETHNICITY_ONS_DESC,
			a.dt_prescribed, 
			a.dmdcode_prescribed, 
			a.product_prescribed, 
			a.bnf_combined AS bnf,
			a.bnf_combined_desc AS bnf_desc,
			d.key_group,
			a.prac_cd_e,
			a.qty_prescribed, 
			a.qty_prescribed_val, 
			a.qty_uom_code, 
			a.dispenser_id, 
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort20_20210603) THEN 1 ELSE 0 END AS c20,
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort16) THEN 1 ELSE 0 END AS c16
	FROM SAILWWMCCV.CCU014_RRDA_WDDS a
	LEFT JOIN 
	SAILWWMCCV.ccu014_c20_c16 b 
	ON 
	a.alf_e=b.alf_e
	LEFT JOIN 
	SAILWWMCCV.WMCC_COMB_ETHN_EHRD c 
	ON 
	a.ALF_E =c.ALF_E 
	LEFT JOIN 
	SAILWWMCCV.CCU014_CD_BNF_CD_ALL d
	ON 
	a.bnf_combined=d.bnf_code
	WHERE a.DT_PRESCRIBED BETWEEN '2018-03-01' AND '2021-05-31'
	AND 
	YEAR(a.DT_PRESCRIBED)='2019' AND MONTH(a.DT_PRESCRIBED)=2; 

INSERT INTO SAILWWMCCV.CCU014_COHORT_DISPENSED 
		SELECT 
	 DISTINCT 
 			'1' as  DRUG_SEQ,
			a.alf_e, 
			round((days(a.dt_prescribed)-days(b.wob))/365.25) AS dispensed_age,
			b.wob,
			b.gndr_cd,b.dod, b.LSOA2011_INCEPTION , 
			b.wimd2019_quintile_inception,
			b.wimd2019_quintile_desc_inception,
			c.EHRD_EC_ONS  ETHNICITY_ONS,
			c.EC_ONS_DESC ETHNICITY_ONS_DESC,
			a.dt_prescribed, 
			a.dmdcode_prescribed, 
			a.product_prescribed, 
			a.bnf_combined AS bnf,
			a.bnf_combined_desc AS bnf_desc,
			d.key_group,
			a.prac_cd_e,
			a.qty_prescribed, 
			a.qty_prescribed_val, 
			a.qty_uom_code, 
			a.dispenser_id, 
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort20_20210603) THEN 1 ELSE 0 END AS c20,
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort16) THEN 1 ELSE 0 END AS c16
	FROM SAILWWMCCV.CCU014_RRDA_WDDS a
	LEFT JOIN 
	SAILWWMCCV.ccu014_c20_c16 b 
	ON 
	a.alf_e=b.alf_e
	LEFT JOIN 
	SAILWWMCCV.WMCC_COMB_ETHN_EHRD c 
	ON 
	a.ALF_E =c.ALF_E 
	LEFT JOIN 
	SAILWWMCCV.CCU014_CD_BNF_CD_ALL d
	ON 
	a.bnf_combined=d.bnf_code
	WHERE a.DT_PRESCRIBED BETWEEN '2018-03-01' AND '2021-05-31'
	AND 
	YEAR(a.DT_PRESCRIBED)='2019' AND MONTH(a.DT_PRESCRIBED)=3; 

INSERT INTO SAILWWMCCV.CCU014_COHORT_DISPENSED 
		SELECT 
	 DISTINCT 
 			'1' as  DRUG_SEQ,
			a.alf_e, 
			round((days(a.dt_prescribed)-days(b.wob))/365.25) AS dispensed_age,
			b.wob,
			b.gndr_cd,b.dod, b.LSOA2011_INCEPTION , 
			b.wimd2019_quintile_inception,
			b.wimd2019_quintile_desc_inception,
			c.EHRD_EC_ONS  ETHNICITY_ONS,
			c.EC_ONS_DESC ETHNICITY_ONS_DESC,
			a.dt_prescribed, 
			a.dmdcode_prescribed, 
			a.product_prescribed, 
			a.bnf_combined AS bnf,
			a.bnf_combined_desc AS bnf_desc,
			d.key_group,
			a.prac_cd_e,
			a.qty_prescribed, 
			a.qty_prescribed_val, 
			a.qty_uom_code, 
			a.dispenser_id, 
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort20_20210603) THEN 1 ELSE 0 END AS c20,
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort16) THEN 1 ELSE 0 END AS c16
	FROM SAILWWMCCV.CCU014_RRDA_WDDS a
	LEFT JOIN 
	SAILWWMCCV.ccu014_c20_c16 b 
	ON 
	a.alf_e=b.alf_e
	LEFT JOIN 
	SAILWWMCCV.WMCC_COMB_ETHN_EHRD c 
	ON 
	a.ALF_E =c.ALF_E 
	LEFT JOIN 
	SAILWWMCCV.CCU014_CD_BNF_CD_ALL d
	ON 
	a.bnf_combined=d.bnf_code
	WHERE a.DT_PRESCRIBED BETWEEN '2018-03-01' AND '2021-05-31'
	AND 
	YEAR(a.DT_PRESCRIBED)='2019' AND MONTH(a.DT_PRESCRIBED)=4; 
INSERT INTO SAILWWMCCV.CCU014_COHORT_DISPENSED 
		SELECT 
	 DISTINCT 
 			'1' as  DRUG_SEQ,
			a.alf_e, 
			round((days(a.dt_prescribed)-days(b.wob))/365.25) AS dispensed_age,
			b.wob,
			b.gndr_cd,b.dod, b.LSOA2011_INCEPTION , 
			b.wimd2019_quintile_inception,
			b.wimd2019_quintile_desc_inception,
			c.EHRD_EC_ONS  ETHNICITY_ONS,
			c.EC_ONS_DESC ETHNICITY_ONS_DESC,
			a.dt_prescribed, 
			a.dmdcode_prescribed, 
			a.product_prescribed, 
			a.bnf_combined AS bnf,
			a.bnf_combined_desc AS bnf_desc,
			d.key_group,
			a.prac_cd_e,
			a.qty_prescribed, 
			a.qty_prescribed_val, 
			a.qty_uom_code, 
			a.dispenser_id, 
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort20_20210603) THEN 1 ELSE 0 END AS c20,
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort16) THEN 1 ELSE 0 END AS c16
	FROM SAILWWMCCV.CCU014_RRDA_WDDS a
	LEFT JOIN 
	SAILWWMCCV.ccu014_c20_c16 b 
	ON 
	a.alf_e=b.alf_e
	LEFT JOIN 
	SAILWWMCCV.WMCC_COMB_ETHN_EHRD c 
	ON 
	a.ALF_E =c.ALF_E 
	LEFT JOIN 
	SAILWWMCCV.CCU014_CD_BNF_CD_ALL d
	ON 
	a.bnf_combined=d.bnf_code
	WHERE a.DT_PRESCRIBED BETWEEN '2018-03-01' AND '2021-05-31'
	AND 
	YEAR(a.DT_PRESCRIBED)='2019' AND MONTH(a.DT_PRESCRIBED)=5; 
INSERT INTO SAILWWMCCV.CCU014_COHORT_DISPENSED 
		SELECT 
	 DISTINCT 
 			'1' as  DRUG_SEQ,
			a.alf_e, 
			round((days(a.dt_prescribed)-days(b.wob))/365.25) AS dispensed_age,
			b.wob,
			b.gndr_cd,b.dod, b.LSOA2011_INCEPTION , 
			b.wimd2019_quintile_inception,
			b.wimd2019_quintile_desc_inception,
			c.EHRD_EC_ONS  ETHNICITY_ONS,
			c.EC_ONS_DESC ETHNICITY_ONS_DESC,
			a.dt_prescribed, 
			a.dmdcode_prescribed, 
			a.product_prescribed, 
			a.bnf_combined AS bnf,
			a.bnf_combined_desc AS bnf_desc,
			d.key_group,
			a.prac_cd_e,
			a.qty_prescribed, 
			a.qty_prescribed_val, 
			a.qty_uom_code, 
			a.dispenser_id, 
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort20_20210603) THEN 1 ELSE 0 END AS c20,
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort16) THEN 1 ELSE 0 END AS c16
	FROM SAILWWMCCV.CCU014_RRDA_WDDS a
	LEFT JOIN 
	SAILWWMCCV.ccu014_c20_c16 b 
	ON 
	a.alf_e=b.alf_e
	LEFT JOIN 
	SAILWWMCCV.WMCC_COMB_ETHN_EHRD c 
	ON 
	a.ALF_E =c.ALF_E 
	LEFT JOIN 
	SAILWWMCCV.CCU014_CD_BNF_CD_ALL d
	ON 
	a.bnf_combined=d.bnf_code
	WHERE a.DT_PRESCRIBED BETWEEN '2018-03-01' AND '2021-05-31'
	AND 
	YEAR(a.DT_PRESCRIBED)='2019' AND MONTH(a.DT_PRESCRIBED)=6; 
INSERT INTO SAILWWMCCV.CCU014_COHORT_DISPENSED 
		SELECT 
	 DISTINCT 
 			'1' as  DRUG_SEQ,
			a.alf_e, 
			round((days(a.dt_prescribed)-days(b.wob))/365.25) AS dispensed_age,
			b.wob,
			b.gndr_cd,b.dod, b.LSOA2011_INCEPTION , 
			b.wimd2019_quintile_inception,
			b.wimd2019_quintile_desc_inception,
			c.EHRD_EC_ONS  ETHNICITY_ONS,
			c.EC_ONS_DESC ETHNICITY_ONS_DESC,
			a.dt_prescribed, 
			a.dmdcode_prescribed, 
			a.product_prescribed, 
			a.bnf_combined AS bnf,
			a.bnf_combined_desc AS bnf_desc,
			d.key_group,
			a.prac_cd_e,
			a.qty_prescribed, 
			a.qty_prescribed_val, 
			a.qty_uom_code, 
			a.dispenser_id, 
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort20_20210603) THEN 1 ELSE 0 END AS c20,
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort16) THEN 1 ELSE 0 END AS c16
	FROM SAILWWMCCV.CCU014_RRDA_WDDS a
	LEFT JOIN 
	SAILWWMCCV.ccu014_c20_c16 b 
	ON 
	a.alf_e=b.alf_e
	LEFT JOIN 
	SAILWWMCCV.WMCC_COMB_ETHN_EHRD c 
	ON 
	a.ALF_E =c.ALF_E 
	LEFT JOIN 
	SAILWWMCCV.CCU014_CD_BNF_CD_ALL d
	ON 
	a.bnf_combined=d.bnf_code
	WHERE a.DT_PRESCRIBED BETWEEN '2018-03-01' AND '2021-05-31'
	AND 
	YEAR(a.DT_PRESCRIBED)='2019' AND MONTH(a.DT_PRESCRIBED)=7; 
INSERT INTO SAILWWMCCV.CCU014_COHORT_DISPENSED 
	SELECT 
	 DISTINCT 
 			'1' as  DRUG_SEQ,
			a.alf_e, 
			round((days(a.dt_prescribed)-days(b.wob))/365.25) AS dispensed_age,
			b.wob,
			b.gndr_cd,b.dod, b.LSOA2011_INCEPTION , 
			b.wimd2019_quintile_inception,
			b.wimd2019_quintile_desc_inception,
			c.EHRD_EC_ONS  ETHNICITY_ONS,
			c.EC_ONS_DESC ETHNICITY_ONS_DESC,
			a.dt_prescribed, 
			a.dmdcode_prescribed, 
			a.product_prescribed, 
			a.bnf_combined AS bnf,
			a.bnf_combined_desc AS bnf_desc,
			d.key_group,
			a.prac_cd_e,
			a.qty_prescribed, 
			a.qty_prescribed_val, 
			a.qty_uom_code, 
			a.dispenser_id, 
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort20_20210603) THEN 1 ELSE 0 END AS c20,
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort16) THEN 1 ELSE 0 END AS c16
	FROM SAILWWMCCV.CCU014_RRDA_WDDS a
	LEFT JOIN 
	SAILWWMCCV.ccu014_c20_c16 b 
	ON 
	a.alf_e=b.alf_e
	LEFT JOIN 
	SAILWWMCCV.WMCC_COMB_ETHN_EHRD c 
	ON 
	a.ALF_E =c.ALF_E 
	LEFT JOIN 
	SAILWWMCCV.CCU014_CD_BNF_CD_ALL d
	ON 
	a.bnf_combined=d.bnf_code
	WHERE a.DT_PRESCRIBED BETWEEN '2018-03-01' AND '2021-05-31'
	AND 
	YEAR(a.DT_PRESCRIBED)='2019' AND MONTH(a.DT_PRESCRIBED)=8; 
INSERT INTO SAILWWMCCV.CCU014_COHORT_DISPENSED 
		SELECT 
	 DISTINCT 
 			'1' as  DRUG_SEQ,
			a.alf_e, 
			round((days(a.dt_prescribed)-days(b.wob))/365.25) AS dispensed_age,
			b.wob,
			b.gndr_cd,b.dod, b.LSOA2011_INCEPTION , 
			b.wimd2019_quintile_inception,
			b.wimd2019_quintile_desc_inception,
			c.EHRD_EC_ONS  ETHNICITY_ONS,
			c.EC_ONS_DESC ETHNICITY_ONS_DESC,
			a.dt_prescribed, 
			a.dmdcode_prescribed, 
			a.product_prescribed, 
			a.bnf_combined AS bnf,
			a.bnf_combined_desc AS bnf_desc,
			d.key_group,
			a.prac_cd_e,
			a.qty_prescribed, 
			a.qty_prescribed_val, 
			a.qty_uom_code, 
			a.dispenser_id, 
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort20_20210603) THEN 1 ELSE 0 END AS c20,
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort16) THEN 1 ELSE 0 END AS c16
	FROM SAILWWMCCV.CCU014_RRDA_WDDS a
	LEFT JOIN 
	SAILWWMCCV.ccu014_c20_c16 b 
	ON 
	a.alf_e=b.alf_e
	LEFT JOIN 
	SAILWWMCCV.WMCC_COMB_ETHN_EHRD c 
	ON 
	a.ALF_E =c.ALF_E 
	LEFT JOIN 
	SAILWWMCCV.CCU014_CD_BNF_CD_ALL d
	ON 
	a.bnf_combined=d.bnf_code
	WHERE a.DT_PRESCRIBED BETWEEN '2018-03-01' AND '2021-05-31'
	AND 
	YEAR(a.DT_PRESCRIBED)='2019' AND MONTH(a.DT_PRESCRIBED)=9; 
INSERT INTO SAILWWMCCV.CCU014_COHORT_DISPENSED 
	SELECT 
	 DISTINCT 
 			'1' as  DRUG_SEQ,
			a.alf_e, 
			round((days(a.dt_prescribed)-days(b.wob))/365.25) AS dispensed_age,
			b.wob,
			b.gndr_cd,b.dod, b.LSOA2011_INCEPTION , 
			b.wimd2019_quintile_inception,
			b.wimd2019_quintile_desc_inception,
			c.EHRD_EC_ONS  ETHNICITY_ONS,
			c.EC_ONS_DESC ETHNICITY_ONS_DESC,
			a.dt_prescribed, 
			a.dmdcode_prescribed, 
			a.product_prescribed, 
			a.bnf_combined AS bnf,
			a.bnf_combined_desc AS bnf_desc,
			d.key_group,
			a.prac_cd_e,
			a.qty_prescribed, 
			a.qty_prescribed_val, 
			a.qty_uom_code, 
			a.dispenser_id, 
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort20_20210603) THEN 1 ELSE 0 END AS c20,
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort16) THEN 1 ELSE 0 END AS c16
	FROM SAILWWMCCV.CCU014_RRDA_WDDS a
	LEFT JOIN 
	SAILWWMCCV.ccu014_c20_c16 b 
	ON 
	a.alf_e=b.alf_e
	LEFT JOIN 
	SAILWWMCCV.WMCC_COMB_ETHN_EHRD c 
	ON 
	a.ALF_E =c.ALF_E 
	LEFT JOIN 
	SAILWWMCCV.CCU014_CD_BNF_CD_ALL d
	ON 
	a.bnf_combined=d.bnf_code
	WHERE a.DT_PRESCRIBED BETWEEN '2018-03-01' AND '2021-05-31'
	AND 
	YEAR(a.DT_PRESCRIBED)='2019' AND MONTH(a.DT_PRESCRIBED)=10; 
INSERT INTO SAILWWMCCV.CCU014_COHORT_DISPENSED 
	SELECT 
	 DISTINCT 
 			'1' as  DRUG_SEQ,
			a.alf_e, 
			round((days(a.dt_prescribed)-days(b.wob))/365.25) AS dispensed_age,
			b.wob,
			b.gndr_cd,b.dod, b.LSOA2011_INCEPTION , 
			b.wimd2019_quintile_inception,
			b.wimd2019_quintile_desc_inception,
			c.EHRD_EC_ONS  ETHNICITY_ONS,
			c.EC_ONS_DESC ETHNICITY_ONS_DESC,
			a.dt_prescribed, 
			a.dmdcode_prescribed, 
			a.product_prescribed, 
			a.bnf_combined AS bnf,
			a.bnf_combined_desc AS bnf_desc,
			d.key_group,
			a.prac_cd_e,
			a.qty_prescribed, 
			a.qty_prescribed_val, 
			a.qty_uom_code, 
			a.dispenser_id, 
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort20_20210603) THEN 1 ELSE 0 END AS c20,
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort16) THEN 1 ELSE 0 END AS c16
	FROM SAILWWMCCV.CCU014_RRDA_WDDS a
	LEFT JOIN 
	SAILWWMCCV.ccu014_c20_c16 b 
	ON 
	a.alf_e=b.alf_e
	LEFT JOIN 
	SAILWWMCCV.WMCC_COMB_ETHN_EHRD c 
	ON 
	a.ALF_E =c.ALF_E 
	LEFT JOIN 
	SAILWWMCCV.CCU014_CD_BNF_CD_ALL d
	ON 
	a.bnf_combined=d.bnf_code
	WHERE a.DT_PRESCRIBED BETWEEN '2018-03-01' AND '2021-05-31'
	AND 
	YEAR(a.DT_PRESCRIBED)='2019' AND MONTH(a.DT_PRESCRIBED)=11; 
INSERT INTO SAILWWMCCV.CCU014_COHORT_DISPENSED 
	SELECT 
	 DISTINCT 
 			'1' as  DRUG_SEQ,
			a.alf_e, 
			round((days(a.dt_prescribed)-days(b.wob))/365.25) AS dispensed_age,
			b.wob,
			b.gndr_cd,b.dod, b.LSOA2011_INCEPTION , 
			b.wimd2019_quintile_inception,
			b.wimd2019_quintile_desc_inception,
			c.EHRD_EC_ONS  ETHNICITY_ONS,
			c.EC_ONS_DESC ETHNICITY_ONS_DESC,
			a.dt_prescribed, 
			a.dmdcode_prescribed, 
			a.product_prescribed, 
			a.bnf_combined AS bnf,
			a.bnf_combined_desc AS bnf_desc,
			d.key_group,
			a.prac_cd_e,
			a.qty_prescribed, 
			a.qty_prescribed_val, 
			a.qty_uom_code, 
			a.dispenser_id, 
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort20_20210603) THEN 1 ELSE 0 END AS c20,
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort16) THEN 1 ELSE 0 END AS c16
	FROM SAILWWMCCV.CCU014_RRDA_WDDS a
	LEFT JOIN 
	SAILWWMCCV.ccu014_c20_c16 b 
	ON 
	a.alf_e=b.alf_e
	LEFT JOIN 
	SAILWWMCCV.WMCC_COMB_ETHN_EHRD c 
	ON 
	a.ALF_E =c.ALF_E 
	LEFT JOIN 
	SAILWWMCCV.CCU014_CD_BNF_CD_ALL d
	ON 
	a.bnf_combined=d.bnf_code
	WHERE a.DT_PRESCRIBED BETWEEN '2018-03-01' AND '2021-05-31'
	AND 
	YEAR(a.DT_PRESCRIBED)='2019' AND MONTH(a.DT_PRESCRIBED)=12; 
----------------------------
--2020

INSERT INTO SAILWWMCCV.CCU014_COHORT_DISPENSED 
	SELECT 
	 DISTINCT 
 			'1' as  DRUG_SEQ,
			a.alf_e, 
			round((days(a.dt_prescribed)-days(b.wob))/365.25) AS dispensed_age,
			b.wob,
			b.gndr_cd,b.dod, b.LSOA2011_INCEPTION , 
			b.wimd2019_quintile_inception,
			b.wimd2019_quintile_desc_inception,
			c.EHRD_EC_ONS  ETHNICITY_ONS,
			c.EC_ONS_DESC ETHNICITY_ONS_DESC,
			a.dt_prescribed, 
			a.dmdcode_prescribed, 
			a.product_prescribed, 
			a.bnf_combined AS bnf,
			a.bnf_combined_desc AS bnf_desc,
			d.key_group,
			a.prac_cd_e,
			a.qty_prescribed, 
			a.qty_prescribed_val, 
			a.qty_uom_code, 
			a.dispenser_id, 
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort20_20210603) THEN 1 ELSE 0 END AS c20,
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort16) THEN 1 ELSE 0 END AS c16
	FROM SAILWWMCCV.CCU014_RRDA_WDDS a
	LEFT JOIN 
	SAILWWMCCV.ccu014_c20_c16 b 
	ON 
	a.alf_e=b.alf_e
	LEFT JOIN 
	SAILWWMCCV.WMCC_COMB_ETHN_EHRD c 
	ON 
	a.ALF_E =c.ALF_E 
	LEFT JOIN 
	SAILWWMCCV.CCU014_CD_BNF_CD_ALL d
	ON 
	a.bnf_combined=d.bnf_code
	WHERE a.DT_PRESCRIBED BETWEEN '2018-03-01' AND '2021-05-31'
	AND 
	YEAR(a.DT_PRESCRIBED)='2020' AND MONTH(a.DT_PRESCRIBED)=1; 

INSERT INTO SAILWWMCCV.CCU014_COHORT_DISPENSED 
	SELECT 
	 DISTINCT 
 			'1' as  DRUG_SEQ,
			a.alf_e, 
			round((days(a.dt_prescribed)-days(b.wob))/365.25) AS dispensed_age,
			b.wob,
			b.gndr_cd,b.dod, b.LSOA2011_INCEPTION , 
			b.wimd2019_quintile_inception,
			b.wimd2019_quintile_desc_inception,
			c.EHRD_EC_ONS  ETHNICITY_ONS,
			c.EC_ONS_DESC ETHNICITY_ONS_DESC,
			a.dt_prescribed, 
			a.dmdcode_prescribed, 
			a.product_prescribed, 
			a.bnf_combined AS bnf,
			a.bnf_combined_desc AS bnf_desc,
			d.key_group,
			a.prac_cd_e,
			a.qty_prescribed, 
			a.qty_prescribed_val, 
			a.qty_uom_code, 
			a.dispenser_id, 
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort20_20210603) THEN 1 ELSE 0 END AS c20,
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort16) THEN 1 ELSE 0 END AS c16
	FROM SAILWWMCCV.CCU014_RRDA_WDDS a
	LEFT JOIN 
	SAILWWMCCV.ccu014_c20_c16 b 
	ON 
	a.alf_e=b.alf_e
	LEFT JOIN 
	SAILWWMCCV.WMCC_COMB_ETHN_EHRD c 
	ON 
	a.ALF_E =c.ALF_E 
	LEFT JOIN 
	SAILWWMCCV.CCU014_CD_BNF_CD_ALL d
	ON 
	a.bnf_combined=d.bnf_code
	WHERE a.DT_PRESCRIBED BETWEEN '2018-03-01' AND '2021-05-31'
	AND 
	YEAR(a.DT_PRESCRIBED)='2020' AND MONTH(a.DT_PRESCRIBED)=2; 

INSERT INTO SAILWWMCCV.CCU014_COHORT_DISPENSED 
	SELECT 
	 DISTINCT 
 			'1' as  DRUG_SEQ,
			a.alf_e, 
			round((days(a.dt_prescribed)-days(b.wob))/365.25) AS dispensed_age,
			b.wob,
			b.gndr_cd,b.dod, b.LSOA2011_INCEPTION , 
			b.wimd2019_quintile_inception,
			b.wimd2019_quintile_desc_inception,
			c.EHRD_EC_ONS  ETHNICITY_ONS,
			c.EC_ONS_DESC ETHNICITY_ONS_DESC,
			a.dt_prescribed, 
			a.dmdcode_prescribed, 
			a.product_prescribed, 
			a.bnf_combined AS bnf,
			a.bnf_combined_desc AS bnf_desc,
			d.key_group,
			a.prac_cd_e,
			a.qty_prescribed, 
			a.qty_prescribed_val, 
			a.qty_uom_code, 
			a.dispenser_id, 
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort20_20210603) THEN 1 ELSE 0 END AS c20,
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort16) THEN 1 ELSE 0 END AS c16
	FROM SAILWWMCCV.CCU014_RRDA_WDDS a
	LEFT JOIN 
	SAILWWMCCV.ccu014_c20_c16 b 
	ON 
	a.alf_e=b.alf_e
	LEFT JOIN 
	SAILWWMCCV.WMCC_COMB_ETHN_EHRD c 
	ON 
	a.ALF_E =c.ALF_E 
	LEFT JOIN 
	SAILWWMCCV.CCU014_CD_BNF_CD_ALL d
	ON 
	a.bnf_combined=d.bnf_code
	WHERE a.DT_PRESCRIBED BETWEEN '2018-03-01' AND '2021-05-31'
	AND 
	YEAR(a.DT_PRESCRIBED)='2020' AND MONTH(a.DT_PRESCRIBED)=3; 

INSERT INTO SAILWWMCCV.CCU014_COHORT_DISPENSED 
	SELECT 
	 DISTINCT 
 			'1' as  DRUG_SEQ,
			a.alf_e, 
			round((days(a.dt_prescribed)-days(b.wob))/365.25) AS dispensed_age,
			b.wob,
			b.gndr_cd,b.dod, b.LSOA2011_INCEPTION , 
			b.wimd2019_quintile_inception,
			b.wimd2019_quintile_desc_inception,
			c.EHRD_EC_ONS  ETHNICITY_ONS,
			c.EC_ONS_DESC ETHNICITY_ONS_DESC,
			a.dt_prescribed, 
			a.dmdcode_prescribed, 
			a.product_prescribed, 
			a.bnf_combined AS bnf,
			a.bnf_combined_desc AS bnf_desc,
			d.key_group,
			a.prac_cd_e,
			a.qty_prescribed, 
			a.qty_prescribed_val, 
			a.qty_uom_code, 
			a.dispenser_id, 
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort20_20210603) THEN 1 ELSE 0 END AS c20,
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort16) THEN 1 ELSE 0 END AS c16
	FROM SAILWWMCCV.CCU014_RRDA_WDDS a
	LEFT JOIN 
	SAILWWMCCV.ccu014_c20_c16 b 
	ON 
	a.alf_e=b.alf_e
	LEFT JOIN 
	SAILWWMCCV.WMCC_COMB_ETHN_EHRD c 
	ON 
	a.ALF_E =c.ALF_E 
	LEFT JOIN 
	SAILWWMCCV.CCU014_CD_BNF_CD_ALL d
	ON 
	a.bnf_combined=d.bnf_code
	WHERE a.DT_PRESCRIBED BETWEEN '2018-03-01' AND '2021-05-31'
	AND 
	YEAR(a.DT_PRESCRIBED)='2020' AND MONTH(a.DT_PRESCRIBED)=4; 
INSERT INTO SAILWWMCCV.CCU014_COHORT_DISPENSED 
	SELECT 
	 DISTINCT 
 			'1' as  DRUG_SEQ,
			a.alf_e, 
			round((days(a.dt_prescribed)-days(b.wob))/365.25) AS dispensed_age,
			b.wob,
			b.gndr_cd,b.dod, b.LSOA2011_INCEPTION , 
			b.wimd2019_quintile_inception,
			b.wimd2019_quintile_desc_inception,
			c.EHRD_EC_ONS  ETHNICITY_ONS,
			c.EC_ONS_DESC ETHNICITY_ONS_DESC,
			a.dt_prescribed, 
			a.dmdcode_prescribed, 
			a.product_prescribed, 
			a.bnf_combined AS bnf,
			a.bnf_combined_desc AS bnf_desc,
			d.key_group,
			a.prac_cd_e,
			a.qty_prescribed, 
			a.qty_prescribed_val, 
			a.qty_uom_code, 
			a.dispenser_id, 
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort20_20210603) THEN 1 ELSE 0 END AS c20,
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort16) THEN 1 ELSE 0 END AS c16
	FROM SAILWWMCCV.CCU014_RRDA_WDDS a
	LEFT JOIN 
	SAILWWMCCV.ccu014_c20_c16 b 
	ON 
	a.alf_e=b.alf_e
	LEFT JOIN 
	SAILWWMCCV.WMCC_COMB_ETHN_EHRD c 
	ON 
	a.ALF_E =c.ALF_E 
	LEFT JOIN 
	SAILWWMCCV.CCU014_CD_BNF_CD_ALL d
	ON 
	a.bnf_combined=d.bnf_code
	WHERE a.DT_PRESCRIBED BETWEEN '2018-03-01' AND '2021-05-31'
	AND 
	YEAR(a.DT_PRESCRIBED)='2020' AND MONTH(a.DT_PRESCRIBED)=5; 
INSERT INTO SAILWWMCCV.CCU014_COHORT_DISPENSED 
		SELECT 
	 DISTINCT 
 			'1' as  DRUG_SEQ,
			a.alf_e, 
			round((days(a.dt_prescribed)-days(b.wob))/365.25) AS dispensed_age,
			b.wob,
			b.gndr_cd,b.dod, b.LSOA2011_INCEPTION , 
			b.wimd2019_quintile_inception,
			b.wimd2019_quintile_desc_inception,
			c.EHRD_EC_ONS  ETHNICITY_ONS,
			c.EC_ONS_DESC ETHNICITY_ONS_DESC,
			a.dt_prescribed, 
			a.dmdcode_prescribed, 
			a.product_prescribed, 
			a.bnf_combined AS bnf,
			a.bnf_combined_desc AS bnf_desc,
			d.key_group,
			a.prac_cd_e,
			a.qty_prescribed, 
			a.qty_prescribed_val, 
			a.qty_uom_code, 
			a.dispenser_id, 
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort20_20210603) THEN 1 ELSE 0 END AS c20,
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort16) THEN 1 ELSE 0 END AS c16
	FROM SAILWWMCCV.CCU014_RRDA_WDDS a
	LEFT JOIN 
	SAILWWMCCV.ccu014_c20_c16 b 
	ON 
	a.alf_e=b.alf_e
	LEFT JOIN 
	SAILWWMCCV.WMCC_COMB_ETHN_EHRD c 
	ON 
	a.ALF_E =c.ALF_E 
	LEFT JOIN 
	SAILWWMCCV.CCU014_CD_BNF_CD_ALL d
	ON 
	a.bnf_combined=d.bnf_code
	WHERE a.DT_PRESCRIBED BETWEEN '2018-03-01' AND '2021-05-31'
	AND 
	YEAR(a.DT_PRESCRIBED)='2020' AND MONTH(a.DT_PRESCRIBED)=6; 
INSERT INTO SAILWWMCCV.CCU014_COHORT_DISPENSED 
	SELECT 
	 DISTINCT 
 			'1' as  DRUG_SEQ,
			a.alf_e, 
			round((days(a.dt_prescribed)-days(b.wob))/365.25) AS dispensed_age,
			b.wob,
			b.gndr_cd,b.dod, b.LSOA2011_INCEPTION , 
			b.wimd2019_quintile_inception,
			b.wimd2019_quintile_desc_inception,
			c.EHRD_EC_ONS  ETHNICITY_ONS,
			c.EC_ONS_DESC ETHNICITY_ONS_DESC,
			a.dt_prescribed, 
			a.dmdcode_prescribed, 
			a.product_prescribed, 
			a.bnf_combined AS bnf,
			a.bnf_combined_desc AS bnf_desc,
			d.key_group,
			a.prac_cd_e,
			a.qty_prescribed, 
			a.qty_prescribed_val, 
			a.qty_uom_code, 
			a.dispenser_id, 
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort20_20210603) THEN 1 ELSE 0 END AS c20,
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort16) THEN 1 ELSE 0 END AS c16
	FROM SAILWWMCCV.CCU014_RRDA_WDDS a
	LEFT JOIN 
	SAILWWMCCV.ccu014_c20_c16 b 
	ON 
	a.alf_e=b.alf_e
	LEFT JOIN 
	SAILWWMCCV.WMCC_COMB_ETHN_EHRD c 
	ON 
	a.ALF_E =c.ALF_E 
	LEFT JOIN 
	SAILWWMCCV.CCU014_CD_BNF_CD_ALL d
	ON 
	a.bnf_combined=d.bnf_code
	WHERE a.DT_PRESCRIBED BETWEEN '2018-03-01' AND '2021-05-31'
	AND 
	YEAR(a.DT_PRESCRIBED)='2020' AND MONTH(a.DT_PRESCRIBED)=7; 
INSERT INTO SAILWWMCCV.CCU014_COHORT_DISPENSED 
	SELECT 
	 DISTINCT 
 			'1' as  DRUG_SEQ,
			a.alf_e, 
			round((days(a.dt_prescribed)-days(b.wob))/365.25) AS dispensed_age,
			b.wob,
			b.gndr_cd,b.dod, b.LSOA2011_INCEPTION , 
			b.wimd2019_quintile_inception,
			b.wimd2019_quintile_desc_inception,
			c.EHRD_EC_ONS  ETHNICITY_ONS,
			c.EC_ONS_DESC ETHNICITY_ONS_DESC,
			a.dt_prescribed, 
			a.dmdcode_prescribed, 
			a.product_prescribed, 
			a.bnf_combined AS bnf,
			a.bnf_combined_desc AS bnf_desc,
			d.key_group,
			a.prac_cd_e,
			a.qty_prescribed, 
			a.qty_prescribed_val, 
			a.qty_uom_code, 
			a.dispenser_id, 
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort20_20210603) THEN 1 ELSE 0 END AS c20,
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort16) THEN 1 ELSE 0 END AS c16
	FROM SAILWWMCCV.CCU014_RRDA_WDDS a
	LEFT JOIN 
	SAILWWMCCV.ccu014_c20_c16 b 
	ON 
	a.alf_e=b.alf_e
	LEFT JOIN 
	SAILWWMCCV.WMCC_COMB_ETHN_EHRD c 
	ON 
	a.ALF_E =c.ALF_E 
	LEFT JOIN 
	SAILWWMCCV.CCU014_CD_BNF_CD_ALL d
	ON 
	a.bnf_combined=d.bnf_code
	WHERE a.DT_PRESCRIBED BETWEEN '2018-03-01' AND '2021-05-31'
	AND 
	YEAR(a.DT_PRESCRIBED)='2020' AND MONTH(a.DT_PRESCRIBED)=8; 
INSERT INTO SAILWWMCCV.CCU014_COHORT_DISPENSED 
	SELECT 
	 DISTINCT 
 			'1' as  DRUG_SEQ,
			a.alf_e, 
			round((days(a.dt_prescribed)-days(b.wob))/365.25) AS dispensed_age,
			b.wob,
			b.gndr_cd,b.dod, b.LSOA2011_INCEPTION , 
			b.wimd2019_quintile_inception,
			b.wimd2019_quintile_desc_inception,
			c.EHRD_EC_ONS  ETHNICITY_ONS,
			c.EC_ONS_DESC ETHNICITY_ONS_DESC,
			a.dt_prescribed, 
			a.dmdcode_prescribed, 
			a.product_prescribed, 
			a.bnf_combined AS bnf,
			a.bnf_combined_desc AS bnf_desc,
			d.key_group,
			a.prac_cd_e,
			a.qty_prescribed, 
			a.qty_prescribed_val, 
			a.qty_uom_code, 
			a.dispenser_id, 
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort20_20210603) THEN 1 ELSE 0 END AS c20,
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort16) THEN 1 ELSE 0 END AS c16
	FROM SAILWWMCCV.CCU014_RRDA_WDDS a
	LEFT JOIN 
	SAILWWMCCV.ccu014_c20_c16 b 
	ON 
	a.alf_e=b.alf_e
	LEFT JOIN 
	SAILWWMCCV.WMCC_COMB_ETHN_EHRD c 
	ON 
	a.ALF_E =c.ALF_E 
	LEFT JOIN 
	SAILWWMCCV.CCU014_CD_BNF_CD_ALL d
	ON 
	a.bnf_combined=d.bnf_code
	WHERE a.DT_PRESCRIBED BETWEEN '2018-03-01' AND '2021-05-31'
	AND 
	YEAR(a.DT_PRESCRIBED)='2020' AND MONTH(a.DT_PRESCRIBED)=9; 
INSERT INTO SAILWWMCCV.CCU014_COHORT_DISPENSED 
	SELECT 
	 DISTINCT 
 			'1' as  DRUG_SEQ,
			a.alf_e, 
			round((days(a.dt_prescribed)-days(b.wob))/365.25) AS dispensed_age,
			b.wob,
			b.gndr_cd,b.dod, b.LSOA2011_INCEPTION , 
			b.wimd2019_quintile_inception,
			b.wimd2019_quintile_desc_inception,
			c.EHRD_EC_ONS  ETHNICITY_ONS,
			c.EC_ONS_DESC ETHNICITY_ONS_DESC,
			a.dt_prescribed, 
			a.dmdcode_prescribed, 
			a.product_prescribed, 
			a.bnf_combined AS bnf,
			a.bnf_combined_desc AS bnf_desc,
			d.key_group,
			a.prac_cd_e,
			a.qty_prescribed, 
			a.qty_prescribed_val, 
			a.qty_uom_code, 
			a.dispenser_id, 
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort20_20210603) THEN 1 ELSE 0 END AS c20,
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort16) THEN 1 ELSE 0 END AS c16
	FROM SAILWWMCCV.CCU014_RRDA_WDDS a
	LEFT JOIN 
	SAILWWMCCV.ccu014_c20_c16 b 
	ON 
	a.alf_e=b.alf_e
	LEFT JOIN 
	SAILWWMCCV.WMCC_COMB_ETHN_EHRD c 
	ON 
	a.ALF_E =c.ALF_E 
	LEFT JOIN 
	SAILWWMCCV.CCU014_CD_BNF_CD_ALL d
	ON 
	a.bnf_combined=d.bnf_code
	WHERE a.DT_PRESCRIBED BETWEEN '2018-03-01' AND '2021-05-31'
	AND 
	YEAR(a.DT_PRESCRIBED)='2020' AND MONTH(a.DT_PRESCRIBED)=10; 
INSERT INTO SAILWWMCCV.CCU014_COHORT_DISPENSED 
	SELECT 
	 DISTINCT 
 			'1' as  DRUG_SEQ,
			a.alf_e, 
			round((days(a.dt_prescribed)-days(b.wob))/365.25) AS dispensed_age,
			b.wob,
			b.gndr_cd,b.dod, b.LSOA2011_INCEPTION , 
			b.wimd2019_quintile_inception,
			b.wimd2019_quintile_desc_inception,
			c.EHRD_EC_ONS  ETHNICITY_ONS,
			c.EC_ONS_DESC ETHNICITY_ONS_DESC,
			a.dt_prescribed, 
			a.dmdcode_prescribed, 
			a.product_prescribed, 
			a.bnf_combined AS bnf,
			a.bnf_combined_desc AS bnf_desc,
			d.key_group,
			a.prac_cd_e,
			a.qty_prescribed, 
			a.qty_prescribed_val, 
			a.qty_uom_code, 
			a.dispenser_id, 
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort20_20210603) THEN 1 ELSE 0 END AS c20,
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort16) THEN 1 ELSE 0 END AS c16
	FROM SAILWWMCCV.CCU014_RRDA_WDDS a
	LEFT JOIN 
	SAILWWMCCV.ccu014_c20_c16 b 
	ON 
	a.alf_e=b.alf_e
	LEFT JOIN 
	SAILWWMCCV.WMCC_COMB_ETHN_EHRD c 
	ON 
	a.ALF_E =c.ALF_E 
	LEFT JOIN 
	SAILWWMCCV.CCU014_CD_BNF_CD_ALL d
	ON 
	a.bnf_combined=d.bnf_code
	WHERE a.DT_PRESCRIBED BETWEEN '2018-03-01' AND '2021-05-31'
	AND 
	YEAR(a.DT_PRESCRIBED)='2020' AND MONTH(a.DT_PRESCRIBED)=11; 
INSERT INTO SAILWWMCCV.CCU014_COHORT_DISPENSED 
	SELECT 
	 DISTINCT 
 			'1' as  DRUG_SEQ,
			a.alf_e, 
			round((days(a.dt_prescribed)-days(b.wob))/365.25) AS dispensed_age,
			b.wob,
			b.gndr_cd,b.dod, b.LSOA2011_INCEPTION , 
			b.wimd2019_quintile_inception,
			b.wimd2019_quintile_desc_inception,
			c.EHRD_EC_ONS  ETHNICITY_ONS,
			c.EC_ONS_DESC ETHNICITY_ONS_DESC,
			a.dt_prescribed, 
			a.dmdcode_prescribed, 
			a.product_prescribed, 
			a.bnf_combined AS bnf,
			a.bnf_combined_desc AS bnf_desc,
			d.key_group,
			a.prac_cd_e,
			a.qty_prescribed, 
			a.qty_prescribed_val, 
			a.qty_uom_code, 
			a.dispenser_id, 
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort20_20210603) THEN 1 ELSE 0 END AS c20,
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort16) THEN 1 ELSE 0 END AS c16
	FROM SAILWWMCCV.CCU014_RRDA_WDDS a
	LEFT JOIN 
	SAILWWMCCV.ccu014_c20_c16 b 
	ON 
	a.alf_e=b.alf_e
	LEFT JOIN 
	SAILWWMCCV.WMCC_COMB_ETHN_EHRD c 
	ON 
	a.ALF_E =c.ALF_E 
	LEFT JOIN 
	SAILWWMCCV.CCU014_CD_BNF_CD_ALL d
	ON 
	a.bnf_combined=d.bnf_code
	WHERE a.DT_PRESCRIBED BETWEEN '2018-03-01' AND '2021-05-31'
	AND 
	YEAR(a.DT_PRESCRIBED)='2020' AND MONTH(a.DT_PRESCRIBED)=12; 

--------2021

INSERT INTO SAILWWMCCV.CCU014_COHORT_DISPENSED 
	SELECT 
	 DISTINCT 
 			'1' as  DRUG_SEQ,
			a.alf_e, 
			round((days(a.dt_prescribed)-days(b.wob))/365.25) AS dispensed_age,
			b.wob,
			b.gndr_cd,b.dod, b.LSOA2011_INCEPTION , 
			b.wimd2019_quintile_inception,
			b.wimd2019_quintile_desc_inception,
			c.EHRD_EC_ONS  ETHNICITY_ONS,
			c.EC_ONS_DESC ETHNICITY_ONS_DESC,
			a.dt_prescribed, 
			a.dmdcode_prescribed, 
			a.product_prescribed, 
			a.bnf_combined AS bnf,
			a.bnf_combined_desc AS bnf_desc,
			d.key_group,
			a.prac_cd_e,
			a.qty_prescribed, 
			a.qty_prescribed_val, 
			a.qty_uom_code, 
			a.dispenser_id, 
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort20_20210603) THEN 1 ELSE 0 END AS c20,
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort16) THEN 1 ELSE 0 END AS c16
	FROM SAILWWMCCV.CCU014_RRDA_WDDS a
	LEFT JOIN 
	SAILWWMCCV.ccu014_c20_c16 b 
	ON 
	a.alf_e=b.alf_e
	LEFT JOIN 
	SAILWWMCCV.WMCC_COMB_ETHN_EHRD c 
	ON 
	a.ALF_E =c.ALF_E 
	LEFT JOIN 
	SAILWWMCCV.CCU014_CD_BNF_CD_ALL d
	ON 
	a.bnf_combined=d.bnf_code
	WHERE a.DT_PRESCRIBED BETWEEN '2018-03-01' AND '2021-05-31'
	AND 
	YEAR(a.DT_PRESCRIBED)='2021' AND MONTH(a.DT_PRESCRIBED)=1; 

INSERT INTO SAILWWMCCV.CCU014_COHORT_DISPENSED 
	SELECT 
	 DISTINCT 
 			'1' as  DRUG_SEQ,
			a.alf_e, 
			round((days(a.dt_prescribed)-days(b.wob))/365.25) AS dispensed_age,
			b.wob,
			b.gndr_cd,b.dod, b.LSOA2011_INCEPTION , 
			b.wimd2019_quintile_inception,
			b.wimd2019_quintile_desc_inception,
			c.EHRD_EC_ONS  ETHNICITY_ONS,
			c.EC_ONS_DESC ETHNICITY_ONS_DESC,
			a.dt_prescribed, 
			a.dmdcode_prescribed, 
			a.product_prescribed, 
			a.bnf_combined AS bnf,
			a.bnf_combined_desc AS bnf_desc,
			d.key_group,
			a.prac_cd_e,
			a.qty_prescribed, 
			a.qty_prescribed_val, 
			a.qty_uom_code, 
			a.dispenser_id, 
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort20_20210603) THEN 1 ELSE 0 END AS c20,
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort16) THEN 1 ELSE 0 END AS c16
	FROM SAILWWMCCV.CCU014_RRDA_WDDS a
	LEFT JOIN 
	SAILWWMCCV.ccu014_c20_c16 b 
	ON 
	a.alf_e=b.alf_e
	LEFT JOIN 
	SAILWWMCCV.WMCC_COMB_ETHN_EHRD c 
	ON 
	a.ALF_E =c.ALF_E 
	LEFT JOIN 
	SAILWWMCCV.CCU014_CD_BNF_CD_ALL d
	ON 
	a.bnf_combined=d.bnf_code
	WHERE a.DT_PRESCRIBED BETWEEN '2018-03-01' AND '2021-05-31'
	AND 
	YEAR(a.DT_PRESCRIBED)='2021' AND MONTH(a.DT_PRESCRIBED)=2; 

INSERT INTO SAILWWMCCV.CCU014_COHORT_DISPENSED 
	SELECT 
	 DISTINCT 
 			'1' as  DRUG_SEQ,
			a.alf_e, 
			round((days(a.dt_prescribed)-days(b.wob))/365.25) AS dispensed_age,
			b.wob,
			b.gndr_cd,b.dod, b.LSOA2011_INCEPTION , 
			b.wimd2019_quintile_inception,
			b.wimd2019_quintile_desc_inception,
			c.EHRD_EC_ONS  ETHNICITY_ONS,
			c.EC_ONS_DESC ETHNICITY_ONS_DESC,
			a.dt_prescribed, 
			a.dmdcode_prescribed, 
			a.product_prescribed, 
			a.bnf_combined AS bnf,
			a.bnf_combined_desc AS bnf_desc,
			d.key_group,
			a.prac_cd_e,
			a.qty_prescribed, 
			a.qty_prescribed_val, 
			a.qty_uom_code, 
			a.dispenser_id, 
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort20_20210603) THEN 1 ELSE 0 END AS c20,
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort16) THEN 1 ELSE 0 END AS c16
	FROM SAILWWMCCV.CCU014_RRDA_WDDS a
	LEFT JOIN 
	SAILWWMCCV.ccu014_c20_c16 b 
	ON 
	a.alf_e=b.alf_e
	LEFT JOIN 
	SAILWWMCCV.WMCC_COMB_ETHN_EHRD c 
	ON 
	a.ALF_E =c.ALF_E 
	LEFT JOIN 
	SAILWWMCCV.CCU014_CD_BNF_CD_ALL d
	ON 
	a.bnf_combined=d.bnf_code
	WHERE a.DT_PRESCRIBED BETWEEN '2018-03-01' AND '2021-05-31'
	AND 
	YEAR(a.DT_PRESCRIBED)='2021' AND MONTH(a.DT_PRESCRIBED)=3; 

INSERT INTO SAILWWMCCV.CCU014_COHORT_DISPENSED 
	SELECT 
	 DISTINCT 
 			'1' as  DRUG_SEQ,
			a.alf_e, 
			round((days(a.dt_prescribed)-days(b.wob))/365.25) AS dispensed_age,
			b.wob,
			b.gndr_cd,b.dod, b.LSOA2011_INCEPTION , 
			b.wimd2019_quintile_inception,
			b.wimd2019_quintile_desc_inception,
			c.EHRD_EC_ONS  ETHNICITY_ONS,
			c.EC_ONS_DESC ETHNICITY_ONS_DESC,
			a.dt_prescribed, 
			a.dmdcode_prescribed, 
			a.product_prescribed, 
			a.bnf_combined AS bnf,
			a.bnf_combined_desc AS bnf_desc,
			d.key_group,
			a.prac_cd_e,
			a.qty_prescribed, 
			a.qty_prescribed_val, 
			a.qty_uom_code, 
			a.dispenser_id, 
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort20_20210603) THEN 1 ELSE 0 END AS c20,
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort16) THEN 1 ELSE 0 END AS c16
	FROM SAILWWMCCV.CCU014_RRDA_WDDS a
	LEFT JOIN 
	SAILWWMCCV.ccu014_c20_c16 b 
	ON 
	a.alf_e=b.alf_e
	LEFT JOIN 
	SAILWWMCCV.WMCC_COMB_ETHN_EHRD c 
	ON 
	a.ALF_E =c.ALF_E 
	LEFT JOIN 
	SAILWWMCCV.CCU014_CD_BNF_CD_ALL d
	ON 
	a.bnf_combined=d.bnf_code
	WHERE a.DT_PRESCRIBED BETWEEN '2018-03-01' AND '2021-05-31'
	AND 
	YEAR(a.DT_PRESCRIBED)='2021' AND MONTH(a.DT_PRESCRIBED)=4; 
INSERT INTO SAILWWMCCV.CCU014_COHORT_DISPENSED 
	SELECT 
	 DISTINCT 
 			'1' as  DRUG_SEQ,
			a.alf_e, 
			round((days(a.dt_prescribed)-days(b.wob))/365.25) AS dispensed_age,
			b.wob,
			b.gndr_cd,b.dod, b.LSOA2011_INCEPTION , 
			b.wimd2019_quintile_inception,
			b.wimd2019_quintile_desc_inception,
			c.EHRD_EC_ONS  ETHNICITY_ONS,
			c.EC_ONS_DESC ETHNICITY_ONS_DESC,
			a.dt_prescribed, 
			a.dmdcode_prescribed, 
			a.product_prescribed, 
			a.bnf_combined AS bnf,
			a.bnf_combined_desc AS bnf_desc,
			d.key_group,
			a.prac_cd_e,
			a.qty_prescribed, 
			a.qty_prescribed_val, 
			a.qty_uom_code, 
			a.dispenser_id, 
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort20_20210603) THEN 1 ELSE 0 END AS c20,
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort16) THEN 1 ELSE 0 END AS c16
	FROM SAILWWMCCV.CCU014_RRDA_WDDS a
	LEFT JOIN 
	SAILWWMCCV.ccu014_c20_c16 b 
	ON 
	a.alf_e=b.alf_e
	LEFT JOIN 
	SAILWWMCCV.WMCC_COMB_ETHN_EHRD c 
	ON 
	a.ALF_E =c.ALF_E 
	LEFT JOIN 
	SAILWWMCCV.CCU014_CD_BNF_CD_ALL d
	ON 
	a.bnf_combined=d.bnf_code
	WHERE a.DT_PRESCRIBED BETWEEN '2018-03-01' AND '2021-05-31'
	AND 
	YEAR(a.DT_PRESCRIBED)='2021' AND MONTH(a.DT_PRESCRIBED)=5; 

INSERT INTO SAILWWMCCV.CCU014_COHORT_DISPENSED 
	SELECT 
	 DISTINCT 
 			'1' as  DRUG_SEQ,
			a.alf_e, 
			round((days(a.dt_prescribed)-days(b.wob))/365.25) AS dispensed_age,
			b.wob,
			b.gndr_cd,b.dod, b.LSOA2011_INCEPTION , 
			b.wimd2019_quintile_inception,
			b.wimd2019_quintile_desc_inception,
			c.EHRD_EC_ONS  ETHNICITY_ONS,
			c.EC_ONS_DESC ETHNICITY_ONS_DESC,
			a.dt_prescribed, 
			a.dmdcode_prescribed, 
			a.product_prescribed, 
			a.bnf_combined AS bnf,
			a.bnf_combined_desc AS bnf_desc,
			d.key_group,
			a.prac_cd_e,
			a.qty_prescribed, 
			a.qty_prescribed_val, 
			a.qty_uom_code, 
			a.dispenser_id, 
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort20_20210603) THEN 1 ELSE 0 END AS c20,
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort16) THEN 1 ELSE 0 END AS c16
	FROM SAILWWMCCV.CCU014_RRDA_WDDS a
	LEFT JOIN 
	SAILWWMCCV.ccu014_c20_c16 b 
	ON 
	a.alf_e=b.alf_e
	LEFT JOIN 
	SAILWWMCCV.WMCC_COMB_ETHN_EHRD c 
	ON 
	a.ALF_E =c.ALF_E 
	LEFT JOIN 
	SAILWWMCCV.CCU014_CD_BNF_CD_ALL d
	ON 
	a.bnf_combined=d.bnf_code
	WHERE a.DT_PRESCRIBED BETWEEN '2018-03-01' AND '2021-08-31'
	AND 
	YEAR(a.DT_PRESCRIBED)='2021' AND MONTH(a.DT_PRESCRIBED)=6; 

INSERT INTO SAILWWMCCV.CCU014_COHORT_DISPENSED 
	SELECT 
	 DISTINCT 
 			'1' as  DRUG_SEQ,
			a.alf_e, 
			round((days(a.dt_prescribed)-days(b.wob))/365.25) AS dispensed_age,
			b.wob,
			b.gndr_cd,b.dod, b.LSOA2011_INCEPTION , 
			b.wimd2019_quintile_inception,
			b.wimd2019_quintile_desc_inception,
			c.EHRD_EC_ONS  ETHNICITY_ONS,
			c.EC_ONS_DESC ETHNICITY_ONS_DESC,
			a.dt_prescribed, 
			a.dmdcode_prescribed, 
			a.product_prescribed, 
			a.bnf_combined AS bnf,
			a.bnf_combined_desc AS bnf_desc,
			d.key_group,
			a.prac_cd_e,
			a.qty_prescribed, 
			a.qty_prescribed_val, 
			a.qty_uom_code, 
			a.dispenser_id, 
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort20_20210603) THEN 1 ELSE 0 END AS c20,
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort16) THEN 1 ELSE 0 END AS c16
	FROM SAILWWMCCV.CCU014_RRDA_WDDS a
	LEFT JOIN 
	SAILWWMCCV.ccu014_c20_c16 b 
	ON 
	a.alf_e=b.alf_e
	LEFT JOIN 
	SAILWWMCCV.WMCC_COMB_ETHN_EHRD c 
	ON 
	a.ALF_E =c.ALF_E 
	LEFT JOIN 
	SAILWWMCCV.CCU014_CD_BNF_CD_ALL d
	ON 
	a.bnf_combined=d.bnf_code
	WHERE a.DT_PRESCRIBED BETWEEN '2018-03-01' AND '2021-08-31'
	AND 
	YEAR(a.DT_PRESCRIBED)='2021' AND MONTH(a.DT_PRESCRIBED)=7; 


INSERT INTO SAILWWMCCV.CCU014_COHORT_DISPENSED 
	SELECT 
	 DISTINCT 
 			'1' as  DRUG_SEQ,
			a.alf_e, 
			round((days(a.dt_prescribed)-days(b.wob))/365.25) AS dispensed_age,
			b.wob,
			b.gndr_cd,b.dod, b.LSOA2011_INCEPTION , 
			b.wimd2019_quintile_inception,
			b.wimd2019_quintile_desc_inception,
			c.EHRD_EC_ONS  ETHNICITY_ONS,
			c.EC_ONS_DESC ETHNICITY_ONS_DESC,
			a.dt_prescribed, 
			a.dmdcode_prescribed, 
			a.product_prescribed, 
			a.bnf_combined AS bnf,
			a.bnf_combined_desc AS bnf_desc,
			d.key_group,
			a.prac_cd_e,
			a.qty_prescribed, 
			a.qty_prescribed_val, 
			a.qty_uom_code, 
			a.dispenser_id, 
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort20_20210603) THEN 1 ELSE 0 END AS c20,
			CASE WHEN a.alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.ccu014_c19_cohort16) THEN 1 ELSE 0 END AS c16
	FROM SAILWWMCCV.CCU014_RRDA_WDDS a
	LEFT JOIN 
	SAILWWMCCV.ccu014_c20_c16 b 
	ON 
	a.alf_e=b.alf_e
	LEFT JOIN 
	SAILWWMCCV.WMCC_COMB_ETHN_EHRD c 
	ON 
	a.ALF_E =c.ALF_E 
	LEFT JOIN 
	SAILWWMCCV.CCU014_CD_BNF_CD_ALL d
	ON 
	a.bnf_combined=d.bnf_code
	WHERE a.DT_PRESCRIBED BETWEEN '2018-03-01' AND '2021-08-31'
	AND 
	YEAR(a.DT_PRESCRIBED)='2021' AND MONTH(a.DT_PRESCRIBED)=8; 

CREATE INDEX SAILWWMCCV.CCU014_COHORT_DISPENSED_index_alf_e_001 ON SAILWWMCCV.CCU014_COHORT_DISPENSED(ALF_E DESC ) DISALLOW REVERSE SCANS;

SELECT max(DT_PRESCRIBED ) FROM SAILWWMCCV.CCU014_COHORT_DISPENSED; 

SELECT count(*) FROM SAILWWMCCV.CCU014_COHORT_DISPENSED; ---274,146,746


SELECT DISTINCT YEAR(DT_PRESCRIBED), count(*) FROM SAILWWMCCV.CCU014_COHORT_DISPENSED
GROUP BY YEAR(DT_PRESCRIBED); 

SELECT DISTINCT MONTH(DT_PRESCRIBED), count(*) FROM SAILWWMCCV.CCU014_COHORT_DISPENSED
GROUP BY MONTH(DT_PRESCRIBED);

-------------------------------------------------------------
--block 2: 
--subseting the cohort by 402 drugs: this is going into supplement
-------------------------------------------------------------
--c20 & c16 ALFs
/*
CALL FNC.DROP_IF_EXISTS ('SAILWWMCCV.ccu014_c19_cohort20_20210603');

CREATE TABLE SAILWWMCCV.ccu014_c19_cohort20_20210603 AS 
(SELECT * FROM SAILWMCCV.C19_COHORT20_20210603) WITH NO DATA; 
INSERT INTO  SAILWWMCCV.ccu014_c19_cohort20_20210603
SELECT * FROM SAILWMCCV.C19_COHORT20_20210603;

CALL FNC.DROP_IF_EXISTS ('SAILWWMCCV.ccu014_c19_cohort16');

CREATE TABLE SAILWWMCCV.ccu014_c19_cohort16 AS 
(SELECT * FROM SAILWMCCV.C19_COHORT16) WITH NO DATA; 
INSERT INTO  SAILWWMCCV.ccu014_c19_cohort16 
SELECT * FROM SAILWMCCV.C19_COHORT16;

--combined pool of c20&c16 cohort
CALL FNC.DROP_IF_EXISTS ('SAILWWMCCV.ccu014_c20_c16');

CREATE TABLE SAILWWMCCV.ccu014_c20_c16 AS 
(
SELECT DISTINCT ALF_E , WOB , GNDR_CD ,DOD ,LSOA2011_INCEPTION , WIMD2019_QUINTILE_INCEPTION , WIMD2019_QUINTILE_DESC_INCEPTION FROM SAILWMCCV.C19_COHORT16
UNION 
SELECT DISTINCT ALF_E , WOB , GNDR_CD ,DOD ,LSOA2011_INCEPTION ,  WIMD2019_QUINTILE_INCEPTION , WIMD2019_QUINTILE_DESC_INCEPTION FROM SAILWWMCCV.ccu014_c19_cohort20_20210603
) WITH NO DATA; 

INSERT INTO SAILWWMCCV.ccu014_c20_c16 
SELECT DISTINCT ALF_E , WOB , GNDR_CD ,DOD ,LSOA2011_INCEPTION , WIMD2019_QUINTILE_INCEPTION , WIMD2019_QUINTILE_DESC_INCEPTION FROM SAILWMCCV.C19_COHORT16
UNION 
SELECT DISTINCT ALF_E , WOB , GNDR_CD ,DOD ,LSOA2011_INCEPTION ,  WIMD2019_QUINTILE_INCEPTION , WIMD2019_QUINTILE_DESC_INCEPTION FROM SAILWWMCCV.ccu014_c19_cohort20_20210603;
*/

------------------------------------------------
--ALFs incident prescription
------------------------------------------------
---------------------------------------------------------------------
--Row sequnece for incident medication
--let's do row sequence for every 100 ALF at a time: 
---------------------------------------------------------------------
CREATE TABLE SAILWWMCCV.CCU014_COHORT_DISPENSED_ALFs AS (
	SELECT DISTINCT alf_e, ROW_NUMBER () OVER (ORDER BY alf_e) row_num FROM 
	(
		SELECT DISTINCT alf_e 
		FROM 
		SAILWWMCCV.CCU014_COHORT_DISPENSED
	)
)WITH NO DATA; 

INSERT INTO  SAILWWMCCV.CCU014_COHORT_DISPENSED_ALFs
	SELECT DISTINCT alf_e, ROW_NUMBER () OVER (ORDER BY alf_e) row_num FROM 
	(
	SELECT DISTINCT alf_e 
	FROM 
	SAILWWMCCV.CCU014_COHORT_DISPENSED
	); 

CREATE TABLE SAILWWMCCV.CCU014_COHORT_DISPENSED_ALFs_202108 AS (
	SELECT DISTINCT alf_e, ROW_NUMBER () OVER (ORDER BY alf_e) row_num FROM 
	(
		SELECT DISTINCT alf_e 
		FROM 
		SAILWWMCCV.CCU014_COHORT_DISPENSED
	)
)WITH NO DATA; 

INSERT INTO  SAILWWMCCV.CCU014_COHORT_DISPENSED_ALFs_202108
	SELECT DISTINCT alf_e, ROW_NUMBER () OVER (ORDER BY alf_e) row_num FROM 
	(
	SELECT DISTINCT alf_e 
	FROM 
	SAILWWMCCV.CCU014_COHORT_DISPENSED
	); 

------------------------------------------------------------------------
--
SELECT max(row_num) FROM SAILWWMCCV.CCU014_COHORT_DISPENSED_ALFs 		---number of patients: 2,839,810
SELECT max(row_num) FROM SAILWWMCCV.CCU014_COHORT_DISPENSED_ALFs_202108 ---number of patients: 2,898,947

--
------------------------------------------------------------------------
--row sequence update for the entire table:
------------------------------------------------------------------------
	SELECT count(*) medication_count 
	FROM  
	SAILWWMCCV.CCU014_COHORT_DISPENSED 
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
	
CALL FNC.DROP_IF_EXISTS ('SAILWWMCCV.CCU014_COHORT_DISPENSED_rows');

CREATE TABLE 		SAILWWMCCV.CCU014_COHORT_DISPENSED_rows AS 
(
	SELECT alf_e, DT_PRESCRIBED,			
	ROW_NUMBER() OVER(PARTITION BY ALF_E,key_group ORDER BY dt_prescribed) DRUG_SEQ,
	bnf, bnf_desc, key_group 
	FROM  
	SAILWWMCCV.CCU014_COHORT_DISPENSED 
	WHERE alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.CCU014_COHORT_DISPENSED_ALFS_202108 WHERE row_num BETWEEN 1 AND 10) 
	AND 
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
)WITH NO DATA; 

--stage inserting:
insert into SAILWWMCCV.CCU014_COHORT_DISPENSED_rows
	SELECT alf_e, DT_PRESCRIBED,			
	ROW_NUMBER() OVER(PARTITION BY ALF_E,key_group ORDER BY dt_prescribed) DRUG_SEQ,
	bnf, bnf_desc, key_group 
	FROM  
	SAILWWMCCV.CCU014_COHORT_DISPENSED 
	WHERE alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.CCU014_COHORT_DISPENSED_ALFS_202108 WHERE row_num BETWEEN 1 AND 100000) 
	AND 
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
	dispensed_age BETWEEN '18' AND '112';

insert into SAILWWMCCV.CCU014_COHORT_DISPENSED_rows 
	SELECT alf_e, DT_PRESCRIBED,			
	ROW_NUMBER() OVER(PARTITION BY ALF_E,key_group ORDER BY dt_prescribed) DRUG_SEQ,
	bnf, bnf_desc, key_group 
	FROM  
	SAILWWMCCV.CCU014_COHORT_DISPENSED 
	WHERE alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.CCU014_COHORT_DISPENSED_ALFS_202108 WHERE row_num BETWEEN 100001 AND 200000)
	AND 
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
	dispensed_age BETWEEN '18' AND '112'; 
insert into SAILWWMCCV.CCU014_COHORT_DISPENSED_rows 
	SELECT alf_e, DT_PRESCRIBED,			
	ROW_NUMBER() OVER(PARTITION BY ALF_E,key_group ORDER BY dt_prescribed) DRUG_SEQ,
	bnf, bnf_desc, key_group 
	FROM  
	SAILWWMCCV.CCU014_COHORT_DISPENSED 
	WHERE alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.CCU014_COHORT_DISPENSED_ALFS_202108 WHERE row_num BETWEEN 200001 AND 300000) 
	AND 
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
	dispensed_age BETWEEN '18' AND '112';
insert into SAILWWMCCV.CCU014_COHORT_DISPENSED_rows 
	SELECT alf_e, DT_PRESCRIBED,			
	ROW_NUMBER() OVER(PARTITION BY ALF_E,key_group ORDER BY dt_prescribed) DRUG_SEQ,
	bnf, bnf_desc, key_group 
	FROM  
	SAILWWMCCV.CCU014_COHORT_DISPENSED 
	WHERE alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.CCU014_COHORT_DISPENSED_ALFS_202108 WHERE row_num BETWEEN 300001 AND 400000)
	AND 
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
	dispensed_age BETWEEN '18' AND '112';
insert into SAILWWMCCV.CCU014_COHORT_DISPENSED_rows 
	SELECT alf_e, DT_PRESCRIBED,			
	ROW_NUMBER() OVER(PARTITION BY ALF_E,key_group ORDER BY dt_prescribed) DRUG_SEQ,
	bnf, bnf_desc, key_group 
	FROM  
	SAILWWMCCV.CCU014_COHORT_DISPENSED 
	WHERE alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.CCU014_COHORT_DISPENSED_ALFS_202108 WHERE row_num BETWEEN 400001 AND 500000) 
	AND 
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
	dispensed_age BETWEEN '18' AND '112';
insert into SAILWWMCCV.CCU014_COHORT_DISPENSED_rows 
	SELECT alf_e, DT_PRESCRIBED,			
	ROW_NUMBER() OVER(PARTITION BY ALF_E,key_group ORDER BY dt_prescribed) DRUG_SEQ,
	bnf, bnf_desc, key_group 
	FROM  
	SAILWWMCCV.CCU014_COHORT_DISPENSED 
	WHERE alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.CCU014_COHORT_DISPENSED_ALFS_202108 WHERE row_num BETWEEN 500001 AND 600000) 
	AND 
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
	dispensed_age BETWEEN '18' AND '112';
insert into SAILWWMCCV.CCU014_COHORT_DISPENSED_rows 
	SELECT alf_e, DT_PRESCRIBED,			
	ROW_NUMBER() OVER(PARTITION BY ALF_E,key_group ORDER BY dt_prescribed) DRUG_SEQ,
	bnf, bnf_desc, key_group 
	FROM  
	SAILWWMCCV.CCU014_COHORT_DISPENSED 
	WHERE alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.CCU014_COHORT_DISPENSED_ALFS_202108 WHERE row_num BETWEEN 600001 AND 700000) 
	AND 
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
	dispensed_age BETWEEN '18' AND '112';
insert into SAILWWMCCV.CCU014_COHORT_DISPENSED_rows 
	SELECT alf_e, DT_PRESCRIBED,			
	ROW_NUMBER() OVER(PARTITION BY ALF_E,key_group ORDER BY dt_prescribed) DRUG_SEQ,
	bnf, bnf_desc, key_group 
	FROM  
	SAILWWMCCV.CCU014_COHORT_DISPENSED 
	WHERE alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.CCU014_COHORT_DISPENSED_ALFS_202108 WHERE row_num BETWEEN 700001 AND 800000) 
	AND 
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
	dispensed_age BETWEEN '18' AND '112';
insert into SAILWWMCCV.CCU014_COHORT_DISPENSED_rows 
	SELECT alf_e, DT_PRESCRIBED,			
	ROW_NUMBER() OVER(PARTITION BY ALF_E,key_group ORDER BY dt_prescribed) DRUG_SEQ,
	bnf, bnf_desc, key_group 
	FROM  
	SAILWWMCCV.CCU014_COHORT_DISPENSED 
	WHERE alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.CCU014_COHORT_DISPENSED_ALFS_202108 WHERE row_num BETWEEN 800001 AND 900000) 
	AND 
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
	dispensed_age BETWEEN '18' AND '112';
insert into SAILWWMCCV.CCU014_COHORT_DISPENSED_rows 
	SELECT alf_e, DT_PRESCRIBED,			
	ROW_NUMBER() OVER(PARTITION BY ALF_E,key_group ORDER BY dt_prescribed) DRUG_SEQ,
	bnf, bnf_desc, key_group 
	FROM  
	SAILWWMCCV.CCU014_COHORT_DISPENSED 
	WHERE alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.CCU014_COHORT_DISPENSED_ALFS_202108 WHERE row_num BETWEEN 900001 AND 1000000) 
	AND 
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
	dispensed_age BETWEEN '18' AND '112';
insert into SAILWWMCCV.CCU014_COHORT_DISPENSED_rows 
	SELECT alf_e, DT_PRESCRIBED,			
	ROW_NUMBER() OVER(PARTITION BY ALF_E,key_group ORDER BY dt_prescribed) DRUG_SEQ,
	bnf, bnf_desc, key_group 
	FROM  
	SAILWWMCCV.CCU014_COHORT_DISPENSED 
	WHERE alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.CCU014_COHORT_DISPENSED_ALFS_202108 WHERE row_num BETWEEN 1000001 AND 1100000) 
	AND 
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
	dispensed_age BETWEEN '18' AND '112';
insert into SAILWWMCCV.CCU014_COHORT_DISPENSED_rows 
	SELECT alf_e, DT_PRESCRIBED,			
	ROW_NUMBER() OVER(PARTITION BY ALF_E,key_group ORDER BY dt_prescribed) DRUG_SEQ,
	bnf, bnf_desc, key_group 
	FROM  
	SAILWWMCCV.CCU014_COHORT_DISPENSED 
	WHERE alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.CCU014_COHORT_DISPENSED_ALFS_202108 WHERE row_num BETWEEN 1100001 AND 1200000) 
	AND 
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
	dispensed_age BETWEEN '18' AND '112';
insert into SAILWWMCCV.CCU014_COHORT_DISPENSED_rows 
	SELECT alf_e, DT_PRESCRIBED,			
	ROW_NUMBER() OVER(PARTITION BY ALF_E,key_group ORDER BY dt_prescribed) DRUG_SEQ,
	bnf, bnf_desc, key_group 
	FROM  
	SAILWWMCCV.CCU014_COHORT_DISPENSED 
	WHERE alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.CCU014_COHORT_DISPENSED_ALFS_202108 WHERE row_num BETWEEN 1200001 AND 1300000) 
	AND 
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
	dispensed_age BETWEEN '18' AND '112';
insert into SAILWWMCCV.CCU014_COHORT_DISPENSED_rows 
	SELECT alf_e, DT_PRESCRIBED,			
	ROW_NUMBER() OVER(PARTITION BY ALF_E,key_group ORDER BY dt_prescribed) DRUG_SEQ,
	bnf, bnf_desc, key_group 
	FROM  
	SAILWWMCCV.CCU014_COHORT_DISPENSED 
	WHERE alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.CCU014_COHORT_DISPENSED_ALFS_202108 WHERE row_num BETWEEN 1300001 AND 1400000) 
	AND 
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
	dispensed_age BETWEEN '18' AND '112';
insert into SAILWWMCCV.CCU014_COHORT_DISPENSED_rows 
	SELECT alf_e, DT_PRESCRIBED,			
	ROW_NUMBER() OVER(PARTITION BY ALF_E,key_group ORDER BY dt_prescribed) DRUG_SEQ,
	bnf, bnf_desc, key_group 
	FROM  
	SAILWWMCCV.CCU014_COHORT_DISPENSED 
	WHERE alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.CCU014_COHORT_DISPENSED_ALFS_202108 WHERE row_num BETWEEN 1400001 AND 1500000) 
	AND 
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
	dispensed_age BETWEEN '18' AND '112';
insert into SAILWWMCCV.CCU014_COHORT_DISPENSED_rows 
	SELECT alf_e, DT_PRESCRIBED,			
	ROW_NUMBER() OVER(PARTITION BY ALF_E,key_group ORDER BY dt_prescribed) DRUG_SEQ,
	bnf, bnf_desc, key_group 
	FROM  
	SAILWWMCCV.CCU014_COHORT_DISPENSED 
	WHERE alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.CCU014_COHORT_DISPENSED_ALFS_202108 WHERE row_num BETWEEN 1500001 AND 1600000) 
	AND 
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
	dispensed_age BETWEEN '18' AND '112';
insert into SAILWWMCCV.CCU014_COHORT_DISPENSED_rows 
	SELECT alf_e, DT_PRESCRIBED,			
	ROW_NUMBER() OVER(PARTITION BY ALF_E,key_group ORDER BY dt_prescribed) DRUG_SEQ,
	bnf, bnf_desc, key_group 
	FROM  
	SAILWWMCCV.CCU014_COHORT_DISPENSED 
	WHERE alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.CCU014_COHORT_DISPENSED_ALFS_202108 WHERE row_num BETWEEN 1600001 AND 1700000) 
	AND 
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
	dispensed_age BETWEEN '18' AND '112';
insert into SAILWWMCCV.CCU014_COHORT_DISPENSED_rows 
	SELECT alf_e, DT_PRESCRIBED,			
	ROW_NUMBER() OVER(PARTITION BY ALF_E,key_group ORDER BY dt_prescribed) DRUG_SEQ,
	bnf, bnf_desc, key_group 
	FROM  
	SAILWWMCCV.CCU014_COHORT_DISPENSED 
	WHERE alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.CCU014_COHORT_DISPENSED_ALFS_202108 WHERE row_num BETWEEN 1700001 AND 1800000) 
	AND 
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
	dispensed_age BETWEEN '18' AND '112';
insert into SAILWWMCCV.CCU014_COHORT_DISPENSED_rows 
	SELECT alf_e, DT_PRESCRIBED,			
	ROW_NUMBER() OVER(PARTITION BY ALF_E,key_group ORDER BY dt_prescribed) DRUG_SEQ,
	bnf, bnf_desc, key_group 
	FROM  
	SAILWWMCCV.CCU014_COHORT_DISPENSED 
	WHERE alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.CCU014_COHORT_DISPENSED_ALFS_202108 WHERE row_num BETWEEN 1800001 AND 1900000) 
	AND 
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
	dispensed_age BETWEEN '18' AND '112';
insert into SAILWWMCCV.CCU014_COHORT_DISPENSED_rows 
	SELECT alf_e, DT_PRESCRIBED,			
	ROW_NUMBER() OVER(PARTITION BY ALF_E,key_group ORDER BY dt_prescribed) DRUG_SEQ,
	bnf, bnf_desc, key_group 
	FROM  
	SAILWWMCCV.CCU014_COHORT_DISPENSED 
	WHERE alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.CCU014_COHORT_DISPENSED_ALFS_202108 WHERE row_num BETWEEN 1900001 AND 2000000) 
	AND 
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
	dispensed_age BETWEEN '18' AND '112';
insert into SAILWWMCCV.CCU014_COHORT_DISPENSED_rows 
	SELECT alf_e, DT_PRESCRIBED,			
	ROW_NUMBER() OVER(PARTITION BY ALF_E,key_group ORDER BY dt_prescribed) DRUG_SEQ,
	bnf, bnf_desc, key_group 
	FROM  
	SAILWWMCCV.CCU014_COHORT_DISPENSED 
	WHERE alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.CCU014_COHORT_DISPENSED_ALFS_202108 WHERE row_num BETWEEN 2000001 AND 2100000) 
	AND 
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
	dispensed_age BETWEEN '18' AND '112';
insert into SAILWWMCCV.CCU014_COHORT_DISPENSED_rows 
	SELECT alf_e, DT_PRESCRIBED,			
	ROW_NUMBER() OVER(PARTITION BY ALF_E,key_group ORDER BY dt_prescribed) DRUG_SEQ,
	bnf, bnf_desc, key_group 
	FROM  
	SAILWWMCCV.CCU014_COHORT_DISPENSED 
	WHERE alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.CCU014_COHORT_DISPENSED_ALFS_202108 WHERE row_num BETWEEN 2100001 AND 2200000) 
	AND 
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
	dispensed_age BETWEEN '18' AND '112';
insert into SAILWWMCCV.CCU014_COHORT_DISPENSED_rows 
	SELECT alf_e, DT_PRESCRIBED,			
	ROW_NUMBER() OVER(PARTITION BY ALF_E,key_group ORDER BY dt_prescribed) DRUG_SEQ,
	bnf, bnf_desc, key_group 
	FROM  
	SAILWWMCCV.CCU014_COHORT_DISPENSED 
	WHERE alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.CCU014_COHORT_DISPENSED_ALFS_202108 WHERE row_num BETWEEN 2200001 AND 2300000) 
	AND 
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
	dispensed_age BETWEEN '18' AND '112';
insert into SAILWWMCCV.CCU014_COHORT_DISPENSED_rows 
	SELECT alf_e, DT_PRESCRIBED,			
	ROW_NUMBER() OVER(PARTITION BY ALF_E,key_group ORDER BY dt_prescribed) DRUG_SEQ,
	bnf, bnf_desc, key_group 
	FROM  
	SAILWWMCCV.CCU014_COHORT_DISPENSED 
	WHERE alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.CCU014_COHORT_DISPENSED_ALFS_202108 WHERE row_num BETWEEN 2300001 AND 2400000) 
	AND 
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
	dispensed_age BETWEEN '18' AND '112';
insert into SAILWWMCCV.CCU014_COHORT_DISPENSED_rows 
	SELECT alf_e, DT_PRESCRIBED,			
	ROW_NUMBER() OVER(PARTITION BY ALF_E,key_group ORDER BY dt_prescribed) DRUG_SEQ,
	bnf, bnf_desc, key_group 
	FROM  
	SAILWWMCCV.CCU014_COHORT_DISPENSED 
	WHERE alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.CCU014_COHORT_DISPENSED_ALFS_202108 WHERE row_num BETWEEN 2400001 AND 2500000) 
	AND 
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
	dispensed_age BETWEEN '18' AND '112';
insert into SAILWWMCCV.CCU014_COHORT_DISPENSED_rows 
	SELECT alf_e, DT_PRESCRIBED,			
	ROW_NUMBER() OVER(PARTITION BY ALF_E,key_group ORDER BY dt_prescribed) DRUG_SEQ,
	bnf, bnf_desc, key_group 
	FROM  
	SAILWWMCCV.CCU014_COHORT_DISPENSED 
	WHERE alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.CCU014_COHORT_DISPENSED_ALFS_202108 WHERE row_num BETWEEN 2500001 AND 2600000) 
	AND 
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
	dispensed_age BETWEEN '18' AND '112';
insert into SAILWWMCCV.CCU014_COHORT_DISPENSED_rows 
	SELECT alf_e, DT_PRESCRIBED,			
	ROW_NUMBER() OVER(PARTITION BY ALF_E,key_group ORDER BY dt_prescribed) DRUG_SEQ,
	bnf, bnf_desc, key_group 
	FROM  
	SAILWWMCCV.CCU014_COHORT_DISPENSED 
	WHERE alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.CCU014_COHORT_DISPENSED_ALFS_202108 WHERE row_num BETWEEN 2600001 AND 2700000) 
	AND 
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
	dispensed_age BETWEEN '18' AND '112';
insert into SAILWWMCCV.CCU014_COHORT_DISPENSED_rows 
	SELECT alf_e, DT_PRESCRIBED,			
	ROW_NUMBER() OVER(PARTITION BY ALF_E,key_group ORDER BY dt_prescribed) DRUG_SEQ,
	bnf, bnf_desc, key_group 
	FROM  
	SAILWWMCCV.CCU014_COHORT_DISPENSED 
	WHERE alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.CCU014_COHORT_DISPENSED_ALFS_202108 WHERE row_num BETWEEN 2700001 AND 2800000) 
	AND 
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
	dispensed_age BETWEEN '18' AND '112';
insert into SAILWWMCCV.CCU014_COHORT_DISPENSED_rows 
	SELECT alf_e, DT_PRESCRIBED,			
	ROW_NUMBER() OVER(PARTITION BY ALF_E,key_group ORDER BY dt_prescribed) DRUG_SEQ,
	bnf, bnf_desc, key_group 
	FROM  
	SAILWWMCCV.CCU014_COHORT_DISPENSED 
	WHERE alf_e IN (SELECT DISTINCT alf_e FROM SAILWWMCCV.CCU014_COHORT_DISPENSED_ALFS_202108 WHERE row_num BETWEEN 2800001 AND 2900000) 
	AND 
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
	dispensed_age BETWEEN '18' AND '112';


COMMIT; 
--checks
SELECT * FROM  SAILWWMCCV.CCU014_COHORT_DISPENSED_rows;

SELECT count(*) FROM  SAILWWMCCV.CCU014_COHORT_DISPENSED_rows
WHERE dt_prescribed >= '2019-03-01' and drug_seq=1 AND KEY_GROUP IS NOT NULL;

-------------------------------------