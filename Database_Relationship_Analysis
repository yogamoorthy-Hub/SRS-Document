-- Task 1: Database Relationship Analysis using Joins
-- MySQL-compatible SQL
-- Tables: Customer, Product, `Order`, Payment

-- Optional: Create database
CREATE DATABASE IF NOT EXISTS SalesDB;
USE SalesDB;

-- =========================================================
-- 1. Sample Table Structure
-- =========================================================

CREATE TABLE IF NOT EXISTS Customer (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    Email VARCHAR(150),
    Phone VARCHAR(20),
    City VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS Product (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(150) NOT NULL,
    Category VARCHAR(100),
    Price DECIMAL(10,2) NOT NULL
);

CREATE TABLE IF NOT EXISTS `Order` (
    OrderID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    ProductID INT NOT NULL,
    OrderDate DATE NOT NULL,
    Quantity INT NOT NULL,
    TotalAmount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

CREATE TABLE IF NOT EXISTS Payment (
    PaymentID INT PRIMARY KEY,
    OrderID INT NOT NULL,
    PaymentDate DATE NOT NULL,
    PaymentMethod VARCHAR(50),
    PaymentStatus VARCHAR(50),
    Amount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES `Order`(OrderID)
);

-- =========================================================
-- 2. Sample Data
-- =========================================================

INSERT IGNORE INTO Customer VALUES
(1, 'Arun Kumar', 'arun@example.com', '9876543210', 'Chennai'),
(2, 'Priya Sharma', 'priya@example.com', '9876543211', 'Madurai'),
(3, 'Rahul Singh', 'rahul@example.com', '9876543212', 'Coimbatore'),
(4, 'Divya Raj', 'divya@example.com', '9876543213', 'Trichy');

INSERT IGNORE INTO Product VALUES
(101, 'Laptop', 'Electronics', 55000.00),
(102, 'Smartphone', 'Electronics', 25000.00),
(103, 'Headphones', 'Accessories', 2500.00),
(104, 'Keyboard', 'Accessories', 1500.00);

INSERT IGNORE INTO `Order` VALUES
(1001, 1, 101, '2026-09-01', 1, 55000.00),
(1002, 2, 102, '2026-09-02', 1, 25000.00),
(1003, 1, 103, '2026-09-03', 2, 5000.00),
(1004, 3, 104, '2026-09-04', 2, 3000.00);

INSERT IGNORE INTO Payment VALUES
(5001, 1001, '2026-09-01', 'Credit Card', 'Paid', 55000.00),
(5002, 1002, '2026-09-02', 'UPI', 'Paid', 25000.00),
(5003, 1003, '2026-09-03', 'Debit Card', 'Paid', 5000.00);

-- =========================================================
-- 3. INNER JOIN
-- Combine Customer, Product, Order, and Payment.
-- Returns only records having matching rows in all tables.
-- =========================================================

SELECT
    o.OrderID,
    o.OrderDate,
    c.CustomerID,
    c.CustomerName,
    c.Email,
    c.City,
    p.ProductID,
    p.ProductName,
    p.Category,
    p.Price,
    o.Quantity,
    o.TotalAmount,
    pay.PaymentID,
    pay.PaymentDate,
    pay.PaymentMethod,
    pay.PaymentStatus,
    pay.Amount AS PaidAmount
FROM `Order` o
INNER JOIN Customer c ON o.CustomerID = c.CustomerID
INNER JOIN Product p ON o.ProductID = p.ProductID
INNER JOIN Payment pay ON o.OrderID = pay.OrderID
ORDER BY o.OrderDate;

-- =========================================================
-- 4. LEFT JOIN
-- Display all orders, including orders without payments.
-- =========================================================

SELECT
    o.OrderID,
    o.OrderDate,
    c.CustomerName,
    p.ProductName,
    o.Quantity,
    o.TotalAmount,
    pay.PaymentMethod,
    pay.PaymentStatus,
    pay.Amount AS PaidAmount
FROM `Order` o
LEFT JOIN Customer c ON o.CustomerID = c.CustomerID
LEFT JOIN Product p ON o.ProductID = p.ProductID
LEFT JOIN Payment pay ON o.OrderID = pay.OrderID
ORDER BY o.OrderID;

-- =========================================================
-- 5. RIGHT JOIN
-- Display all customers, including customers with no orders.
-- =========================================================

SELECT
    c.CustomerID,
    c.CustomerName,
    c.Email,
    c.City,
    o.OrderID,
    o.OrderDate,
    p.ProductName,
    o.Quantity,
    o.TotalAmount
FROM `Order` o
RIGHT JOIN Customer c ON o.CustomerID = c.CustomerID
LEFT JOIN Product p ON o.ProductID = p.ProductID
ORDER BY c.CustomerID;

-- =========================================================
-- 6. Complete Order Details
-- =========================================================

SELECT
    o.OrderID,
    o.OrderDate,
    c.CustomerName,
    c.Email,
    c.Phone,
    c.City,
    p.ProductName,
    p.Category,
    p.Price AS UnitPrice,
    o.Quantity,
    o.TotalAmount,
    pay.PaymentMethod,
    pay.PaymentStatus
FROM `Order` o
JOIN Customer c ON o.CustomerID = c.CustomerID
JOIN Product p ON o.ProductID = p.ProductID
LEFT JOIN Payment pay ON o.OrderID = pay.OrderID
ORDER BY o.OrderDate DESC;

-- =========================================================
-- 7. Customer Purchase History
-- =========================================================

SELECT
    c.CustomerID,
    c.CustomerName,
    c.City,
    o.OrderID,
    o.OrderDate,
    p.ProductName,
    p.Category,
    o.Quantity,
    o.TotalAmount,
    pay.PaymentStatus
FROM Customer c
LEFT JOIN `Order` o ON c.CustomerID = o.CustomerID
LEFT JOIN Product p ON o.ProductID = p.ProductID
LEFT JOIN Payment pay ON o.OrderID = pay.OrderID
ORDER BY c.CustomerID, o.OrderDate;

-- =========================================================
-- 8. Customer-wise Purchase Summary
-- =========================================================

SELECT
    c.CustomerID,
    c.CustomerName,
    COUNT(DISTINCT o.OrderID) AS TotalOrders,
    COALESCE(SUM(o.Quantity), 0) AS TotalItemsPurchased,
    COALESCE(SUM(o.TotalAmount), 0) AS TotalPurchaseAmount
FROM Customer c
LEFT JOIN `Order` o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY TotalPurchaseAmount DESC;

-- =========================================================
-- 9. Product Sales Report
-- =========================================================

SELECT
    p.ProductID,
    p.ProductName,
    p.Category,
    COUNT(o.OrderID) AS NumberOfOrders,
    COALESCE(SUM(o.Quantity), 0) AS UnitsSold,
    COALESCE(SUM(o.TotalAmount), 0) AS TotalSales
FROM Product p
LEFT JOIN `Order` o ON p.ProductID = o.ProductID
GROUP BY p.ProductID, p.ProductName, p.Category
ORDER BY TotalSales DESC;

-- =========================================================
-- 10. Payment Report
-- =========================================================

SELECT
    pay.PaymentID,
    pay.PaymentDate,
    o.OrderID,
    c.CustomerName,
    p.ProductName,
    pay.PaymentMethod,
    pay.PaymentStatus,
    pay.Amount
FROM Payment pay
JOIN `Order` o ON pay.OrderID = o.OrderID
JOIN Customer c ON o.CustomerID = c.CustomerID
JOIN Product p ON o.ProductID = p.ProductID
ORDER BY pay.PaymentDate DESC;

-- =========================================================
-- 11. Multi-Table Sales Report
-- =========================================================

SELECT
    c.CustomerName,
    c.City,
    p.ProductName,
    p.Category,
    COUNT(o.OrderID) AS Orders,
    SUM(o.Quantity) AS QuantityPurchased,
    SUM(o.TotalAmount) AS SalesAmount,
    COALESCE(SUM(pay.Amount), 0) AS AmountPaid
FROM Customer c
JOIN `Order` o ON c.CustomerID = o.CustomerID
JOIN Product p ON o.ProductID = p.ProductID
LEFT JOIN Payment pay ON o.OrderID = pay.OrderID
GROUP BY
    c.CustomerName,
    c.City,
    p.ProductName,
    p.Category
ORDER BY SalesAmount DESC;

-- =========================================================
-- 12. Orders With Pending/Missing Payments
-- =========================================================

SELECT
    o.OrderID,
    c.CustomerName,
    p.ProductName,
    o.TotalAmount,
    COALESCE(pay.PaymentStatus, 'No Payment') AS PaymentStatus
FROM `Order` o
JOIN Customer c ON o.CustomerID = c.CustomerID
JOIN Product p ON o.ProductID = p.ProductID
LEFT JOIN Payment pay ON o.OrderID = pay.OrderID
WHERE pay.PaymentID IS NULL
   OR pay.PaymentStatus <> 'Paid';
