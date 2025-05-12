**[Back to Main README](../README.md)**

# ✅ Data Quality Assurance

**SQL test scripts ensuring data reliability in a PostgreSQL-based data warehouse** 🛡️

---

## 📋 Overview

This directory contains **SQL test scripts** to validate data reliability and integrity in the **Sales Analytics Data Warehouse**. Built with **PostgreSQL**, these tests focus on the Silver and Gold layers of the **Medallion Architecture**, ensuring the data used in [sales_analysis.sql](../analytics_report/sales_analysis.sql) is accurate and actionable.

---

## 📂 Test Script Structure

The tests are organized to validate data at each processing stage, ensuring high-quality outputs.

```
tests/
├──  quality_checks_silver_[crm_cust_info].sql         # Customer Information  
├──  quality_checks_silver_[crm_prd_info].sql          # Product Information  
├──  quality_checks_silver_[crm_sales_details].sql     # Sales Data  
├──  quality_checks_silver_[erp_source_tables].sql     # ERP Source Validation  
└──  quality_checks_gold.sql                           # Final Gold Layer Checks  
```

---

## 🏗️ Quality Check Strategy

### Bronze Layer 📥
- No quality checks are performed, as this layer stores raw data from CRM/ERP sources (see [Data README](../data/README.md)).

### Silver Layer 🛠️
- 🔹 **`crm_cust_info` (Customer Info) ✅**  
   - Ensures that customer data (names, emails, phone numbers, etc.) is **accurate and complete**.  
   - Identifies **missing, duplicate, or inconsistent** records.  

🔹 **`crm_prd_info` (Product Info) ✅**  
   - Validates product details such as **names, categories, and prices**.  
   - Ensures **product consistency** across CRM and ERP systems.  

🔹 **`crm_sales_details` (Sales Data) ✅**  
   - Checks for **correct transaction amounts, timestamps, and missing values**.  
   - Ensures proper relationships between **customers, products, and sales**.  

🔹 **`erp_source_tables` (ERP Source Data) ✅**  
   - Verifies **data integrity and completeness** of ERP records.  
   - Identifies **duplicate transactions, incorrect formats, and inconsistencies**.  

---

### **Gold Layer Quality Checks** 💎

**`gold_layer` (Final Analytical Data) ✅**  
   - **Comprehensive quality checks** for business-ready reports and analytics.  
   - Ensures **star schema integrity**, referential integrity, and **normalized data**.  
   - Detects anomalies in **aggregations, KPIs, and time-series data**.  
   - Validates business rules and ensures **actionable insights** for stakeholders. 

---

![data_check](https://github.com/user-attachments/assets/4f0ef086-9342-4ebc-b804-db006b8d138f)

---

## 🚀 Usage

### Prerequisites
- **PostgreSQL**: Install from [postgresql.org](https://www.postgresql.org/download/) 🌐
- **Data Warehouse**: Ensure data is loaded (see [Scripts README](../scripts/README.md)).

### Running Tests
1. **Run Silver Layer Tests**:
   ```sql
   \i tests/quality_checks_silver_[crm_cust_info].sql # Customer Information
   \i tests/quality_checks_silver_[crm_prd_info].sql  # Product Information 
   \i tests/quality_checks_silver_[crm_sales_details].sql # Sales Data
   \i tests/quality_checks_silver_[erp_source_tables].sql # ERP Source Validation 
   ```

2. **Run Gold Layer Tests**:
    ```
    \i tests/quality_checks_gold.sql                           # Final Gold Layer Checks  
    ```
