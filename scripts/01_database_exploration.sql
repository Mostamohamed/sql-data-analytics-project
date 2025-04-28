/*
===============================================================================
Database Exploration
===============================================================================
Purpose:
    - To explore the structure of the database, including the list of tables and their schemas.
    - To inspect the columns and metadata for specific tables.

Table Used:
    - INFORMATION_SCHEMA.TABLES
    - INFORMATION_SCHEMA.COLUMNS
===============================================================================
*/
-- Explore All Objects in the database
SELECT * FROM INFORMATION_SCHEMA.TABLES

-- Explore All Columns in the database
SELECT * FROM INFORMATION_SCHEMA.COLUMNS

-- Explore All Columns in the database for a specific table (dim_customers)
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers';
