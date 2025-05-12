/*
===============================================================================
DDL Script: Create Gold Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'gold' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'gold' Tables
===============================================================================
*/

-- Create the tables for gold schema

DO $$
BEGIN
    -- Drop and create dim_customers
    RAISE NOTICE 'Dropping and creating dim_customers table';
    DROP TABLE IF EXISTS gold.dim_customers CASCADE;
    CREATE TABLE gold.dim_customers (
        customer_key           INT PRIMARY KEY,  
        customer_id            INT,
        customer_number        VARCHAR(255),  
        first_name             VARCHAR(255),
        last_name              VARCHAR(255),
        country                VARCHAR(255),
        marital_status         VARCHAR(255),
        gender                 VARCHAR(255),
        birth_date             DATE,
        create_date            TIMESTAMP WITH TIME ZONE 
    );

    -- Drop and create dim_products
    RAISE NOTICE 'Dropping and creating dim_products table';
    DROP TABLE IF EXISTS gold.dim_products CASCADE;
    CREATE TABLE gold.dim_products (
        product_key           INT PRIMARY KEY,  
        product_id            INT,
        product_number        VARCHAR(255),
        product_name          VARCHAR(255),
        category_id           VARCHAR(10),
        category              VARCHAR(255),
        subcategory           VARCHAR(255),
        maintenance           VARCHAR(10), 
        product_cost          NUMERIC,  
        product_line          VARCHAR(255),
        start_dt              DATE
    );

    -- Drop and create fact_sales
    RAISE NOTICE 'Dropping and creating fact_sales table';
    DROP TABLE IF EXISTS gold.fact_sales;
    CREATE TABLE gold.fact_sales (
        order_number        VARCHAR(255),
        product_key         INT,
        customer_key        INT,
        customer_id         INT,
        order_date          DATE,
        shipping_date       DATE,
        due_date            DATE,
        sales_amount        NUMERIC,  
        quantity            INT,
        price               NUMERIC, 
        FOREIGN KEY (product_key) REFERENCES gold.dim_products(product_key),
        FOREIGN KEY  (customer_key) REFERENCES gold.dim_customers(customer_key)
    );

    RAISE NOTICE 'Tables creation completed';
	
	EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '----------------------------------------------------';
        RAISE NOTICE '---- ERROR OCCURRED DURING GOLD LAYER TABLES CREATION -----';
        RAISE NOTICE 'Error Message: %', SQLERRM;
        RAISE NOTICE 'Error Code: %', SQLSTATE;
        RAISE NOTICE 'Error Detail: %', COALESCE(PG_EXCEPTION_DETAIL, 'N/A');
        RAISE NOTICE 'Error Hint: %', COALESCE(PG_EXCEPTION_HINT, 'N/A');
        RAISE NOTICE '----------------------------------------------------';

        -- Rollback the transaction
        ROLLBACK;
        RAISE EXCEPTION 'Gold Layer tables creation failed. Transaction rolled back.';
END;
$$;


-- Load Data from View into the tables
DO $$
DECLARE
    rows_count INTEGER;
    start_time TIMESTAMP;
    end_time TIMESTAMP;
    interval_diff INTERVAL;
    hours INTEGER;
    minutes INTEGER;
    seconds INTEGER;
    milliseconds INTEGER;
