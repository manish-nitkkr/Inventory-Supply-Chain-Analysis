# Inventory & Supply Chain Analysis

## Project Overview

This project analyzes inventory and supply chain data to understand inventory levels, product demand, warehouse performance, order accuracy, backorders, and inventory optimization opportunities.

The project follows an end-to-end data analysis workflow using Python, MySQL, and Power BI.

## Business Problem

Inventory and supply chain operations need to balance product demand, inventory availability, warehouse capacity, and order performance.

This analysis aims to identify inventory inefficiencies, potential stock risks, excess inventory, warehouse performance issues, and opportunities for better inventory planning.

## Objectives

- Analyze overall inventory and demand performance
- Evaluate category and warehouse performance
- Measure order accuracy and backorder rates
- Identify products with potential excess inventory or stock risk
- Analyze warehouse capacity utilization
- Perform ABC inventory classification based on COGS
- Calculate Economic Order Quantity (EOQ)
- Calculate Reorder Point (ROP)

## Dataset

The dataset contains inventory and supply chain information covering products, categories, suppliers, warehouses, sales, inventory levels, order performance, transportation costs, lead times, and COGS.

Two versions of the dataset are included in this repository:

- `Inventory_SupplyChain.csv` — Raw dataset
- `Inventory_SupplyChain_Cleaned.csv` — Cleaned dataset

## Tools & Technologies

- **Python** — Data cleaning and preprocessing
- **Jupyter Notebook** — Data exploration and cleaning workflow
- **MySQL** — Data validation and SQL analysis
- **Power BI** — Interactive dashboard and visualization

## Data Cleaning & Preparation

Data cleaning and preprocessing were performed using Python in Jupyter Notebook.

The main steps included:

- Checking for duplicate records
- Handling inconsistent text formatting
- Validating data types
- Checking date formats
- Reviewing missing and inconsistent values
- Validating numerical fields
- Creating a cleaned dataset for further analysis

The cleaned dataset was then used for SQL analysis and Power BI reporting.

## Analysis Workflow

```text
Raw Dataset
     ↓
Python / Jupyter Notebook
     ↓
Data Cleaning & Validation
     ↓
Cleaned Dataset
     ↓
MySQL Analysis
     ↓
Power BI Dashboard
     ↓
Business Insights & Recommendations

## MySQL Analysis

MySQL was used to perform structured analysis and derive business-focused metrics.

Key analysis areas included:

- Overall inventory and demand KPIs
- Category-wise performance
- Warehouse performance and capacity utilization
- Product-level inventory risk
- Order accuracy and backorder analysis
- Monthly inventory trends
- ABC inventory classification
- Economic Order Quantity (EOQ)
- Reorder Point (ROP)

The SQL queries used for the analysis are available in `inventory_sql.sql`.

## Power BI Dashboard

The cleaned dataset and analytical outputs were used to build an interactive Power BI dashboard.

The dashboard focuses on:

- Inventory performance
- Sales and demand
- Warehouse performance
- Order accuracy and backorders
- Inventory risk
- ABC analysis
- EOQ and Reorder Point

## Key Insights

- Inventory levels and demand were analyzed across product categories and warehouses.
- Warehouse capacity utilization was evaluated to identify potential capacity-related issues.
- Order accuracy and backorder rates were analyzed to assess operational performance.
- Product-level inventory risk was assessed to identify potential excess inventory and stock-risk products.
- ABC analysis was used to classify products based on their contribution to COGS.
- EOQ analysis was performed to support inventory ordering decisions.
- Reorder Point analysis was performed to support timely replenishment.

## Business Recommendations

- Monitor products with potential excess inventory and optimize stock levels.
- Prioritize high-value products identified through ABC analysis.
- Review warehouses with higher capacity utilization.
- Monitor products and categories with elevated backorder rates.
- Use EOQ and Reorder Point metrics to support inventory replenishment planning.

## Project Files

- `Inventory_SupplyChain.csv` — Raw dataset
- `Inventory_SupplyChain_Cleaned.csv` — Cleaned dataset
- `Inventory_Cleaning_Analysis.ipynb` — Python/Jupyter analysis
- `inventory_sql.sql` — MySQL analysis
- `Inventory_Analysis.pbix` — Power BI dashboard
