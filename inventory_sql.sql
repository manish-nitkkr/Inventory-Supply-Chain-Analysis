-- =====================================================
-- INVENTORY & SUPPLY CHAIN ANALYSIS
-- MySQL Analysis
-- =====================================================
-- 1. DATABASE SETUP
create database inventory_db;
USE inventory_db;
SELECT COUNT(*) AS total_rows
FROM inventory;

-- Check Order Accuracy distribution
SELECT
    `Order Accuracy`,
    COUNT(*) AS total
FROM inventory
GROUP BY `Order Accuracy`;

-- Check Backorder distribution
SELECT
    Backorder,
    COUNT(*) AS total
FROM inventory
GROUP BY Backorder;

-- 3. CREATE ANALYSIS TABLE
-- Convert Date into DATE format
-- Convert True/False fields into 1/0 for analysis
CREATE TABLE inventory_analysis AS
SELECT
    STR_TO_DATE(Date, '%Y-%m-%d') AS Date,
    Region,
    `Product ID`,
    `Product Name`,
    Category,
    Supplier,
    Warehouse,
    `Order Status`,
    `Units Sold`,
    `Inventory Level`,
    `Transportation Cost`,
    CASE
        WHEN `Order Accuracy` = 'True' THEN 1
        WHEN `Order Accuracy` = 'False' THEN 0
    END AS `Order Accuracy`,
    `Lead Time (Days)`,
    CASE
        WHEN Backorder = 'True' THEN 1
        WHEN Backorder = 'False' THEN 0
    END AS Backorder,
    `Average Inventory`,
    `Warehouse Capacity`,
    COGS
FROM inventory;

DESCRIBE inventory_analysis;

SELECT COUNT(*) AS total_rows
FROM inventory_analysis;

-- OVERALL KPI ANALYSIS
SELECT
    SUM(`Units Sold`) AS total_units_sold,
    SUM(`Inventory Level`) AS total_inventory,
    AVG(`Inventory Level`) AS avg_inventory,
    SUM(COGS) AS total_cogs,
    AVG(`Lead Time (Days)`) AS avg_lead_time,
    AVG(`Order Accuracy`) * 100 AS order_accuracy_pct,
    AVG(Backorder) * 100 AS backorder_rate
FROM inventory_analysis;

-- CATEGORY ANALYSIS
SELECT
    Category,
    SUM(`Inventory Level`) AS total_inventory,
    SUM(`Units Sold`) AS total_units_sold,
    SUM(COGS) AS total_cogs,
    AVG(Backorder) * 100 AS backorder_rate
FROM inventory_analysis
GROUP BY Category
ORDER BY total_inventory DESC;
SELECT
    `Product Name`,
    Category,
    SUM(`Units Sold`) AS total_units_sold,
    SUM(`Inventory Level`) AS total_inventory,
    AVG(`Inventory Level`) AS avg_inventory,
    AVG(Backorder) * 100 AS backorder_rate,
    CASE
        WHEN SUM(`Inventory Level`) > SUM(`Units Sold`) * 6
             AND AVG(Backorder) < 0.10
            THEN 'Potential Excess Inventory'

        WHEN SUM(`Inventory Level`) < SUM(`Units Sold`) * 2
             OR AVG(Backorder) >= 0.20
            THEN 'Potential Stock Risk'

        ELSE 'Normal'
    END AS inventory_status
FROM inventory_analysis
GROUP BY `Product Name`, Category
ORDER BY total_inventory DESC;
SELECT
    Category,
    SUM(`Inventory Level`) AS total_inventory,
    AVG(`Inventory Level`) AS avg_inventory
FROM inventory_analysis
GROUP BY Category
ORDER BY total_inventory DESC;

-- WAREHOUSE ANALYSIS
SELECT
    Warehouse,
    SUM(`Inventory Level`) AS total_inventory,
    AVG(`Inventory Level`) AS avg_inventory
FROM inventory_analysis
GROUP BY Warehouse
ORDER BY total_inventory DESC;
SELECT
    `Product Name`,
    SUM(`Inventory Level`) AS total_inventory
FROM inventory_analysis
GROUP BY `Product Name`
ORDER BY total_inventory DESC;

SELECT
    Category,
    SUM(`Inventory Level`) AS total_inventory,
    SUM(`Units Sold`) AS total_units_sold
FROM inventory_analysis
GROUP BY Category
ORDER BY total_inventory DESC;

