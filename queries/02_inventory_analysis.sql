-- ============================================================
-- INVENTORY ANALYSIS
-- Monitors stock levels, warehouse capacity, and product distribution
-- ============================================================


-- 1. Current Inventory Levels Per Warehouse
-- Full picture of what stock is where

SELECT 
    w.name AS Warehouse_Name,
    w.location AS Warehouse_Location,
    p.Product_name,
    p.Category,
    i.quantity_on_hand,
    p.Unit_price,
    ROUND(i.quantity_on_hand * p.Unit_price, 2) AS Stock_Value,
    i.last_updated_date
FROM Inventory i
INNER JOIN Warehouse w ON i.Warehouse_ID = w.Warehouse_ID
INNER JOIN Product p ON i.Product_ID = p.Product_ID
ORDER BY w.name, Stock_Value DESC;


-- 2. Warehouse Capacity Utilization
-- Shows how full each warehouse is as a percentage

SELECT 
    w.name AS Warehouse_Name,
    w.location,
    w.capacity AS Total_Capacity,
    SUM(i.quantity_on_hand) AS Total_Stock,
    ROUND((SUM(i.quantity_on_hand) / w.capacity) * 100, 2) AS Utilization_Percent,
    (w.capacity - SUM(i.quantity_on_hand)) AS Remaining_Capacity
FROM Warehouse w
LEFT JOIN Inventory i ON w.Warehouse_ID = i.Warehouse_ID
GROUP BY w.Warehouse_ID, w.name, w.location, w.capacity
ORDER BY Utilization_Percent DESC;


-- 3. Low Stock Alert
-- Products where total inventory falls below 25 units (reorder threshold)

SELECT 
    p.Product_name,
    p.Category,
    p.Unit_price,
    SUM(i.quantity_on_hand) AS Total_Stock_All_Warehouses,
    CASE 
        WHEN SUM(i.quantity_on_hand) < 10 THEN 'CRITICAL'
        WHEN SUM(i.quantity_on_hand) < 25 THEN 'LOW'
        ELSE 'OK'
    END AS Stock_Status
FROM Product p
LEFT JOIN Inventory i ON p.Product_ID = i.Product_ID
GROUP BY p.Product_ID, p.Product_name, p.Category, p.Unit_price
ORDER BY Total_Stock_All_Warehouses ASC;


-- 4. Products Stored Across Multiple Warehouses
-- Identifies which products are distributed across locations

SELECT 
    p.Product_name,
    p.Category,
    COUNT(i.Warehouse_ID) AS Warehouse_Count,
    SUM(i.quantity_on_hand) AS Total_Quantity,
    GROUP_CONCAT(w.name ORDER BY w.name SEPARATOR ' | ') AS Stored_In
FROM Product p
INNER JOIN Inventory i ON p.Product_ID = i.Product_ID
INNER JOIN Warehouse w ON i.Warehouse_ID = w.Warehouse_ID
GROUP BY p.Product_ID, p.Product_name, p.Category
ORDER BY Warehouse_Count DESC;


-- 5. Total Inventory Value by Category

SELECT 
    p.Category,
    COUNT(DISTINCT p.Product_ID) AS Unique_Products,
    SUM(i.quantity_on_hand) AS Total_Units,
    ROUND(SUM(i.quantity_on_hand * p.Unit_price), 2) AS Total_Category_Value,
    ROUND(AVG(p.Unit_price), 2) AS Avg_Unit_Price
FROM Product p
INNER JOIN Inventory i ON p.Product_ID = i.Product_ID
GROUP BY p.Category
ORDER BY Total_Category_Value DESC;
