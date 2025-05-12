**[Back to Main README](../README.md)**

# ⚙️ ETL and Analytics Scripts

**SQL scripts powering the ETL pipeline and analytics for a PostgreSQL-based data warehouse** 🛠️

---

## 📋 Overview

This directory contains the **SQL scripts** that drive the ETL pipeline and analytics for the **Sales Analytics Data Warehouse**. Built with **PostgreSQL**, these scripts implement the **Medallion Architecture** to process data from raw ingestion to analytics-ready outputs, culminating in [sales_analysis.sql](analytics_report/sales_analysis.sql) for business insights.

---
![data_layer](https://github.com/user-attachments/assets/d298da24-6a18-4476-93d9-d4709a33b6af)

## 📂 Script Structure

The scripts are organized to manage database setup, data ingestion, transformation, and analytics across the Medallion Architecture.

```
scripts/
├── setup/
│   └── init_database.sql                   # Initializes the PostgreSQL database
├── bronze/
│   ├── DDL_Bronze_Table.sql            # Defines Bronze layer table structures
│   ├── Proc_Load_Bronze_Data.sql              # Loads raw data from CSV files
├── silver/
│   ├── DDL_Silver_Table.sql            # Defines Silver layer table structures
│   ├── Proc_Load_Data_Into_Silver.sql         # Transforms Bronze data to Silver
├── gold/
│   ├── DDL_Gold_Table.sql              # Creates star schema tables and views
    ├── DDL_Gold_View.sql
```

---

## 🏗️ Medallion Architecture Workflow

### Bronze Layer 📥
- **`setup/schema_bronze.sql`**:
  - Creates tables in the `bronze` schema to mirror raw dataset structure.
  - Drops existing tables for a clean slate before loading.
- **`setup/Proc_Load_Bronze_Data.sql`**:
  - Uses PostgreSQL’s `COPY` command for efficient bulk loading.
  - Logs load times and record counts for tracking.

### Silver Layer ⚪
- **`silver/DDL_Silver_Table.sql`**:
  - Defines tables in the `silver` schema with standardized constraints.
  - Ensures schema consistency by dropping existing tables.
- **`silver/Proc_Load_Data_Into_Silver.sql`**:
  - Extracts data from Bronze tables.
  - Cleans data (e.g., removes duplicates, fixes nulls) and loads it into Silver.

### Gold Layer 💎
- **`gold/DDL_Gold_Table.sql`**:
  - Creates fact and dimension tables (`dim_customers`, `dim_products`, `fact_sales`)
- **`gold/DDL_Gold_View.sql`**:
  - Creates fact and dimension tables (`dim_customers_v`, `dim_products_v`, `fact_sales_v`)
  - Ensures referential integrity and optimization for reporting.
- **`analytics_report/sales_analysis.sql`**:
  - Executes advanced analytics, including:
    - Dimension analysis (e.g., customer countries).
    - Time Series Analysis (e.g., yearly sales).
    - Data Segmentation (e.g., customer tiers).
    - Contribution analysis (e.g., regional sales share).

---

## 🚀 Usage

### Prerequisites
- **PostgreSQL**: Install from [postgresql.org](https://www.postgresql.org/download/) 🌐
- **Dataset**: Ensure CSV files are in `data/` (see [Data README](../data/README.md)).

### Execution
1. **Initialize Database**:
    ```sql
    \i scripts/setup/init_db.sql
    ```
2. **Load Bronze Layer**:
    ```
    \i scripts/bronze/DDL_Bronze_Table.sql
    \i scripts/bronze/Proc_Load_Bronze_Data.sql
    ```
3. **Transform to Silver Layer**:
    ```
   \i scripts/silver/DDL_Silver_Table.sql
    \i scripts/silver/Proc_Load_Data_Into_Silver.sql
    ```
4. **Build Gold Layer and Run Analytics**:
    ```
    \i scripts/gold/DDL_Gold_View.sql
    \i scripts/gold/DDL_Gold_Table.sql
    \i scripts/analytics_report/sales_analysis.sql
    ```