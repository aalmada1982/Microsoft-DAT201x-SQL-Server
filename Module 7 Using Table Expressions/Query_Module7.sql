-- Module 7: Using Table Expressions   
-- Table Expressions Overview

-- Querying views: Views are named queries with definitions stores in a database.
--		Views can provide abstraction, encapsulation and simplification.
--		From an admistrative perspective, views can provide a security layer to a database.
-- Views maybe referenced in a select statement just like a table.
-- Demo creating and querying views

-- create a view
CREATE VIEW SalesLT.vCustomerAddress
AS
SELECT
C.CustomerID, C.FirstName, C.LastName,
A.AddressLine1, A.City, A.StateProvince
FROM SalesLT.Customer AS C JOIN SalesLT.CustomerAddress AS CA
ON C.CustomerID = CA.CustomerID
JOIN SalesLT.Address AS A
ON CA.AddressID = A.AddressID 
-- Command(s) completed successfully.

-- Query the views
SELECT
CustomerID, City
FROM SalesLT.vCustomerAddress

-- Join the view with another table
SELECT
VCA.StateProvince,
VCA.City,
ISNULL(SUM(SOH.TotalDue),0.00) AS Revenue
FROM SalesLT.vCustomerAddress AS VCA
JOIN SalesLT.SalesOrderHeader AS SOH
ON VCA.CustomerID = SOH.CustomerID
GROUP BY VCA.StateProvince, VCA.City
ORDER BY VCA.StateProvince, Revenue DESC

-- Using Temporary Tables and Table Variables
-- views are persisted in the database whereas temporary tables are temporary, as their name suggests
-- Created in tempdb and deleted automatically
-- created with the # prefix, global temporary tables are created with the ## prefix

-- Table Variables
-- Introduced because temporary tables cause recompilations
-- Created using the @ prefix
-- Used similarly to temporary tables but scoped to the batch, instead than to the session
-- Used only for small data sets, they are not efficient for handling large volumes of data

-- Demo usign temporary tables and variables
-- Temporary variable example

CREATE TABLE #Colors
(Color varchar(15));
-- Command(s) completed successfully.

INSERT INTO #Colors
SELECT DISTINCT
Color
FROM SalesLT.Product;
-- (10 row(s) affected)

SELECT * FROM #Colors
/*
NULL
Black
Blue
... */

-- TABLE VARIABLES
DECLARE @Colors AS TABLE (Color varchar(15));

INSERT INTO @Colors
SELECT DISTINCT 
Color
FROM SalesLT.Product;

SELECT * FROM @Colors;
-- it only works when the three commands are executed into a single batch
-- they remain in scope within a single batch of code

-- Table valued functions
-- TVF is a specific type of function which returns a table (to a calling query)
-- TVFs are named objects permanently stored in the database

-- DEMO CREATING AND QUERYING A TVF
CREATE FUNCTION SalesLT.udfCustomerByCity
(@City varchar(20))
RETURNS TABLE
AS
RETURN(
SELECT
C.CustomerID, C.FirstName, C.LastName,
A.AddressLine1, A.City, A.StateProvince
FROM SalesLT.Customer AS C JOIN SalesLT.CustomerAddress AS CA
ON C.CustomerID = CA.CustomerID
JOIN SalesLT.Address AS A
ON CA.AddressID = A.AddressID 
WHERE A.City = @City)
-- Command(s) completed successfully.

SELECT * FROM SalesLT.udfCustomerByCity('Bellevue')

-- Derived Tables
-- a derived table is a subquery that returns an entire table, they are named query expressions
-- not stored in database - they represent virtual relational tables
-- the scope of a derived table is the query in which they are defined
-- Demo using derived tables

SELECT
Category,
COUNT(ProductID) AS Products
FROM
(SELECT 
P.ProductID, 
P.Name AS ProductName,
PC.Name AS Category
FROM SalesLT.Product AS P
JOIN SalesLT.ProductCategory PC
ON P.ProductCategoryID = PC.ProductCategoryID)
AS ProdCats
GROUP BY Category
ORDER BY Products DESC

-- Using Common Table Expressions
-- CTEs are named table expressions, can be considered an alternative to derived queries
-- it can be equated to defining the derived table upfront
-- Main differences of CTE against derived queries:
-- can be called multiple times within the query, this also allows for recursion

-- CTE example:
USE [AdventureWorksLT2012]
-- Using a CTE
WITH ProducByCategory (ProductID, ProductName, Category)
AS
(
SELECT 
P.ProductID, P.Name, PC.Name AS Category
FROM SalesLT.Product AS P
JOIN SalesLT.ProductCategory AS PC
ON P.ProductCategoryID = PC.ProductCategoryID)

SELECT 
Category,
COUNT(DISTINCT ProductID) AS Products
FROM ProducByCategory
GROUP BY Category
ORDER BY Products DESC

-- RECURSIVE CTE
SELECT * FROM SalesLT.Employee

-- Using a CTE to perform recursion
WITH OrgReport (ManagerID, EmployeeID, EmployeeName, Level)
AS
(-- Anchor query
SELECT
E.ManagerID, E.EmployeeID, E.EmployeeName, 0
FROM SalesLT.Employee AS E
WHERE E.ManagerID IS NULL

UNION ALL
-- Recursive query
SELECT E.ManagerID, E.EmployeeID, E.EmployeeName, Level + 1
FROM SalesLT.Employee AS E
INNER JOIN OrgReport AS O
ON E.ManagerID = O.EmployeeID
)
SELECT * FROM OrgReport
OPTION (MAXRECURSION 3);