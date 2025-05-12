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

-- ============================================================================
-- >> ERP Customer Table (erp_cust_az12)
-- ============================================================================

-- Check all columns and ensure transformations are working correctly
SELECT  
	cid,
	CASE 
		WHEN cid LIKE 'NAS%' THEN substring(cid, 4, length(cid))
		ELSE cid
	END AS new_cid,
	bdate,
	gen
FROM 
	bronze.erp_cust_az12

	-- Check for invalid birth dates
	SELECT   
		bdate
	FROM 
		bronze.erp_cust_az12
	WHERE  
		bdate < '1924-01-01' OR bdate > '2025-05-06';
	
	-- Standardize gender values
	SELECT  
		DISTINCT
		gen,
		CASE UPPER(TRIM(gen))
			WHEN 'F' THEN 'Female'
			WHEN 'M' THEN 'Male'
			ELSE 'Unknown'
		END AS new_gen
	FROM
		bronze.erp_cust_az12;
	
-- ============================================================================
-- >> ERP Location Table (erp_loc_a101)
-- ============================================================================

-- Check data standardization and consistency
SELECT 
	cid,
	replace(cid, '-', '') AS new_cid
FROM
	bronze.erp_loc_a101;

-- Standardize country names
SELECT DISTINCT
    cntry,
    CASE
        WHEN UPPER(TRIM(cntry)) IN ('USA', 'US', 'UNITED STATUS') THEN 'United States'
        WHEN UPPER(TRIM(cntry)) IN ('DE') THEN 'Germany'
        WHEN UPPER(TRIM(cntry)) IS NULL OR UPPER(TRIM(cntry)) = '' THEN 'Unknown'
        ELSE cntry
    END AS new_cntry
FROM
    bronze.erp_loc_a101;

-- ============================================================================
-- >> ERP Product Category Table (erp_px_cat_g1v2)
-- ============================================================================

-- Check for unwanted spaces in columns
SELECT DISTINCT
    cat,
    subcat,
    maintenance
FROM
    bronze.erp_px_cat_g1v2
WHERE
    cat != TRIM(cat) 
    OR subcat != TRIM(subcat) 
    OR maintenance != TRIM(maintenance);