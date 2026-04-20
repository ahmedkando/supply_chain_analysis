CREATE VIEW Supplier_Price_Competitiveness AS 
SELECT 
    s.Name AS Supplier_Name,
    p.Product_name,
    p.Category,
    sup.Supplier_price,
    p.Unit_price AS Market_Price,
    ROUND(((sup.Supplier_price - p.Unit_price) / p.Unit_price) * 100, 2) AS Price_Variance_Percent,
    sup.Lead_Time AS Lead_Time_Days
FROM Supplies sup
INNER JOIN Supplier s ON sup.Supplier_ID = s.Supplier_ID
INNER JOIN Product p ON sup.Product_ID = p.Product_ID;

CREATE VIEW Supplier_Lead_Time_Ranking AS 
SELECT 
    s.Supplier_ID,
    s.Name AS Supplier_Name,
    COUNT(sup.Product_ID) AS Products_Supplied,
    AVG(CAST(sup.Lead_Time AS FLOAT)) AS Avg_Lead_Time_Days,
    MIN(sup.Lead_Time) AS Fastest_Delivery,
    MAX(sup.Lead_Time) AS Slowest_Delivery
FROM Supplier s
INNER JOIN Supplies sup ON s.Supplier_ID = sup.Supplier_ID
GROUP BY s.Supplier_ID, s.Name;

CREATE VIEW Supplier_Portfolio_Overview AS
SELECT 
    s.Name AS Supplier_Name,
    s.Address,
    COUNT(sup.Product_ID) AS Total_Products,
    SUM(sup.Supplier_price) AS Total_Portfolio_Value,
    AVG(sup.Supplier_price) AS Avg_Product_Price,
    MIN(sup.Supplier_price) AS Cheapest_Product,
    MAX(sup.Supplier_price) AS Most_Expensive_Product
FROM Supplier s
LEFT JOIN Supplies sup ON s.Supplier_ID = sup.Supplier_ID
GROUP BY s.Supplier_ID, s.Name, s.Address;

CREATE VIEW Suppliers_Who_Received_RFIs AS
SELECT 
    s.Name AS Supplier_Name,
    r.RFI_ID,
    rf.issue_date AS RF_Issue_Date,
    rf.due_date AS RF_Due_Date,
    rf.status AS RF_Status
FROM Supplier s
INNER JOIN Receives rec ON s.Supplier_ID = rec.Supplier_ID
INNER JOIN RFI r ON rec.RFI_ID = r.RFI_ID
INNER JOIN RF rf ON r.RF_ID = rf.RF_ID;