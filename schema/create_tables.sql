-- ============================================================
-- SUPPLY CHAIN DATABASE SCHEMA
-- Creates all tables with relationships and constraints
-- ============================================================


-- -------------------- PROCUREMENT --------------------

CREATE TABLE RF (
    RF_ID       INT PRIMARY KEY,
    issue_date  DATE,
    due_date    DATE,
    status      VARCHAR(50)
);

CREATE TABLE RFI (
    RFI_ID  INT PRIMARY KEY,
    RF_ID   INT NOT NULL,
    FOREIGN KEY (RF_ID) REFERENCES RF(RF_ID)
);

CREATE TABLE RFQ (
    RFQ_ID  INT PRIMARY KEY,
    RF_ID   INT,
    FOREIGN KEY (RF_ID) REFERENCES RF(RF_ID)
);


-- -------------------- SUPPLIERS --------------------

CREATE TABLE Supplier (
    Supplier_ID INT PRIMARY KEY,
    Name        VARCHAR(100),
    Address     VARCHAR(255)
);

CREATE TABLE SupplierContact (
    Supplier_ID     INT,
    Contact_number  VARCHAR(20),
    PRIMARY KEY (Supplier_ID, Contact_number),
    FOREIGN KEY (Supplier_ID) REFERENCES Supplier(Supplier_ID)
);


-- -------------------- PRODUCTS --------------------

CREATE TABLE Product (
    Product_ID          INT PRIMARY KEY,
    Product_name        VARCHAR(100),
    Category            VARCHAR(50),
    Unit_price          DECIMAL(10, 2),
    Available_quantity  INT
);


-- -------------------- SUPPLIER-PRODUCT RELATIONSHIPS --------------------

CREATE TABLE Supplies (
    Product_ID      INT,
    Supplier_ID     INT,
    Supplier_price  DECIMAL(10, 2),
    Lead_Time       INT,
    PRIMARY KEY (Product_ID, Supplier_ID),
    FOREIGN KEY (Product_ID)  REFERENCES Product(Product_ID),
    FOREIGN KEY (Supplier_ID) REFERENCES Supplier(Supplier_ID)
);

CREATE TABLE Receives (
    Supplier_ID INT,
    RFI_ID      INT,
    PRIMARY KEY (Supplier_ID, RFI_ID),
    FOREIGN KEY (Supplier_ID) REFERENCES Supplier(Supplier_ID),
    FOREIGN KEY (RFI_ID)      REFERENCES RFI(RFI_ID)
);

CREATE TABLE RFQ_items (
    item_number         INT,
    RFQ_ID              INT,
    requested_item      VARCHAR(100),
    proposed_unit_price DECIMAL(10, 2),
    Product_ID          INT,
    PRIMARY KEY (item_number, RFQ_ID),
    FOREIGN KEY (RFQ_ID)      REFERENCES RFQ(RFQ_ID),
    FOREIGN KEY (Product_ID)  REFERENCES Product(Product_ID)
);


-- -------------------- PURCHASE ORDERS --------------------

CREATE TABLE Purchase_Order (
    PO_ID        INT PRIMARY KEY,
    RFQ_ID       INT,
    order_date   DATE,
    total_amount DECIMAL(12, 2),
    status       VARCHAR(50),
    FOREIGN KEY (RFQ_ID) REFERENCES RFQ(RFQ_ID)
);

CREATE TABLE PO_Item (
    Item_number      INT,
    PO_ID            INT,
    ordered_quantity INT,
    unit_price       DECIMAL(10, 2),
    Product_ID       INT,
    PRIMARY KEY (Item_number, PO_ID),
    FOREIGN KEY (PO_ID)       REFERENCES Purchase_Order(PO_ID),
    FOREIGN KEY (Product_ID)  REFERENCES Product(Product_ID)
);


-- -------------------- WAREHOUSE & INVENTORY --------------------

CREATE TABLE Warehouse (
    Warehouse_ID INT PRIMARY KEY,
    name         VARCHAR(100),
    location     VARCHAR(255),
    capacity     INT
);

CREATE TABLE Inventory (
    Product_ID         INT,
    Warehouse_ID       INT,
    quantity_on_hand   INT,
    last_updated_date  DATE,
    PRIMARY KEY (Product_ID, Warehouse_ID),
    FOREIGN KEY (Product_ID)   REFERENCES Product(Product_ID),
    FOREIGN KEY (Warehouse_ID) REFERENCES Warehouse(Warehouse_ID)
);


-- -------------------- LOGISTICS --------------------

CREATE TABLE Carrier (
    Carrier_ID   INT PRIMARY KEY,
    name         VARCHAR(100),
    contact_info VARCHAR(255),
    service_type VARCHAR(50)
);

CREATE TABLE Receiver (
    Receiver_ID  INT PRIMARY KEY,
    name         VARCHAR(100),
    role         VARCHAR(50),
    contact_info VARCHAR(255)
);

CREATE TABLE Transaction_record (
    Transaction_ID   INT PRIMARY KEY,
    transaction_date DATE,
    recv             DATE,
    delv             DATE,
    condition        VARCHAR(100),
    notes            TEXT,
    status           VARCHAR(50),
    Receiver_ID      INT,
    Carrier_ID       INT,
    Warehouse_ID     INT,
    PO_ID            INT,
    FOREIGN KEY (Receiver_ID)  REFERENCES Receiver(Receiver_ID),
    FOREIGN KEY (Carrier_ID)   REFERENCES Carrier(Carrier_ID),
    FOREIGN KEY (Warehouse_ID) REFERENCES Warehouse(Warehouse_ID),
    FOREIGN KEY (PO_ID)        REFERENCES Purchase_Order(PO_ID)
);


-- -------------------- CUSTOMERS --------------------

CREATE TABLE Customer (
    Customer_ID  INT PRIMARY KEY,
    name         VARCHAR(100),
    address      VARCHAR(255),
    contact_info VARCHAR(255)
);

CREATE TABLE Customer_Order (
    Order_ID       INT PRIMARY KEY,
    order_date     DATE,
    status         VARCHAR(50),
    Transaction_ID INT,
    Customer_ID    INT,
    FOREIGN KEY (Transaction_ID) REFERENCES Transaction_record(Transaction_ID),
    FOREIGN KEY (Customer_ID)    REFERENCES Customer(Customer_ID)
);

CREATE TABLE Order_Item (
    Item_number INT,
    Order_ID    INT,
    quantity    INT,
    unit_price  DECIMAL(10, 2),
    Product_ID  INT,
    PRIMARY KEY (Item_number, Order_ID),
    FOREIGN KEY (Order_ID)    REFERENCES Customer_Order(Order_ID),
    FOREIGN KEY (Product_ID)  REFERENCES Product(Product_ID)
);