SELECT 
	Warehouse,
    SUM(`Inventory Level`) AS total_inventory,
    SUM(`Units Sold`) AS total_units_sold
FROM inventory_analysis
GROUP BY Warehouse
ORDER BY total_inventory DESC;
SELECT
    Warehouse,
    SUM(`Inventory Level`) AS total_inventory,
    SUM(`Units Sold`) AS total_units_sold,
    ROUND(
        SUM(`Inventory Level`) / SUM(`Units Sold`),
        2
    ) AS inventory_sales_ratio
FROM inventory_analysis
GROUP BY Warehouse
ORDER BY inventory_sales_ratio;
SELECT
    Warehouse,
    COUNT(*) AS total_orders,
    SUM(Backorder) AS total_backorders,
    ROUND(AVG(Backorder) * 100, 2) AS backorder_rate
FROM inventory_analysis
GROUP BY Warehouse
ORDER BY backorder_rate DESC;
SELECT
    Category,
    COUNT(*) AS total_orders,
    SUM(Backorder) AS total_backorders,
    ROUND(AVG(Backorder) * 100, 2) AS backorder_rate
FROM inventory_analysis
GROUP BY Category
ORDER BY backorder_rate DESC;
SELECT
    Category,
    COUNT(*) AS total_orders,
    SUM(`Order Accuracy`) AS accurate_orders,
    ROUND(AVG(`Order Accuracy`) * 100, 2) AS accuracy_rate
FROM inventory_analysis
GROUP BY Category
ORDER BY accuracy_rate DESC;
SELECT
    `Order Status`,
    COUNT(*) AS total_orders
FROM inventory_analysis
GROUP BY `Order Status`
ORDER BY total_orders DESC;
SELECT
    YEAR(Date) AS year,
    MONTH(Date) AS month,
    SUM(`Inventory Level`) AS total_inventory
FROM inventory_analysis
GROUP BY YEAR(Date), MONTH(Date)
ORDER BY year, month;
SELECT
    Warehouse,
    SUM(`Inventory Level`) AS total_inventory,
    AVG(`Warehouse Capacity`) AS avg_capacity
FROM inventory_analysis
GROUP BY Warehouse
ORDER BY total_inventory DESC;
SELECT
    Warehouse,
    ROUND(AVG(`Inventory Level`), 2) AS avg_inventory,
    ROUND(AVG(`Warehouse Capacity`), 2) AS avg_capacity,
    ROUND(
        AVG(`Inventory Level`) / AVG(`Warehouse Capacity`) * 100,
        2
    ) AS capacity_utilization_pct
FROM inventory_analysis
GROUP BY Warehouse
ORDER BY capacity_utilization_pct DESC;

SELECT
    COUNT(*) AS total_records,
    SUM(`Units Sold`) AS total_units_sold,
    SUM(`Inventory Level`) AS total_inventory,
    AVG(`Inventory Level`) AS avg_inventory,
    SUM(COGS) AS total_cogs,
    ROUND(AVG(Backorder) * 100, 2) AS backorder_rate,
    ROUND(AVG(`Order Accuracy`) * 100, 2) AS order_accuracy
FROM inventory_analysis;
USE inventory_db;

WITH product_cogs AS (
    SELECT
        `Product Name`,
        SUM(COGS) AS total_cogs
    FROM inventory_analysis
    GROUP BY `Product Name`
),
abc_calc AS (
    SELECT
        `Product Name`,
        total_cogs,

        SUM(total_cogs) OVER (
            ORDER BY total_cogs DESC, `Product Name`
        ) AS cumulative_cogs,

        SUM(total_cogs) OVER () AS grand_total_cogs

    FROM product_cogs
)
-- ABC Analysis
-- A = Top 70% cumulative COGS
-- B = Next 20%
-- C = Remaining 10%
SELECT
    `Product Name`,
    ROUND(total_cogs, 2) AS total_cogs,

    ROUND(
        total_cogs / grand_total_cogs * 100,
        2
    ) AS cogs_percent,

    ROUND(
        cumulative_cogs / grand_total_cogs * 100,
        2
    ) AS cumulative_cogs_percent,

    CASE
        WHEN cumulative_cogs / grand_total_cogs <= 0.70 THEN 'A'
        WHEN cumulative_cogs / grand_total_cogs <= 0.90 THEN 'B'
        ELSE 'C'
    END AS abc_class

FROM abc_calc
ORDER BY total_cogs DESC;
CREATE OR REPLACE VIEW abc_analysis AS

