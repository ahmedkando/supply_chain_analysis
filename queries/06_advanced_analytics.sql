-- ============================================================
-- ADVANCED ANALYTICS
-- Window functions, trends, and inventory turnover analysis
-- ============================================================


-- ============================================================
-- 1. TOP 3 SUPPLIERS PER PRODUCT (WINDOW FUNCTIONS)
-- Ranks all suppliers for each product by price and lead time
-- Uses RANK() window function to identify best options
-- ============================================================

-- 1a. Top 3 Suppliers Per Product by Price (Cheapest First)
SELECT *
FROM (
    SELECT
        p.Product_name,
        p.Category,
        s.Name                                              AS Supplier_Name,
        sup.Supplier_price,
        p.Unit_price                                        AS Market_Price,
        ROUND(((sup.Supplier_price - p.Unit_price)
              / p.Unit_price) * 100, 2)                    AS Price_Variance_Pct,
        sup.Lead_Time                                       AS Lead_Time_Days,
        RANK() OVER (
            PARTITION BY p.Product_ID
            ORDER BY sup.Supplier_price ASC
        )                                                   AS Price_Rank
    FROM Supplies sup
    INNER JOIN Product  p ON sup.Product_ID  = p.Product_ID
    INNER JOIN Supplier s ON sup.Supplier_ID = s.Supplier_ID
) ranked
WHERE Price_Rank <= 3
ORDER BY Product_name, Price_Rank;


-- 1b. Top 3 Suppliers Per Product by Lead Time (Fastest First)
SELECT *
FROM (
    SELECT
        p.Product_name,
        p.Category,
        s.Name                                              AS Supplier_Name,
        sup.Lead_Time                                       AS Lead_Time_Days,
        sup.Supplier_price,
        RANK() OVER (
            PARTITION BY p.Product_ID
            ORDER BY sup.Lead_Time ASC
        )                                                   AS Speed_Rank
    FROM Supplies sup
    INNER JOIN Product  p ON sup.Product_ID  = p.Product_ID
    INNER JOIN Supplier s ON sup.Supplier_ID = s.Supplier_ID
) ranked
WHERE Speed_Rank <= 3
ORDER BY Product_name, Speed_Rank;


-- 1c. Best Overall Supplier Per Product (Balanced Score)
-- Combines price rank and speed rank into a single score
-- Lower score = better overall supplier
SELECT *
FROM (
    SELECT
        p.Product_name,
        p.Category,
        s.Name                                              AS Supplier_Name,
        sup.Supplier_price,
        sup.Lead_Time                                       AS Lead_Time_Days,
        RANK() OVER (
            PARTITION BY p.Product_ID
            ORDER BY sup.Supplier_price ASC
        )                                                   AS Price_Rank,
        RANK() OVER (
            PARTITION BY p.Product_ID
            ORDER BY sup.Lead_Time ASC
        )                                                   AS Speed_Rank,
        RANK() OVER (
            PARTITION BY p.Product_ID
            ORDER BY sup.Supplier_price ASC
        ) +
        RANK() OVER (
            PARTITION BY p.Product_ID
            ORDER BY sup.Lead_Time ASC
        )                                                   AS Combined_Score
    FROM Supplies sup
    INNER JOIN Product  p ON sup.Product_ID  = p.Product_ID
    INNER JOIN Supplier s ON sup.Supplier_ID = s.Supplier_ID
) scored
ORDER BY Product_name, Combined_Score ASC;


-- ============================================================
-- 2. MONTHLY REVENUE TREND
-- Tracks revenue over time to identify growth patterns
-- ============================================================

-- 2a. Monthly Revenue from Customer Orders
SELECT
    DATE_FORMAT(co.order_date, '%Y-%m')             AS Month,
    DATE_FORMAT(co.order_date, '%M %Y')             AS Month_Label,
    COUNT(DISTINCT co.Order_ID)                     AS Total_Orders,
    COUNT(oi.Item_number)                           AS Total_Line_Items,
    SUM(oi.quantity)                                AS Total_Units_Sold,
    ROUND(SUM(oi.quantity * oi.unit_price), 2)      AS Monthly_Revenue,
    ROUND(AVG(oi.quantity * oi.unit_price), 2)      AS Avg_Item_Revenue
FROM Customer_Order co
INNER JOIN Order_Item oi ON co.Order_ID = oi.Order_ID
GROUP BY DATE_FORMAT(co.order_date, '%Y-%m'), DATE_FORMAT(co.order_date, '%M %Y')
ORDER BY Month ASC;


-- 2b. Monthly Revenue with Running Total
-- Shows cumulative revenue growth over time
SELECT
    Month,
    Month_Label,
    Total_Orders,
    Monthly_Revenue,
    ROUND(SUM(Monthly_Revenue) OVER (
        ORDER BY Month
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ), 2)                                           AS Cumulative_Revenue,
    ROUND(Monthly_Revenue - LAG(Monthly_Revenue, 1) OVER (
        ORDER BY Month
    ), 2)                                           AS Revenue_Change_vs_Last_Month,
    ROUND(((Monthly_Revenue - LAG(Monthly_Revenue, 1) OVER (ORDER BY Month))
          / NULLIF(LAG(Monthly_Revenue, 1) OVER (ORDER BY Month), 0)) * 100
    , 2)                                            AS Growth_Pct
