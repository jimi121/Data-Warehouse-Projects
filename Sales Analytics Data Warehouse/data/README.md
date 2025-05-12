**[Back to Main README](../README.md)**

# 📋 Sales Analytics Dataset

**Dataset foundation for a PostgreSQL-based sales analytics data warehouse using the Medallion Architecture** 🌐

---

## 📋 Overview

This dataset serves as the foundation for the **Sales Analytics Data Warehouse**, providing raw data from CRM and ERP systems. Processed through the **Medallion Architecture** (Bronze, Silver, Gold layers) in **PostgreSQL**, it enables advanced analytics as implemented in [sales_analysis.sql](../analytics_report/sales_analysis.sql).

---

## 📂 Dataset Structure

The dataset is organized into two source directories containing raw CSV files ingested into the Bronze layer.

```
data/
├── crm_source/
│   ├── customers.csv          # Customer details
│   ├── products.csv          # Product details
│   ├── sales.csv             # Sales transactions
└── erp_source/
├── customer_details.csv  # Additional customer information
├── locations.csv         # Customer location data
├── product_categories.csv # Product category data
```

---

## 🗄️ Tables in the Data Warehouse

The raw data is transformed into a star schema in the Gold layer, using tables like `dim_customers`, `dim_products`, and `fact_sales`. Below are the Bronze layer source tables.

### 1. Customers (`customers.csv`)
| Column Name        | Data Type     | Description                                      |
|--------------------|---------------|--------------------------------------------------|
| `customer_id`      | INTEGER       | Unique identifier (Primary Key).                 |
| `customer_key`     | VARCHAR(255)  | Unique key for linking.                          |
| `first_name`       | VARCHAR(255)  | Customer's first name.                           |
| `last_name`        | VARCHAR(255)  | Customer's last name.                            |
| `marital_status`   | VARCHAR(50)   | Marital status (e.g., Single).                   |
| `gender`           | VARCHAR(10)   | Customer's gender.                               |
| `create_date`      | TIMESTAMP     | Record creation timestamp.                       |

### 2. Products (`products.csv`)
| Column Name   | Data Type     | Description                                      |
|---------------|---------------|--------------------------------------------------|
| `product_id`  | INTEGER       | Unique identifier (Primary Key).                 |
| `product_key` | VARCHAR(255)  | Unique key for linking.                          |
| `product_name`| VARCHAR(255)  | Product name.                                    |
| `product_cost`| NUMERIC       | Product cost.                                    |
| `product_line`| VARCHAR(255)  | Product line or category.                        |
| `start_date`  | DATE          | Product availability date.                       |
| `end_date`    | DATE          | Product discontinuation date (if applicable).    |

### 3. Sales (`sales.csv`)
| Column Name     | Data Type     | Description                                      |
|-----------------|---------------|--------------------------------------------------|
| `order_number`  | VARCHAR(255)  | Unique order identifier (Primary Key).           |
| `product_key`   | VARCHAR(255)  | Foreign Key to `products`.                       |
| `customer_id`   | INTEGER       | Foreign Key to `customers`.                      |
| `order_date`    | DATE          | Order date.                                      |
| `shipping_date` | DATE          | Shipping date.                                   |
| `due_date`      | DATE          | Due date.                                        |
| `sales_amount`  | NUMERIC       | Total sales value.                               |
| `quantity`      | INTEGER       | Units sold.                                      |
| `price`         | NUMERIC       | Unit price.                                      |

### 4. Customer Details (`customer_details.csv`)
| Column Name   | Data Type     | Description                                      |
|---------------|---------------|--------------------------------------------------|
| `customer_id` | INTEGER       | Foreign Key to `customers` (Primary Key).        |
| `birth_date`  | DATE          | Customer's birth date.                           |
| `gender`      | VARCHAR(10)   | Customer's gender (may overlap).                 |

### 5. Locations (`locations.csv`)
| Column Name   | Data Type     | Description                                      |
|---------------|---------------|--------------------------------------------------|
| `customer_id` | INTEGER       | Foreign Key to `customers` (Primary Key).        |
| `country`     | VARCHAR(255)  | Customer's country.                              |

### 6. Product Categories (`product_categories.csv`)
| Column Name   | Data Type     | Description                                      |
|---------------|---------------|--------------------------------------------------|
| `category_id` | INTEGER       | Unique identifier (Primary Key).                 |
| `category`    | VARCHAR(255)  | Main category name.                              |
| `subcategory` | VARCHAR(255)  | Subcategory name.                                |
| `maintenance` | VARCHAR(255)  | Maintenance notes.                               |

---

## 🔗 Relationships
- **Sales to Products**: `sales.product_key` references `products.product_key` (many-to-one).
- **Sales to Customers**: `sales.customer_id` references `customers.customer_id` (many-to-one).
- **Customer Details to Customers**: `customer_details.customer_id` references `customers.customer_id` (one-to-one).
- **Locations to Customers**: `locations.customer_id` references `customers.customer_id` (one-to-one).

### Gold Layer Mapping
- `dim_customers`: Merges `customers.csv`, `customer_details.csv`, and `locations.csv`.
- `dim_products`: Combines `products.csv` and `product_categories.csv`.
- `fact_sales`: Derived from `sales.csv`, linked to `dim_customers` and `dim_products`.

These support analytics in [sales_analysis.sql](../analytics_report/sales_analysis.sql).

---

## 📚 Resources

- **Scripts**: [scripts/](../scripts/)
- **Tests**: [tests/](../tests/)
- **Documentation**: [doc/](../doc/)
- **Diagrams**: [Draw.io](https://www.drawio.com/)
- **Naming Convention**:[naming_convention](../doc/naming_conventions.md)
