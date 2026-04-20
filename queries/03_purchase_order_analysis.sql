

-- 1. Full Purchase Order Details with Line Items
-- Joins Purchase_Order, PO_Item, and Product for complete order view

CREATE VIEW vw_Purchase_Order_Details AS
SELECT 
    po.PO_ID,
    po.order_date,
    po.status AS Order_Status,
    po.total_amount AS PO_Total,
    poi.Item_number,
    p.Product_ID,
    p.Product_name,
    p.Category,
    poi.ordered_quantity,
    poi.unit_price AS Ordered_Price,
    p.Unit_price AS Market_Price,
    (poi.ordered_quantity * poi.unit_price) AS Line_Total,
    ((poi.unit_price - p.Unit_price) / p.Unit_price) * 100 AS Price_Diff_Percent
FROM Purchase_Order po
INNER JOIN PO_Item poi ON po.PO_ID = poi.PO_ID
INNER JOIN Product p ON poi.Product_ID = p.Product_ID;


-- 2. Purchase Order Status Summary
-- How many orders are in each status and their total value
CREATE VIEW vw_Purchase_Order_Status_Summary AS
SELECT 
    status AS Order_Status,
    COUNT(*) AS Order_Count,
    SUM(total_amount) AS Total_Value,
    AVG(total_amount) AS Avg_Order_Value,
    MIN(total_amount) AS Smallest_Order,
    MAX(total_amount) AS Largest_Order
FROM Purchase_Order
GROUP BY status;


-- 3. Procurement Spend Per Product
-- Which products are being ordered most and at what total cost
CREATE VIEW vw_Procurement_Spend_Per_Product AS
SELECT 
    p.Product_ID,
    p.Product_name,
    p.Category,
    COUNT(DISTINCT poi.PO_ID) AS Times_Ordered,
    SUM(poi.ordered_quantity) AS Total_Units_Ordered,
    SUM(poi.ordered_quantity * poi.unit_price) AS Total_Spend,
    AVG(poi.unit_price) AS Avg_Purchase_Price,
    p.Unit_price AS Current_Market_Price
FROM PO_Item poi
INNER JOIN Product p ON poi.Product_ID = p.Product_ID
GROUP BY p.Product_ID, p.Product_name, p.Category, p.Unit_price;


-- 4. RFQ to Purchase Order Conversion
-- Tracks which RFQs led to actual purchase orders
CREATE VIEW vw_RFQ_to_PO_Conversion AS
SELECT 
    rfq.RFQ_ID,
    rf.issue_date AS RF_Issue_Date,
    rf.status AS RF_Status,
    COUNT(ri.item_number) AS Items_In_RFQ,
    po.PO_ID,
    po.order_date AS PO_Date,
    po.status AS PO_Status,
    po.total_amount AS PO_Value,
    DATEDIFF(DAY, rf.issue_date, po.order_date) AS Days_To_Order
FROM RFQ rfq
INNER JOIN RF rf ON rfq.RF_ID = rf.RF_ID
LEFT JOIN RFQ_items ri ON rfq.RFQ_ID = ri.RFQ_ID
LEFT JOIN Purchase_Order po ON rfq.RFQ_ID = po.RFQ_ID
GROUP BY 
    rfq.RFQ_ID,
    rf.issue_date,
    rf.status,
    po.PO_ID,
    po.order_date,
    po.status,
    po.total_amount;
