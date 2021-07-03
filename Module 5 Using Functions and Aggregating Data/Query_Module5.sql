-- Module 5: Using Functions and Aggregating Data   
-- Introduction to Functions
-- Scalar Functions
-- Scalar functions: have a single value function
USE [AdventureWorksLT2012]
SELECT	
YEAR(S.SellStartDate) AS SellStartYear, S.SellStartDate, S.ProductID, S.Name
FROM [SalesLT].[Product] AS S
ORDER BY SellStartYear

SELECT	
YEAR(S.SellStartDate) AS SellStartYear, DATENAME(mm,S.SellStartDate),
DAY(S.SellStartDate), DATENAME(DW,S.SellStartDate),
S.ProductID, S.Name
FROM [SalesLT].[Product] AS S
ORDER BY SellStartYear

SELECT	
DATENAME(YYYY,S.SellStartDate) AS SellStartYear, DATENAME(mm,S.SellStartDate) AS SellStartMonth,
DAY(S.SellStartDate) AS SellStartDay, DATENAME(DW,S.SellStartDate) AS SellStartWeekDay,
S.ProductID, S.Name
FROM [SalesLT].[Product] AS S
ORDER BY SellStartYear

SELECT	
DATEDIFF(YYYY,S.SellStartDate,GETDATE()) AS YearsSold,
S.ProductID, S.Name
FROM [SalesLT].[Product] AS S
ORDER BY YearsSold DESC

SELECT	
UPPER(S.Name) AS ProductName
FROM [SalesLT].[Product] AS S


SELECT 
P.Name, P.ProductNumber, LEFT(P.ProductNumber,2) AS ProductType
FROM SalesLT.Product AS P

SELECT 
P.Name, P.ProductNumber, LEFT(P.ProductNumber,2) AS ProductType,
SUBSTRING(P.ProductNumber,CHARINDEX('-',P.ProductNumber,0)+1,4) AS ModelCode,
SUBSTRING(P.ProductNumber,9,2) AS SizeColor
FROM SalesLT.Product AS P

-- Logical Functions

SELECT ISNUMERIC('ZZZZ') AS IS_A_NUMBER

SELECT
P.ProductID,
P.ListPrice, 
IIF(P.ListPrice < 50,'Low','High') AS PricePoint
FROM [SalesLT].[Product] AS P

SELECT 
P.Name, P.Size AS NumericSize
FROM [SalesLT].[Product] AS P
WHERE ISNUMERIC(P.Size) = 1

SELECT 
P.Name, IIF(P.ProductCategoryID IN (5,6,7),'Bikes','Other') AS ProductType
FROM [SalesLT].[Product] AS P

SELECT 
P.Name, IIF(ISNUMERIC(P.Size)=1,'Numeric','Non-Numeric') AS SizeType
FROM [SalesLT].[Product] AS P

SELECT 
P.Name AS ProductName,
C.Name AS CategoryName,
CHOOSE(C.ParentProductCategoryID,'Bikes','Components','Clothing','Accesories') AS ProductType
FROM [SalesLT].[Product] AS P
JOIN [SalesLT].ProductCategory AS C
ON P.ProductCategoryID = C.ProductCategoryID

-- Window Functions
-- which are functions applied to a window, or set of rows
SELECT TOP(3)
P.ProductID, P.Name, P.ListPrice,
RANK() OVER(ORDER BY P.ListPrice DESC) AS RankByPrice
FROM [SalesLT].[Product] AS P

SELECT TOP(100)
P.ProductID, P.Name, P.ListPrice,
RANK() OVER(ORDER BY P.ListPrice DESC) AS RankByPrice
FROM [SalesLT].[Product] AS P
ORDER BY RankByPrice

SELECT 
C.Name AS Category,
P.Name AS Product,
P.ListPrice,
RANK() OVER(PARTITION BY C.Name ORDER BY P.ListPrice DESC) AS RankByPrice
FROM SalesLT.Product AS P
JOIN SalesLT.ProductCategory AS C
ON P.ProductCategoryID = C.ProductCategoryID
ORDER BY Category, RankByPrice

-- Aggregate Functions

-- Aggregate functions are functions that operate on sets or rows of data
SELECT
COUNT(*) AS Products,
COUNT(DISTINCT P.ProductCategoryID) AS Categories,
AVG(P.ListPrice) AS AveragePrice
FROM SalesLT.Product AS P

SELECT 
COUNT(P.ProductID) AS BikeModels,
AVG(P.ListPrice) AS AveragePrice
FROM SalesLT.Product AS P
JOIN SalesLT.ProductCategory AS C
ON P.ProductCategoryID = C.ProductCategoryID
WHERE C.Name LIKE '%Bikes'

-- Grouping Aggregated Data

SELECT
C.SalesPerson,
ISNULL(SUM(SOH.SubTotal),0.00) AS SalesRevenue
FROM SalesLT.Customer AS C
LEFT JOIN SalesLT.SalesOrderHeader AS SOH
ON C.CustomerID = SOH.CustomerID
GROUP BY C.SalesPerson
ORDER BY SalesRevenue DESC

SELECT
C.SalesPerson,
CONCAT(C.FirstName + ' ',C.LastName) AS Customer,
ISNULL(SUM(SOH.SubTotal),0.00) AS SalesRevenue
FROM SalesLT.Customer AS C
LEFT JOIN SalesLT.SalesOrderHeader AS SOH
ON C.CustomerID = SOH.CustomerID
GROUP BY C.SalesPerson, CONCAT(C.FirstName + ' ',C.LastName)
ORDER BY SalesRevenue DESC

-- Filtering Groups
-- having is a filtering condition which operates, not over rows, but over groups of rows
SELECT
SOD.ProductID,
SUM(SOD.OrderQty) AS Quantity 
FROM SalesLT.SalesOrderDetail AS SOD
JOIN SalesLT.SalesOrderHeader AS SOH
ON SOD.SalesOrderID = SOH.SalesOrderID
WHERE DATENAME(YYYY,SOH.OrderDate) = 2004
GROUP BY SOD.ProductID
HAVING SUM(SOD.OrderQty) > = 50
ORDER BY Quantity DESC

