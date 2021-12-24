-----------------------------------------------
--fixed timeshot OF WDDS DATA AT 2021-11-12 FOR CCU014
--by: fatemeh.torabi@swansea.ac.uk
-----------------------------------------------
CALL FNC.DROP_IF_EXISTS ('SAILWWMCCV.CCU014_RRDA_WDDS');

CREATE TABLE SAILWWMCCV.CCU014_RRDA_WDDS as
(
SELECT * FROM SAILWMCCV.C19_COHORT20_RRDA_WDDS
)WITH NO DATA; 

COMMIT; 

ALTER TABLE SAILWWMCCV.CCU014_RRDA_WDDS ACTIVATE NOT LOGGED INITIALLY;

---2018
INSERT INTO SAILWWMCCV.CCU014_RRDA_WDDS
SELECT * FROM SAILWMCCV.C19_COHORT20_RRDA_WDDS
WHERE year(DT_PRESCRIBED) = '2018' AND month(DT_PRESCRIBED)=1;
INSERT INTO SAILWWMCCV.CCU014_RRDA_WDDS
SELECT * FROM SAILWMCCV.C19_COHORT20_RRDA_WDDS
WHERE year(DT_PRESCRIBED) = '2018' AND month(DT_PRESCRIBED)=2;
INSERT INTO SAILWWMCCV.CCU014_RRDA_WDDS
SELECT * FROM SAILWMCCV.C19_COHORT20_RRDA_WDDS
WHERE year(DT_PRESCRIBED) = '2018' AND month(DT_PRESCRIBED)=3;
INSERT INTO SAILWWMCCV.CCU014_RRDA_WDDS
SELECT * FROM SAILWMCCV.C19_COHORT20_RRDA_WDDS
WHERE year(DT_PRESCRIBED) = '2018' AND month(DT_PRESCRIBED)=4;
INSERT INTO SAILWWMCCV.CCU014_RRDA_WDDS
SELECT * FROM SAILWMCCV.C19_COHORT20_RRDA_WDDS
WHERE year(DT_PRESCRIBED) = '2018' AND month(DT_PRESCRIBED)=5;
INSERT INTO SAILWWMCCV.CCU014_RRDA_WDDS
SELECT * FROM SAILWMCCV.C19_COHORT20_RRDA_WDDS
WHERE year(DT_PRESCRIBED) = '2018' AND month(DT_PRESCRIBED)=6;
INSERT INTO SAILWWMCCV.CCU014_RRDA_WDDS
SELECT * FROM SAILWMCCV.C19_COHORT20_RRDA_WDDS
WHERE year(DT_PRESCRIBED) = '2018' AND month(DT_PRESCRIBED)=7;
INSERT INTO SAILWWMCCV.CCU014_RRDA_WDDS
SELECT * FROM SAILWMCCV.C19_COHORT20_RRDA_WDDS
WHERE year(DT_PRESCRIBED) = '2018' AND month(DT_PRESCRIBED)=8;
INSERT INTO SAILWWMCCV.CCU014_RRDA_WDDS
SELECT * FROM SAILWMCCV.C19_COHORT20_RRDA_WDDS
WHERE year(DT_PRESCRIBED) = '2018' AND month(DT_PRESCRIBED)=9;
INSERT INTO SAILWWMCCV.CCU014_RRDA_WDDS
SELECT * FROM SAILWMCCV.C19_COHORT20_RRDA_WDDS
WHERE year(DT_PRESCRIBED) = '2018' AND month(DT_PRESCRIBED)=10;
INSERT INTO SAILWWMCCV.CCU014_RRDA_WDDS
SELECT * FROM SAILWMCCV.C19_COHORT20_RRDA_WDDS
WHERE year(DT_PRESCRIBED) = '2018' AND month(DT_PRESCRIBED)=11;
INSERT INTO SAILWWMCCV.CCU014_RRDA_WDDS
SELECT * FROM SAILWMCCV.C19_COHORT20_RRDA_WDDS
WHERE year(DT_PRESCRIBED) = '2018' AND month(DT_PRESCRIBED)=12;
---2019
INSERT INTO SAILWWMCCV.CCU014_RRDA_WDDS
SELECT * FROM SAILWMCCV.C19_COHORT20_RRDA_WDDS
WHERE year(DT_PRESCRIBED) = '2019' AND month(DT_PRESCRIBED)=1;
INSERT INTO SAILWWMCCV.CCU014_RRDA_WDDS
SELECT * FROM SAILWMCCV.C19_COHORT20_RRDA_WDDS
WHERE year(DT_PRESCRIBED) = '2019' AND month(DT_PRESCRIBED)=2;
INSERT INTO SAILWWMCCV.CCU014_RRDA_WDDS
SELECT * FROM SAILWMCCV.C19_COHORT20_RRDA_WDDS
WHERE year(DT_PRESCRIBED) = '2019' AND month(DT_PRESCRIBED)=3;
INSERT INTO SAILWWMCCV.CCU014_RRDA_WDDS
SELECT * FROM SAILWMCCV.C19_COHORT20_RRDA_WDDS
WHERE year(DT_PRESCRIBED) = '2019' AND month(DT_PRESCRIBED)=4;
INSERT INTO SAILWWMCCV.CCU014_RRDA_WDDS
SELECT * FROM SAILWMCCV.C19_COHORT20_RRDA_WDDS
WHERE year(DT_PRESCRIBED) = '2019' AND month(DT_PRESCRIBED)=5;
INSERT INTO SAILWWMCCV.CCU014_RRDA_WDDS
SELECT * FROM SAILWMCCV.C19_COHORT20_RRDA_WDDS
WHERE year(DT_PRESCRIBED) = '2019' AND month(DT_PRESCRIBED)=6;
INSERT INTO SAILWWMCCV.CCU014_RRDA_WDDS
SELECT * FROM SAILWMCCV.C19_COHORT20_RRDA_WDDS
WHERE year(DT_PRESCRIBED) = '2019' AND month(DT_PRESCRIBED)=7;
INSERT INTO SAILWWMCCV.CCU014_RRDA_WDDS
SELECT * FROM SAILWMCCV.C19_COHORT20_RRDA_WDDS
WHERE year(DT_PRESCRIBED) = '2019' AND month(DT_PRESCRIBED)=8;
INSERT INTO SAILWWMCCV.CCU014_RRDA_WDDS
SELECT * FROM SAILWMCCV.C19_COHORT20_RRDA_WDDS
WHERE year(DT_PRESCRIBED) = '2019' AND month(DT_PRESCRIBED)=9;
INSERT INTO SAILWWMCCV.CCU014_RRDA_WDDS
SELECT * FROM SAILWMCCV.C19_COHORT20_RRDA_WDDS
WHERE year(DT_PRESCRIBED) = '2019' AND month(DT_PRESCRIBED)=10;
INSERT INTO SAILWWMCCV.CCU014_RRDA_WDDS
SELECT * FROM SAILWMCCV.C19_COHORT20_RRDA_WDDS
WHERE year(DT_PRESCRIBED) = '2019' AND month(DT_PRESCRIBED)=11;
INSERT INTO SAILWWMCCV.CCU014_RRDA_WDDS
SELECT * FROM SAILWMCCV.C19_COHORT20_RRDA_WDDS
WHERE year(DT_PRESCRIBED) = '2019' AND month(DT_PRESCRIBED)=12;
---2020
INSERT INTO SAILWWMCCV.CCU014_RRDA_WDDS
SELECT * FROM SAILWMCCV.C19_COHORT20_RRDA_WDDS
WHERE year(DT_PRESCRIBED) = '2020' AND month(DT_PRESCRIBED)=1;
INSERT INTO SAILWWMCCV.CCU014_RRDA_WDDS
SELECT * FROM SAILWMCCV.C19_COHORT20_RRDA_WDDS
WHERE year(DT_PRESCRIBED) = '2020' AND month(DT_PRESCRIBED)=2;
INSERT INTO SAILWWMCCV.CCU014_RRDA_WDDS
SELECT * FROM SAILWMCCV.C19_COHORT20_RRDA_WDDS
WHERE year(DT_PRESCRIBED) = '2020' AND month(DT_PRESCRIBED)=3;
INSERT INTO SAILWWMCCV.CCU014_RRDA_WDDS
SELECT * FROM SAILWMCCV.C19_COHORT20_RRDA_WDDS
WHERE year(DT_PRESCRIBED) = '2020' AND month(DT_PRESCRIBED)=4;
INSERT INTO SAILWWMCCV.CCU014_RRDA_WDDS
SELECT * FROM SAILWMCCV.C19_COHORT20_RRDA_WDDS
WHERE year(DT_PRESCRIBED) = '2020' AND month(DT_PRESCRIBED)=5;
INSERT INTO SAILWWMCCV.CCU014_RRDA_WDDS
SELECT * FROM SAILWMCCV.C19_COHORT20_RRDA_WDDS
WHERE year(DT_PRESCRIBED) = '2020' AND month(DT_PRESCRIBED)=6;
INSERT INTO SAILWWMCCV.CCU014_RRDA_WDDS
SELECT * FROM SAILWMCCV.C19_COHORT20_RRDA_WDDS
WHERE year(DT_PRESCRIBED) = '2020' AND month(DT_PRESCRIBED)=7;
INSERT INTO SAILWWMCCV.CCU014_RRDA_WDDS
SELECT * FROM SAILWMCCV.C19_COHORT20_RRDA_WDDS
WHERE year(DT_PRESCRIBED) = '2020' AND month(DT_PRESCRIBED)=8;
INSERT INTO SAILWWMCCV.CCU014_RRDA_WDDS
SELECT * FROM SAILWMCCV.C19_COHORT20_RRDA_WDDS
WHERE year(DT_PRESCRIBED) = '2020' AND month(DT_PRESCRIBED)=9;
INSERT INTO SAILWWMCCV.CCU014_RRDA_WDDS
SELECT * FROM SAILWMCCV.C19_COHORT20_RRDA_WDDS
WHERE year(DT_PRESCRIBED) = '2020' AND month(DT_PRESCRIBED)=10;
INSERT INTO SAILWWMCCV.CCU014_RRDA_WDDS
SELECT * FROM SAILWMCCV.C19_COHORT20_RRDA_WDDS
WHERE year(DT_PRESCRIBED) = '2020' AND month(DT_PRESCRIBED)=11;
INSERT INTO SAILWWMCCV.CCU014_RRDA_WDDS
SELECT * FROM SAILWMCCV.C19_COHORT20_RRDA_WDDS
WHERE year(DT_PRESCRIBED) = '2020' AND month(DT_PRESCRIBED)=12;
---2021
INSERT INTO SAILWWMCCV.CCU014_RRDA_WDDS
SELECT * FROM SAILWMCCV.C19_COHORT20_RRDA_WDDS
WHERE year(DT_PRESCRIBED) = '2021' AND month(DT_PRESCRIBED)=1;
INSERT INTO SAILWWMCCV.CCU014_RRDA_WDDS
SELECT * FROM SAILWMCCV.C19_COHORT20_RRDA_WDDS
WHERE year(DT_PRESCRIBED) = '2021' AND month(DT_PRESCRIBED)=2;
INSERT INTO SAILWWMCCV.CCU014_RRDA_WDDS
SELECT * FROM SAILWMCCV.C19_COHORT20_RRDA_WDDS
WHERE year(DT_PRESCRIBED) = '2021' AND month(DT_PRESCRIBED)=3;
INSERT INTO SAILWWMCCV.CCU014_RRDA_WDDS
SELECT * FROM SAILWMCCV.C19_COHORT20_RRDA_WDDS
WHERE year(DT_PRESCRIBED) = '2021' AND month(DT_PRESCRIBED)=4;
INSERT INTO SAILWWMCCV.CCU014_RRDA_WDDS
SELECT * FROM SAILWMCCV.C19_COHORT20_RRDA_WDDS
WHERE year(DT_PRESCRIBED) = '2021' AND month(DT_PRESCRIBED)=5;
INSERT INTO SAILWWMCCV.CCU014_RRDA_WDDS
SELECT * FROM SAILWMCCV.C19_COHORT20_RRDA_WDDS
WHERE year(DT_PRESCRIBED) = '2021' AND month(DT_PRESCRIBED)=6;
INSERT INTO SAILWWMCCV.CCU014_RRDA_WDDS
SELECT * FROM SAILWMCCV.C19_COHORT20_RRDA_WDDS
WHERE year(DT_PRESCRIBED) = '2021' AND month(DT_PRESCRIBED)=7;
INSERT INTO SAILWWMCCV.CCU014_RRDA_WDDS
SELECT * FROM SAILWMCCV.C19_COHORT20_RRDA_WDDS
WHERE year(DT_PRESCRIBED) = '2021' AND month(DT_PRESCRIBED)=8;

--CHECK
SELECT count(*) FROM SAILWWMCCV.CCU014_RRDA_WDDS;---503,360,499


SELECT DISTINCT YEAR(DT_PRESCRIBED), count(*) FROM SAILWWMCCV.CCU014_RRDA_WDDS
GROUP BY YEAR(DT_PRESCRIBED); 

SELECT DISTINCT MONTH(DT_PRESCRIBED), count(*) FROM SAILWWMCCV.CCU014_RRDA_WDDS
GROUP BY MONTH(DT_PRESCRIBED);

