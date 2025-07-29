# Customer Segmentation and Sales Performance Analysis with MySQL

## Project Overview

This project focuses on analyzing customer behavior and sales performance using a transactional dataset, with a strong emphasis on MySQL for data cleaning, feature engineering, and analysis. The primary goals are to segment customers based on their purchasing patterns (using RFM analysis) and to derive actionable insights into sales trends.

## Dataset

The dataset used in this project is the **Online Retail** dataset from the UCI Machine Learning Repository. It contains transactional data for a UK-based online retail store over a period of one year (01/12/2010 to 09/12/2011). The dataset includes the following key columns:

*   `InvoiceNo`: Invoice number. A 6-digit integral number uniquely assigned to each transaction. If this code starts with letter \'c\', it indicates a cancellation.
*   `StockCode`: Product (item) code. A 5-digit integral number uniquely assigned to each distinct product.
*   `Description`: Product (item) name.
*   `Quantity`: The quantities of each product (item) per transaction.
*   `InvoiceDate`: Invoice Date and time. The day and time when each transaction was generated.
*   `UnitPrice`: Unit price. Product price per unit in sterling.
*   `CustomerID`: Customer number. A 5-digit integral number uniquely assigned to each customer.
*   `Country`: Country name. The name of the country where each customer resides.

## Methodology

The project follows a structured data analysis approach, leveraging MySQL for robust data handling and analysis:

1.  **Data Acquisition and Preparation:**
    *   The `OnlineRetail.xlsx` dataset was converted to `online_retail.csv` for easier import into MySQL.
    *   A MySQL database (`retail_analytics`) and a `transactions` table were created to house the data.
    *   The `online_retail.csv` data was imported into the `transactions` table.

2.  **Data Cleaning (using SQL):**
    *   Identified and removed rows with missing `CustomerID` as it\'s crucial for customer-level analysis.
    *   Removed transactions with non-positive `Quantity` or `UnitPrice`, as these typically represent returns or invalid entries that would skew sales analysis.
    *   Checked for duplicate transactions to ensure data integrity.

3.  **Feature Engineering (RFM Analysis using SQL):**
    *   **RFM (Recency, Frequency, Monetary) analysis** was performed to segment customers based on their purchasing behavior.
    *   A SQL `VIEW` named `customer_rfm` was created to calculate:
        *   **Recency:** Days since the customer\'s last purchase.
        *   **Frequency:** Total number of unique purchases (invoices) made by the customer.
        *   **Monetary:** Total amount spent by the customer.

4.  **Sales Performance Analysis (using SQL):**
    *   **Total Sales by Country:** Aggregated sales to identify top-performing regions.
    *   **Monthly Sales Trend:** Analyzed sales over time to identify seasonality and growth patterns.
    *   **Top Products by Sales Amount:** Identified best-selling products.
    *   **Top Customers by Total Spending:** Highlighted high-value customers.
    *   **Average Order Value:** Calculated the average value of each transaction.
    *   **Unique Customers Over Time:** Tracked the number of distinct customers making purchases each month.
    *   **Sales by Hour of Day/Day of Week:** Identified peak sales periods to optimize operational efficiency and marketing campaigns.

## Tools and Technologies

*   **MySQL:** For database management, data cleaning, feature engineering, and complex analytical queries.
*   **SQL:** The primary language used for all data manipulation and analysis within the database.
*   **Python (for data conversion):** Used a simple Python script with `pandas` to convert the initial `.xlsx` file to `.csv` for MySQL import.
*   **Power BI / Tableau (Conceptual):** A conceptual dashboard mockup is provided to illustrate how the insights derived from MySQL could be visualized for business stakeholders.

## Project Structure

customer-sales-analytics-mysql/
├── mysql_queries.sql
├── dashboard_mockup_mysql.md
├── .gitignore
├── LICENSE
└── README.md

## How to Run the Project

To replicate this project and run the analysis yourself, follow these steps:

1.  **Install MySQL Community Server:** If you don\'t have MySQL installed, download and install it from the [official MySQL website](https://dev.mysql.com/downloads/mysql/ ). Remember to set a root password during installation.

