-- Module 3 Querying Multiple Tables with Joins   
-- Introduction to Joins
-- [Inner] Join (where the inner clause is optional)
-- Equivalent to intersection A ^ B in a Venn Diagram
-- most of the time the join is done using a n "=" is said to be a equi-join

-- Demo: Using Inner Joins
USE [AdventureWorksLT2012]
-- MAKING A JOIN BETWEEN [SalesLT].[Product] AND [SalesLT].[ProductCategory] TABLES
SELECT
A.Name AS ProductName,
B.Name AS Category
FROM [SalesLT].[Product] AS A
INNER JOIN [SalesLT].[ProductCategory] AS B
ON A.ProductCategoryID = B.ProductCategoryID
/*
(295 row(s) affected)
ProductName					Category
Mountain-100 Silver, 38	Mountain Bikes
Mountain-100 Silver, 42	Mountain Bikes
Mountain-100 Silver, 44	Mountain Bikes
*/

-- JOINING MORE THAN 2 TABLES
SELECT
OH.OrderDate,
OH.SalesOrderNumber,
P.Name AS ProductName,
OD.OrderQty,
OD.UnitPrice,
OD.LineTotal
FROM [SalesLT].[SalesOrderHeader] AS OH
INNER JOIN [SalesLT].[SalesOrderDetail] AS OD
ON OH.SalesOrderID = OD.SalesOrderID
INNER JOIN [SalesLT].[Product] AS P
ON OD.ProductID = P.ProductID
ORDER BY OH.OrderDate, OH.SalesOrderID, OD.SalesOrderDetailID
-- (542 row(s) affected)
-- JOINS USING MULTIPLE JOINING PREDICATES
-- THE ON PART OF A JOIN IS ACTUALLY SIMILAR TO A WHERE CLAUSE
-- THEREFORE, MORE THAN ONE PREDICATE CAN BE USED
SELECT
OH.OrderDate,
OH.SalesOrderNumber,
P.Name AS ProductName,
OD.OrderQty,
OD.UnitPrice,
OD.LineTotal
FROM [SalesLT].[SalesOrderHeader] AS OH
INNER JOIN [SalesLT].[SalesOrderDetail] AS OD
ON OH.SalesOrderID = OD.SalesOrderID
INNER JOIN [SalesLT].[Product] AS P
ON OD.ProductID = P.ProductID AND OD.UnitPrice = P.ListPrice -- NOTICE THE MULTIPLE PREDICATE CONDITION
ORDER BY OH.OrderDate, OH.SalesOrderID, OD.SalesOrderDetailID
-- (0 row(s) affected)
-- WE HAVE NO PRODUCTS THAT WERE ACTUALLY SOLD (OD.UnitPrice) AT THE LIST PRICE (P.ListPrice)

-- Outer Joins
-- return all the rows from the first/left table and any matching rows from the second/right table
-- LEFT, RIGHT AND FULL KEYWORDS ARE USED TO SPECIFY WHICH OF THE TABLES IS GOING TO BE SHOWN IN FULL (ALL THE ROWS)
-- LEFT [OUTER] JOIN (is the default)
-- RIGHT [OUTER] JOIN
-- FULL OUTER JOIN
-- (remember that whenever there is a join, sql server first creates a cartesian product, and only then filters the results)

--- NULLS IN JOINS: INDICATE THAT THERE WERE NULLS ON THE UNDERLYING DATA OR, MORE COMMONLY, THAT THERE WAS NO MATCH IN THAT ROW
-- Demo: Using Outer Joins

-- Get all customers, with sales orders for those who've bought anything
SELECT
C.FirstName,
C.LastName,
OH.SalesOrderNumber
FROM [SalesLT].[Customer] AS C
LEFT OUTER JOIN [SalesLT].[SalesOrderHeader] AS OH
ON C.CustomerID = OH.CustomerID

-- Return only customers who haven't purchased anything
SELECT
C.FirstName,
C.LastName,
OH.SalesOrderNumber
FROM [SalesLT].[Customer] AS C
LEFT OUTER JOIN [SalesLT].[SalesOrderHeader] AS OH
ON C.CustomerID = OH.CustomerID
WHERE OH.CustomerID IS NULL

-- left outer join with more than two tables
-- chain of tables, once you've used a left join you gonna have keep using left joins (to avoid the nulls in the right side)