WITH product_cogs AS (
    SELECT
        `Product Name`,
        SUM(COGS) AS total_cogs
    FROM inventory_analysis
    GROUP BY `Product Name`
),
abc_calc AS (
    SELECT
        `Product Name`,
        total_cogs,

        SUM(total_cogs) OVER (
            ORDER BY total_cogs DESC, `Product Name`
        ) AS cumulative_cogs,

        SUM(total_cogs) OVER () AS grand_total_cogs

    FROM product_cogs
)

SELECT
    `Product Name`,
    ROUND(total_cogs, 2) AS total_cogs,

    ROUND(
        total_cogs / grand_total_cogs * 100,
        2
    ) AS cogs_percent,

    ROUND(
        cumulative_cogs / grand_total_cogs * 100,
        2
    ) AS cumulative_cogs_percent,

    CASE
        WHEN cumulative_cogs / grand_total_cogs <= 0.70 THEN 'A'
        WHEN cumulative_cogs / grand_total_cogs <= 0.90 THEN 'B'
        ELSE 'C'
    END AS abc_class

FROM abc_calc;
SELECT *
FROM abc_analysis
ORDER BY total_cogs DESC;
USE inventory_db;

-- EOQ assumptions:
-- Ordering Cost = 500
-- Holding Cost = 50
SELECT
    `Product Name`,
    SUM(`Units Sold`) AS total_demand,
    
    ROUND(
        SQRT(
            (2 * SUM(`Units Sold`) * 500) / 50
        ),
        0
    ) AS eoq

FROM inventory_analysis

GROUP BY `Product Name`
ORDER BY eoq DESC;
SELECT
    MIN(Date) AS start_date,
    MAX(Date) AS end_date,
    DATEDIFF(MAX(Date), MIN(Date)) + 1 AS total_days
FROM inventory_analysis;
WITH product_demand AS (
    SELECT
        `Product Name`,
        SUM(`Units Sold`) AS total_demand
    FROM inventory_analysis
    GROUP BY `Product Name`
)
SELECT
    `Product Name`,
    total_demand,

    ROUND(
        total_demand / 608 * 365,
        0
    ) AS annual_demand,

    ROUND(
        SQRT(
            (2 * (total_demand / 608 * 365) * 500) / 50
        ),
        0
    ) AS eoq

FROM product_demand
ORDER BY eoq DESC;
CREATE OR REPLACE VIEW eoq_analysis AS

WITH product_demand AS (
    SELECT
        `Product Name`,
        SUM(`Units Sold`) AS total_demand
    FROM inventory_analysis
    GROUP BY `Product Name`
)

SELECT
    `Product Name`,

    total_demand,

    ROUND(
        total_demand / 608 * 365,
        0
    ) AS annual_demand,

    ROUND(
        SQRT(
            (2 * (total_demand / 608 * 365) * 500) / 50
        ),
        0
    ) AS eoq

FROM product_demand;SELECT *
FROM eoq_analysis
ORDER BY eoq DESC;
USE inventory_db;

WITH product_demand AS (
    SELECT
        `Product Name`,
        SUM(`Units Sold`) AS total_demand
    FROM inventory_analysis
    GROUP BY `Product Name`
),
product_data AS (
    SELECT
        `Product Name`,
        SUM(`Units Sold`) / 608 * 365 AS annual_demand,
        AVG(`Lead Time (Days)`) AS avg_lead_time
    FROM inventory_analysis
    GROUP BY `Product Name`
)
SELECT
    `Product Name`,
    ROUND(annual_demand, 0) AS annual_demand,
    ROUND(avg_lead_time, 2) AS avg_lead_time,
    ROUND(
        (annual_demand / 365) * avg_lead_time,
        0
    ) AS reorder_point
FROM product_data
ORDER BY reorder_point DESC;
USE inventory_db;

CREATE OR REPLACE VIEW rop_analysis AS
SELECT
    `Product Name`,
    ROUND(
        SUM(`Units Sold`) / 608 * 365,
        0
    ) AS annual_demand,
    ROUND(
        AVG(`Lead Time (Days)`),
        2
    ) AS avg_lead_time,
    ROUND(
        (SUM(`Units Sold`) / 608 * 365 / 365)
        * AVG(`Lead Time (Days)`),
        0
    ) AS reorder_point
FROM inventory_analysis
GROUP BY `Product Name`;
SELECT *
FROM rop_analysis
ORDER BY reorder_point DESC;