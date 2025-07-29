-- MySQL Queries for Customer Segmentation and Sales Performance Analysis

-- 1. Data Cleaning
-- Check for duplicate transactions (InvoiceNo, StockCode, CustomerID, InvoiceDate)
SELECT InvoiceNo, StockCode, CustomerID, InvoiceDate, COUNT(*)
FROM transactions
GROUP BY InvoiceNo, StockCode, CustomerID, InvoiceDate
HAVING COUNT(*) > 1;

-- Remove duplicate rows (if any, this is a common way to handle them if a unique identifier isn't present)
-- Note: This requires a temporary table or a more complex subquery depending on MySQL version and setup.
-- For simplicity, we'll assume no exact duplicates based on the above check, or handle them during import.

-- Handle missing CustomerIDs (assign a placeholder or remove rows)
-- For RFM analysis, CustomerID is crucial. We will remove rows with NULL CustomerID.
DELETE FROM transactions
WHERE CustomerID IS NULL;

-- Handle negative Quantity (these are usually returns, but for sales analysis, we might exclude them or treat separately)
-- For this project, we will focus on positive sales quantities.
DELETE FROM transactions
WHERE Quantity <= 0;

-- Handle negative UnitPrice (invalid data, remove)
DELETE FROM transactions
WHERE UnitPrice <= 0;

-- Check for data type consistency (already handled by table creation, but good to note)

-- 2. Feature Engineering (RFM - Recency, Frequency, Monetary Value)
-- Calculate Recency, Frequency, and Monetary Value for each customer
-- Recency: Days since last purchase
-- Frequency: Total number of purchases
-- Monetary: Total amount spent

CREATE VIEW customer_rfm AS
SELECT
    CustomerID,
    DATEDIFF((SELECT MAX(InvoiceDate) FROM transactions), MAX(InvoiceDate)) AS Recency,
    COUNT(DISTINCT InvoiceNo) AS Frequency,
    SUM(Quantity * UnitPrice) AS Monetary
FROM transactions
GROUP BY CustomerID;

-- You can then query this view:
-- SELECT * FROM customer_rfm LIMIT 10;

-- 3. Sales Performance Analysis

-- Total Sales by Country
SELECT Country, SUM(Quantity * UnitPrice) AS TotalSales
FROM transactions
GROUP BY Country
ORDER BY TotalSales DESC;

-- Monthly Sales Trend
SELECT
    DATE_FORMAT(InvoiceDate, '%Y-%m') AS SalesMonth,
    SUM(Quantity * UnitPrice) AS MonthlySales
FROM transactions
GROUP BY SalesMonth
ORDER BY SalesMonth;

-- Top 10 Products by Sales Amount
SELECT
    StockCode,
    Description,
    SUM(Quantity * UnitPrice) AS ProductSales
FROM transactions
GROUP BY StockCode, Description
ORDER BY ProductSales DESC
LIMIT 10;

-- Top 10 Customers by Total Spending
SELECT
    CustomerID,
    SUM(Quantity * UnitPrice) AS TotalSpending
FROM transactions
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID
ORDER BY TotalSpending DESC
LIMIT 10;

-- Average Order Value
SELECT AVG(OrderTotal) AS AverageOrderValue
FROM (
    SELECT InvoiceNo, SUM(Quantity * UnitPrice) AS OrderTotal
    FROM transactions
    GROUP BY InvoiceNo
) AS OrderSummaries;

-- Number of Unique Customers Over Time (Monthly)
SELECT
    DATE_FORMAT(InvoiceDate, '%Y-%m') AS SalesMonth,
    COUNT(DISTINCT CustomerID) AS UniqueCustomers
FROM transactions
WHERE CustomerID IS NOT NULL
GROUP BY SalesMonth
ORDER BY SalesMonth;

-- Sales by Product Category (assuming StockCode can be grouped into categories, or if we had a product dimension table)
-- For this dataset, we'll group by the first few characters of StockCode as a proxy for category if a formal category isn't available.
-- Or, we can analyze by Description if descriptions are consistent enough.

-- Example: Sales by first character of StockCode (as a proxy for category)
SELECT
    SUBSTRING(StockCode, 1, 1) AS StockCodePrefix,
    SUM(Quantity * UnitPrice) AS SalesByPrefix
FROM transactions
GROUP BY StockCodePrefix
ORDER BY SalesByPrefix DESC;

-- Sales by Hour of Day (to identify peak sales hours)
SELECT
    HOUR(InvoiceDate) AS HourOfDay,
    SUM(Quantity * UnitPrice) AS Sales
FROM transactions
GROUP BY HourOfDay
ORDER BY HourOfDay;

-- Sales by Day of Week
SELECT
    DAYOFWEEK(InvoiceDate) AS DayOfWeekNum, -- 1=Sunday, 2=Monday, etc.
    DAYNAME(InvoiceDate) AS DayOfWeekName,
    SUM(Quantity * UnitPrice) AS Sales
FROM transactions
GROUP BY DayOfWeekNum, DayOfWeekName
ORDER BY DayOfWeekNum;

-- 4. Conceptual Reporting/Visualization Outline
-- This section outlines how the results from the above SQL queries can be used to create dashboards in Power BI or Tableau.

-- Dashboard Title: Customer & Sales Performance Dashboard

-- Key Performance Indicators (KPIs):
-- - Total Sales Amount
-- - Total Number of Transactions
-- - Total Unique Customers
-- - Average Order Value
-- - Number of Customers with RFM scores (e.g., High-Value, Loyal, etc.)

-- Visualizations:
-- 1. Sales Trend Over Time (Line Chart): Monthly or daily sales.
-- 2. Sales by Country (Bar Chart/Map): Top performing countries.
-- 3. Top Products/SKUs (Bar Chart): Products contributing most to sales.
-- 4. Top Customers (Bar Chart): Customers with highest spending.
-- 5. RFM Segmentation (Scatter Plot/Table): Visualizing customer segments based on Recency, Frequency, Monetary values.
-- 6. Sales by Hour of Day/Day of Week (Bar Charts): To identify peak sales periods.

-- Filters/Slicers:
-- - Date Range
-- - Country
-- - Product Category/Description
-- - Customer Segment (e.g., High-Value, New, At-Risk)

-- This SQL file provides the foundation for extracting the necessary data for these visualizations.


