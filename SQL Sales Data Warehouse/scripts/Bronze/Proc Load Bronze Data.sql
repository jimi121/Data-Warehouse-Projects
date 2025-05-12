/*
===================================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===================================================================================

Script Purpose:
    This stored procedure loads data into 'Bronze' schema from eternal scv files.
    It Performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the 'COPY' command to load data from the csv files to bronze tables.
    - Calculate the time taken by each tables.
    - Calculate whole time of the Batch time to load.

Parameters:
    None,
    This stored procedure does not accept any parameters or return any values.

How to ues:
    CALL bronze.load_bronze();

======================================================================================================

*/

CREATE OR REPLACE PROCEDURE bronze.load_bronze()
LANGUAGE plpgsql
AS $$
DECLARE 
	rows_count			INTEGER;
	start_time			TIMESTAMP;
	end_time			TIMESTAMP;
	interval_diff		INTERVAL;
	hours				INTEGER;
	minutes				INTEGER;
	seconds				INTEGER;
	milliseconds		INTEGER;
	batch_start_time	TIMESTAMP;
	batch_end_time		TIMESTAMP;
BEGIN
	RAISE NOTICE '======================================================================================';
	RAISE NOTICE '=========================== LOADING BRONZE LAYER =====================================';
	RAISE NOTICE '======================================================================================';
	RAISE NOTICE '';
	
	RAISE NOTICE '-------------------------------------------------------------';
	RAISE NOTICE '---------------- LOADING CRM TABLES -------------------------';
	RAISE NOTICE '-------------------------------------------------------------';
	RAISE NOTICE '';
	 
	-----------------------------------------------------------------------------------------------------
	batch_start_time := NOW();
	start_time := NOW();
	-- Truncate the table and then import the CSV file
	RAISE NOTICE '>> Truncate Table and insert into bronze.crm_cust_info';
	TRUNCATE TABLE bronze.crm_cust_info;
	COPY bronze.crm_cust_info
	FROM 'C:\Users\USER\Desktop\PORTFOLIO PROJECT\SQL\Sales Data Warehouse\datasets\source_crm\cust_info.csv'
	DELIMITERS ','
	CSV HEADER;
	GET DIAGNOSTICS rows_count = ROW_COUNT;
	RAISE NOTICE 'crm_cust_info: % rows affected', rows_count;
	--TIME
	end_time := NOW();
	interval_diff = end_time - start_time;
	hours := EXTRACT(HOUR FROM interval_diff);
	minutes := EXTRACT(MINUTE FROM interval_diff);
	seconds := EXTRACT(SECOND FROM interval_diff);
	milliseconds := EXTRACT(MILLISECONDS FROM interval_diff);
	RAISE NOTICE 'Load Duration: % hours, % minutes, % seconds, % milliseconds', hours, minutes, seconds, milliseconds;
	RAISE NOTICE '';
	
	----------------------------------------------------------------------------------------------------
	
	----------------------------------------------------------------------------------------------------
	start_time := NOW();
	-- Truncate the table and then import the csv file 
	RAISE NOTICE '>> Truncate Table and insert into bronze.crm_prd_info';
	TRUNCATE TABLE bronze.crm_prd_info;
	COPY bronze.crm_prd_info
	FROM 'C:\Users\USER\Desktop\PORTFOLIO PROJECT\SQL\Sales Data Warehouse\datasets\source_crm\prd_info.csv'
	DELIMITERS ','
	CSV HEADER;
	GET DIAGNOSTICS rows_count = ROW_COUNT;
	RAISE NOTICE 'crm_prd_info: % rows affected', rows_count;
	--TIME
	end_time := NOW();
	interval_diff := end_time - start_time;
	hours := EXTRACT(HOUR FROM interval_diff);
	minutes := EXTRACT(MINUTE FROM interval_diff);
	seconds := EXTRACT(SECOND FROM interval_diff);
	milliseconds := EXTRACT(MILLISECONDS FROM interval_diff);
	RAISE NOTICE 'Load Duration: % hours, % minutes, % seconds, % milliseconds', hours, minutes, seconds, milliseconds;
	RAISE NOTICE '';

	------------------------------------------------------------------------------------------------------
	
	------------------------------------------------------------------------------------------------------
	start_time := NOW();
	-- Truncate the table and then import the csv file
	RAISE NOTICE '>> Truncate Table and insert into bronze.crm_sales_details';
	TRUNCATE TABLE bronze.crm_sales_details;
	COPY bronze.crm_sales_details
	FROM 'C:\Users\USER\Desktop\PORTFOLIO PROJECT\SQL\Sales Data Warehouse\datasets\source_crm\sales_details.csv'
	DELIMITERS ','
	CSV HEADER;
	GET DIAGNOSTICS rows_count = ROW_COUNT;
	RAISE NOTICE 'crm_sales_details: % rows affected', rows_count;
	--TIME
	end_time := NOW();
	interval_diff := end_time - start_time;
	hours := EXTRACT(HOUR FROM interval_diff);
	minutes := EXTRACT(MINUTE FROM interval_diff);
	seconds := EXTRACT(MINUTE FROM interval_diff);
	milliseconds := EXTRACT(MILLISECONDS FROM interval_diff);
	RAISE NOTICE 'Load Duration: % hours, % minutes, % seconds, % milliseconds', hours, minutes, seconds, milliseconds;
	RAISE NOTICE '';
	
	--------------------------------------------------------------------------------------------------------
	 
	 RAISE NOTICE '-------------------------------------------------------------';
	 RAISE NOTICE '--------------- LOADING ERP TABLES --------------------------';
	 RAISE NOTICE '-------------------------------------------------------------';
	 RAISE NOTICE '';
	 
	--------------------------------------------------------------------------------------------------------
	start_time := NOW();
	-- Truncate the Table & then Import the csv file
	RAISE NOTICE '>> Truncate Table and insert into bronze.erp_cust_az12';
	TRUNCATE TABLE bronze.erp_cust_az12;
	COPY bronze.erp_cust_az12
	FROM 'C:\Users\USER\Desktop\PORTFOLIO PROJECT\SQL\Sales Data Warehouse\datasets\source_erp\CUST_AZ12.csv'
	DELIMITER ','
	CSV HEADER;
	GET DIAGNOSTICS rows_count = ROW_COUNT;
    RAISE NOTICE 'erp_cust_az12: % rows affected', rows_count;

	-- TIME
	end_time := NOW();
    interval_diff := end_time - start_time;
	hours := EXTRACT(HOUR FROM interval_diff);
    minutes := EXTRACT(MINUTE FROM interval_diff);
    seconds := EXTRACT(SECOND FROM interval_diff);
    milliseconds := EXTRACT(MILLISECONDS FROM interval_diff);
	RAISE NOTICE 'Load Duration: % hours, % minutes, % seconds, % milliseconds', hours, minutes, seconds, milliseconds;
    RAISE NOTICE '';
	--------------------------------------------------------------------------------------------------------
	
	--------------------------------------------------------------------------------------------------------
	start_time := NOW();
	-- Truncate the Table & then Import the csv file
	RAISE NOTICE '>> Truncate Table and insert into silver.erp_loc_a101';
	TRUNCATE TABLE bronze.erp_loc_a101;
	COPY bronze.erp_loc_a101
	FROM 'C:\Users\USER\Desktop\PORTFOLIO PROJECT\SQL\Sales Data Warehouse\datasets\source_erp\LOC_A101.csv'
	DELIMITER ','
	CSV HEADER;
	GET DIAGNOSTICS rows_count = ROW_COUNT;
    RAISE NOTICE 'erp_loc_a101: % rows affected', rows_count;

	-- TIME
	end_time := NOW();
    interval_diff := end_time - start_time;
	hours := EXTRACT(HOUR FROM interval_diff);
    minutes := EXTRACT(MINUTE FROM interval_diff);
    seconds := EXTRACT(SECOND FROM interval_diff);
    milliseconds := EXTRACT(MILLISECONDS FROM interval_diff);
	RAISE NOTICE 'Load Duration: % hours, % minutes, % seconds, % milliseconds', hours, minutes, seconds, milliseconds;
    RAISE NOTICE '';
	----------------------------------------------------------------------------------------------------------
	
	----------------------------------------------------------------------------------------------------------
	start_time := NOW();
	-- Truncate the Table & then Import the csv file
	RAISE NOTICE '>> Truncate Table and insert into silver.erp_px_cat_g1v2';
	TRUNCATE TABLE bronze.erp_px_cat_g1v2;
	COPY bronze.erp_px_cat_g1v2
	FROM 'C:\Users\USER\Desktop\PORTFOLIO PROJECT\SQL\Sales Data Warehouse\datasets\source_erp\PX_CAT_G1V2.csv'
	DELIMITER ','
	CSV HEADER;
	GET DIAGNOSTICS rows_count = ROW_COUNT;
    RAISE NOTICE 'erp_px_cat_g1v2: % rows affected', rows_count;

	-- TIME
	end_time := NOW();
    interval_diff := end_time - start_time;
	hours := EXTRACT(HOUR FROM interval_diff);
    minutes := EXTRACT(MINUTE FROM interval_diff);
    seconds := EXTRACT(SECOND FROM interval_diff);
    milliseconds := EXTRACT(MILLISECONDS FROM interval_diff);
	RAISE NOTICE 'Load Duration: % hours, % minutes, % seconds, % milliseconds', hours, minutes, seconds, milliseconds;
    RAISE NOTICE '';
	----------------------------------------------------------------------------------------------------------
	
	RAISE NOTICE '-----------------------------------------------------------------------------------';
	RAISE NOTICE '-------------------- Loading Bronze Layer completed--------------------------------';
	batch_end_time := NOW();
	interval_diff := batch_end_time - batch_start_time;
	hours := EXTRACT(HOUR FROM interval_diff);
	minutes := EXTRACT(MINUTE FROM interval_diff);
    seconds := EXTRACT(SECOND FROM interval_diff);
    milliseconds := EXTRACT(MILLISECONDS FROM interval_diff);
	RAISE NOTICE 'Bronze Layer Loading Duration: % hours, % minutes, % seconds, % milliseconds', hours, minutes, seconds, milliseconds;
	RAISE NOTICE '----------------------------------------------------------------------------------';
	RAISE NOTICE '';
	
	-- Error Handling Logic
	EXCEPTION
	    WHEN OTHERS THEN
	        RAISE NOTICE '----------------------------------------------------';
	        RAISE NOTICE '---- ERROR OCCURRED DURING LOADING BRONZE LAYER -----';
	        RAISE NOTICE 'Error Message: %', SQLERRM;
	        RAISE NOTICE 'Error Code: %', SQLSTATE;
	        RAISE NOTICE 'Error Detail: %', COALESCE(PG_EXCEPTION_DETAIL, 'N/A');
	        RAISE NOTICE 'Error Hint: %', COALESCE(PG_EXCEPTION_HINT, 'N/A');
	        RAISE NOTICE '----------------------------------------------------';
	        RAISE NOTICE '';

			-- Rollback the transaction
            ROLLBACK;
END;
$$;

CALL bronze.load_bronze();


