2.  **Download the Dataset:** Obtain the `Online Retail` dataset from the UCI Machine Learning Repository:
    [https://archive.ics.uci.edu/dataset/352/online+retail](https://archive.ics.uci.edu/dataset/352/online+retail )
    Download the `.xlsx` file.

3.  **Convert XLSX to CSV:** Use a tool or a simple Python script (like the one used in this project conceptually) to convert the `OnlineRetail.xlsx` file to `online_retail.csv`. Ensure the CSV file is in a location accessible by your MySQL server.

4.  **Clone this Repository:**
    ```bash
    git clone https://github.com/creativemehedi/customer-sales-analytics-mysql.git
    ```

5.  **Navigate to the project directory:**
    ```bash
    cd customer-sales-analytics-mysql
    ```

6.  **Connect to MySQL and Create Database/Table:**
    Open your MySQL client (e.g., MySQL Command Line Client or terminal ) and connect to your MySQL server:
    ```bash
    mysql -u root -p
    ```
    Enter your password when prompted. Then, execute the following SQL commands:
    ```sql
    CREATE DATABASE retail_analytics;
    USE retail_analytics;
    CREATE TABLE transactions (
        InvoiceNo VARCHAR(20) NOT NULL,
        StockCode VARCHAR(20) NOT NULL,
        Description VARCHAR(255),
        Quantity INT NOT NULL,
        InvoiceDate DATETIME NOT NULL,
        UnitPrice DECIMAL(10, 2) NOT NULL,
        CustomerID INT,
        Country VARCHAR(50)
    );
    ```

7.  **Import Data into MySQL:**
    Execute the `LOAD DATA LOCAL INFILE` command in your MySQL client. **Remember to replace the placeholder path with the actual path to your `online_retail.csv` file.**
    ```sql
    LOAD DATA LOCAL INFILE \'C:/path/to/your/online_retail.csv\'
    INTO TABLE transactions
    FIELDS TERMINATED BY \',\'
    ENCLOSED BY \'"\'
    LINES TERMINATED BY \'\\n\'
    IGNORE 1 ROWS;
    ```

8.  **Execute Analysis Queries:**
    Open the `mysql_queries.sql` file (found in this repository) and execute the queries within your MySQL client. You can copy-paste them or use the `SOURCE` command if your client supports it:
    ```sql
    SOURCE /path/to/your/customer-sales-analytics-mysql/mysql_queries.sql;
    ```

## Insights and Recommendations

### Key Insights from Analysis

Based on the analysis of the Online Retail transactional dataset using MySQL, the following key insights can be derived:

1.  **Customer Segmentation (RFM):** The RFM analysis (Recency, Frequency, Monetary) allows for the categorization of customers into distinct segments. For instance:
    *   **High-Value/Loyal Customers:** Those with low Recency (recently purchased), high Frequency (frequently purchase), and high Monetary value (spend a lot). These customers are crucial for business growth and should be targeted with loyalty programs and exclusive offers.
    *   **At-Risk Customers:** Those with high Recency (haven\'t purchased recently), but potentially high Frequency and Monetary value in the past. These customers might need re-engagement campaigns.
    *   **New Customers:** Those with low Recency and low Frequency/Monetary value. The focus for these customers should be on encouraging repeat purchases and increasing their lifetime value.
    *   **Churned Customers:** Those with high Recency and low Frequency/Monetary value. Understanding why these customers churned can help prevent future churn.

2.  **Sales Trends and Seasonality:** Analyzing monthly sales trends reveals patterns and seasonality. For example, there might be peak sales periods (e.g., holiday seasons) and slower periods. This information is vital for inventory management, staffing, and planning marketing campaigns.

3.  **Top-Performing Countries:** Identifying countries with the highest total sales helps in focusing international marketing efforts and understanding regional market demands. This can inform localization strategies for products and promotions.

4.  **Best-Selling Products:** Pinpointing the top products by sales amount allows for optimizing product placement, marketing campaigns for these specific items, and ensuring adequate stock levels. Conversely, identifying slow-moving products can inform strategies for clearance or discontinuation.

5.  **High-Value Customers:** Recognizing the top customers by total spending enables businesses to provide personalized experiences, offer exclusive benefits, and build stronger relationships, as these customers contribute significantly to revenue.

6.  **Peak Sales Hours/Days:** Understanding when sales are highest (e.g., specific hours of the day or days of the week) can help optimize staffing, schedule marketing campaigns for maximum impact, and manage website traffic.

### Recommendations for Business Optimization

Based on these insights, here are actionable recommendations for the retail business:

1.  **Tailored Marketing Campaigns:** Develop specific marketing campaigns for each RFM segment. For example, re-engagement emails for at-risk customers, exclusive discounts for loyal customers, and welcome offers for new customers.
2.  **Inventory and Staffing Optimization:** Use sales trend and peak hour/day analysis to optimize inventory levels and staffing schedules, reducing costs and improving customer service during busy periods.
3.  **Geographic Expansion/Focus:** Leverage insights from sales by country to either expand marketing efforts in high-performing regions or identify untapped markets for potential growth.
4.  **Product Portfolio Management:** Promote best-selling products more aggressively and consider strategies to boost sales of underperforming products, or re-evaluate their place in the product catalog.
5.  **Customer Loyalty Programs:** Implement or enhance loyalty programs to reward high-value customers and incentivize repeat purchases from other segments.
6.  **Personalized Customer Experience:** Use customer segmentation data to personalize product recommendations, website content, and communication, leading to higher engagement and conversion rates.
7.  **Data-Driven Decision Making:** Continuously monitor these metrics and insights to make agile, data-driven decisions regarding marketing spend, product development, and customer relationship management.

These recommendations aim to enhance profitability and customer satisfaction by transforming raw transactional data into strategic business intelligence.

## Dashboard (Conceptual)

Refer to `dashboard_mockup_mysql.md` (found in this repository) for the conceptual design of a Power BI/Tableau dashboard that would visualize the findings of this analysis. This includes proposed charts, key metrics, and interactive elements.
