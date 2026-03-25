# Supply Chain Data Analysis (SQL + Power BI)

A relational database project simulating a real-world supply chain system — from supplier procurement and inventory management to customer order fulfillment. Built to demonstrate SQL database design, analytical querying, and data visualization skills.

---

## Project Overview

This project models the full supply chain lifecycle:

**Supplier → RFI → RFQ → Purchase Order → Warehouse → Customer Order**

It includes 18 relational tables covering procurement, inventory, logistics, and sales — with 20+ analytical SQL queries and a Power BI dashboard for visual reporting.

---

## Database Schema

| Area | Tables |
|---|---|
| Procurement | RF, RFI, RFQ, RFQ_items |
| Suppliers | Supplier, SupplierContact, Supplies, Receives |
| Orders | Purchase_Order, PO_Item |
| Warehouse | Warehouse, Inventory |
| Logistics | Carrier, Receiver, Transaction_record |
| Customers | Customer, Customer_Order, Order_Item, Product |

---

## Project Structure

```
supply-chain-analysis/
│
├── README.md
├── schema/
│   └── create_tables.sql          -- All table definitions and relationships
├── data/
│   └── insert_data.sql            -- Sample data for testing
└── queries/
    ├── 01_supplier_analysis.sql   -- Supplier pricing, lead time, portfolio
    ├── 02_inventory_analysis.sql  -- Stock levels, warehouse utilization, alerts
    ├── 03_purchase_order_analysis.sql -- Spend tracking, order status, RFQ conversion
    ├── 04_delivery_performance.sql    -- Carrier performance, transit times, audit trail
    ├── 05_customer_order_analysis.sql -- Revenue, demand, fulfillment tracking
    └── 06_advanced_analytics.sql      -- Window functions, revenue trends, inventory turnover
```

---

## Key Analyses

### Supplier Analysis
- Price competitiveness vs market price with variance percentage
- Lead time ranking to identify fastest suppliers
- Supplier portfolio value and product coverage

### Inventory Analysis
- Real-time stock levels per warehouse
- Warehouse capacity utilization percentage
- Low stock alerts with CRITICAL / LOW / OK classification
- Total inventory value by product category

### Purchase Order Analysis
- Full PO breakdown with line items and price comparison
- Order status summary with total procurement spend
- RFQ to PO conversion tracking with days-to-order metric

### Delivery Performance
- Transit time calculation per carrier
- Carrier performance ranking by average delivery speed
- Full transaction audit trail from PO to delivery

### Advanced Analytics (Window Functions)
- Top 3 suppliers per product ranked by price using RANK() OVER PARTITION BY
- Top 3 suppliers per product ranked by lead time
- Best overall supplier per product using combined price + speed score
- Monthly revenue trend with running cumulative total using SUM() OVER
- Month-over-month revenue change and growth percentage using LAG()
- Monthly revenue breakdown by product category with percentage share
- Inventory turnover ratio per product with HIGH / MODERATE / LOW classification
- Inventory turnover and stock value per warehouse
- Dead stock detection — products with stock but no sales

### Customer Order Analysis
- Revenue per customer and per product
- Top products by demand and sales volume
- Order fulfillment tracker with delivery status

---

## Tools Used

- **MySQL** — Database design and querying
- **Power BI** — Dashboard and data visualization
- **SQL** — DDL, DML, JOINs, aggregations, CASE statements, subqueries

---

## How to Run

1. Run `schema/create_tables.sql` to create the database
2. Run `data/insert_data.sql` to populate with sample data
3. Run any query file from the `queries/` folder in MySQL Workbench or any SQL client

---

## Skills Demonstrated

- Relational database design and normalization
- Foreign key relationships and composite primary keys
- Multi-table JOINs (INNER, LEFT)
- Aggregate functions (SUM, AVG, COUNT, MIN, MAX)
- Window functions (RANK, LAG, SUM OVER, PARTITION BY)
- CASE statements for conditional logic
- DATEDIFF for time-based analysis
- GROUP BY, HAVING, ORDER BY
- GROUP_CONCAT for readable output
- Subqueries and CTEs
