-- ============================================================
-- SUPPLY CHAIN DATABASE - EXPANDED SAMPLE DATA
-- Realistic dataset for meaningful analytical results
-- ============================================================


-- -------------------- PROCUREMENT --------------------

INSERT INTO RF (RF_ID, issue_date, due_date, status) VALUES
(1, '2024-01-05', '2024-02-05', 'Closed'),
(2, '2024-01-15', '2024-02-15', 'Closed'),
(3, '2024-02-01', '2024-03-01', 'Closed'),
(4, '2024-02-20', '2024-03-20', 'Closed'),
(5, '2024-03-10', '2024-04-10', 'Closed'),
(6, '2024-04-01', '2024-05-01', 'Open'),
(7, '2024-04-15', '2024-05-15', 'Open'),
(8, '2024-05-01', '2024-06-01', 'Open');

INSERT INTO RFI (RFI_ID, RF_ID) VALUES
(101, 1), (102, 2), (103, 3),
(104, 4), (105, 5), (106, 6),
(107, 7), (108, 8);

INSERT INTO RFQ (RFQ_ID, RF_ID) VALUES
(201, 1), (202, 2), (203, 3),
(204, 4), (205, 5), (206, 6),
(207, 7), (208, 8);


-- -------------------- SUPPLIERS --------------------

INSERT INTO Supplier (Supplier_ID, Name, Address) VALUES
(1, 'Tech Supplies Inc',        '123 Industrial Rd, Cairo, Egypt'),
(2, 'Global Electronics',       '456 Commerce St, Alexandria, Egypt'),
(3, 'Delta Office Solutions',   '789 Business Park, Giza, Egypt'),
(4, 'Nile Hardware Co',         '321 Factory Ave, Cairo, Egypt'),
(5, 'MedTech Distributors',     '654 Health St, Alexandria, Egypt'),
(6, 'FastTrack Logistics Supp', '987 Logistics Blvd, Cairo, Egypt'),
(7, 'Prime Components Ltd',     '147 Industrial Zone, Mansoura, Egypt'),
(8, 'EgyTech Wholesale',        '258 Trade Center, Tanta, Egypt');

INSERT INTO SupplierContact (Supplier_ID, Contact_number) VALUES
(1, '+20-123-456-7890'), (1, '+20-123-456-7891'),
(2, '+20-987-654-3210'), (2, '+20-987-654-3211'),
(3, '+20-111-222-3333'), (3, '+20-111-222-3334'),
(4, '+20-444-555-6666'),
(5, '+20-777-888-9999'), (5, '+20-777-888-9998'),
(6, '+20-333-444-5555'),
(7, '+20-666-777-8888'), (7, '+20-666-777-8889'),
(8, '+20-222-333-4444');


-- -------------------- PRODUCTS --------------------

INSERT INTO Product (Product_ID, Product_name, Category, Unit_price, Available_quantity) VALUES
(1,  'Laptop Dell XPS 15',       'Electronics',   1500.00,  50),
(2,  'Office Chair Ergonomic',   'Furniture',      250.00, 100),
(3,  'Printer HP LaserJet',      'Electronics',    450.00,  30),
(4,  'Standing Desk Adjustable', 'Furniture',      600.00,  40),
(5,  'Monitor LG 27 inch',       'Electronics',    380.00,  60),
(6,  'Keyboard Mechanical',      'Electronics',     95.00, 150),
(7,  'Webcam Logitech HD',       'Electronics',     75.00,  80),
(8,  'Filing Cabinet 4-Drawer',  'Furniture',      180.00,  35),
(9,  'Whiteboard 120x90cm',      'Office Supplies', 90.00,  45),
(10, 'Paper A4 Box 5 Reams',     'Office Supplies', 25.00, 500),
(11, 'Toner Cartridge HP',       'Office Supplies',120.00,  90),
(12, 'UPS Power Backup 1500VA',  'Electronics',    350.00,  25),
(13, 'Network Switch 24-Port',   'Electronics',    420.00,  20),
(14, 'Office Desk Standard',     'Furniture',      320.00,  55),
(15, 'Headset Jabra Pro',        'Electronics',    160.00,  70);


