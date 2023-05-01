USE saheen_db.public;

CREATE OR REPLACE TABLE CONSUMER_COMPLAINTS
(
DATE_RECEIVED STRING,
PRODUCT_NAME VARCHAR2(50),
SUB_PRODUCT VARCHAR2(100),
ISSUE VARCHAR2(100),
SUB_ISSUE VARCHAR2(100),
CONSUMER_COMPLAINT_NARRATIVE STRING,
Company_Public_Response STRING,
Company VARCHAR(100),
State_Name CHAR(4),
Zip_Code STRING,
Tags VARCHAR(60),
Consumer_Consent_Provided CHAR(25),
Submitted_via STRING,
Date_Sent_to_Company STRING,
Company_Response_to_Consumer VARCHAR(80),
Timely_Response CHAR(4),
CONSUMER_DISPUTED CHAR(4),
COMPLAINT_ID NUMBER(12,0) NOT NULL PRIMARY KEY
);



CREATE OR REPLACE STORAGE INTEGRATION s3_storage_integration
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::168690745982:role/mySnowflakeRole'
  STORAGE_ALLOWED_LOCATIONS = ('s3://snowflake-stage-bucket/Consumer Complaints/');

  
DESC STORAGE INTEGRATION s3_storage_integration;


CREATE OR REPLACE STAGE s3_stage_consumer_complaints
  STORAGE_INTEGRATION = s3_storage_integration
  URL = 's3://snowflake-stage-bucket/Consumer Complaints/'
  FILE_FORMAT = CSV;


SHOW STAGES;

LIST @SAHEEN_DB.PUBLIC.s3_stage_consumer_complaints;


COPY INTO SAHEEN_DB.PUBLIC.CONSUMER_COMPLAINTS
FROM  @SAHEEN_DB.PUBLIC.s3_stage_consumer_complaints
FILES = ('ConsumerComplaints_cleaned.csv')
FILE_FORMAT = (FORMAT_NAME='csv');


SELECT * FROM SAHEEN_DB.PUBLIC.CONSUMER_COMPLAINTS;





-- Queries

SELECT * FROM CONSUMER_COMPLAINTS LIMIT 50;

SELECT DISTINCT PRODUCT_NAME FROM CONSUMER_COMPLAINTS;

DESC TABLE CONSUMER_COMPLAINTS;



// Now, Query a result with 
// --Consumer Loan -- Student Loan -- Payday Loan from PRODUCT_NAME COLUMN as a SINGLE COLUMN
// other products as "OTHER FIN PRODUCTS"

SELECT
CASE WHEN PRODUCT_NAME IN ('Consumer Loan','Student loan','Payday loan') THEN 'LOAN PRODUCT'
     ELSE 'OTHER FIN PRODUCT'
END AS PRODUCT_TYPE
,*
FROM CONSUMER_COMPLAINTS
LIMIT 50;




// To view the distinct date values from DATE_SENT_TO_COMPANY Column:

SELECT DISTINCT DATE_SENT_TO_COMPANY FROM CONSUMER_COMPLAINTS; -- Doesn't work because the column is in String Format.

SELECT DISTINCT YEAR(DATE(DATE_SENT_TO_COMPANY,'DD-MM-YYYY')) FROM CONSUMER_COMPLAINTS;
-- OR
SELECT DISTINCT YEAR(TO_DATE(DATE_SENT_TO_COMPANY,'DD-MM-YYYY'))FROM CONSUMER_COMPLAINTS;
-- OR
SELECT DISTINCT(SUBSTR(DATE_SENT_TO_COMPANY,7,12)) FROM CONSUMER_COMPLAINTS;
-- OR
SELECT DISTINCT(EXTRACT(YEAR FROM(TO_DATE(DATE_SENT_TO_COMPANY,'DD-MM-YYYY')))) FROM CONSUMER_COMPLAINTS;


SHOW COLUMNS IN CONSUMER_COMPLAINTS;




// Query a result with the column TXN_PERIOD which has the following flags:
-- 1st JAN 2013 - 31st DEC 2013 --> ppr12
-- 1st JAN 2014 - 31st DEC 2014 --> pr12
-- 1st JAN 2015 - 31st DEC 2015 --> r12

SELECT CASE 
    WHEN DATE(DATE_RECEIVED,'DD-MM-YYYY') BETWEEN '2013-01-01' AND '2013-12-31' THEN 'PPR12'
    WHEN DATE(DATE_RECEIVED,'DD-MM-YYYY') BETWEEN '2014-01-01' AND '2014-12-31' THEN 'PR12'
    WHEN DATE(DATE_RECEIVED,'DD-MM-YYYY') BETWEEN '2015-01-01' AND '2015-12-31' THEN 'R12'
    ELSE DATE_RECEIVED
    END AS TXN_PERIOD
,*
FROM CONSUMER_COMPLAINTS;


SELECT DISTINCT TXN_PERIOD
FROM
(
SELECT CASE 
    WHEN DATE(DATE_RECEIVED,'DD-MM-YYYY') BETWEEN '2013-01-01' AND '2013-12-31' THEN 'PPR12'
    WHEN DATE(DATE_RECEIVED,'DD-MM-YYYY') BETWEEN '2014-01-01' AND '2014-12-31' THEN 'PR12'
    WHEN DATE(DATE_RECEIVED,'DD-MM-YYYY') BETWEEN '2015-01-01' AND '2015-12-31' THEN 'R12'
    ELSE DATE_RECEIVED
    END AS TXN_PERIOD
,*
FROM CONSUMER_COMPLAINTS
)flag;