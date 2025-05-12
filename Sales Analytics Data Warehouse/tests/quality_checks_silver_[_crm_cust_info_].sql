/*
===============================================================================
						Quality Checks for CRM Source
===============================================================================
Script Purpose:
    This script performs various quality checks for data consistency, accuracy, 
    and standardization across the 'silver' layer. It includes checks for:
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges and orders.
    - Data consistency between related fields.

Usage Notes:
    - Run these checks after data loading Silver Layer.
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/

/*
===============================================================================
>> crm_cust_info

- Check for Nulls & Duplicates in PK 
- Check Unwanted Spaces in columns
- Data Standardization & Consistency (cst_gndr)
- Data Standardization & Consistency (cst_marital_status)
- Check the Data Type
===============================================================================
*/

-------------------------------------------------
-- Check for Nulls & Duplicates in PK 
-- Expectation: No Result
-------------------------------------------------
SELECT 
	cst_id,
	COUNT(*)
FROM 
	bronze.crm_cust_info 
GROUP BY 
	cst_id 
HAVING 
	COUNT(*) > 1
	OR cst_id IS NULL;

-- Resolve the duplicate and null problem in PK
SELECT 
	*
FROM (
	SELECT 
		*,
		ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS rnk
	FROM 
		bronze.crm_cust_info
	WHERE 
		cst_id IS NOT NULL
	) AS subquery
WHERE rnk = 1;

-------------------------------------------------
-- Check for Unwanted Spaces
-- Expectation: No Results
-------------------------------------------------

SELECT 
	cst_firstname,
	cst_lastname
FROM 
	bronze.crm_cust_info
WHERE 
	cst_firstname != TRIM(cst_firstname)
	OR cst_lastname != TRIM(cst_lastname);

-- do for others columns to check if there is unwanted spaces in them

-------------------------------------------------
-- Data Standardization & Consistency (cst_gndr)
-------------------------------------------------

--1. first check the unique value in marital status column
SELECT 
	DISTINCT cst_gndr
FROM
	bronze.crm_cust_info;

--2. change the abbreviations to full names
SELECT 
	cst_gndr,
	CASE 
		WHEN cst_gndr = 'M' THEN 'Male'
		WHEN cst_gndr = 'F' THEN 'Female'
		ELSE 'Unknown'
	END AS new_gender
FROM 
	bronze.crm_cust_info;

--3. handle lower case value 
SELECT 
	cst_gndr,
	CASE 
		WHEN UPPER(cst_gndr) = 'M' THEN 'Male'
		WHEN UPPER(cst_gndr) = 'F' THEN 'Female'
		ELSE 'Unknown'
	END AS new_gender
FROM 
	bronze.crm_cust_info;

--4. handle unwanted space 
SELECT 
	cst_gndr,
	CASE 
		WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
		WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
		ELSE 'Unknown'
	END AS new_gender
FROM
	bronze.crm_cust_info;

----------------------------------------------------------
-- Data Standardization & Consistency (cst_marital_status)
----------------------------------------------------------

--1. first check the unique value in marital status column
SELECT 
	DISTINCT cst_marital_status
FROM 
	bronze.crm_cust_info;

--2. change the abbreviations to full names
SELECT 
	cst_marital_status,
	CASE 
		WHEN cst_marital_status = 'M' THEN 'Married'
		WHEN cst_marital_status = 'S' THEN 'Single'
		ELSE 'Unknown'
	END AS new_marital_st
FROM 
	bronze.crm_cust_info;

--3. handle lower case value 
SELECT 
	cst_marital_status,
	CASE 
		WHEN UPPER(cst_marital_status) = 'M' THEN 'Married'
		WHEN UPPER(cst_marital_status) = 'S' THEN 'Single'
		ELSE 'Unknown'
	END AS new_marital_st
FROM 
	bronze.crm_cust_info;

--4. handle unwanted space 
SELECT 
	cst_marital_status,
	CASE 
		WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
		WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
		ELSE 'Unknown'
	END AS new_marital_st
FROM 
	bronze.crm_cust_info;

------------------------------------------------
-- Check the Data Type for bronze.crm_cust_info
-------------------------------------------------
SELECT 
	column_name,
	data_type
FROM 
	information_schema.COLUMNS
WHERE 
	table_name = 'crm_cust_info'
	AND table_schema = 'bronze';