-- -------------------- SUPPLIER-PRODUCT RELATIONSHIPS --------------------

INSERT INTO Supplies (Product_ID, Supplier_ID, Supplier_price, Lead_Time) VALUES
(1,  1, 1420.00,  7), (1,  7, 1460.00,  5), (1,  8, 1480.00, 10),
(2,  3,  235.00,  4), (2,  4,  242.00,  6),
(3,  1,  425.00, 10), (3,  2,  438.00,  8),
(4,  3,  570.00,  7), (4,  4,  585.00,  9),
(5,  2,  360.00,  6), (5,  7,  370.00,  4),
(6,  2,   88.00,  3), (6,  8,   91.00,  5),
(7,  2,   70.00,  3), (7,  6,   72.00,  2),
(8,  3,  168.00,  8), (8,  4,  172.00,  6),
(9,  3,   82.00,  5), (9,  4,   85.00,  4),
(10, 6,   22.00,  2), (10, 8,   23.00,  3),
(11, 1,  110.00,  5), (11, 2,  114.00,  4),
(12, 1,  330.00, 12), (12, 7,  338.00,  9),
(13, 7,  395.00,  8), (13, 8,  405.00, 11),
(14, 3,  300.00,  7), (14, 4,  308.00,  5),
(15, 2,  148.00,  4), (15, 6,  152.00,  3);

INSERT INTO Receives (Supplier_ID, RFI_ID) VALUES
(1, 101), (2, 101), (3, 102), (4, 102),
(1, 103), (7, 103), (2, 104), (5, 104),
(3, 105), (6, 105), (4, 106), (8, 106),
(7, 107), (8, 107), (1, 108), (2, 108);

INSERT INTO RFQ_items (item_number, RFQ_ID, requested_item, proposed_unit_price, Product_ID) VALUES
(1, 201, 'Laptop Dell XPS 15',        1450.00,  1),
(2, 201, 'Monitor LG 27 inch',         365.00,  5),
(1, 202, 'Office Chair Ergonomic',     240.00,  2),
(2, 202, 'Standing Desk Adjustable',   578.00,  4),
(1, 203, 'Printer HP LaserJet',        430.00,  3),
(2, 203, 'Toner Cartridge HP',         112.00, 11),
(1, 204, 'Keyboard Mechanical',         90.00,  6),
(2, 204, 'Webcam Logitech HD',          71.00,  7),
(3, 204, 'Headset Jabra Pro',          150.00, 15),
(1, 205, 'Paper A4 Box 5 Reams',        22.00, 10),
(2, 205, 'Whiteboard 120x90cm',         84.00,  9),
(1, 206, 'UPS Power Backup 1500VA',    335.00, 12),
(2, 206, 'Network Switch 24-Port',     398.00, 13),
(1, 207, 'Office Desk Standard',       305.00, 14),
(2, 207, 'Filing Cabinet 4-Drawer',    170.00,  8),
(1, 208, 'Laptop Dell XPS 15',        1440.00,  1),
(2, 208, 'Headset Jabra Pro',          148.00, 15);


-- -------------------- PURCHASE ORDERS --------------------

INSERT INTO Purchase_Order (PO_ID, RFQ_ID, order_date, total_amount, status) VALUES
(301, 201, '2024-01-10', 10130.00, 'Completed'),
(302, 202, '2024-01-22',  5380.00, 'Completed'),
(303, 203, '2024-02-08',  3710.00, 'Completed'),
(304, 204, '2024-02-25',  2480.00, 'Completed'),
(305, 205, '2024-03-15',  1760.00, 'Completed'),
(306, 206, '2024-04-05',  5310.00, 'Approved'),
(307, 207, '2024-04-20',  4650.00, 'Approved'),
(308, 208, '2024-05-02',  7340.00, 'Pending');

