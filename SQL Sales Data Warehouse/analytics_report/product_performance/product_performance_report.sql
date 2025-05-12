-- Product Insights View
CREATE OR REPLACE VIEW gold.vw_product_insights AS
WITH product_data AS (
    SELECT 
        f.order_date,
        f.order_number,
        f.customer_key,
        f.sales_amount,
        f.quantity,
        p.product_key,
        p.product_name,
        p.category,
        p.subcategory,
        p.product_cost AS unit_cost
    FROM gold.fact_sales f
    JOIN gold.dim_products p ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL
),
product_metrics AS (
    SELECT 
        product_key,
        product_name,
        category,
        subcategory,
        unit_cost,
        COUNT(DISTINCT order_number) AS total_orders,
        COUNT(DISTINCT customer_key) AS unique_customers,
        SUM(sales_amount) AS total_revenue,
        SUM(quantity) AS total_units_sold,
        MIN(order_date) AS first_sale,
        MAX(order_date) AS last_sale,
        EXTRACT(YEAR FROM AGE(MAX(order_date), MIN(order_date))) * 12 +
        EXTRACT(MONTH FROM AGE(MAX(order_date), MIN(order_date))) AS sales_tenure_months
    FROM product_data
    GROUP BY product_key, product_name, category, subcategory, unit_cost
)
SELECT 
    product_key,
    product_name,
    category,
    subcategory,
    unit_cost,
    total_orders,
    unique_customers,
    total_units_sold,
    total_revenue,
    last_sale,
    EXTRACT(MONTH FROM AGE(CURRENT_DATE, last_sale)) AS months_since_last_sale,
    sales_tenure_months,
    CASE 
        WHEN total_revenue > 50000 THEN 'Top Performer'
        WHEN total_revenue BETWEEN 10000 AND 50000 THEN 'Mid Tier'
        ELSE 'Low Tier'
    END AS performance_segment,
    COALESCE(ROUND(total_revenue / NULLIF(total_orders, 0), 2), 0) AS avg_revenue_per_order,
    COALESCE(ROUND(total_revenue / NULLIF(sales_tenure_months, 0), 2), 0) AS avg_monthly_revenue
FROM product_metrics
ORDER BY product_key;
