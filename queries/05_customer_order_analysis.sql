
-- 1. Customer Order Summary with Revenue
-- Full breakdown of what each customer ordered and spent

CREATE VIEW vw_Customer_Order_Summary AS
SELECT 
    cu.Customer_ID,
    cu.name AS Customer_Name,
    cu.address AS Customer_Location,
    co.Order_ID,
    co.order_date,
    co.status AS Order_Status,
    COUNT(oi.Item_number) AS Items_In_Order,
    SUM(oi.quantity) AS Total_Units,
    SUM(oi.quantity * oi.unit_price) AS Order_Revenue
FROM Customer cu
INNER JOIN Customer_Order co ON cu.Customer_ID = co.Customer_ID
INNER JOIN Order_Item oi ON co.Order_ID = oi.Order_ID
GROUP BY 
    cu.Customer_ID, cu.name, cu.address,
    co.Order_ID, co.order_date, co.status;

-- 2. Top Products by Customer Demand
-- Which products customers order most frequently
CREATE VIEW vw_Top_Products_By_Demand AS
SELECT 
    p.Product_ID,
    p.Product_name,
    p.Category,
    COUNT(DISTINCT oi.Order_ID) AS Orders_Count,
    SUM(oi.quantity) AS Total_Units_Sold,
    SUM(oi.quantity * oi.unit_price) AS Total_Revenue,
    AVG(oi.unit_price) AS Avg_Selling_Price,
    p.Unit_price AS Listed_Price
FROM Order_Item oi
INNER JOIN Product p ON oi.Product_ID = p.Product_ID
GROUP BY 
    p.Product_ID, p.Product_name, p.Category, p.Unit_price;


-- 3. Customer Revenue Ranking
-- Total revenue and order count per customer

CREATE VIEW vw_Customer_Revenue_Ranking AS
SELECT 
    cu.Customer_ID,
    cu.name AS Customer_Name,
    COUNT(DISTINCT co.Order_ID) AS Total_Orders,
    SUM(oi.quantity) AS Total_Units_Purchased,
    SUM(oi.quantity * oi.unit_price) AS Total_Revenue,
    AVG(oi.quantity * oi.unit_price) AS Avg_Item_Value
FROM Customer cu
INNER JOIN Customer_Order co ON cu.Customer_ID = co.Customer_ID
INNER JOIN Order_Item oi ON co.Order_ID = oi.Order_ID
GROUP BY cu.Customer_ID, cu.name;

-- 4. Order Fulfillment Status Tracker
-- Connects customer orders to their delivery transaction status

CREATE VIEW vw_Order_Fulfillment_Tracker AS
SELECT 
    cu.Customer_ID,
    cu.name AS Customer_Name,
    co.Order_ID,
    co.order_date,
    co.status AS Order_Status,
    t.status AS Delivery_Status,
    t.condition AS Delivery_Condition,
    c.name AS Carrier_Name,
    w.name AS Warehouse_Name,
    DATEDIFF(DAY, co.order_date, t.recv) AS Days_To_Fulfill
FROM Customer_Order co
INNER JOIN Customer cu ON co.Customer_ID = cu.Customer_ID
LEFT JOIN Transaction_record t ON co.Transaction_ID = t.Transaction_ID
LEFT JOIN Carrier c ON t.Carrier_ID = c.Carrier_ID
LEFT JOIN Warehouse w ON t.Warehouse_ID = w.Warehouse_ID;

-- 5. Revenue by Product Category
-- High level sales performance by category
CREATE VIEW vw_Revenue_By_Category AS
SELECT 
    p.Category,
    COUNT(DISTINCT oi.Order_ID) AS Orders,
    SUM(oi.quantity) AS Units_Sold,
    SUM(oi.quantity * oi.unit_price) AS Total_Revenue,
    AVG(oi.unit_price) AS Avg_Price
FROM Order_Item oi
INNER JOIN Product p ON oi.Product_ID = p.Product_ID
GROUP BY p.Category;