INSERT INTO PO_Item (Item_number, PO_ID, ordered_quantity, unit_price, Product_ID) VALUES
(1, 301,  5, 1450.00,  1),
(2, 301,  8,  365.00,  5),
(1, 302, 10,  240.00,  2),
(2, 302,  5,  578.00,  4),
(1, 303,  7,  430.00,  3),
(2, 303, 10,  112.00, 11),
(1, 304, 15,   90.00,  6),
(2, 304, 10,   71.00,  7),
(3, 304,  5,  150.00, 15),
(1, 305, 40,   22.00, 10),
(2, 305, 10,   84.00,  9),
(1, 306,  8,  335.00, 12),
(2, 306,  7,  398.00, 13),
(1, 307, 10,  305.00, 14),
(2, 307,  8,  170.00,  8),
(1, 308,  4, 1440.00,  1),
(2, 308,  6,  148.00, 15);


-- -------------------- WAREHOUSE & INVENTORY --------------------

INSERT INTO Warehouse (Warehouse_ID, name, location, capacity) VALUES
(1, 'Main Warehouse Cairo',           'Cairo Industrial Zone',    10000),
(2, 'Alexandria Distribution Center', 'Alexandria Port Area',      5000),
(3, 'Giza Storage Facility',          'Giza Industrial District',  3000),
(4, 'Delta Regional Hub',             'Mansoura Logistics Park',   4000);

INSERT INTO Inventory (Product_ID, Warehouse_ID, quantity_on_hand, last_updated_date) VALUES
(1,  1, 18,  '2024-04-20'),
(2,  1, 45,  '2024-04-20'),
(3,  1,  8,  '2024-04-22'),
(5,  1, 32,  '2024-04-21'),
(6,  1, 95,  '2024-04-20'),
(10, 1, 320, '2024-04-23'),
(11, 1, 40,  '2024-04-22'),
(14, 1, 28,  '2024-04-21'),
(1,  2, 12,  '2024-04-19'),
(4,  2, 15,  '2024-04-20'),
(7,  2, 38,  '2024-04-21'),
(8,  2,  6,  '2024-04-22'),
(12, 2,  7,  '2024-04-20'),
(15, 2, 42,  '2024-04-21'),
(2,  3, 20,  '2024-04-18'),
(3,  3,  4,  '2024-04-20'),
(9,  3, 18,  '2024-04-19'),
(13, 3,  5,  '2024-04-22'),
(5,  4, 14,  '2024-04-17'),
(6,  4, 55,  '2024-04-20'),
(10, 4, 180, '2024-04-21'),
(11, 4, 22,  '2024-04-20'),
(15, 4, 16,  '2024-04-19');


-- -------------------- LOGISTICS --------------------

INSERT INTO Carrier (Carrier_ID, name, contact_info, service_type) VALUES
(1, 'Fast Shipping Co',     '+20-111-222-3333', 'Express'),
(2, 'Economy Transport',    '+20-444-555-6666', 'Standard'),
(3, 'Nile Freight',         '+20-555-666-7777', 'Standard'),
(4, 'Delta Express',        '+20-888-999-0000', 'Express'),
(5, 'SecureMove Logistics', '+20-777-111-2222', 'Premium');

INSERT INTO Receiver (Receiver_ID, name, role, contact_info) VALUES
(1, 'Ahmed Hassan',   'Warehouse Manager',     '+20-100-111-2222'),
(2, 'Fatima Ali',     'Logistics Coordinator', '+20-100-333-4444'),
(3, 'Mohamed Samir',  'Receiving Supervisor',  '+20-100-555-6666'),
(4, 'Nour Ibrahim',   'Warehouse Manager',     '+20-100-777-8888'),
(5, 'Khaled Mostafa', 'Logistics Coordinator', '+20-100-999-0000');

