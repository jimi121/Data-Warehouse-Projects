/*
================================================================================
Sales Data Analysis Script
================================================================================
Purpose:
  - Deliver a detailed analysis of sales data across customer and product dimensions.
  - Compute essential metrics and segment data for actionable business insights.
  - Provide reusable views for streamlined reporting.

Structure:
  1. Dimensions Overview: Examine the scope of customer and product attributes.
  2. Time Span Analysis: Assess the temporal extent of sales and customer data.
  3. Key Metrics Summary: Aggregate critical business performance indicators.
  4. Distribution Insights: Evaluate data spread across key dimensions.
  5. Performance Rankings: Highlight top and bottom performers.
  6. Temporal Trends: Analyze changes and patterns over time.
  7. Running Totals: Compute cumulative metrics and moving averages.
  8. Product Trends: Assess product performance year-over-year.
  9. Segmentation Analysis: Categorize data for targeted insights.
 10. Contribution Analysis: Measure category impacts on overall metrics.
 11. Reporting Views: Establish views for customer and product reports.

Notes:
  - Assumes 'gold' schema with tables: dim_customers, dim_products, fact_sales.
  - Handles NULL values in date fields and prevents division-by-zero errors.
  - Uses consistent formatting and naming for clarity and professionalism.
================================================================================
*/

-- ==============================================================================
-- 1. Dimensions Overview
-- Purpose: Identify unique attributes in customer and product dimensions.
-- ==============================================================================
-- Unique customer countries
SELECT DISTINCT country AS customer_country
FROM gold.dim_customers
ORDER BY customer_country;

-- Unique product attributes
SELECT DISTINCT 
    category,
    subcategory,
    product_name
FROM gold.dim_products
ORDER BY category, subcategory, product_name;

-- ==============================================================================
-- 2. Time Span Analysis
-- Purpose: Determine the earliest and latest data points for sales and customers.
-- ==============================================================================
-- Sales date range by country
SELECT 
    c.country,
    MIN(s.order_date) AS earliest_sale,
    MAX(s.order_date) AS latest_sale,
    AGE(MAX(s.order_date), MIN(s.order_date)) AS sales_duration
FROM gold.fact_sales s
JOIN gold.dim_customers c ON s.customer_key = c.customer_key
GROUP BY c.country
ORDER BY sales_duration DESC;

-- Customer age extremes
WITH customer_age AS (
    SELECT 
        CONCAT(first_name, ' ', last_name) AS full_name,
        EXTRACT(YEAR FROM AGE(NOW(), birth_date)) AS current_age
    FROM gold.dim_customers
    WHERE birth_date IS NOT NULL
)
SELECT 
    'Youngest' AS age_category,
    MIN(current_age) AS age
FROM customer_age
UNION ALL
SELECT 
    'Oldest' AS age_category,
    MAX(current_age) AS age
FROM customer_age;

-- ==============================================================================
-- 3. Key Metrics Summary
-- Purpose: Provide a consolidated view of essential business metrics.
-- ==============================================================================
SELECT 
    'Total Revenue' AS metric_name,
    SUM(sales_amount) AS metric_value
FROM gold.fact_sales
UNION ALL
SELECT 
    'Items Sold',
    SUM(quantity)
FROM gold.fact_sales
UNION ALL
SELECT 
    'Average Unit Price',
    ROUND(AVG(price), 2)
FROM gold.fact_sales
UNION ALL
SELECT 
    'Unique Orders',
    COUNT(DISTINCT order_number)
FROM gold.fact_sales
UNION ALL
SELECT 
    'Unique Products Sold',
    COUNT(DISTINCT product_key)
FROM gold.fact_sales
UNION ALL
SELECT 
    'Active Customers',
    COUNT(DISTINCT customer_key)
FROM gold.fact_sales
ORDER BY metric_name;

-- ==============================================================================
-- 4. Distribution Insights
-- Purpose: Analyze how data is distributed across various dimensions.
-- ==============================================================================
-- Customers per country
SELECT 
    country,
    COUNT(customer_key) AS customer_count
FROM gold.dim_customers
GROUP BY country
ORDER BY customer_count DESC;

-- Customers by gender
SELECT 
    gender,
    COUNT(customer_key) AS customer_count
FROM gold.dim_customers
GROUP BY gender
ORDER BY customer_count DESC;

-- Products per category
SELECT 
    category,
    COUNT(product_key) AS product_count
FROM gold.dim_products
GROUP BY category
ORDER BY product_count DESC;

