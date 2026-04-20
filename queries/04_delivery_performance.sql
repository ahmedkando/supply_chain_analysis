

-- 1. Delivery Time Analysis Per Transaction
-- Calculates actual delivery duration and flags delays

CREATE VIEW vw_Delivery_Time_Analysis AS
SELECT 
    t.Transaction_ID,
    t.transaction_date AS Order_Initiated,
    t.delv AS Dispatch_Date,
    t.recv AS Received_Date,
    DATEDIFF(DAY, t.delv, t.recv) AS Transit_Days,
    DATEDIFF(DAY, t.transaction_date, t.recv) AS Total_Fulfillment_Days,
    t.condition AS Delivery_Condition,
    t.status AS Delivery_Status,
    t.notes,
    c.name AS Carrier_Name,
    c.service_type AS Carrier_Type
FROM Transaction_record t
INNER JOIN Carrier c ON t.Carrier_ID = c.Carrier_ID;

-- 2. Carrier Performance Summary
-- Ranks carriers by average delivery time and transaction count

CREATE VIEW vw_Carrier_Performance AS
SELECT 
    c.Carrier_ID,
    c.name AS Carrier_Name,
    c.service_type,
    COUNT(t.Transaction_ID) AS Total_Deliveries,
    ROUND(AVG(CAST(DATEDIFF(DAY, t.delv, t.recv) AS FLOAT)), 1) AS Avg_Transit_Days,
    MIN(DATEDIFF(DAY, t.delv, t.recv)) AS Fastest_Delivery_Days,
    MAX(DATEDIFF(DAY, t.delv, t.recv)) AS Slowest_Delivery_Days,
    SUM(CASE WHEN t.status = 'Completed' THEN 1 ELSE 0 END) AS Completed_Deliveries,
    SUM(CASE WHEN t.status = 'In Transit' THEN 1 ELSE 0 END) AS In_Transit_Deliveries
FROM Carrier c
LEFT JOIN Transaction_record t ON c.Carrier_ID = t.Carrier_ID
GROUP BY c.Carrier_ID, c.name, c.service_type;


-- 3. Warehouse Receiving Activity
-- Which warehouses are receiving the most deliveries

CREATE VIEW vw_Warehouse_Activity AS
SELECT 
    w.Warehouse_ID,
    w.name AS Warehouse_Name,
    w.location,
    COUNT(t.Transaction_ID) AS Deliveries_Received,
    SUM(CASE WHEN t.condition = 'Good' THEN 1 ELSE 0 END) AS Good_Condition,
    SUM(CASE WHEN t.condition <> 'Good' THEN 1 ELSE 0 END) AS Damaged_Or_Issues
FROM Warehouse w
LEFT JOIN Transaction_record t ON w.Warehouse_ID = t.Warehouse_ID
GROUP BY w.Warehouse_ID, w.name, w.location;

-- 4. Full Transaction Audit Trail
-- Complete view linking PO to delivery to receiver

CREATE VIEW vw_Transaction_Audit AS
SELECT 
    t.Transaction_ID,
    po.PO_ID,
    po.total_amount AS PO_Value,
    po.status AS PO_Status,
    c.name AS Carrier_Name,
    c.service_type AS Carrier_Type,
    w.name AS Warehouse_Name,
    r.name AS Receiver_Name,
    r.role AS Receiver_Role,
    t.transaction_date,
    t.delv AS Dispatch_Date,
    t.recv AS Received_Date,
    t.condition AS Delivery_Condition,
    t.status AS Transaction_Status,
    t.notes
FROM Transaction_record t
INNER JOIN Purchase_Order po ON t.PO_ID = po.PO_ID
INNER JOIN Carrier c ON t.Carrier_ID = c.Carrier_ID
INNER JOIN Warehouse w ON t.Warehouse_ID = w.Warehouse_ID
INNER JOIN Receiver r ON t.Receiver_ID = r.Receiver_ID;