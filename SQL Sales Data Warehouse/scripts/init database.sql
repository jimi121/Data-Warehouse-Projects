/*
======================================================================================================
Create Database and Schemas (PostgreSQL Version)
======================================================================================================
Script Purpose:
    This script creates a new database named 'SALES DATA WAREHOUSE' if it doesn't already exist.
    It then creates three schemas within the database: 'bronze', 'silver', and 'gold'.

WARNING:
    Running this script might require you to manually drop the database if it exists due to PostgreSQL's 
    handling of concurrent connections.  It's best practice to connect to a different database (e.g., 'postgres')
    to drop 'SALES DATA WAREHOUSE' if it exists.
    
======================================================================================================
*/


-- Connect to the 'postgres' database (or another database other than the one you are creating)
-- This is essential for dropping the target database if it exists.
-- psql command to connect to postgres
\c postgres  

-- Check if the database exists and drop it if it does.
-- Note:  You might need to disconnect other users connected to DataWarehouseAnalytics before dropping.
-- Use double quotes for case-sensitive names
DROP DATABASE IF EXISTS "SALES DATA WAREHOUSE"; 


-- recreate the database and connect to the new database
CREATE DATABASE "SALES DATA WAREHOUSE"; 

-- Connect to the newly created "SALES DATA WAREHOUSE" database
-- psql command to connect to "SALES DATA WAREHOUSE"
\c "DataWarehouseAnalytics" 

--create schema for the data
CREATE SCHEMA bronze;
CREATE SCHEMA silver;
CREATE SCHEMA gold;