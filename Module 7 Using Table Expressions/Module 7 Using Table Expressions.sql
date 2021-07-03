-- Module 7 Using Table Expressions

-- Querying Views
-- VIEWS ARE BASICALLY, NAMED QUERIES (NAMED COMPLEX QUERIES)
-- views can provide abstraction, encapsulation and simplification
-- It can also add a security layer over the queries
-- a person can be given access to thw view without them having access to the underlying tables
-- so, from an administrative perspective it can offer extra security
--- for most practical purposes a view can be queried just like a table would
-- there are only a few restrictions when inserting and updating data in it

-- Demo using views
-- Create a view
USE [AdventureWorksLT2012]
-- Command(s) completed successfully.
CREATE VIEW [SalesLT].[vCustomerAddress]  -- views are, by convention, named starting with a v
AS
SELECT
C.CustomerID,
C.FirstName,
C.LastName,
A.AddressLine1,
A.City,
A.StateProvince
FROM [SalesLT].[Customer] AS C
INNER JOIN [SalesLT].[CustomerAddress] AS CA
ON C.CustomerID = C.CustomerID
INNER JOIN [SalesLT].[Address] AS A
ON CA.AddressID = A.AddressID
-- Command(s) completed successfully.

-- querying the view
SELECT * FROM [SalesLT].[vCustomerAddress]
-- AND EFFECTIVELY I CAN RETRIEVE THE DATA FROM THE COMPLEX JOIN ENCAPSULATED IN [SalesLT].[vCustomerAddress]
-- intellisense works as if it was a normal table

-- joining the view with a table
SELECT 
vca.StateProvince,
SUM(soh.TotalDue)/1000000 AS RevenueMillUSD
FROM [SalesLT].[vCustomerAddress] AS vca
LEFT JOIN [SalesLT].[SalesOrderHeader] AS soh
ON vca.CustomerID = soh.CustomerID
GROUP BY vca.StateProvince
ORDER BY RevenueMillUSD DESC
/*
StateProvince	RevenueMillUSD
California		52649.30
Ontario			41309.40
Washington		38879.50
-- There seems to be a problem with data, Revenue is astronomical!!!! */
-- I cannot find out what's the problem, but it is not my business now
-- I fixeed: always check the ON clause of the join, not all of them are correlated queries
-- I misstyped "ON vca.CustomerID = vca.CustomerID"
-- instead of ON "vca.CustomerID = soh.CustomerID"
/*
StateProvince	RevenueMillUSD
California		62.1597
Ontario			48.7714
Washington		45.9025 */

-- Key Points
-- Views are database objects that encapsulate SELECT queries.
-- You can query a view in the same way as a table, however there are some considerations for updating them.

-- Using Temporary Tables and Table Variables

-- temporary tables are always named with the prefix # (hash or pound symbol at the beginning)
-- #tempProducts
-- Temporary tables:
-- Are created in tempdb and deleted automatically (at the end of the session the temporaty tables are erased)
-- with a # prefix
-- Global temporary tables are created with the ## prefix
-- There are some concerns regarding applications that rely too heavily in temporary tables
-- because they can clutter teh tempdb
-- the continuous creation and destruction of those temporary tables is very intensive in computational resources

-- An alternative is using table variables
-- variables are prefixed instead qith the @ symbol
-- table is another data type, as long as variables are concerned
-- Once defined, table variables can be queried as a table would be
-- they are scoped to the batch, not to the session (as temporary tables are)
-- variables cease to be present (after whay are called) in the following GO statement
-- variable tables are designed to hold limited amounts of data, big chunck of data stored in memory won't improve performance

-- Demo: using temporary tables and table variables
-- Temporay tables
-- CREATING THE TEMPORARY TABLE
CREATE TABLE #Colors (Color varchar(15))
-- Command(s) completed successfully.
-- INSERTING DATA IN IT
INSERT INTO #Colors
SELECT DISTINCT Color FROM [SalesLT].[Product]

-- (10 row(s) affected)
-- QUERING THE TABLE AS ANY OTHER VARIABLE
SELECT * FROM #Colors
-- (10 row(s) affected)
-- BUT YOU WON'T FIND IT ANYWHERE IN THE OBJECT EXPLORER --> EXCEPT IN SYSTEM DATABASES > TEMPDB

-- Table variables
-- DECLARING THE TABLE VARIABLE
DECLARE @Colors AS TABLE (Color varchar(15))

-- POPULATE THE TABLE VARIABLE WITH DATA
INSERT INTO @Colors
SELECT DISTINCT Color FROM [SalesLT].[Product]
-- Msg 1087, Level 15, State 2, Line 98
-- Must declare the table variable "@Colors".!!!
-- EVERYTHING MUST BE IN THE SAME BATCH OF COMMANDS
DECLARE @Colors AS TABLE (Color varchar(15))
INSERT INTO @Colors
SELECT DISTINCT Color FROM [SalesLT].[Product]
SELECT * FROM @Colors
GO
-- ONLY NOW I GET THE RESULT
-- TABLE VARIABLES MUST BE DECLARED, UPDATED AND QUERIED IN THE SAME BATCH OF CODE
-- ALL AT ONCE

