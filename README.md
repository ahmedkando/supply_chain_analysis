📊 Procurement & Supply Chain Management System

📌 Project Overview

This project implements a full Procurement and Supply Chain Management System backed by a relational SQL database. It tracks the entire lifecycle from:

Supplier requests (RF, RFI, RFQ)
Purchase orders
Inventory & warehouse management
Logistics & delivery
Customer orders & revenue

The Power BI dashboard transforms raw transactional data into interactive insights across multiple business domains, enabling data-driven decision-making and operational monitoring.

🗄️ Database Schema

The system is designed using a normalized relational database with the following modules:

🔹 Modules & Tables
Module	Tables	Description
Procurement	RF, RFI, RFQ, RFQ_items	Request lifecycle management
Suppliers	Supplier, SupplierContact, Supplies, Receives	Supplier profiles & relationships
Products	Product	Product catalog
Purchase Orders	Purchase_Order, PO_Item	Orders and line items
Warehouse	Warehouse, Inventory	Stock & storage
Logistics	Carrier, Receiver, Transaction_record	Shipment tracking
Customers	Customer, Customer_Order, Order_Item	Sales & customer data
📁 SQL Files
File	Purpose
create_tables.sql	Create database schema
insert_data.sql	Insert sample dataset
01_supplier_analysis.sql	Supplier analytics views
02_inventory_analysis.sql	Inventory & warehouse views
03_purchase_order_analysis.sql	Procurement analytics
04_delivery_performance.sql	Logistics & delivery views
05_customer_order_analysis.sql	Sales & customer analytics
📊 Analytical Views

All views are designed for Power BI consumption (clean, aggregated, no ORDER BY).

🔹 Supplier Analysis
Supplier_Price_Competitiveness
Supplier_Lead_Time_Ranking
Supplier_Portfolio_Overview
Suppliers_Who_Received_RFIs
🔹 Inventory Analysis
vw_Current_Inventory_Levels
vw_Warehouse_Capacity_Utilization
vw_Low_Stock_Alert
vw_Products_Multi_Warehouse
vw_Inventory_Value_By_Category
🔹 Purchase Order Analysis
vw_Purchase_Order_Details
vw_Purchase_Order_Status_Summary
vw_Procurement_Spend_Per_Product
vw_RFQ_to_PO_Conversion
🔹 Delivery Performance
vw_Delivery_Time_Analysis
vw_Carrier_Performance
vw_Warehouse_Activity
vw_Transaction_Audit
🔹 Customer & Sales Analysis
vw_Customer_Order_Summary
vw_Top_Products_By_Demand
vw_Customer_Revenue_Ranking
vw_Order_Fulfillment_Tracker
vw_Revenue_By_Category
📈 Power BI Dashboard

The dashboard is built using Microsoft Power BI Desktop and organized into 5 pages:

Page	Focus Area	Key Visuals
1	Supplier Analysis	Lead time chart, price variance, portfolio
2	Inventory	Warehouse utilization, stock alerts
3	Purchase Orders	PO status, spend analysis
4	Logistics	Carrier performance, delivery tracking
5	Sales	Customer revenue, product demand
⚙️ How to Run
🔹 Step 1 — Setup Database
Open your SQL tool (SSMS / MySQL Workbench)
Run:
create_tables.sql
insert_data.sql
Execute all analysis files (01 → 05) to create views
🔹 Step 2 — Connect Power BI
Open Power BI Desktop
Click Get Data → SQL Server / MySQL
Enter server name
Load all views (vw_*)
Build visuals
🧰 Technology Stack
Component	Technology
Database	SQL Server / MySQL
Query Language	SQL (DDL + DML + Views)
Visualization	Microsoft Power BI
Data Model	Star schema via views
Features	Slicers, Filters, Drill-down
📂 Project Structure
procurement-dashboard/
│
├── create_tables.sql
├── insert_data.sql
├── 01_supplier_analysis.sql
├── 02_inventory_analysis.sql
├── 03_purchase_order_analysis.sql
├── 04_delivery_performance.sql
├── 05_customer_order_analysis.sql
│
├── dashboard.pbix
└── README.md
💡 Key Insights Delivered
📉 Identify most cost-efficient suppliers
⏱ Analyze lead times & delivery performance
📦 Monitor inventory levels & warehouse utilization
💰 Track procurement spend
🚚 Evaluate carrier performance
📊 Discover top customers & best-selling products
🚀 Future Improvements
Add real-time data pipeline
Integrate forecasting (demand prediction)
Add alerts for low stock & delays
Deploy dashboard to Power BI Service
👨‍💻 Author

Ahmed Kandeel
Computer Science Student | Data & Full-Stack Enthusiast