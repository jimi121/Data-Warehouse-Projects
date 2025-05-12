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

>> Table: crm_prd_info

 	-- Check for NULLs or Duplicates in Primary Key
 	-- Check for Unwanted Spaces
 	-- Check for NULLs or Negative Values in Cost
 	-- Data Standardization & Consistency
 	-- Check for Invalid Date Orders (Start Date > End Date)
===============================================================================
*/

-------------------------------------------------
-- Check for NULLs or Duplicates in Primary Key
-------------------------------------------------
SELECT
	prd_id,
	count(*)
FROM
	bronze.crm_prd_info
GROUP BY 
	prd_id 
HAVING count(*) > 1
	OR prd_id IS NULL;

-- 2. Resolve the duplicate and null problem in PK
SELECT 
	*
FROM (
	SELECT 
		*,
		ROW_NUMBER() OVER (PARTITION BY prd_id ORDER BY prd_start_dt DESC) AS rnk
	FROM 
		bronze.crm_prd_info
	) subquery
WHERE 
	rnk=1 AND prd_id IS NOT NULL;

-------------------------------------------------
-- Check for Unwanted Spaces (prd_nm)
-------------------------------------------------
SELECT 
	prd_nm
FROM 
	bronze.crm_prd_info
WHERE 
	prd_nm != TRIM(prd_nm);

-- do for others columns to check if there is unwanted spaces in them

-------------------------------------------------
-- Check for NULLs or Negative Values (prd_cost)
-------------------------------------------------

SELECT 
	prd_cost
FROM 
	bronze.crm_prd_info
WHERE 
	prd_cost < 0 
	OR prd_cost IS NULL;

-- 2. resolve the null problem in the prd_cost
SELECT 
	prd_cost,
	COALESCE(prd_cost,0) AS new_prd_cost,
	CASE 
		WHEN COALESCE(prd_cost,0) < 0 THEN ABS(COALESCE(prd_cost,0)) ELSE COALESCE(prd_cost,0) 
	END AS prd_cost
FROM 
	bronze.crm_prd_info;

-------------------------------------------------
-- Data Standardization & Consistency
-------------------------------------------------

SELECT 
	DISTINCT prd_line
FROM 
	bronze.crm_prd_info;

--2. change the abbreviations to full names
SELECT
	prd_line,
	CASE 
		WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
		WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
		WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
		WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
		ELSE 'Unknown'
	END AS new_prd_line
FROM 
	bronze.crm_prd_info;

SELECT * FROM bronze.crm_prd_info cpi;

--------------------------------------------------------------------
-- Extract prd_key and cat_id from prd_key and replace '_' with '-'
--------------------------------------------------------------------

SELECT  
	prd_key,
	REPLACE(SUBSTRING(prd_key, 1,5),'_', '-') AS prd_key,
	REPLACE(SUBSTRING(prd_key, 7, length(prd_key)),'_', '-') AS cat_id
FROM bronze.crm_prd_info;

----------------------------------------------------------------------
-- Check if the prduction start date and production end date are valid
-----------------------------------------------------------------------
SELECT  
	prd_key,
	prd_start_dt,
	prd_end_dt
FROM bronze.crm_prd_info;

--2. Calculate end date as one day before the next start date

SELECT  
	prd_key,
	prd_start_dt,
	prd_end_dt,
	lead(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) AS new_end_dt
FROM bronze.crm_prd_info;