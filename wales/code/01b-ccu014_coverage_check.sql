--------------------------------------------------------------------
--coverage check of fixed timeshot OF WDDS DATA AT 2021-11-12 FOR CCU014
--by: fatemeh.torabi@swansea.ac.uk
--------------------------------------------------------------------
--coverage
--------------------------------------------------------------------
--	MAX (AVAIL FROM DT): 2021-10-18
--------------------------------------------------------------------
SELECT 	MAX(AVAIL_FROM_DT) AS MAX_WDDS1_AVAIL_FROM_DT FROM	SAILWWMCCV.CCU014_RRDA_WDDS;

--------------------------------------------------------------------
--	MAX	(Coverage no rules): 2021-08-31
--------------------------------------------------------------------
SELECT	MAX(DT_PRESCRIBED) AS MAX_WDDS1_DT FROM
	(
	SELECT
	DISTINCT(DT_PRESCRIBED),
	COUNT(*) COUNTS
	FROM 
	SAILWWMCCV.CCU014_RRDA_WDDS
	WHERE
	YEAR(DT_PRESCRIBED) >= '2020'
	AND DT_PRESCRIBED < AVAIL_FROM_DT
	GROUP BY
	DT_PRESCRIBED
	ORDER BY
	DT_PRESCRIBED DESC
	);
--------------------------------------------------------------------
--	Coverage based on rules: 2021-08-25
--------------------------------------------------------------------
--	0.7 (70%) OF RATIO_TO_AVG (If the coverage falls below 0.7 then 
--	wait for 2 consistent days of coverage equal to or above 0.7)
--	AVERAGE BASED ON ALL DATA FROM 2020 ONWARDS	
WITH COV AS (
SELECT
	A.DT_PRESCRIBED AS MAX_WDDS_DT,
	A.COUNTS ,
	CAST(AVG_COUNT AS INTEGER) AVG,
	((A.COUNTS)/ AVG_COUNT) AS RATIO_TO_AVG
FROM
	(
		--a
		SELECT
		1 AS LINK ,
		DT_PRESCRIBED ,
		COUNT(*) AS COUNTS
		FROM
		SAILWWMCCV.CCU014_RRDA_WDDS
		WHERE
		YEAR(DT_PRESCRIBED) >= '2020'
		AND DT_PRESCRIBED < AVAIL_FROM_DT
		GROUP BY
		DT_PRESCRIBED
		ORDER BY
		DT_PRESCRIBED DESC 
	)a
	LEFT JOIN 
	(
		SELECT
		A.LINK,
		AVG(COUNTS*1.0) AS AVG_COUNT,
		SUM(COUNTS) AS TOTAL
		FROM
			(
			SELECT
			1 AS LINK ,
			DT_PRESCRIBED ,
			COUNT(*) AS COUNTS
			FROM
			SAILWWMCCV.CCU014_RRDA_WDDS
			WHERE
			YEAR(DT_PRESCRIBED) >= '2020'
			AND DT_PRESCRIBED < AVAIL_FROM_DT
			GROUP BY
			DT_PRESCRIBED
			ORDER BY
			DT_PRESCRIBED 
			)a
		GROUP BY LINK 
	)TOTAL 
	ON
	A.LINK = TOTAL.LINK
	ORDER BY
	DT_PRESCRIBED DESC
) ,
ROWS_PASS AS 
(
	SELECT 	* FROM 	COV
	WHERE
	RATIO_TO_AVG >= 0.7 
),
TWO_DATES AS 
(
	SELECT
	R.*,
	LAG(R.MAX_WDDS_DT) OVER (
	ORDER BY MAX_WDDS_DT DESC) LAG_DATE
	FROM
	ROWS_PASS R
	ORDER BY
	R.MAX_WDDS_DT DESC 
)
SELECT
MAX(DATES) AS MAX_COV_WDDS1_DT
FROM
	(
	SELECT
	MAX_WDDS_DT,
	LAG_DATE,
	(MAX_WDDS_DT + 1) AS DATE_CHECK,
	CASE
	WHEN LAG_DATE = (MAX_WDDS_DT + 1) THEN LAG_DATE
	ELSE NULL
	END AS DATES
	FROM
	TWO_DATES 
);