-- Module 6: Using Subqueries and APPLY   
-- Introduction to Subqueries
/*
Introduction to Subqueries
• Subqueries are nested queries: queries within queries
• Results of inner query passed to outer query
– Inner query acts like an expression from perspective of outer query
*/
/*
• Scalar subquery returns
single value to outer query
– Can be used anywhere singlevalued
expression is used:
SELECT, WHERE, and so on
*/

/*
Multi-valued subquery
returns multiple values as a
single column set to the
outer query
– Used with IN predicate
*/

-- Demo: Using Subqueries: Typical non-correlated subquery
USE [AdventureWorksLT2012]
SELECT
MAX(SOD.UnitPrice)
FROM SalesLT.SalesOrderDetail AS SOD
-- 1466,01
SELECT
*
FROM SalesLT.Product
WHERE ListPrice > 1466.01

SELECT
*
FROM SalesLT.Product
WHERE ListPrice > (
SELECT
MAX(SOD.UnitPrice)
FROM SalesLT.SalesOrderDetail AS SOD
)
/*
Self-Contained or Correlated?
• Most subqueries are self-contained and have no
connection with the outer query other than passing it results
• Correlated subqueries refer to elements of tables used in outer
query
– Dependent on outer query, cannot be executed separately
– Behaves as if inner query is executed once per outer row
– May return scalar value or multiple values
*/

-- Demo: Using Correlated Subqueries
-- for each customer show all sales of the last day they made a purchase
SELECT
SOH.CustomerID,
SOH.SalesOrderID,
SOH.OrderDate
FROM SalesLT.SalesOrderHeader SOH

SELECT
SOH.CustomerID,
SOH.SalesOrderID,
SOH.OrderDate
FROM SalesLT.SalesOrderHeader SOH
WHERE SOH.OrderDate =
(SELECT
MAX(SOH.OrderDate)
FROM SalesLT.SalesOrderHeader SOH)

SELECT
SOH1.CustomerID,
SOH1.SalesOrderID,
SOH1.OrderDate
FROM SalesLT.SalesOrderHeader AS SOH1
WHERE SOH1.OrderDate =
(
SELECT
SOH2.OrderDate
FROM SalesLT.SalesOrderHeader AS SOH2
WHERE SOH2.CustomerID = SOH1.CustomerID
)
ORDER BY CustomerID

-- The APPLY Operator
-- Using APPLY with Table-Valued Functions
/*
CROSS APPLY applies the right table expression to each row in left table
Conceptually similar to CROSS JOIN between two tables but can correlate data between sources */

-- Demo: Using Apply

-- display sales order details for items that are equal to the
-- maximun unit price for that sales order

SELECT
SOH.SalesOrderID,
MUP.MaxUnitPrice
FROM SalesLT.SalesOrderHeader AS SOH
CROSS APPLY SalesLT.udfMaxUnitPrice(SOH.SalesOrderID) AS MUP
ORDER BY SOH.SalesOrderID