-- Average product cost by category
SELECT 
    category,
    ROUND(AVG(cost), 2) AS avg_cost
FROM gold.dim_products
GROUP BY category
ORDER BY avg_cost DESC;

-- Revenue by product category
SELECT 
    p.category,
    SUM(f.sales_amount) AS category_revenue
FROM gold.fact_sales f
JOIN gold.dim_products p ON f.product_key = p.product_key
GROUP BY p.category
ORDER BY category_revenue DESC;

-- Revenue by customer
SELECT 
    c.customer_key,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    SUM(f.sales_amount) AS total_spent
FROM gold.fact_sales f
JOIN gold.dim_customers c ON f.customer_key = c.customer_key
GROUP BY c.customer_key, customer_name
ORDER BY total_spent DESC;

-- Items sold by country
SELECT 
    c.country,
    SUM(f.quantity) AS total_items_sold
FROM gold.fact_sales f
JOIN gold.dim_customers c ON f.customer_key = c.customer_key
GROUP BY c.country
ORDER BY total_items_sold DESC;

-- ==============================================================================
-- 5. Performance Rankings
-- Purpose: Rank entities based on performance metrics.
-- ==============================================================================
-- Top 5 revenue-generating products
SELECT 
    p.product_name,
    SUM(f.sales_amount) AS revenue
FROM gold.fact_sales f
JOIN gold.dim_products p ON f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY revenue DESC
LIMIT 5;

-- Bottom 5 products by revenue
SELECT 
    p.product_name,
    SUM(f.sales_amount) AS revenue
FROM gold.fact_sales f
JOIN gold.dim_products p ON f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY revenue ASC
LIMIT 5;

-- Top 10 customers by revenue
SELECT 
    c.customer_key,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    SUM(f.sales_amount) AS revenue
FROM gold.fact_sales f
JOIN gold.dim_customers c ON f.customer_key = c.customer_key
GROUP BY c.customer_key, customer_name
ORDER BY revenue DESC
LIMIT 10;

-- Customers with fewest orders (Top 3)
SELECT 
    c.customer_key,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(DISTINCT f.order_number) AS order_count
FROM gold.fact_sales f
JOIN gold.dim_customers c ON f.customer_key = c.customer_key
GROUP BY c.customer_key, customer_name
ORDER BY order_count ASC
LIMIT 3;

-- ==============================================================================
-- 6. Temporal Trends
-- Purpose: Track sales performance over time.
-- ==============================================================================
-- Annual sales overview
SELECT 
    EXTRACT(YEAR FROM order_date) AS sale_year,
    SUM(sales_amount) AS yearly_revenue,
    COUNT(DISTINCT customer_key) AS yearly_customers,
    SUM(quantity) AS yearly_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY sale_year
ORDER BY sale_year;

-- Monthly sales overview
SELECT 
    TO_CHAR(order_date, 'YYYY-MM') AS sale_month,
    SUM(sales_amount) AS monthly_revenue,
    COUNT(DISTINCT customer_key) AS monthly_customers,
    SUM(quantity) AS monthly_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY sale_month
ORDER BY sale_month;

-- ==============================================================================
-- 7. Running Totals
-- Purpose: Calculate cumulative metrics over time.
-- ==============================================================================
-- Yearly cumulative sales and moving average price
WITH annual_metrics AS (
    SELECT 
        EXTRACT(YEAR FROM order_date) AS year,
        SUM(sales_amount) AS yearly_sales,
        AVG(price) AS avg_price
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY year
)
SELECT 
    year,
    yearly_sales,
    ROUND(avg_price, 2) AS avg_price,
    SUM(yearly_sales) OVER (ORDER BY year) AS cumulative_sales,
    ROUND(AVG(avg_price) OVER (ORDER BY year), 2) AS moving_avg_price
FROM annual_metrics
ORDER BY year;

-- Monthly cumulative sales and moving average price
WITH monthly_metrics AS (
    SELECT 
        TO_CHAR(order_date, 'YYYY-MM') AS month,
        SUM(sales_amount) AS monthly_sales,
        AVG(price) AS avg_price
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY month
)
SELECT 
    month,
    monthly_sales,
    ROUND(avg_price, 2) AS avg_price,
    SUM(monthly_sales) OVER (ORDER BY month) AS cumulative_sales,
    ROUND(AVG(avg_price) OVER (ORDER BY month), 2) AS moving_avg_price
FROM monthly_metrics
ORDER BY month;