BEGIN
    -- Start of the batch
    RAISE NOTICE '-----------------------------------------------------------------------------------';
    RAISE NOTICE 'Starting Gold Layer Data Load at %', NOW();
    RAISE NOTICE '-----------------------------------------------------------------------------------';
    
    -- Initialize start time for the entire batch
    start_time := NOW();

    -- Step 1: Process dim_customers
    RAISE NOTICE '>> Truncating dim_customers table';
    TRUNCATE TABLE gold.dim_customers CASCADE;

    RAISE NOTICE '>> Inserting data into dim_customers table from the view';
    INSERT INTO gold.dim_customers
    SELECT * FROM gold.dim_customers_v;
    GET DIAGNOSTICS rows_count = ROW_COUNT;
    RAISE NOTICE '>> dim_customers: % rows inserted', rows_count;

    -- Step 2: Process dim_products
    RAISE NOTICE '>> Truncating dim_products table';
    TRUNCATE TABLE gold.dim_products CASCADE;

    RAISE NOTICE '>> Inserting data into dim_products table from the view';
    INSERT INTO gold.dim_products
    SELECT * FROM gold.dim_products_v;
    GET DIAGNOSTICS rows_count = ROW_COUNT;
    RAISE NOTICE '>> dim_products: % rows inserted', rows_count;

    -- Step 3: Process fact_sales
    RAISE NOTICE '>> Truncating fact_sales table';
    TRUNCATE TABLE gold.fact_sales CASCADE;

    RAISE NOTICE '>> Inserting data into fact_sales table from the view';
    INSERT INTO gold.fact_sales
    SELECT * FROM gold.fact_sales_v;
    GET DIAGNOSTICS rows_count = ROW_COUNT;
    RAISE NOTICE '>> fact_sales: % rows inserted', rows_count;

    -- Verify data load
    RAISE NOTICE '-----------------------------------------------------------------------------------';
    RAISE NOTICE 'Verifying Data Load';
    RAISE NOTICE '-----------------------------------------------------------------------------------';

    SELECT COUNT(*) INTO rows_count FROM gold.dim_customers;
    RAISE NOTICE '>> dim_customers: % rows', rows_count;

    SELECT COUNT(*) INTO rows_count FROM gold.dim_products;
    RAISE NOTICE '>> dim_products: % rows', rows_count;

    SELECT COUNT(*) INTO rows_count FROM gold.fact_sales;
    RAISE NOTICE '>> fact_sales: % rows', rows_count;

    -- Calculate and log total duration
    end_time := NOW();
    interval_diff := end_time - start_time;
    hours := EXTRACT(HOUR FROM interval_diff);
    minutes := EXTRACT(MINUTE FROM interval_diff);
    seconds := EXTRACT(SECOND FROM interval_diff)::INTEGER;
    milliseconds := EXTRACT(MILLISECONDS FROM interval_diff)::INTEGER % 1000;

    RAISE NOTICE '-----------------------------------------------------------------------------------';
    RAISE NOTICE 'Gold Layer Data Load Completed Successfully';
    RAISE NOTICE 'Total Duration: % hours, % minutes, % seconds, % milliseconds', hours, minutes, seconds, milliseconds;
    RAISE NOTICE '-----------------------------------------------------------------------------------';

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '----------------------------------------------------';
        RAISE NOTICE '---- ERROR OCCURRED DURING GOLD LAYER LOADING -----';
        RAISE NOTICE 'Error Message: %', SQLERRM;
        RAISE NOTICE 'Error Code: %', SQLSTATE;
        RAISE NOTICE 'Error Detail: %', COALESCE(PG_EXCEPTION_DETAIL, 'N/A');
        RAISE NOTICE 'Error Hint: %', COALESCE(PG_EXCEPTION_HINT, 'N/A');
        RAISE NOTICE '----------------------------------------------------';

        -- Rollback the transaction
        ROLLBACK;
        RAISE EXCEPTION 'Gold Layer loading failed. Transaction rolled back.';
END;
$$;


-- Inspect the structure of each table
-- Customers table
SELECT  
	column_name,
	data_type
FROM
	information_schema.COLUMNS 
WHERE  
	table_name = 'dim_customers';

-- Products table 
SELECT  
	column_name,
	data_type
FROM
	information_schema.COLUMNS 
WHERE  
	table_name = 'dim_products';

-- fact_sales
SELECT  
	column_name,
	data_type
FROM
	information_schema.COLUMNS 
WHERE  
	table_name = 'fact_sales';