FROM (
    SELECT
        DATE_FORMAT(co.order_date, '%Y-%m')         AS Month,
        DATE_FORMAT(co.order_date, '%M %Y')         AS Month_Label,
        COUNT(DISTINCT co.Order_ID)                 AS Total_Orders,
        ROUND(SUM(oi.quantity * oi.unit_price), 2)  AS Monthly_Revenue
    FROM Customer_Order co
    INNER JOIN Order_Item oi ON co.Order_ID = oi.Order_ID
    GROUP BY DATE_FORMAT(co.order_date, '%Y-%m'),
             DATE_FORMAT(co.order_date, '%M %Y')
) monthly
ORDER BY Month ASC;


-- 2c. Monthly Revenue by Product Category
-- Which category drives the most revenue each month
SELECT
    DATE_FORMAT(co.order_date, '%Y-%m')             AS Month,
    p.Category,
    COUNT(DISTINCT co.Order_ID)                     AS Orders,
    SUM(oi.quantity)                                AS Units_Sold,
    ROUND(SUM(oi.quantity * oi.unit_price), 2)      AS Category_Revenue,
    ROUND(SUM(oi.quantity * oi.unit_price) * 100.0
        / SUM(SUM(oi.quantity * oi.unit_price)) OVER (
            PARTITION BY DATE_FORMAT(co.order_date, '%Y-%m')
        ), 2)                                       AS Pct_Of_Monthly_Revenue
FROM Customer_Order co
INNER JOIN Order_Item  oi ON co.Order_ID  = oi.Order_ID
INNER JOIN Product      p ON oi.Product_ID = p.Product_ID
GROUP BY DATE_FORMAT(co.order_date, '%Y-%m'), p.Category
ORDER BY Month ASC, Category_Revenue DESC;


-- ============================================================
-- 3. INVENTORY TURNOVER
-- Measures how efficiently inventory is being sold and restocked
-- Higher turnover = inventory moving faster = healthier operation
-- Formula: Turnover = Units Sold / Average Inventory on Hand
-- ============================================================

-- 3a. Inventory Turnover Per Product
SELECT
    p.Product_name,
    p.Category,
    p.Unit_price,
    COALESCE(SUM(oi.quantity), 0)                   AS Total_Units_Sold,
    COALESCE(SUM(i.quantity_on_hand), 0)            AS Current_Stock,
    p.Available_quantity                             AS Listed_Available,
    CASE
        WHEN COALESCE(SUM(i.quantity_on_hand), 0) = 0 THEN NULL
        ELSE ROUND(COALESCE(SUM(oi.quantity), 0)
                  / SUM(i.quantity_on_hand), 2)
    END                                             AS Inventory_Turnover_Ratio,
    CASE
        WHEN COALESCE(SUM(i.quantity_on_hand), 0) = 0 THEN 'OUT OF STOCK'
        WHEN COALESCE(SUM(oi.quantity), 0)
           / NULLIF(SUM(i.quantity_on_hand), 0) >= 1   THEN 'HIGH TURNOVER'
        WHEN COALESCE(SUM(oi.quantity), 0)
           / NULLIF(SUM(i.quantity_on_hand), 0) >= 0.5 THEN 'MODERATE TURNOVER'
        ELSE 'LOW TURNOVER'
    END                                             AS Turnover_Status
FROM Product p
LEFT JOIN Inventory    i  ON p.Product_ID  = i.Product_ID
LEFT JOIN Order_Item   oi ON p.Product_ID  = oi.Product_ID
GROUP BY p.Product_ID, p.Product_name, p.Category,
         p.Unit_price, p.Available_quantity
ORDER BY Inventory_Turnover_Ratio DESC;


-- 3b. Inventory Turnover Per Warehouse
-- Which warehouse moves stock the fastest
SELECT
    w.name                                          AS Warehouse_Name,
    w.location,
    w.capacity                                      AS Total_Capacity,
    SUM(i.quantity_on_hand)                         AS Current_Stock,
    ROUND(SUM(i.quantity_on_hand) * 100.0
         / w.capacity, 2)                           AS Utilization_Pct,
    COUNT(DISTINCT i.Product_ID)                    AS Unique_Products_Stored,
    ROUND(SUM(i.quantity_on_hand * p.Unit_price), 2) AS Stock_Value
FROM Warehouse w
LEFT JOIN Inventory i ON w.Warehouse_ID = i.Warehouse_ID
LEFT JOIN Product   p ON i.Product_ID   = p.Product_ID
GROUP BY w.Warehouse_ID, w.name, w.location, w.capacity
ORDER BY Stock_Value DESC;


-- 3c. Dead Stock Detection
-- Products with stock but zero sales — potential waste
SELECT
    p.Product_name,
    p.Category,
    p.Unit_price,
    SUM(i.quantity_on_hand)                         AS Stock_On_Hand,
    ROUND(SUM(i.quantity_on_hand) * p.Unit_price, 2) AS Tied_Up_Value,
    COALESCE(SUM(oi.quantity), 0)                   AS Units_Ever_Sold,
    CASE
        WHEN COALESCE(SUM(oi.quantity), 0) = 0 THEN 'DEAD STOCK'
        WHEN COALESCE(SUM(oi.quantity), 0) < 5 THEN 'SLOW MOVING'
        ELSE 'ACTIVE'
    END                                             AS Stock_Health
FROM Product p
LEFT JOIN Inventory  i  ON p.Product_ID = i.Product_ID
LEFT JOIN Order_Item oi ON p.Product_ID = oi.Product_ID
GROUP BY p.Product_ID, p.Product_name, p.Category, p.Unit_price
HAVING Stock_On_Hand > 0
ORDER BY Units_Ever_Sold ASC, Tied_Up_Value DESC;
