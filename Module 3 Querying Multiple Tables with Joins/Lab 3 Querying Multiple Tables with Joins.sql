-- Lab 3: Querying Multiple Tables with Joins
-- APPARENTLY JOIN IS BY DEFAULT AN INNER JOIN
-- Generating Invoice Reports
USE [AdventureWorksLT2012]
SELECT C.CompanyName, OH.SalesOrderID, OH.TotalDue
FROM SalesLT.Customer AS C
INNER JOIN SalesLT.SalesOrderHeader AS OH
ON C.CustomerID =  OH.CustomerID

/* Generating Invoice Reports (2)

Extend your customer orders query to include the main office address for each customer, 
including the full street address, city, state or province, postal code, and country or region. 
Make sure to use the aliases provided, and default column names elsewhere. */

SELECT C.CompanyName, A.AddressLine1, ISNULL(a.AddressLine2, '') AS AddressLine2, 
A.City, A.StateProvince, A.PostalCode, A.CountryRegion, OH.SalesOrderID, OH.TotalDue
FROM SalesLT.Customer AS C
INNER JOIN SalesLT.SalesOrderHeader AS OH
ON C.CustomerID =  OH.CustomerID
INNER JOIN  [SalesLT].[CustomerAddress] AS CA
ON CA.CustomerID = C.CustomerID AND CA.AddressType LIKE 'Main Office'
INNER JOIN [SalesLT].[Address] AS A
ON CA.AddressID =  A.AddressID;

/*
Retrieving Sales Data
The sales manager wants a list of all customer companies and their contacts (first name and last name), 
showing the sales order ID and total due for each order they have placed.

INSTRUCTIONS
50 XP
Customers who have not placed any orders should be included at the bottom of the list with NULL values for the order ID 
and total due. Make sure to use the aliases provided, and default column names elsewhere.
*/
-- select the CompanyName, FirstName, LastName, SalesOrderID and TotalDue columns
-- from the appropriate tables
SELECT C.CompanyName, C.FirstName, C.LastName, 
oh.SalesOrderID, oh.TotalDue
FROM SalesLT.Customer AS c
LEFT JOIN SalesLT.SalesOrderHeader AS oh
-- join based on CustomerID
ON c.CustomerID = oh.CustomerID
-- order the SalesOrderIDs from highest to lowest
ORDER BY oh.SalesOrderID DESC;

SELECT c.CompanyName, c.FirstName, c.LastName, c.Phone
FROM SalesLT.Customer AS c
LEFT JOIN SalesLT.CustomerAddress AS ca
-- join based on CustomerID
ON c.CustomerID = ca.CustomerID
-- filter for when the AddressID doesn't exist
WHERE ca.AddressID IS NULL;

/*
Retrieving Sales Data (3)
Some customers have never placed orders, and some products have never been ordered.
*/
SELECT c.CustomerID, p.ProductID
FROM SalesLT.Customer AS c
FULL OUTER JOIN SalesLT.SalesOrderHeader AS oh
ON c.CustomerID = oh.CustomerID
FULL OUTER JOIN SalesLT.SalesOrderDetail AS od
-- join based on the SalesOrderID
ON od.SalesOrderID = oh.SalesOrderID
FULL OUTER JOIN SalesLT.Product AS p
-- join based on the ProductID
ON p.ProductID = od.ProductID
WHERE oh.SalesOrderID IS NULL
ORDER BY p.ProductID, c.CustomerID;

