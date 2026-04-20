CREATE VIEW vw_Current_Inventory_Levels AS
SELECT 
    w.name AS Warehouse_Name,
    w.location AS Warehouse_Location,
    p.Product_name,
    p.Category,
    i.quantity_on_hand,
    p.Unit_price,
    (i.quantity_on_hand * p.Unit_price) AS Stock_Value,
    i.last_updated_date
FROM Inventory i
INNER JOIN Warehouse w ON i.Warehouse_ID = w.Warehouse_ID
INNER JOIN Product p ON i.Product_ID = p.Product_ID;

CREATE VIEW vw_Warehouse_Capacity_Utilization AS
SELECT 
    w.Warehouse_ID,
    w.name AS Warehouse_Name,
    w.location,
    w.capacity AS Total_Capacity,
    SUM(i.quantity_on_hand) AS Total_Stock,
    ROUND((SUM(i.quantity_on_hand) * 100.0) / w.capacity, 2) AS Utilization_Percent,
    (w.capacity - SUM(i.quantity_on_hand)) AS Remaining_Capacity
FROM Warehouse w
LEFT JOIN Inventory i ON w.Warehouse_ID = i.Warehouse_ID
GROUP BY w.Warehouse_ID, w.name, w.location, w.capacity;


CREATE VIEW vw_Low_Stock_Alert AS
SELECT 
    p.Product_ID,
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
GROUP BY p.Product_ID, p.Product_name, p.Category, p.Unit_price;

CREATE VIEW vw_Products_Multi_Warehouse AS
SELECT 
    p.Product_ID,
    p.Product_name,
    p.Category,
    COUNT(DISTINCT i.Warehouse_ID) AS Warehouse_Count,
    SUM(i.quantity_on_hand) AS Total_Quantity
FROM Product p
INNER JOIN Inventory i ON p.Product_ID = i.Product_ID
GROUP BY p.Product_ID, p.Product_name, p.Category;

CREATE VIEW vw_Inventory_Value_By_Category AS
SELECT 
    p.Category,
    COUNT(DISTINCT p.Product_ID) AS Unique_Products,
    SUM(i.quantity_on_hand) AS Total_Units,
    SUM(i.quantity_on_hand * p.Unit_price) AS Total_Category_Value,
    AVG(p.Unit_price) AS Avg_Unit_Price
FROM Product p
INNER JOIN Inventory i ON p.Product_ID = i.Product_ID
GROUP BY p.Category;