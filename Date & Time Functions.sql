-- SQL DATE FUNCTIONS

-- GET CURRENT DATE
SELECT CURRENT_DATE;

-- GET CURRENT TIME
SELECT CURRENT_TIMESTAMP;

-- GET CURRENT DATE
SELECT CURRENT_TIME;

-- GET THE CURRENT TIMEZONE DETAILS
SHOW PARAMETERS LIKE '%TIMEZONE%';

-- CONVERT TIMEZONE
SELECT CONVERT_TIMEZONE('UTC',CURRENT_TIMESTAMP) AS UTC_TIMEZONE;

SELECT CONVERT_TIMEZONE ('Europe/Warsaw','UTC', '2019-01-01 00:00:00' :: timestamp_ntz) AS CONV; -- HERE, :: MEANS TO TYPECAST INTO A DIFFERENT FORMAT. HERE ITS TO CONVERT TO TIMESTAMP_NTZ

USE DATABASE SAHEEN_DB;

-- Altering a TIMEZONE
ALTER SESSION SET timestamp_type_mapping = timestamp_ntz;
CREATE OR REPLACE TABLE ts_test(ts timestamp);
DESCRIBE TABLE ts_test;


CREATE OR REPLACE TABLE ts_test(ts timestamp_ltz);
ALTER SESSION SET timezone = 'America/Los_Angeles';

INSERT INTO ts_test VALUES('2014-01-01 16:00:00');          -- The timezone is UTC
INSERT INTO ts_test VALUES('2014-01-01 16:00:00 +00:00');   -- The timezone is UTC - 08:00 HRS
SELECT * FROM ts_test;                                      -- Note that the time for January 2nd is 08:00 in Los Angeles (which is 16:00 in UTC)

-- Taking just the HOUR from the timestamp
SELECT ts, hour(ts) FROM ts_test;


-- CONVERT DATE TO SUBSEQUENT 4 MONTHS AHEAD
SELECT ADD_MONTHS(CURRENT_DATE,4) AS DATE_AFTER_4_MONTHS;


-- 3 MONTHS BACK DATE
SELECT ADD_MONTHS(CURRENT_DATE,-3) AS DATE_BEFORE_3_MONTHS;

SELECT ADD_MONTHS(CURRENT_DATE,5) AS DATE_5_MNTHS_AHEAD;

SELECT TO_CHAR(ADD_MONTHS(CURRENT_DATE,-3),'DD-MM-YYYY') as DATE_BEFORE_3_MONTHS;

SELECT TO_VARCHAR(ADD_MONTHS(CURRENT_DATE,-3),'MM-DD-YYYY') as DATE_BEFORE_3_MONTHS;


-- GET YR FROM DATE
SELECT DATE_TRUNC('YEAR',CURRENT_DATE) AS YR_FROM_DATE;

-- GET MTH FROM DATE
SELECT DATE_TRUNC('MONTH',CURRENT_DATE) AS MTH_FROM_DATE;

-- GET DAY FROM DATE
SELECT DATE_TRUNC('DAY',CURRENT_DATE) AS DAY_FROM_DATE;

-- To get the CURRENT WEEK NUMBER
SELECT WEEK(CURRENT_DATE) AS CURRENT_WEEK;
SELECT WEEK(CURRENT_TIMESTAMP);

--To extract WEEK from a list of dates in a table, (TAKING ts_test TABLE as ref,)

INSERT INTO ts_test VALUES('2023-04-11 20:30:00 +05:30');
SELECT * FROM ts_test;
SELECT *, WEEK(ts) AS WEEK FROM ts_test;

-- To extract each day, month, year and week in seperate columns
SELECT *, DAY(ts), MONTH(ts), YEAR(ts), WEEK(ts) AS WEEK FROM ts_test;

-- Extracting, month, day, hour, minutes, seconds from current_timestamp
SELECT
  YEAR(current_timestamp),
  MONTH(current_timestamp),
  DAY(current_timestamp),
  HOUR( current_timestamp),
  MINUTE(current_timestamp),
  SECOND(current_timestamp);


-- GET LAST DAY OF current MONTH
SELECT LAST_DAY(CURRENT_DATE) AS last_day_curr_month;

-- GET LAST DAY OF NEXT MONTH
SELECT LAST_DAY(CURRENT_DATE + INTERVAL '1 MONTH') AS last_day_next_month;

-- GET LAST DAY OF PREVIOUS MONTH
SELECT LAST_DAY(CURRENT_DATE - INTERVAL '1 MONTH') AS LAST_DAY_PREV_MNTH;

-- GET FIRST DAY OF PREVIOUS MONTH
SELECT LAST_DAY(CURRENT_DATE - INTERVAL '2 MONTH') + INTERVAL '1 DAY' AS FIRST_DAY;

-- SELECT CURRENT QUARTER OF YEAR
SELECT QUARTER(CURRENT_DATE) AS QTR;

SELECT EXTRACT(YEAR FROM CURRENT_DATE) AS YR;
SELECT EXTRACT(MONTH FROM CURRENT_DATE) AS MTH;
SELECT EXTRACT(DAY FROM CURRENT_DATE) AS DAY;

--To get the qtr of a particular date
SELECT QUARTER(TO_DATE('2022-08-24'));          -- HERE WE HAVE TO FIRRST CONVERT THE DATE INTO DATE FORMAT AND THEN FIND THGE QTR

-- To record a specific date in a different format, we should use the below format
SELECT TO_DATE('08-23-2022','mm-dd-yyyy');

--If the date is in default format, we use the belown format
SELECT TO_DATE('1993-08-17') AS DATE;

-- If we want to display the date in a specific local format
SELECT TO_CHAR(TO_DATE('1993-08-17'),'DD-MM-YYYY') AS DATE_DD_MM_YYYY; --THIS WILL BE HIGHLY USED

SELECT TO_CHAR(TO_DATE('1993-08-17'),'MM-YYYY') AS MM_YYYY;

SELECT TO_CHAR(TO_DATE('1993-08-17'),'MON-YYYY') AS MON_YYYY;

SELECT TO_CHAR(TO_DATE('1993-08-17'),'MON-YY') AS DATE_MON_YY;

SELECT TO_CHAR(TO_DATE('1993-08-17'),'DY') AS DATE_DAY;

SELECT TO_CHAR(TO_DATE('1993-08-17'),'DY-DD-MM-YYYY') AS DATE_DAY;

-- To display the day name
SELECT DAYNAME('1993-08-23');
SELECT DAYNAME(CURRENT_DATE);

SELECT TO_CHAR(TO_DATE('1993-08-17'),'YYYY-DD') AS DATE;
SELECT TO_CHAR(TO_DATE('1993-08-17'),'DD-MM') AS DATE;

SELECT DATEDIFF('DAY','2022-06-01',CURRENT_DATE);
SELECT DATEDIFF('DAY','2022-07-23','2023-07-19');

SELECT DATEDIFF('MONTH','2021-06-01',CURRENT_DATE);
SELECT DATEDIFF('YEAR', '2014-06-01',CURRENT_DATE);

SELECT DATEADD('DAY',-23,'2022-06-01');
SELECT DATEADD('MONTH',-2,'2022-06-01');
SELECT DATEADD('YEAR',-5,'2022-06-01');


SELECT
    months_between('2019-03-15'::date,                          -- HERE, :: MEANS TO TYPECAST INTO A DIFFERENT FORMAT. HERE ITS TO CONVERT TO DATE
                   '2019-02-15'::date) as monthsbetween1,
    months_between('2019-03-31'::date,
                   '2020-02-28'::date) as monthsbetween2;