SELECT
P.Name AS ProductName,
OH.SalesOrderNumber
FROM [SalesLT].[Product] AS P
LEFT JOIN [SalesLT].[SalesOrderDetail] AS OD
ON P.ProductID = OD.ProductID
LEFT JOIN [SalesLT].[SalesOrderHeader] AS OH -- ADDITIONAL TABLES TO THE RIGHT ARE (MUST BE) LINKED VIA LEFT JOIN
ON OD.SalesOrderID = OD.SalesOrderID
ORDER BY P.ProductID

-- LAST EXAMPLE: NOW A TABLE AT THE END OF THE QUERY IS LINKED TO THE FIRST TABLE OF THE CHAIN
SELECT
P.Name AS ProductName,
C.Name AS Category,
OH.SalesOrderNumber
FROM [SalesLT].[Product] AS P
LEFT JOIN [SalesLT].[SalesOrderDetail] AS OD
ON P.ProductID = OD.ProductID
LEFT JOIN [SalesLT].[SalesOrderHeader] AS OH 
ON OD.SalesOrderID = OD.SalesOrderID
INNER JOIN [SalesLT].[ProductCategory] AS C
ON P.ProductCategoryID = C.ProductCategoryID
ORDER BY P.ProductID

-- Cross Joins
-- THEY ARE BASICALLY CARTESIAN PRODUCT
-- THEREFORE, LOGICALL, CROSS JOINS DO NOT REQUIRE A ON CLAUSE
USE [AdventureWorks2012]
SELECT 
E.NationalIDNumber, P.Name AS ProductName
FROM [HumanResources].[Employee] AS E
CROSS JOIN [Production].[Product] AS P
-- CARTESIAN PRODUCTS ARE THE FOUNDATION OF JOINS, JOINS ARE CARTESIAN PRODUCTS WITH FILTERS

-- Cross Joins: Demo
USE [AdventureWorksLT2012]
SELECT
P.Name AS ProductName,
C.FirstName + ' ' + C.LastName as Customer,
C.Phone AS CustomerPhone
FROM [SalesLT].[Product] P
CROSS JOIN [SalesLT].[Customer] AS C
-- (249865 row(s) affected)

-- Self Joins
-- COMPARING ROWS IN A TABLE TO OTHER ROWS IN THE SAME TABLE
-- EXAMPLE: RELATING EMLOYEES TO THEIR MANAGERS (WHICH ARE ALSO EMPLOYEES)
-- AN ALIAS IS MANDATORY (BECAUSE THE JOIN IS BETWEEN THE SAME TABLE)

-- Self Joins: Demo
-- NOTE THAT THERE IS NO EMPLOYEE TABLE, SO IT HAS TO BE CREATED
CREATE TABLE [SalesLT].[Employee]
(
EmployeeID int IDENTITY PRIMARY KEY,
EmployeeName nvarchar(256),
ManagerID int
) 
GO

INSERT INTO [SalesLT].[Employee] (EmployeeName,ManagerID)
SELECT DISTINCT 
SalesPerson,
NULLIF(CAST(RIGHT(SalesPerson,1) AS INT),0) 
FROM [SalesLT].[Customer]
GO
-- (9 row(s) affected)

UPDATE [SalesLT].[Employee] 
SET ManagerID = (SELECT MIN(EmployeeID) FROM [SalesLT].[Employee] WHERE ManagerID IS NULL)
WHERE ManagerID IS NULL
AND EmployeeID > (SELECT MIN(EmployeeID) FROM [SalesLT].[Employee] WHERE ManagerID IS NULL)
GO
-- (3 row(s) affected)

SELECT * FROM [SalesLT].[Employee] 
/*
EmployeeID	EmployeeName				ManagerID
1			adventure-works\david8		8
2			adventure-works\garrett1	1
3			adventure-works\jae0		NULL
4			adventure-works\jillian0	3
5			adventure-works\josé1		1
6			adventure-works\linda3		3
7			adventure-works\michael9	9
8			adventure-works\pamela0		3
9			adventure-works\shu0		3
*/

DELETE FROM [SalesLT].[Employee] 
WHERE EmployeeID > 9

-- NOW WE SEE THE ACTUAL SELF JOIN DEMO
SELECT
E.EmployeeName,
M.EmployeeName AS ManagerName
FROM [SalesLT].[Employee] AS E
LEFT JOIN [SalesLT].[Employee] AS M
ON E.ManagerID = M.EmployeeID
ORDER BY E.ManagerID

/*
KEY POINTS
A self-join is an inner, outer, or cross join that matches rows in a table to other rows in the same table. 
When defining a self-join, you must specify an alias for at least one instance of the table being joined.
*/