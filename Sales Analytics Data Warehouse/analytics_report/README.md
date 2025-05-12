**[Back to Main README](../README.md)**

# 📈 Business Insights and Reporting

**SQL reports delivering actionable insights from a PostgreSQL-based data warehouse** 📊

---

## 📋 Overview

This directory contains **SQL reports** that provide **business insights** from the **Sales Analytics Data Warehouse**. Built with **PostgreSQL**, these reports leverage the Gold layer’s star schema and views (`vw_customer_insights`, `vw_product_insights`) from [sales_analysis.sql](../analytics_report/sales_analysis.sql) to summarize customer behavior and product performance for stakeholders.

---

## 📂 Analysis Process
![analysis](https://github.com/jimi121/Data-Warehouse-Projects/blob/main/Sales%20Analytics%20Data%20Warehouse/doc/EDA%20steps.svg)

The **Exploratory Data Analysis (EDA)**, executed via [sales_analysis.sql](../analytics_report/sales_analysis.sql), follows a structured approach:

1. **Schema Analysis**: Mapping relationships in `dim_customers`, `dim_products`, `fact_sales`.
2. **Dimension Profiling**: Analyzing customer countries and product categories.
3. **Date Range Exploration**: Assessing sales data time range.
4. **Metric Evaluation**: Calculating total revenue and order counts.
5. **Magnitude Exploration**: Measuring sales and quantity magnitudes.
6. **Performance Rankings**: Identifying top customers and products.
7. **Time Series Analysis**: Tracking yearly and monthly sales patterns.
8. **Cumulative Metrics**: Computing running totals and averages.
9. **Performance Insights**: Evaluating business performance.
10. **Data Segmentation**: Grouping customers and products by metrics.
11. **Contribution Analysis**: Assessing regional and category contributions.

---

## 📝 Generated Reports

### 1. Customer Insights Report [customer_insights_reports.sql](../analytics_report/customer_insights/customer_insights_reports.sql) 👥
- **Purpose**: Analyzes customer behavior for marketing strategies.
- **Metrics**:
  - Demographics: Name, age, country.
  - Transaction History: Orders, revenue, quantities.
  - Segmentation: Tiers (e.g., VIP, Standard).
  - KPIs: Recency, Average Order Value (AOV), Monthly Spend.
- **Value**: Identifies high-value customers and informs retention efforts.

- **Check output** [here](../analytics_report/customer_insights/customer_metrics.csv)

### 2. Product Performance Report (`product_performance_report.sql`) 📦
- **Purpose**: Evaluates product sales for inventory decisions.
- **Metrics**:
  - Details: Name, category, cost.
  - Performance: Orders, revenue, quantities.
  - Segmentation: Tiers (e.g., Top Performer, Low Tier).
  - KPIs: Recency, Average Order Revenue (AOR), Monthly Revenue.
- **Value**: Highlights top products and guides development plans.

- **Check output** [here]((../analytics_report/product_performance/product_metrics))
---

## 🚀 Usage

### Prerequisites
- **PostgreSQL**: Install from [postgresql.org](https://www.postgresql.org/download/) 🌐
- **Data Warehouse**: Ensure data is loaded (see [Scripts README](../scripts/README.md)).

### Execution
1. **Generate Reports**:
   ```sql
   \i analytics_report/customer_insights/customer_insights_reports.sql
   \i analytics_report/product_performance/product_performance_report.sql