INSERT INTO Transaction_record (Transaction_ID, transaction_date, recv, delv, condition, notes, status, Receiver_ID, Carrier_ID, Warehouse_ID, PO_ID) VALUES
(401, '2024-01-12', '2024-01-15', '2024-01-12', 'Good',    'Delivered on time',              'Completed',  1, 1, 1, 301),
(402, '2024-01-25', '2024-01-30', '2024-01-25', 'Good',    'Minor delay due to traffic',     'Completed',  2, 2, 2, 302),
(403, '2024-02-10', '2024-02-14', '2024-02-10', 'Good',    'Delivered on time',              'Completed',  3, 4, 3, 303),
(404, '2024-02-27', '2024-03-05', '2024-02-27', 'Damaged', 'Two units damaged in transit',   'Completed',  1, 3, 1, 304),
(405, '2024-03-17', '2024-03-20', '2024-03-17', 'Good',    'Delivered on time',              'Completed',  4, 1, 4, 305),
(406, '2024-04-07', '2024-04-12', '2024-04-07', 'Good',    'Awaiting quality inspection',    'In Transit', 2, 5, 2, 306),
(407, '2024-04-22', '2024-04-28', '2024-04-22', 'Good',    'En route to warehouse',          'In Transit', 3, 2, 3, 307),
(408, '2024-05-04', '2024-05-09', '2024-05-04', 'Good',    'Processing at origin warehouse', 'Pending',    5, 4, 1, 308);


-- -------------------- CUSTOMERS --------------------

INSERT INTO Customer (Customer_ID, name, address, contact_info) VALUES
(1,  'ABC Corporation',        '789 Business Ave, Cairo',        '+20-222-333-4444'),
(2,  'XYZ Enterprises',        '321 Market St, Giza',            '+20-555-666-7777'),
(3,  'Nile Tech Solutions',    '456 Tech Park, Alexandria',      '+20-111-444-7777'),
(4,  'Delta Trading Co',       '789 Commerce Rd, Mansoura',      '+20-333-777-1111'),
(5,  'Cairo Consulting Group', '123 Office Tower, Cairo',        '+20-444-888-2222'),
(6,  'Med Supply Egypt',       '654 Health District, Cairo',     '+20-666-111-5555'),
(7,  'EduTech Institute',      '258 Education Zone, Giza',       '+20-777-222-6666'),
(8,  'Pharos Logistics',       '147 Port Area, Alexandria',      '+20-888-333-7777'),
(9,  'Green Office Egypt',     '369 Sustainability Blvd, Cairo', '+20-999-444-8888'),
(10, 'Smart Systems Ltd',      '741 Innovation Hub, Cairo',      '+20-100-555-9999');

INSERT INTO Customer_Order (Order_ID, order_date, status, Transaction_ID, Customer_ID) VALUES
(501, '2024-01-16', 'Delivered',  401,  1),
(502, '2024-01-31', 'Delivered',  402,  2),
(503, '2024-02-15', 'Delivered',  403,  3),
(504, '2024-03-06', 'Delivered',  404,  4),
(505, '2024-03-21', 'Delivered',  405,  5),
(506, '2024-04-13', 'Shipped',    406,  6),
(507, '2024-04-29', 'Processing', 407,  7),
(508, '2024-05-10', 'Processing', 408,  8),
(509, '2024-04-25', 'Shipped',    406,  9),
(510, '2024-05-05', 'Processing', 408, 10);

INSERT INTO Order_Item (Item_number, Order_ID, quantity, unit_price, Product_ID) VALUES
(1, 501,  3, 1500.00,  1),
(2, 501,  5,  380.00,  5),
(1, 502,  6,  250.00,  2),
(2, 502,  3,  600.00,  4),
(1, 503,  4,  450.00,  3),
(2, 503,  8,  120.00, 11),
(3, 503,  2,  160.00, 15),
(1, 504, 10,   95.00,  6),
(2, 504,  8,   75.00,  7),
(1, 505, 30,   25.00, 10),
(2, 505,  5,   90.00,  9),
(3, 505,  2,  180.00,  8),
(1, 506,  5,  350.00, 12),
(2, 506,  4,  420.00, 13),
(1, 507,  8,  320.00, 14),
(2, 507,  5,  180.00,  8),
(1, 508,  2, 1500.00,  1),
(2, 508,  4,  160.00, 15),
(1, 509, 20,   25.00, 10),
(2, 509, 10,   95.00,  6),
(3, 509,  5,   90.00,  9),
(1, 510,  3,  380.00,  5),
(2, 510,  5,   75.00,  7),
(3, 510,  2,  420.00, 13);
