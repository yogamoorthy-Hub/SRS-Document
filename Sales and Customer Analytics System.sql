-- Task 2: Sales and Customer Analytics System
-- MySQL-compatible SQL
-- Tables used: Customer, Product, `Order`

USE SalesDB;

-- =========================================================
-- 1. Basic Sales Statistics
-- Apply COUNT(), SUM(), AVG(), MIN(), and MAX()
-- =========================================================

SELECT
    COUNT(OrderID) AS TotalOrders,
    SUM(TotalAmount) AS TotalSales,
    AVG(TotalAmount) AS AverageOrderValue,
    MIN(TotalAmount) AS MinimumOrderValue,
    MAX(TotalAmount) AS MaximumOrderValue
FROM `Order`;

-- =========================================================
-- 2. Total Sales Report
-- =========================================================

SELECT
    SUM(TotalAmount) AS TotalSalesAmount
FROM `Order`;

-- =========================================================
-- 3. Total Sales by Date
-- =========================================================

SELECT
    OrderDate,
    COUNT(OrderID) AS NumberOfOrders,
    SUM(TotalAmount) AS DailySales
FROM `Order`
GROUP BY OrderDate
ORDER BY OrderDate;

-- =========================================================
-- 4. Monthly Sales Report
-- =========================================================

SELECT
    YEAR(OrderDate) AS SalesYear,
    MONTH(OrderDate) AS SalesMonth,
    COUNT(OrderID) AS TotalOrders,
    SUM(TotalAmount) AS TotalSales,
    AVG(TotalAmount) AS AverageOrderValue
FROM `Order`
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY SalesYear, SalesMonth;

-- =========================================================
-- 5. Top Customers Based on Purchase Amount
-- =========================================================

SELECT
    c.CustomerID,
    c.CustomerName,
    c.City,
    COUNT(o.OrderID) AS TotalOrders,
    SUM(o.Quantity) AS TotalItemsPurchased,
    SUM(o.TotalAmount) AS TotalPurchaseAmount,
    AVG(o.TotalAmount) AS AverageOrderValue
FROM Customer c
JOIN `Order` o
    ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CustomerName, c.City
ORDER BY TotalPurchaseAmount DESC;

-- =========================================================
-- 6. Top 5 Customers
-- =========================================================

SELECT
    c.CustomerID,
    c.CustomerName,
    SUM(o.TotalAmount) AS TotalPurchaseAmount
FROM Customer c
JOIN `Order` o
    ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY TotalPurchaseAmount DESC
LIMIT 5;

-- =========================================================
-- 7. Best-Selling Products by Quantity
-- =========================================================

SELECT
    p.ProductID,
    p.ProductName,
    p.Category,
    COUNT(o.OrderID) AS NumberOfOrders,
    SUM(o.Quantity) AS TotalUnitsSold,
    SUM(o.TotalAmount) AS TotalSales
FROM Product p
JOIN `Order` o
    ON p.ProductID = o.ProductID
GROUP BY p.ProductID, p.ProductName, p.Category
ORDER BY TotalUnitsSold DESC;

-- =========================================================
-- 8. Best-Selling Products by Sales Amount
-- =========================================================

SELECT
    p.ProductID,
    p.ProductName,
    p.Category,
    SUM(o.Quantity) AS UnitsSold,
    SUM(o.TotalAmount) AS TotalSales,
    AVG(o.TotalAmount) AS AverageSalesPerOrder
FROM Product p
JOIN `Order` o
    ON p.ProductID = o.ProductID
GROUP BY p.ProductID, p.ProductName, p.Category
ORDER BY TotalSales DESC;

-- =========================================================
-- 9. Top 5 Best-Selling Products
-- =========================================================

SELECT
    p.ProductID,
    p.ProductName,
    SUM(o.Quantity) AS UnitsSold,
    SUM(o.TotalAmount) AS TotalSales
FROM Product p
JOIN `Order` o
    ON p.ProductID = o.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY UnitsSold DESC
