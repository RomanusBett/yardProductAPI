-- 1. Create the database
CREATE DATABASE InventoryTracking;
USE InventoryTracking;

-- 2. Create tables

-- Suppliers table 
CREATE TABLE Suppliers (
    SupplierID INT AUTO_INCREMENT PRIMARY KEY,
    SupplierName VARCHAR(100) NOT NULL,
    ContactName VARCHAR(100),
    Phone VARCHAR(20) UNIQUE,
    Email VARCHAR(100) UNIQUE,
    Address VARCHAR(255)
);

-- Products table 
CREATE TABLE Products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL UNIQUE,
    SupplierID INT NOT NULL,
    Category VARCHAR(50),
    UnitPrice DECIMAL(10,2) NOT NULL,
    ReorderLevel INT DEFAULT 0,
    CONSTRAINT fk_products_supplier FOREIGN KEY (SupplierID)
        REFERENCES Suppliers(SupplierID)
        ON DELETE CASCADE
);

-- Warehouses table 
CREATE TABLE Warehouses (
    WarehouseID INT AUTO_INCREMENT PRIMARY KEY,
    WarehouseName VARCHAR(100) NOT NULL UNIQUE,
    Location VARCHAR(255)
);

-- Inventory table 
CREATE TABLE Inventory (
    InventoryID INT AUTO_INCREMENT PRIMARY KEY,
    ProductID INT NOT NULL,
    WarehouseID INT NOT NULL,
    Quantity INT NOT NULL DEFAULT 0,
    CONSTRAINT fk_inventory_product FOREIGN KEY (ProductID)
        REFERENCES Products(ProductID)
        ON DELETE CASCADE,
    CONSTRAINT fk_inventory_warehouse FOREIGN KEY (WarehouseID)
        REFERENCES Warehouses(WarehouseID)
        ON DELETE CASCADE,
    CONSTRAINT uq_inventory UNIQUE (ProductID, WarehouseID)
);

-- Customers table 
CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    Phone VARCHAR(20) UNIQUE,
    Email VARCHAR(100) UNIQUE,
    Address VARCHAR(255)
);

-- Orders table 
CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderDate DATE NOT NULL,
    Status ENUM('Pending', 'Shipped', 'Delivered', 'Cancelled') DEFAULT 'Pending',
    CONSTRAINT fk_orders_customer FOREIGN KEY (CustomerID)
        REFERENCES Customers(CustomerID)
        ON DELETE CASCADE
);

-- OrderItems table 
CREATE TABLE OrderItems (
    OrderItemID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_orderitems_order FOREIGN KEY (OrderID)
        REFERENCES Orders(OrderID)
        ON DELETE CASCADE,
    CONSTRAINT fk_orderitems_product FOREIGN KEY (ProductID)
        REFERENCES Products(ProductID)
        ON DELETE CASCADE
);

-- PurchaseOrders table 
CREATE TABLE PurchaseOrders (
    PurchaseOrderID INT AUTO_INCREMENT PRIMARY KEY,
    SupplierID INT NOT NULL,
    OrderDate DATE NOT NULL,
    Status ENUM('Pending', 'Received', 'Cancelled') DEFAULT 'Pending',
    CONSTRAINT fk_purchaseorders_supplier FOREIGN KEY (SupplierID)
        REFERENCES Suppliers(SupplierID)
        ON DELETE CASCADE
);

-- PurchaseOrderItems table 
CREATE TABLE PurchaseOrderItems (
    PurchaseOrderItemID INT AUTO_INCREMENT PRIMARY KEY,
    PurchaseOrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_poitems_po FOREIGN KEY (PurchaseOrderID)
        REFERENCES PurchaseOrders(PurchaseOrderID)
        ON DELETE CASCADE,
    CONSTRAINT fk_poitems_product FOREIGN KEY (ProductID)
        REFERENCES Products(ProductID)
        ON DELETE CASCADE
);
