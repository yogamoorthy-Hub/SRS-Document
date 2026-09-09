-- Task 3: Advanced SQL Query System
-- MySQL-compatible SQL
-- Tables used: Customer, Product, `Order`, Payment
-- Database created in Task 1

USE SalesDB;

-- =========================================================
-- 1. Products Above the Average Price
-- Subquery to calculate average product price
-- =========================================================

SELECT
    ProductID,
    ProductName,
    Category,
    Price
FROM Product
WHERE Price > (
    SELECT AVG(Price)
    FROM Product
)
ORDER BY Price DESC;

-- =========================================================
-- 2. Products Below the Average Price
-- =========================================================

SELECT
    ProductID,
    ProductName,
    Category,
    Price
FROM Product
WHERE Price < (
    SELECT AVG(Price)
    FROM Product
)
ORDER BY Price ASC;

-- =========================================================
-- 3. Customers With Maximum Purchases
-- Nested query finds the maximum customer purchase amount
-- =========================================================

SELECT
    c.CustomerID,
    c.CustomerName,
    SUM(o.TotalAmount) AS TotalPurchaseAmount
FROM Customer c
JOIN `Order` o
    ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CustomerName
HAVING SUM(o.TotalAmount) = (
    SELECT MAX(CustomerTotal)
    FROM (
        SELECT
            CustomerID,
            SUM(TotalAmount) AS CustomerTotal
        FROM `Order`
        GROUP BY CustomerID
    ) AS CustomerPurchases
);

-- =========================================================
-- 4. Top Customer Using ORDER BY and LIMIT
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
LIMIT 1;

-- =========================================================
-- 5. Customers Who Have Spent More Than the Average Customer
-- =========================================================

SELECT
    c.CustomerID,
    c.CustomerName,
    SUM(o.TotalAmount) AS TotalPurchaseAmount
FROM Customer c
JOIN `Order` o
    ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CustomerName
HAVING SUM(o.TotalAmount) > (
    SELECT AVG(CustomerTotal)
    FROM (
        SELECT
            CustomerID,
            SUM(TotalAmount) AS CustomerTotal
        FROM `Order`
        GROUP BY CustomerID
    ) AS CustomerTotals
)
ORDER BY TotalPurchaseAmount DESC;

-- =========================================================
-- 6. Products With Sales Above Average Product Sales
-- =========================================================

SELECT
    p.ProductID,
    p.ProductName,
    p.Category,
    SUM(o.TotalAmount) AS ProductSales
FROM Product p
JOIN `Order` o
    ON p.ProductID = o.ProductID
GROUP BY p.ProductID, p.ProductName, p.Category
HAVING SUM(o.TotalAmount) > (
    SELECT AVG(ProductSales)
    FROM (
        SELECT
            ProductID,
            SUM(TotalAmount) AS ProductSales
        FROM `Order`
        GROUP BY ProductID
    ) AS ProductTotals
)
ORDER BY ProductSales DESC;

-- =========================================================
-- 7. Most Expensive Product in Each Category
-- Correlated subquery
-- =========================================================

SELECT
    p.ProductID,
    p.ProductName,
    p.Category,
    p.Price
FROM Product p
WHERE p.Price = (
    SELECT MAX(p2.Price)
    FROM Product p2
    WHERE p2.Category = p.Category
)
ORDER BY p.Category;

-- =========================================================
-- 8. Customers Who Purchased a Product Above Average Price
-- =========================================================

SELECT DISTINCT
    c.CustomerID,
    c.CustomerName,
    p.ProductName,
    p.Price
FROM Customer c
JOIN `Order` o
    ON c.CustomerID = o.CustomerID
JOIN Product p
    ON o.ProductID = p.ProductID
WHERE p.Price > (
    SELECT AVG(Price)
    FROM Product
)
ORDER BY p.Price DESC;

-- =========================================================
-- 9. Customers With More Orders Than the Average Customer
-- =========================================================

SELECT
    c.CustomerID,
    c.CustomerName,
    COUNT(o.OrderID) AS TotalOrders
FROM Customer c
JOIN `Order` o
    ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CustomerName
HAVING COUNT(o.OrderID) > (
    SELECT AVG(OrderCount)
    FROM (
        SELECT
            CustomerID,
            COUNT(OrderID) AS OrderCount
        FROM `Order`
        GROUP BY CustomerID
    ) AS CustomerOrderCounts
)
ORDER BY TotalOrders DESC;

-- =========================================================
-- 10. Best-Selling Product by Quantity
-- =========================================================

SELECT
    p.ProductID,
    p.ProductName,
    SUM(o.Quantity) AS TotalUnitsSold
FROM Product p
JOIN `Order` o
    ON p.ProductID = o.ProductID
GROUP BY p.ProductID, p.ProductName
HAVING SUM(o.Quantity) = (
    SELECT MAX(ProductQuantity)
    FROM (
        SELECT
            ProductID,
            SUM(Quantity) AS ProductQuantity
        FROM `Order`
        GROUP BY ProductID
    ) AS ProductSales
);

-- =========================================================
-- 11. Customers Who Have Never Placed an Order
-- NOT EXISTS subquery
-- =========================================================

SELECT
    c.CustomerID,
    c.CustomerName,
    c.Email,
    c.City
FROM Customer c
WHERE NOT EXISTS (
    SELECT 1
    FROM `Order` o
    WHERE o.CustomerID = c.CustomerID
);

