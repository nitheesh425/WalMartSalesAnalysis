# Walmart Sales Analysis Dashboard

 Project Overview

This project focuses on analyzing Walmart sales data using **MySQL and Tableau**. The main objective is to understand sales performance, product trends, customer purchasing behavior, and revenue patterns through SQL analysis and an interactive Tableau dashboard.

The project follows a data analytics workflow, from data cleaning and exploratory data analysis to advanced SQL queries and dashboard visualization.

## 🛠️ Tools & Technologies

* **MySQL** – Data cleaning, data transformation, and SQL analysis
* **Tableau** – Data visualization and interactive dashboard creation
* **CSV** – Source dataset

## 📊 Dataset Description

The dataset contains sales transaction information, including:

* Invoice ID
* Branch, city, and state
* Customer type and gender
* Product name and product line
* Unit price and quantity
* VAT and total sales
* Cost of Goods Sold (COGS)
* Gross income and gross margin percentage
* Date and time of sale
* Payment method
* Customer ratings

Additional fields, including day name, month name, and time of day, were prepared for further analysis.

## 🔄 Project Workflow

### 1. Database Creation

* Created the `walmart` database in MySQL.
* Created a sales table to store transaction data.
* Imported the CSV dataset into the database.

### 2. Data Cleaning

* Checked the total number of records.
* Identified duplicate invoice IDs.
* Checked for missing values and blank fields.
* Removed unnecessary spaces from text columns.
* Checked for invalid quantities and zero unit prices.
* Prepared date values for time-based analysis.

### 3. Feature Engineering

Created additional fields to support analysis:

* Day name
* Month name
* Time of day
* Product category based on sales compared with the average

### 4. Exploratory Data Analysis (EDA)

Used SQL queries to analyze:

* Sales by product line
* Revenue by month, city, and state
* Popular payment methods
* Customer types and gender distribution
* Product ratings
* Quantity sold
* VAT and cost of goods sold
* Sales by day and time of day

### 5. Advanced SQL Analysis

Applied advanced SQL techniques, including:

* Aggregate functions
* Common Table Expressions (CTEs)
* Window functions
* Ranking functions
* `LAG()` for month-over-month sales growth
* Revenue contribution analysis
* Product ranking by branch and state
* Pareto-style product revenue analysis

### 6. Tableau Dashboard

Developed a Tableau dashboard to present sales information visually and make it easier to explore sales performance, profitability, product trends, and business patterns.

<img width="1195" height="743" alt="{8C7D3782-55B8-4299-B3A2-1C53F3A38486}" src="https://github.com/user-attachments/assets/c45fda5a-6c3c-491e-bb6f-40b80379ff30" />


## 🎯 Key Business Questions

* Which product lines generate the highest revenue?
* Which products sell the most?
* Which city or state contributes the most to sales?
* Which payment method generates the highest revenue?
* How do sales change from month to month?
* Which branches perform best?
* Which customer types generate the highest revenue?
* Which days and times have stronger sales activity?
* How do customer ratings vary by product line and branch?

## 📁 Project Files

* `SQLWalMartAnalysis.sql` – SQL queries for database creation, data cleaning, feature engineering, and sales analysis.
* `walmart sales dashboard.twbx` – Packaged Tableau workbook containing the sales dashboard.

## 💡 Skills Demonstrated

* SQL querying
* Data cleaning and transformation
* Exploratory Data Analysis
* Feature engineering
* Aggregate functions and subqueries
* CTEs and window functions
* Business and sales analysis
* Data visualization using Tableau
* Dashboard development

## 🏁 Conclusion

This project demonstrates how SQL can be used to clean, transform, and analyze sales data to answer business questions. Tableau is then used to present the analysis through visualizations and a dashboard.

The project helped develop practical skills in data analysis, advanced SQL, and business intelligence while exploring sales performance, product trends, and customer behavior.

**Project Type:** Data Analytics
**Tools:** MySQL, Tableau
**Focus:** Sales Analysis, SQL, EDA, and Dashboard Development
