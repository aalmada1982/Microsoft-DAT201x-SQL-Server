-- Module 6: Using Subqueries and APPLY
-- Introduction to Subqueries

-- subqueries: they can retrieve scalars (single values) or multiple values
-- frequently used in the WHERE clause

-- Demo: Using Subqueries
-- Scalar Subquery
-- Display a list of products whose list price is higher than the highest unit price of items that have sold
USE [AdventureWorksLT2012]
SELECT MAX(sod.UnitPrice) FROM [SalesLT].[SalesOrderDetail] AS sod
-- 1466.01
SELECT
*
FROM [SalesLT].[Product] AS P
WHERE P.ListPrice > 1466.01
-- (39 row(s) affected)

SELECT
*
FROM [SalesLT].[Product] AS P
WHERE P.ListPrice > (SELECT MAX(sod.UnitPrice) FROM [SalesLT].[SalesOrderDetail] AS sod)
-- (39 row(s) affected)
-- the instructors recommend to check if replacing the value of the subquery in the outer query works
-- in a nutshell, checking always that the individual portions of the code function properly

-- Multivalued subquery
-- List products that have an order quantity greater than 20
SELECT
Quantity
FROM (
SELECT 
sod.ProductID,
SUM(sod.OrderQty) AS Quantity
FROM [SalesLT].[SalesOrderDetail] AS sod
GROUP BY sod.ProductID
HAVING SUM(sod.OrderQty) > 20
) AS HighVolumeProducts 
-- (26 row(s) affected)

SELECT
P.Name AS ProductName 
FROM [SalesLT].[Product] AS P
WHERE P.ProductID IN (
SELECT
ProductID
FROM (
SELECT 
sod.ProductID,
SUM(sod.OrderQty) AS Quantity
FROM [SalesLT].[SalesOrderDetail] AS sod
GROUP BY sod.ProductID
HAVING SUM(sod.OrderQty) > 20
) AS HighVolumeProducts 
)

-- Scalar and Multivalued NON-CORRELATED SUBQUERIES (AKA SELF CONTAINED QUERIES)
-- In this case the inner subquery and the outer query can operate independently
-- NON-CORRELATED SUBQUERIES are basically functions that return one or multiple values
-- both components, the inner and the outer queries can run independently

-- CORRELATED SUBQUERIES
/*
...So it's logically, I wouldn't use them just because you think oh well nowadays
they're not as slow as they used to be. It's something that is a bit slower and
it's logically quite complex. But it can do something that is quite complicated
because what we're looking for here is for each employee ID, show me
the values where the order date is equal to the maximum order date for that employee.
So the last order that employee took in English is what we're saying. Yeah.
Okay. */

-- Demo: Using Correlated Subqueries
-- For each customer list all sales on the last day that they bought something 
SELECT 
soh.CustomerID,
soh.SalesOrderID,
soh.OrderDate 
FROM [SalesLT].[SalesOrderHeader] soh
ORDER BY soh.CustomerID DESC,soh.OrderDate DESC

SELECT 
soh.CustomerID,
soh.SalesOrderID,
soh.OrderDate 
FROM [SalesLT].[SalesOrderHeader] soh
WHERE soh.OrderDate = (	SELECT 
						MAX(soh.OrderDate) 
						FROM [SalesLT].[SalesOrderHeader] soh)
-- JARGON:
-- INNER QUERY (SUBQUERY)
-- CALLING QUERY (OUTER QUERY)

SELECT 
so1.CustomerID,
so1.SalesOrderID,
so1.OrderDate 
FROM [SalesLT].[SalesOrderHeader] so1
WHERE so1.OrderDate = (	
SELECT MAX(so2.OrderDate) 
FROM [SalesLT].[SalesOrderHeader] so2
WHERE so1.CustomerID = so2.CustomerID)
ORDER BY so1.CustomerID DESC

-- the most common problem with correlated subqueries is that tehy can be tested (easily)
-- it demands careful inspection of data knowing exactly if they are workking

-- Key Points
-- Correlated subqueries reference objects in the outer query.

-- The APPLY Operator
-- APPLY retrieves results only possible through a correlated subquery but with a less complex piece of code
-- it can additionally be used to produce JOINs but here the focus is placed in replacing the need for subqueries
-- CROSS APPLY operator
-- CROSS APPLY applies the right table expression to each row in the left table
-- it is conceptually similar to a CROSS JOIN operation but can correlate data between sources

-- Demo: Using Apply

-- Setup
CREATE FUNCTION [SalesLT].[udfMaxUnitPrice] (@SalesOrderID int)
RETURNS TABLE
AS
RETURN
SELECT SalesOrderID,Max(UnitPrice) as MaxUnitPrice FROM 
SalesLT.SalesOrderDetail
WHERE SalesOrderID=@SalesOrderID
GROUP BY SalesOrderID;

-- NOW I WILL TRY TO BREAK THE INNER WORKINGS OF THE CROSS APPLY
-- STEP BY STEP
SELECT 
sod.SalesOrderID,
Max(sod.UnitPrice) as MaxUnitPrice
FROM SalesLT.SalesOrderDetail AS sod
WHERE sod.SalesOrderID = 71774
GROUP BY sod.SalesOrderID
/*
SalesOrderID	MaxUnitPrice
71774			356.898			*/
-- SUPPOSEDLY CROSS APPLY WILL RUN THIS QUERY IN THE [SalesLT].[SalesOrderDetail]
-- FOR EVERY ORDER ID IN THE [SalesLT].[SalesOrderHeader] so1 TABLE
-- LET'S CHJECK TO SEE IF IT IS FOR REAL
SELECT * FROM [SalesLT].[udfMaxUnitPrice](71774)
/*
SalesOrderID	MaxUnitPrice
71774			356.898   */
-- IT IS EXACLTY THE SAME RESULT!!!

--Display the sales order details for items that are equal to
-- the maximum unit price for that sales order

SELECT 
sod.SalesOrderID,
mup.MaxUnitPrice
FROM [SalesLT].[SalesOrderHeader] sod
CROSS APPLY [SalesLT].[udfMaxUnitPrice](sod.SalesOrderID) AS mup
ORDER BY mup.MaxUnitPrice DESC


/*
Key Points
The APPLY operator enables you to execute a table-valued function for each row in a rowset returned by a SELECT statement. 
Conceptually, this approach is similar to a correlated subquery.
CROSS APPLY returns matching rows, similar to an inner join. 
OUTER APPLY returns all rows in the original SELECT query results with NULL values for rows where no match was found. */