-- ==============================================================================
-- 8. Product Trends
-- Purpose: Evaluate product performance across years.
-- ==============================================================================
WITH product_yearly AS (
    SELECT 
        EXTRACT(YEAR FROM f.order_date) AS year,
        p.product_name,
        SUM(f.sales_amount) AS yearly_sales
    FROM gold.fact_sales f
    JOIN gold.dim_products p ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL
    GROUP BY year, p.product_name
),
trend_analysis AS (
    SELECT 
        year,
        product_name,
        yearly_sales,
        AVG(yearly_sales) OVER (PARTITION BY product_name) AS avg_sales,
        LAG(yearly_sales) OVER (PARTITION BY product_name ORDER BY year) AS prior_year_sales
    FROM product_yearly
)
SELECT 
    year,
    product_name,
    yearly_sales,
    ROUND(avg_sales, 2) AS avg_sales,
    ROUND(yearly_sales - avg_sales, 2) AS variance_from_avg,
    CASE 
        WHEN yearly_sales > avg_sales THEN 'Above Avg'
        WHEN yearly_sales < avg_sales THEN 'Below Avg'
        ELSE 'On Avg'
    END AS performance_flag,
    prior_year_sales,
    ROUND(yearly_sales - prior_year_sales, 2) AS year_on_year_change,
    CASE 
        WHEN yearly_sales > prior_year_sales THEN 'Growth'
        WHEN yearly_sales < prior_year_sales THEN 'Decline'
        ELSE 'Stable'
    END AS trend
FROM trend_analysis
ORDER BY product_name, year;

-- ==============================================================================
-- 9. Segmentation Analysis
-- Purpose: Group data into segments for deeper insights.
-- ==============================================================================
-- Product cost segmentation
SELECT 
    CASE 
        WHEN product_cost < 100 THEN 'Under 100'
        WHEN product_cost BETWEEN 100 AND 500 THEN '100-500'
        WHEN product_cost BETWEEN 500 AND 1000 THEN '500-1000'
        ELSE 'Over 1000'
    END AS cost_segment,
    COUNT(product_key) AS product_count
FROM gold.dim_products
GROUP BY cost_segment
ORDER BY product_count DESC;

-- Customer segmentation by tenure and spending
WITH customer_summary AS (
    SELECT 
        c.customer_key,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        SUM(f.sales_amount) AS total_spent,
        EXTRACT(YEAR FROM AGE(MAX(f.order_date), MIN(f.order_date))) * 12 +
        EXTRACT(MONTH FROM AGE(MAX(f.order_date), MIN(f.order_date))) AS tenure_months
    FROM gold.fact_sales f
    JOIN gold.dim_customers c ON f.customer_key = c.customer_key
    WHERE f.order_date IS NOT NULL
    GROUP BY c.customer_key, customer_name
)
SELECT 
    customer_key,
    customer_name,
    total_spent,
    tenure_months,
    CASE 
        WHEN tenure_months >= 12 AND total_spent > 5000 THEN 'Premium'
        WHEN tenure_months >= 12 THEN 'Loyal'
        ELSE 'Recent'
    END AS segment
FROM customer_summary
ORDER BY total_spent DESC;

-- ==============================================================================
-- 10. Contribution Analysis
-- Purpose: Assess how parts contribute to the whole.
-- ==============================================================================
-- Category sales contribution
WITH category_totals AS (
    SELECT 
        p.category,
        SUM(f.sales_amount) AS category_sales
    FROM gold.fact_sales f
    JOIN gold.dim_products p ON f.product_key = p.product_key
    GROUP BY p.category
)
SELECT 
    category,
    category_sales,
    SUM(category_sales) OVER () AS total_sales,
    ROUND((category_sales * 100.0 / SUM(category_sales) OVER ()), 2) || '%' AS contribution_percent
FROM category_totals
ORDER BY contribution_percent DESC;

-- Regional sales contribution
WITH region_totals AS (
    SELECT 
        c.country AS region,
        SUM(f.sales_amount) AS region_sales
    FROM gold.fact_sales f
    JOIN gold.dim_customers c ON f.customer_key = c.customer_key
    GROUP BY c.country
)
SELECT 
    region,
    region_sales,
    SUM(region_sales) OVER () AS total_sales,
    ROUND((region_sales * 100.0 / SUM(region_sales) OVER ()), 2) || '%' AS contribution_percent
FROM region_totals
ORDER BY contribution_percent DESC;

-- ==============================================================================
-- 11. Reporting Views
-- Purpose: Create persistent views for customer and product reporting.
-- ==============================================================================
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

/*
================================================================================
End of Sales Data Analysis Script
================================================================================
*/