LIMIT 5;

-- =========================================================
-- 10. Category-Wise Sales Analysis
-- =========================================================

SELECT
    p.Category,
    COUNT(DISTINCT p.ProductID) AS NumberOfProducts,
    COUNT(o.OrderID) AS NumberOfOrders,
    SUM(o.Quantity) AS TotalUnitsSold,
    SUM(o.TotalAmount) AS TotalSales,
    AVG(o.TotalAmount) AS AverageOrderValue,
    MIN(o.TotalAmount) AS MinimumOrderValue,
    MAX(o.TotalAmount) AS MaximumOrderValue
FROM Product p
LEFT JOIN `Order` o
    ON p.ProductID = o.ProductID
GROUP BY p.Category
ORDER BY TotalSales DESC;

-- =========================================================
-- 11. Category-Wise Sales Percentage
-- =========================================================

SELECT
    p.Category,
    SUM(o.TotalAmount) AS CategorySales,
    ROUND(
        (SUM(o.TotalAmount) / (SELECT SUM(TotalAmount) FROM `Order`)) * 100,
        2
    ) AS SalesPercentage
FROM Product p
JOIN `Order` o
    ON p.ProductID = o.ProductID
GROUP BY p.Category
ORDER BY CategorySales DESC;

-- =========================================================
-- 12. Customer Purchase Statistics
-- =========================================================

SELECT
    c.CustomerID,
    c.CustomerName,
    COUNT(o.OrderID) AS OrderCount,
    SUM(o.TotalAmount) AS TotalSpent,
    AVG(o.TotalAmount) AS AverageSpent,
    MIN(o.TotalAmount) AS LowestPurchase,
    MAX(o.TotalAmount) AS HighestPurchase
FROM Customer c
LEFT JOIN `Order` o
    ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY TotalSpent DESC;

-- =========================================================
-- 13. Overall Product Statistics
-- =========================================================

SELECT
    COUNT(DISTINCT p.ProductID) AS TotalProducts,
    COUNT(o.OrderID) AS TotalProductOrders,
    SUM(o.Quantity) AS TotalUnitsSold,
    SUM(o.TotalAmount) AS TotalProductSales,
    AVG(o.TotalAmount) AS AverageProductOrderValue,
    MIN(o.TotalAmount) AS MinimumProductOrderValue,
    MAX(o.TotalAmount) AS MaximumProductOrderValue
FROM Product p
LEFT JOIN `Order` o
    ON p.ProductID = o.ProductID;

-- =========================================================
-- 14. High-Value Customers
-- Customers whose total purchase amount is above average
-- =========================================================

SELECT
    c.CustomerID,
    c.CustomerName,
    SUM(o.TotalAmount) AS TotalPurchaseAmount
FROM Customer c
JOIN `Order` o
    ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CustomerName
HAVING SUM(o.TotalAmount) >
       (SELECT AVG(CustomerTotal)
        FROM (
            SELECT SUM(TotalAmount) AS CustomerTotal
            FROM `Order`
            GROUP BY CustomerID
        ) AS CustomerSales)
ORDER BY TotalPurchaseAmount DESC;

-- =========================================================
-- 15. Complete Sales Analytics Report
-- =========================================================

SELECT
    c.CustomerName,
    p.ProductName,
    p.Category,
    COUNT(o.OrderID) AS Orders,
    SUM(o.Quantity) AS QuantitySold,
    SUM(o.TotalAmount) AS SalesAmount,
    AVG(o.TotalAmount) AS AverageOrderValue,
    MIN(o.TotalAmount) AS MinimumOrder,
    MAX(o.TotalAmount) AS MaximumOrder
FROM `Order` o
JOIN Customer c
    ON o.CustomerID = c.CustomerID
JOIN Product p
    ON o.ProductID = p.ProductID
GROUP BY
    c.CustomerName,
    p.ProductName,
    p.Category
ORDER BY SalesAmount DESC;