-- =========================================================
-- 12. Products Never Ordered
-- NOT EXISTS subquery
-- =========================================================

SELECT
    p.ProductID,
    p.ProductName,
    p.Category,
    p.Price
FROM Product p
WHERE NOT EXISTS (
    SELECT 1
    FROM `Order` o
    WHERE o.ProductID = p.ProductID
);

-- =========================================================
-- 13. Orders Greater Than the Average Order Value
-- =========================================================

SELECT
    o.OrderID,
    o.OrderDate,
    c.CustomerName,
    p.ProductName,
    o.Quantity,
    o.TotalAmount
FROM `Order` o
JOIN Customer c
    ON o.CustomerID = c.CustomerID
JOIN Product p
    ON o.ProductID = p.ProductID
WHERE o.TotalAmount > (
    SELECT AVG(TotalAmount)
    FROM `Order`
)
ORDER BY o.TotalAmount DESC;

-- =========================================================
-- 14. Category With the Highest Sales
-- Nested aggregation
-- =========================================================

SELECT
    p.Category,
    SUM(o.TotalAmount) AS CategorySales
FROM Product p
JOIN `Order` o
    ON p.ProductID = o.ProductID
GROUP BY p.Category
HAVING SUM(o.TotalAmount) = (
    SELECT MAX(CategoryTotal)
    FROM (
        SELECT
            p2.Category,
            SUM(o2.TotalAmount) AS CategoryTotal
        FROM Product p2
        JOIN `Order` o2
            ON p2.ProductID = o2.ProductID
        GROUP BY p2.Category
    ) AS CategorySalesTotals
);

-- =========================================================
-- 15. Advanced Customer-Product Business Report
-- =========================================================

SELECT
    c.CustomerID,
    c.CustomerName,
    c.City,
    COUNT(DISTINCT o.OrderID) AS TotalOrders,
    SUM(o.Quantity) AS TotalItems,
    SUM(o.TotalAmount) AS TotalPurchase,
    AVG(o.TotalAmount) AS AverageOrderValue,
    MAX(o.TotalAmount) AS HighestOrderValue,
    MIN(o.TotalAmount) AS LowestOrderValue,
    (
        SELECT COUNT(DISTINCT o2.ProductID)
        FROM `Order` o2
        WHERE o2.CustomerID = c.CustomerID
    ) AS UniqueProductsPurchased
FROM Customer c
JOIN `Order` o
    ON c.CustomerID = o.CustomerID
GROUP BY
    c.CustomerID,
    c.CustomerName,
    c.City
ORDER BY TotalPurchase DESC;

-- =========================================================
-- 16. Advanced Product Performance Report
-- =========================================================

SELECT
    p.ProductID,
    p.ProductName,
    p.Category,
    p.Price,
    COALESCE(SUM(o.Quantity), 0) AS UnitsSold,
    COALESCE(SUM(o.TotalAmount), 0) AS TotalSales,
    COALESCE(AVG(o.TotalAmount), 0) AS AverageOrderValue,
    (
        SELECT COUNT(DISTINCT o2.CustomerID)
        FROM `Order` o2
        WHERE o2.ProductID = p.ProductID
    ) AS UniqueCustomers
FROM Product p
LEFT JOIN `Order` o
    ON p.ProductID = o.ProductID
GROUP BY
    p.ProductID,
    p.ProductName,
    p.Category,
    p.Price
ORDER BY TotalSales DESC;

-- =========================================================
-- 17. Payment Status Business Analysis
-- =========================================================

SELECT
    c.CustomerName,
    COUNT(DISTINCT o.OrderID) AS TotalOrders,
    SUM(o.TotalAmount) AS OrderedAmount,
    COALESCE(SUM(pay.Amount), 0) AS PaidAmount,
    SUM(o.TotalAmount) - COALESCE(SUM(pay.Amount), 0) AS OutstandingAmount
FROM Customer c
JOIN `Order` o
    ON c.CustomerID = o.CustomerID
LEFT JOIN Payment pay
    ON o.OrderID = pay.OrderID
GROUP BY c.CustomerID, c.CustomerName
HAVING OutstandingAmount > 0
ORDER BY OutstandingAmount DESC;

-- =========================================================
-- 18. FINAL ADVANCED SQL REPORT
-- Combines customer, product, order and payment analysis
-- =========================================================

SELECT
    c.CustomerID,
    c.CustomerName,
    c.City,
    p.ProductName,
    p.Category,
    p.Price AS ProductPrice,
    o.OrderID,
    o.OrderDate,
    o.Quantity,
    o.TotalAmount AS OrderAmount,
    COALESCE(pay.Amount, 0) AS PaidAmount,
    COALESCE(pay.PaymentStatus, 'No Payment') AS PaymentStatus,
    CASE
        WHEN o.TotalAmount > (SELECT AVG(TotalAmount) FROM `Order`)
            THEN 'Above Average Order'
        ELSE 'Average/Below Average Order'
    END AS OrderCategory,
    CASE
        WHEN p.Price > (SELECT AVG(Price) FROM Product)
            THEN 'Above Average Price'
        ELSE 'Average/Below Average Price'
    END AS ProductPriceCategory
FROM `Order` o
JOIN Customer c
    ON o.CustomerID = c.CustomerID
JOIN Product p
    ON o.ProductID = p.ProductID
LEFT JOIN Payment pay
    ON o.OrderID = pay.OrderID
ORDER BY o.TotalAmount DESC;
