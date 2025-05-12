# Sales Analytics Data Warehouse

**A PostgreSQL-based data warehouse leveraging the Medallion Architecture for comprehensive sales analytics**

![image](https://github.com/jimi121/Data-Warehouse-Projects/blob/main/Sales%20Analytics%20Data%20Warehouse/doc/SQL_Projects.svg)
---

## Project Summary

This repository showcases an **end-to-end data warehouse solution** built to process and analyze sales data using **PostgreSQL**. By implementing the **Medallion Architecture**, the project transforms raw data into a structured, analytics-ready format through robust ETL processes and advanced SQL queries. The core focus is delivering actionable insights into sales performance, customer behavior, and product trends.

### Objectives
- **ETL Pipeline**: Extract, transform, and load data from raw sources to a star schema.
- **Data Modeling**: Create fact and dimension tables for efficient analytics.
- **Analytics**: Generate insights through SQL queries, including segmentation, rankings, and trends.
- **Documentation**: Provide clear metadata and diagrams for transparency.

---

## Medallion Architecture

The project is structured using the **Medallion Architecture**, with three distinct layers:

- **Bronze Layer**: Raw data ingested from CSV files (e.g., ERP/CRM systems).
- **Silver Layer**: Cleaned and standardized data, ready for transformation.
- **Gold Layer**: Curated data in a star schema, optimized for analytics (e.g., `dim_customers`, `dim_products`, `fact_sales`).

### Architecture Diagram
![Medallion Flow](https://github.com/jimi121/Data-Warehouse-Projects/blob/main/Sales%20Analytics%20Data%20Warehouse/doc/Data_Architecture.png)  

---

## Project Features

### Technical Components
- **Data Ingestion**: Load raw sales data into PostgreSQL.
- **Data Cleaning**: Handle missing values, duplicates, and inconsistencies.
- **Star Schema**: Implement tables (`dim_customers`, `dim_products`, `fact_sales`) and views (`vw_customer_insights`, `vw_product_insights`) for analytics.
- **SQL Analytics**: Perform detailed analysis, including time series analysis, data segmentation, and contribution analysis see [sales_analysis.sql](analytics_report/sales_analysis.sql).
- **Scalability**: Design for handling large datasets efficiently.

### Skills Highlighted
- **Data Engineering**: Developing ETL pipelines with SQL.
- **SQL Proficiency**: Writing optimized queries for data processing and analytics.
- **Data Architecture**: Structuring a warehouse using the Medallion Architecture.
- **Business Insights**: Translating data into strategic recommendations.

### Technology Stack
- **Database**: PostgreSQL
- **ETL**: SQL scripts
- **Visualization**: Power BI
- **Documentation**: Draw.io, Notion
---

## 📂 Repository Structure

| Directory       | Description                                      | Details                     |
|-----------------|--------------------------------------------------|-----------------------------|
| `data/`         | Raw dataset from CRM/ERP sources                | [📋 README](data/README.md) |
| `scripts/`      | ETL pipeline and analytics scripts              | [⚙️ README](scripts/README.md) |
| `tests/`        | Data quality assurance scripts                  | [✅ README](tests/README.md) |
| `analytics/`    | SQL reports for business insights               | [📈 README](analytics/README.md) |
| `dashboard/`    | Power BI dashboard for sales visualizations     | [📊 README](dashboard/README.md) |

---
## ETL & Analytics Pipeline

### ETL Process
1. **Bronze Layer**: Ingest raw CSV data into PostgreSQL (`scripts/bronze/Proc_Load_Bronze_Data.sql`).
2. **Silver Layer**: Clean and standardize data, addressing nulls and inconsistencies (`scripts/silver/Proc_Load_Data_Into_Silver.sql`).
3. **Gold Layer**: Create star schema tables and views for analytics (`scripts/gold/DDL_Gold_Table.sql`, `sales_analysis.sql`).
![data flow](https://github.com/jimi121/Data-Warehouse-Projects/blob/main/Sales%20Analytics%20Data%20Warehouse/doc/data_flow.svg)

### Analytics Workflow
The analytics process, implemented in [sales_analysis.sql](analytics_report/sales_analysis.sql), includes:
- **Dimensions Overview**: Analyze unique customer countries and product attributes.
- **Time Span Analysis**: Assess sales duration and customer age extremes.
- **Key Metrics**: Calculate total revenue, items sold, and unique orders.
- **Distribution Insights**: Examine data spread across countries, genders, and categories.
- **Performance Rankings**: Identify top and bottom products and customers by revenue.
- **Temporal Trends**: Track yearly and monthly sales performance.
- **Running Totals**: Compute cumulative sales and moving average prices.
- **Product Trends**: Evaluate year-over-year product performance.
- **Segmentation**: Group products by cost and customers by tenure/spending.
- **Contribution Analysis**: Measure category and regional sales contributions.
- **Reporting Views**: Create `vw_customer_insights` and `vw_product_insights` for streamlined reporting.

Outputs are stored in `analytics_report/`.

![EDA](https://github.com/jimi121/Data-Warehouse-Projects/blob/main/Sales%20Analytics%20Data%20Warehouse/doc/EDA%20steps.svg)  


---

## Setup Instructions

### Prerequisites
- **PostgreSQL**: Install from [postgresql.org](https://www.postgresql.org/download/).
- **Git**: Clone the repository:
  ```bash
  git clone https://github.com/[Your-GitHub-Username]/sales-analytics-warehouse.git

- Load sample datasets from the `/datasets/` folder.  

### **🔹 Running SQL Scripts:**  
1️⃣ **Initialize Database:**  
   ```
   \i init_database.sql;
   ```
2️⃣ **Run ETL Scripts:**  
   ```
   \i scripts/bronze/       -- load data
   \i scripts/silver/       -- transform data
   \i scripts/gold/         -- final model
   ```
3️⃣ **Start Analysis:** Query tables to generate insights!  

---


## 🙏 Gratitude
I would like to express my sincere gratitude to my instructor, Baraa Khatib Salkini, IT Project Manager and Lead for Big Data, Data Lakehouse, and BI at Mercedes-Benz AG. His guidance and expertise have taught me so much, and I’m truly grateful for the opportunity to learn from him.
*   [LinkedIn](https://www.linkedin.com/in/baraa-khatib-salkini-845b1b55/)
*   [YouTube](https://www.youtube.com/@DataWithBaraa) 



## 📌 **Follow me on:**  
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue?logo=linkedin)](www.linkedin.com/in/olajimi-adeleke)  
[![GitHub](https://img.shields.io/badge/GitHub-Follow-black?logo=github)](https://github.com/jimi121?tab=repositories)   

📧 Email me at: [adelekejimi@gmail.com](mailto:adelekejimi@gmail.com)  