-- STARTING A NEW BATCH
SELECT * FROM #Colors
-- STILL WORKS
SELECT * FROM @Colors
-- Must declare the table variable "@Colors"
-- THE TABLE VARIABLE IS NOT THERE
-- AS LONG AS THE TABLE VARIABLES ARE IN THE CODE BATCH IN WHICH THEY WERE DECLARED
-- THEY WILL BEHAVE AS A TABLE, THEY CAN BE JOINED ETCETERA
/*
Key Points

Temporary tables are prefixed with a # symbol 
(You can also create global temporary tables that can be accessed by other processes by prefixing the name with ##)
Local temporary tables are automatically deleted when the session in which they were created ends. 
Global temporary tables are deleted when the last user sessions referencing them is closed.

Table variables are prefixed with a @ symbol.
Table variables are scoped to the batch in which they are created. */

-- Querying Table-Valued Functions
-- TVF are named objects with definitions (functions) that are stored in the database
-- TVF returned a virtual table to a calling query (AS IN CROSS APLLY)
-- Unlike views TVF support input parameters
-- (TVF can be thought of as parametrized views)
-- as we know from previous lessons TVF are permanently stored in the database (withing Programability folder)

-- Demo Using Table Valued Functions
CREATE FUNCTION [SalesLT].[udfCustomersByCity] -- user defined function "Customers By City" udf is naming convention, as v for views
(@City AS varchar(20))
RETURNS TABLE
AS
RETURN
(SELECT 
C.CustomerID, C.FirstName, C.LastName,
A.AddressLine1, A.City, A.StateProvince
FROM [SalesLT].[Customer] AS C
JOIN [SalesLT].[CustomerAddress] AS CA
ON C.CustomerID = CA.CustomerID
JOIN [SalesLT].[Address] AS A
ON CA.AddressID = A.AddressID
WHERE City = @City);
-- Command(s) completed successfully.

SELECT A.City FROM [SalesLT].[Address] AS A

SELECT * FROM [SalesLT].[udfCustomersByCity]('Oxnard')
/*
CustomerID	FirstName		LastName	AddressLine1		City	StateProvince
30089		Michael John	Troyer		Oxnard Outlet		Oxnard	California
30027		Joseph			Mitzner		123 Camelia Avenue	Oxnard	California */

-- Using Derived Tables
-- DT can be equated to subqueries that retrieve tables
-- subqueries used in the previous lessons were scalar subqueries (only one value)
-- or multi-value subqueries (subqueries that retrieve columns)
-- DT are the sort of subqueries that return multicolumn tables
-- You know them, you've used them a lot in recent months!!!!
-- not stored in the database, they are virtual tables for the purpose of simplifying a query
-- the scope of the DT is the query in which it is defined
-- is purely a programming construct within a select statement

-- Guidelines for using subqueries:
-- 1. they must have an alias
-- 2. have unique names for all columns
-- 3. not use ORDER BY clause (unless TOP and OFFSET/FETCH expressions are included)
-- is better to do the ORDER BY in the outer query
-- 4. DT cannot be referred to multiple times in a query (only once)

-- Demo: Using Derived Tables
SELECT
Category,
COUNT(ProductID) as Products
FROM    (SELECT PC.Name AS Category, P.ProductID
		FROM [SalesLT].[Product] AS P
		JOIN [SalesLT].[ProductCategory] AS PC
		ON P.ProductCategoryID = PC.ProductCategoryID) AS ProductCategory
GROUP BY Category
ORDER BY Products DESC
/*
Category		Products
Road Bikes		43
Road Frames		33
Mountain Bikes	32 */

-- Using Common Table Expressions
-- CTEs are named table expressions defined in a query
-- CTEs are similar to derived queries in scope and naming
-- Unlike derived tables, CTEs allow for multiple references and recursion
-- Unlike a view it doesn't live on once the code batch is finished

-- Demo: Using Common Table Expressions
-- Using a CTE

WITH ProductsByCategory (ProductID, ProductName, Category)
AS
(
SELECT P.ProductID, P.Name AS ProductName, PC.Name as Category
FROM [SalesLT].[Product] AS P
INNER JOIN [SalesLT].[ProductCategory] AS PC
ON P.ProductCategoryID = PC.ProductCategoryID
)
SELECT Category, COUNT(ProductID) AS Products
FROM ProductsByCategory
GROUP BY Category
ORDER BY Products DESC;

-- Recursive CTE
SELECT * FROM [SalesLT].[Employee];

-- Using a CTE to perform recursion
WITH OrgReport (ManagerID, EmployeeID ,EmployeeName, Level)
AS
(
-- Anchor query
SELECT E.ManagerID, e.EmployeeID ,E.EmployeeName, 0
FROM [SalesLT].[Employee] AS E
WHERE E.ManagerID IS NULL

UNION ALL
-- Recursive query
SELECT E.ManagerID, e.EmployeeID ,E.EmployeeName, Level + 1 
FROM [SalesLT].[Employee] AS E
INNER JOIN OrgReport AS O ON E.ManagerID = O.EmployeeID
)
SELECT * FROM OrgReport
OPTION (MAXRECURSION 3);