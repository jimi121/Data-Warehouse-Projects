/*
===============================================================================
				DDL Script: Create Gold Views (PostgreSQL)
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/

-- =============================================================================
-- >> Create Dimension: gold.dim_customers
-- =============================================================================

CREATE OR REPLACE VIEW gold.dim_customers_v 
AS
SELECT
    ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,
    ci.cst_id AS customer_id,
    ci.cst_key AS customer_number,
    ci.cst_firstname AS first_name,
    ci.cst_lastname AS last_name,
    la.cntry AS country,
    ci.cst_marital_status AS marital_status,
     CASE 
        WHEN ci.cst_gndr = 'Unknown' THEN COALESCE(ca.gen, 'Unknown')
        ELSE ci.cst_gndr
    END AS gender,
    ca.bdate AS birth_date,
    ci.cst_create_date AS create_date
FROM
    silver.crm_cust_info AS ci
    LEFT JOIN silver.erp_cust_az12 AS ca 
    ON ci.cst_key = ca.cid
    LEFT JOIN silver.erp_loc_a101 AS la 
	ON ci.cst_key = la.cid;


-- =============================================================================
-- >> Create Dimension: gold.dim_products
-- =============================================================================
CREATE OR REPLACE VIEW gold.dim_products_v 
AS
SELECT
    ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.sls_prd_key) AS product_key,
    pn.prd_id AS product_id,
    pn.sls_prd_key AS product_number,
    pn.prd_nm AS product_name,  
    pn.cat_id AS category_id,
    pc.cat AS category,
    pc.subcat AS subcategory,
    pc.maintenance AS maintenance,
    pn.prd_cost AS product_cost,
    pn.prd_line AS product_line,
    pn.prd_start_dt AS start_date
FROM
    silver.crm_prd_info AS pn
    LEFT JOIN silver.erp_px_cat_g1v2 AS pc 
    ON pn.cat_id = pc.id
WHERE
    pn.prd_end_dt IS NULL; -- Filter out historical products
    
    
-- =============================================================================
-- >> Create Fact Table: gold.fact_sales
-- =============================================================================
CREATE OR REPLACE VIEW gold.fact_sales_v 
AS
SELECT
    sd.sls_ord_num AS order_number,
    pr.product_key,
    cu.customer_key,
    sd.sls_cust_id AS customer_id,
    sd.sls_order_dt AS order_date,
    sd.sls_ship_dt AS shipping_date,
    sd.sls_due_dt AS due_date,
    sd.sls_sales AS sales_amount,
    sd.sls_quantity AS quantity, 
    sd.sls_price AS price
FROM
    silver.crm_sales_details AS sd
    LEFT JOIN gold.dim_products_v AS pr 
    ON pr.product_number = sd.sls_prd_key
    LEFT JOIN gold.dim_customers_v AS cu 
	ON cu.customer_id = sd.sls_cust_id;



DO $$
DECLARE
    start_time TIMESTAMP;
    end_time TIMESTAMP;
    interval_diff INTERVAL;
    hours INTEGER;
    minutes INTEGER;
    seconds INTEGER;
    milliseconds INTEGER;
BEGIN
    start_time := NOW();
    RAISE NOTICE '-----------------------------------------------------------------------------------';
    RAISE NOTICE 'Starting view creation process at %', start_time;
    RAISE NOTICE '-----------------------------------------------------------------------------------';

    RAISE NOTICE 'Creating view gold.dim_customers_v';
    CREATE OR REPLACE VIEW gold.dim_customers_v AS
    SELECT
        ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,
        ci.cst_id AS customer_id,
        ci.cst_key AS customer_number,
        ci.cst_firstname AS first_name,
        ci.cst_lastname AS last_name,
        la.cntry AS country,
        ci.cst_marital_status AS marital_status,
        CASE 
            WHEN ci.cst_gndr = 'Unknown' THEN COALESCE(ca.gen, 'Unknown')
            ELSE ci.cst_gndr
        END AS gender,
        ca.bdate AS birth_date,
        ci.cst_create_date AS create_date
    FROM
        silver.crm_cust_info AS ci
        LEFT JOIN silver.erp_cust_az12 AS ca ON ci.cst_key = ca.cid
        LEFT JOIN silver.erp_loc_a101 AS la ON ci.cst_key = la.cid;
    RAISE NOTICE 'View gold.dim_customers_v created successfully';

    RAISE NOTICE 'Creating view gold.dim_products_v';
    CREATE OR REPLACE VIEW gold.dim_products_v AS
    SELECT
        ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.sls_prd_key) AS product_key,
        pn.prd_id AS product_id,
        pn.sls_prd_key AS product_number,
        pn.prd_nm AS product_name,
        pn.cat_id AS category_id,
        pc.cat AS category,
        pc.subcat AS subcategory,
        pc.maintenance AS maintenance,
        pn.prd_cost AS product_cost,
        pn.prd_line AS product_line,
        pn.prd_start_dt AS start_date
    FROM
        silver.crm_prd_info AS pn
        LEFT JOIN silver.erp_px_cat_g1v2 AS pc ON pn.cat_id = pc.id
    WHERE
        pn.prd_end_dt IS NULL;
    RAISE NOTICE 'View gold.dim_products_v created successfully';

    RAISE NOTICE 'Creating view gold.fact_sales_v';
    CREATE OR REPLACE VIEW gold.fact_sales_v AS
    SELECT
        sd.sls_ord_num AS order_number,
        pr.product_key,
        cu.customer_key,
        sd.sls_cust_id AS customer_id,
        sd.sls_order_dt AS order_date,
        sd.sls_ship_dt AS shipping_date,
        sd.sls_due_dt AS due_date,
        sd.sls_sales AS sales_amount,
        sd.sls_quantity AS quantity,
        sd.sls_price AS price
    FROM
        silver.crm_sales_details AS sd
        LEFT JOIN gold.dim_products_v AS pr ON pr.product_number = sd.sls_prd_key
        LEFT JOIN gold.dim_customers_v AS cu ON cu.customer_id = sd.sls_cust_id;
    RAISE NOTICE 'View gold.fact_sales_v created successfully';

    end_time := NOW();
    interval_diff := end_time - start_time;
    hours := EXTRACT(HOUR FROM interval_diff);
    minutes := EXTRACT(MINUTE FROM interval_diff);
    seconds := EXTRACT(SECOND FROM interval_diff)::INTEGER;
    milliseconds := EXTRACT(MILLISECONDS FROM interval_diff)::INTEGER % 1000;

    RAISE NOTICE '-----------------------------------------------------------------------------------';
    RAISE NOTICE 'All views created successfully';
    RAISE NOTICE 'Total duration: % hours, % minutes, % seconds, % milliseconds', hours, minutes, seconds, milliseconds;
    RAISE NOTICE '-----------------------------------------------------------------------------------';
END;
$$;
