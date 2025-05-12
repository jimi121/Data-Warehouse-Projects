**[Back to Main README](../README.md)**

# 📊 Sales Analytics Dashboard

**Power BI dashboard visualizing sales insights from a PostgreSQL-based data warehouse** 📈

---

## 📋 Overview

This directory contains a **Power BI dashboard** that visualizes **sales analytics** from the **Sales Analytics Data Warehouse**. Built with **PostgreSQL**, the dashboard connects directly to the **Gold layer tables** (`gold.dim_customers`, `gold.dim_products`, `gold.fact_sales`) to deliver insights on sales performance, regional trends, and growth opportunities. These tables are created in [schema_gold.sql](../scripts/Gold/DDL_Gold_Table.sql) and populated with analytics-ready data via [sales_analysis.sql](../analytics_report/sales_analysis.sql).

---

## 📊 Dashboard Insights

The dashboard provides a comprehensive view of sales performance from 2010–2014, derived from the Gold layer tables. Below are the key insights and their business implications.
![dashboard](https://github.com/jimi121/Data-Warehouse-Projects/blob/main/Sales%20Analytics%20Data%20Warehouse/dashboard/Dashboard.PNG)
### 1. Overall Sales Performance 📅
- **Total Sales**: $29 million across 60,000 items sold.
- **Year-over-Year (YoY) Growth**: 0.15% in 2014, a sharp decline from previous years.
- **Implication**: While sales volume is robust, growth is nearly stagnant, signaling a need for new strategies.

### 2. Regional Sales Breakdown 🌍
- **Top Markets**:
  - United States: $9 million (~20,500 items sold).
  - Australia: $9 million (~11,300 items sold).
  - United Kingdom: $3.4 million (~6,800 items sold).
  - Germany: $2.9 million (~5,600 items sold).
  - France: $2.6 million (data on items sold not specified).
- **Contribution**: United States and Australia account for 62% of total sales.
- **Implication**: Over-reliance on two markets poses a risk; diversification is essential.

### 3. Sales Growth Trends (2011–2014) 📉
- **Historical Growth**:
  - 2011: 16.78%
  - 2012: 17.37% (peak)
  - 2013: 1.76%
  - 2014: 0.97%
  - Current (2014): 0.15%
- **Implication**: Growth has slowed significantly, possibly due to market saturation or lack of innovation.

### 4. Regional Growth Rates 📈
- **Top Performer**: Canada at 0.48%.
- **Other Markets**:
  - United States: 0.18%
  - France: 0.12%
  - Germany and United Kingdom: 0.11%
  - Australia: 0.09%
- **Implication**: Canada shows the most growth potential, while larger markets like Australia lag.

### 5. Average Order Value (AOV) by Region 💰
- **Highest AOV**:
  - Germany: $1,165
  - Australia: $1,148
  - United Kingdom: $1,118
- **Other Regions**:
  - France: $1,064
  - United States: $994
  - Canada: $589
- **Implication**: Canada’s low AOV indicates a preference for budget items, while Germany and Australia favor higher-value purchases.

### 6. Quantities Sold by Region 📦
- **Top Regions**:
  - United States: ~20,500 items
  - Australia: ~11,300 items
  - Canada: 7,600 items
  - United Kingdom: 6,800 items
  - Germany: 5,600 items
- **Implication**: High sales volumes in the United States and Canada require strong inventory management.

---

## 💡 Business Recommendations

Based on the dashboard insights, the following strategies can drive growth and mitigate risks:

1. **Capitalize on Canada’s Growth Potential 🚀**:
   - **Insight**: Canada has the highest YoY growth (0.48%) but the lowest AOV ($589).
   - **Action**: Promote higher-value products from `dim_products` to increase AOV, and expand marketing efforts to attract more customers.

2. **Diversify Market Reliance 🌎**:
   - **Insight**: United States and Australia contribute 62% of sales.
   - **Action**: Increase marketing in the United Kingdom, Germany, and France, and explore new markets (e.g., Asia, South America).

3. **Address Stagnant Growth 📉**:
   - **Insight**: YoY growth has dropped to 0.15% from a peak of 17.37% in 2012.
   - **Action**: Introduce new product lines from `dim_products` and run promotions in key markets like the United States.

4. **Optimize Inventory and Logistics 📋**:
   - **Insight**: High sales volumes in the United States (20,500 items) and Canada (7,600 items).
   - **Action**: Ensure adequate stock and improve shipping efficiency to meet demand.

5. **Leverage High AOV Markets 💸**:
   - **Insight**: Germany ($1,165), Australia ($1,148), and the United Kingdom ($1,118) have high AOVs.
   - **Action**: Identify top products from `dim_products` in these regions and promote them in Canada and the United States to boost AOV.

---

## 🏗️ Integration with Data Warehouse

The dashboard connects directly to the **Gold layer tables** in PostgreSQL, specifically:
- **`dim_customers`**: Contains customer details (e.g., `customer_id`, `country`, `birth_date`).
- **`dim_products`**: Stores product information (e.g., `product_id`, `category`, `product_cost`).
- **`fact_sales`**: Records sales transactions (e.g., `order_date`, `sales_amount`, `quantity`).

These tables are created in [schema_gold.sql](../scripts/Gold/DDL_Gold_Table.sql) and populated with data processed through the **Medallion Architecture**:
- **Bronze Layer**: Raw data ingestion (see [Data README](../data/README.md)).
- **Silver Layer**: Cleaning and standardization (see [Scripts README](../scripts/README.md)).
- **Gold Layer**: Analytics-ready data with quality checks (see [Tests README](../tests/README.md)).

The analytics in [sales_analysis.sql](../scripts/Gold/sales_analysis.sql) preprocesses the data by:
- Aggregating sales metrics (`sales_amount`, `quantity`) from `fact_sales`.
- Joining with `dim_customers` for regional analysis (e.g., sales by `country`).
- Linking to `dim_products` for product performance (e.g., sales by `category`).

The customer and product reports ([Reports README](../analytics_report/README.md)) complement the dashboard by providing detailed SQL-based insights, which are visualized in Power BI.

---

## 🚀 Usage

### Prerequisites
- **PostgreSQL**: Install from [postgresql.org](https://www.postgresql.org/download/) 🌐
- **Power BI**: Install Power BI Desktop 📊
- **Data Warehouse**: Ensure data is loaded (see [Scripts README](../scripts/README.md)).

### Accessing the Dashboard
1. **Prepare Gold Layer Data**:
   ```sql
   \i scripts/gold/DDL_GOLD_TABLE.sql
   \i analytics_report/sales_analysis.sql
   ```

2. **Connect Power BI to PostgreSQL**:

- Use the PostgreSQL connector in Power BI.
-  Connect to the database and import the Gold layer tables (`gold.dim_customers`, `gold.dim_products`, `gold.fact_sales`).
- Create relationships in Power BI:
    - Join `fact_sales.customer_key` to `dim_customers.customer_key`.
    - Join `fact_sales.product_key` to `dim_products.product_key`.

3. **Open Dashboard**:

- Load the Power BI file (`dashboard/sales_dashboard.pbix`) to view visualizations.

**Dashboard File**: `dashboard/sales_dashboard.pbix`
