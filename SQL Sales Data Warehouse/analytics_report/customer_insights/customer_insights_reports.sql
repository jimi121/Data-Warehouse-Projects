-- Customer Insights View
CREATE OR REPLACE VIEW gold.vw_customer_insights AS
WITH customer_data AS (
    SELECT 
        c.customer_key,
        c.customer_number,
        CONCAT(c.first_name, ' ', c.last_name) AS full_name,
        EXTRACT(YEAR FROM AGE(NOW(), c.birth_date)) AS age,
        f.order_date,
        f.order_number,
        f.product_key,
        f.sales_amount,
        f.quantity
    FROM gold.fact_sales f
    JOIN gold.dim_customers c ON f.customer_key = c.customer_key
    WHERE f.order_date IS NOT NULL
),
customer_metrics AS (
    SELECT 
        customer_key,
        customer_number,
        full_name,
        age,
        COUNT(DISTINCT order_number) AS total_orders,
        COUNT(DISTINCT product_key) AS unique_products,
        SUM(sales_amount) AS total_revenue,
        SUM(quantity) AS total_items,
        MIN(order_date) AS first_purchase,
        MAX(order_date) AS last_purchase,
        EXTRACT(YEAR FROM AGE(MAX(order_date), MIN(order_date))) * 12 +
        EXTRACT(MONTH FROM AGE(MAX(order_date), MIN(order_date))) AS tenure_months
    FROM customer_data
    GROUP BY customer_key, customer_number, full_name, age
)
SELECT 
    customer_number,
    customer_key,
    full_name,
    age,
    CASE 
        WHEN age < 20 THEN 'Under 20'
        WHEN age BETWEEN 20 AND 29 THEN '20s'
        WHEN age BETWEEN 30 AND 39 THEN '30s'
        WHEN age BETWEEN 40 AND 49 THEN '40s'
        ELSE '50+'
    END AS age_bracket,
    CASE 
        WHEN tenure_months >= 12 AND total_revenue > 5000 THEN 'VIP'
        WHEN tenure_months >= 12 THEN 'Standard'
        ELSE 'New comer'
    END AS customer_tier,
    total_orders,
    unique_products,
    total_items,
    total_revenue,
    last_purchase,
    EXTRACT(MONTH FROM AGE(CURRENT_DATE, last_purchase)) AS months_since_last,
    tenure_months,
    COALESCE(ROUND(total_revenue / NULLIF(total_orders, 0), 2), 0) AS avg_order_value,
    COALESCE(ROUND(total_revenue / NULLIF(tenure_months, 0), 2), 0) AS avg_monthly_spend
FROM customer_metrics
ORDER BY customer_number, customer_key;