

-- 1. Delivery Time Analysis Per Transaction
-- Calculates actual delivery duration and flags delays

SELECT 
    t.Transaction_ID,
    t.transaction_date AS Order_Initiated,
    t.delv AS Dispatch_Date,
    t.recv AS Received_Date,
    DATEDIFF(t.recv, t.delv) AS Transit_Days,
    DATEDIFF(t.recv, t.transaction_date) AS Total_Fulfillment_Days,
    t.condition AS Delivery_Condition,
    t.status AS Delivery_Status,
    t.notes,
    c.name AS Carrier_Name,
    c.service_type AS Carrier_Type
FROM Transaction_record t
INNER JOIN Carrier c ON t.Carrier_ID = c.Carrier_ID
ORDER BY Total_Fulfillment_Days DESC;


-- 2. Carrier Performance Summary
-- Ranks carriers by average delivery time and transaction count

SELECT 
    c.name AS Carrier_Name,
    c.service_type,
    COUNT(t.Transaction_ID) AS Total_Deliveries,
    ROUND(AVG(DATEDIFF(t.recv, t.delv)), 1) AS Avg_Transit_Days,
    MIN(DATEDIFF(t.recv, t.delv)) AS Fastest_Delivery_Days,
    MAX(DATEDIFF(t.recv, t.delv)) AS Slowest_Delivery_Days,
    SUM(CASE WHEN t.status = 'Completed' THEN 1 ELSE 0 END) AS Completed,
    SUM(CASE WHEN t.status = 'In Transit' THEN 1 ELSE 0 END) AS In_Transit
FROM Carrier c
LEFT JOIN Transaction_record t ON c.Carrier_ID = t.Carrier_ID
GROUP BY c.Carrier_ID, c.name, c.service_type
ORDER BY Avg_Transit_Days ASC;


-- 3. Warehouse Receiving Activity
-- Which warehouses are receiving the most deliveries

SELECT 
    w.name AS Warehouse_Name,
    w.location,
    COUNT(t.Transaction_ID) AS Deliveries_Received,
    SUM(CASE WHEN t.condition = 'Good' THEN 1 ELSE 0 END) AS Good_Condition,
    SUM(CASE WHEN t.condition != 'Good' THEN 1 ELSE 0 END) AS Damaged_Or_Issues,
    GROUP_CONCAT(DISTINCT c.service_type SEPARATOR ' | ') AS Carrier_Types_Used
FROM Warehouse w
LEFT JOIN Transaction_record t ON w.Warehouse_ID = t.Warehouse_ID
LEFT JOIN Carrier c ON t.Carrier_ID = c.Carrier_ID
GROUP BY w.Warehouse_ID, w.name, w.location
ORDER BY Deliveries_Received DESC;


-- 4. Full Transaction Audit Trail
-- Complete view linking PO to delivery to receiver

SELECT 
    t.Transaction_ID,
    po.PO_ID,
    po.total_amount AS PO_Value,
    po.status AS PO_Status,
    c.name AS Carrier,
    c.service_type,
    w.name AS Destination_Warehouse,
    r.name AS Received_By,
    r.role AS Receiver_Role,
    t.transaction_date,
    t.delv AS Dispatched,
    t.recv AS Received,
    t.condition,
    t.status AS Transaction_Status,
    t.notes
FROM Transaction_record t
INNER JOIN Purchase_Order po ON t.PO_ID = po.PO_ID
INNER JOIN Carrier c ON t.Carrier_ID = c.Carrier_ID
INNER JOIN Warehouse w ON t.Warehouse_ID = w.Warehouse_ID
INNER JOIN Receiver r ON t.Receiver_ID = r.Receiver_ID
ORDER BY t.transaction_date DESC;
