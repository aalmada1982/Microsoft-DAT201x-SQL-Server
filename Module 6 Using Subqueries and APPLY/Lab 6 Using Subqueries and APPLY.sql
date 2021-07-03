-- Lab 6: Using Subqueries and APPLY
-- 1. Retrieving Product Price Information
-- Use subqueries to compare the cost and list prices for each product [SalesLT].[Product]
-- with the unit prices charged in each sale. [SalesLT].[SalesOrderDetail]

SELECT DISTINCT
P.ProductID,
P.Name AS ProductName,
P.StandardCost,
P.ListPrice
FROM [SalesLT].[Product] AS P
-- (295 row(s) affected)

SELECT DISTINCT
SOD.ProductID,
SOD.ProductID,
SOD.UnitPrice
FROM [SalesLT].[SalesOrderDetail] AS SOD

SELECT DISTINCT
P.ProductID,
P.Name AS ProductName,
P.ListPrice
FROM [SalesLT].[Product] AS P
WHERE P.ListPrice > (SELECT AVG(SOD.UnitPrice) FROM [SalesLT].[SalesOrderDetail] AS SOD)
ORDER BY P.ProductID

/*	
2. Retrieving Product Price Information (2)
AdventureWorks is interested in finding out which products are being sold at a loss.

INSTRUCTIONS 50 XP
Retrieve the product ID, name, and list price for each product where the list price is 100 or more, 
and the product has been sold for (strictly) less than 100.

Remember, the ProductID in your subquery will be from the SalesLT.SalesOrderDetail table.
*/
SELECT
P.ProductID,
P.Name AS ProductName,
P.ListPrice
FROM [SalesLT].[Product] AS P
WHERE P.ListPrice >= 100
AND P.ProductID IN (
					SELECT DISTINCT
					SOD.ProductID 
					FROM [SalesLT].[SalesOrderDetail] AS SOD
					WHERE SOD.UnitPrice < 100)
/* THIS IS AN UNCORRELATED SUBQUERY
BECAUSE IS POSSIBLE TO RUN THE INNER QUERY INDEPENDENTLY
BUT WHAT I CAN SAY IS THAT A JOIN WOULD HAVE BEEN BETTER

ProductID	ProductName				ListPrice
810			HL Mountain Handlebars	120,27
813			HL Road Handlebars		120,27
876			Hitch Rack - 4-Bike		120,00
894			Rear Derailleur			121,46
907			Rear Brakes				106,50
948			Front Brakes			106,50
996			HL Bottom Bracket		121,49 

-- 3. Retrieving Product Price Information (3)
In order to get an idea of how many products are selling above or below list price, 
you want to gather some aggregate product data.

INSTRUCTIONS 50 XP
Retrieve the product ID, name, cost, and list price for each product along with the average unit price 
for which that product has been sold. Make sure to use the aliases provided, and default column names elsewhere. */

SELECT 
P.ProductID,
P.Name AS ProductName,
P.StandardCost,
P.ListPrice, 
(SELECT
AVG(SOD.UnitPrice) AS AvgSellingPrice
FROM [SalesLT].[SalesOrderDetail] AS SOD
WHERE SOD.ProductID = P.ProductID) AS AvgSellingPrice
FROM [SalesLT].[Product] AS P
ORDER BY P.ProductID

-- HERE I CRAFT THE SUBQUERY
SELECT
SOD.ProductID,
AVG(SOD.UnitPrice) AS AvgSellingPrice
FROM [SalesLT].[SalesOrderDetail] AS SOD
GROUP BY SOD.ProductID
ORDER BY AvgSellingPrice DESC

/*
 4. Retrieving Product Price Information (4)
 AdventureWorks is interested in finding out which products are costing more than they're being sold for, on average.

INSTRUCTIONS 50 XP
Filter the query for the previous exercise to include only products where the cost is higher than the average selling price. 
Make sure to use the aliases provided, and default column names elsewhere. */

SELECT 
P.ProductID,
P.Name AS ProductName,
P.StandardCost,
P.ListPrice, 
(SELECT
AVG(SOD.UnitPrice) AS AvgSellingPrice
FROM [SalesLT].[SalesOrderDetail] AS SOD
WHERE SOD.ProductID = P.ProductID) AS AvgSellingPrice
FROM [SalesLT].[Product] AS P
WHERE P.StandardCost > 
(SELECT AVG(SOD.UnitPrice) AS AvgSellingPrice
FROM [SalesLT].[SalesOrderDetail] AS SOD
WHERE SOD.ProductID = P.ProductID)
ORDER BY P.ProductID

-- HERE AGAIN I CRAFT THE SUBQUERY THAT IS GOIN TO BE USED ABOVE
-- APPARENTLY IT WAS NOT NECESSARY
/*
5. Retrieving Customer Information
The AdventureWorksLT database includes a table-valued user-defined function named dbo.ufnGetCustomerInformation. 
Use this function to retrieve details of customers based on customer ID values retrieved from tables in the database. */
SELECT * FROM [dbo].[ufnGetCustomerInformation](1)
/* 
CustomerID	FirstName	LastName
1			Orlando		Gee
SO IT WORKS!!!				

INSTRUCTIONS 50 XP
Retrieve the sales order ID, customer ID, first name, last name, and total due for all sales orders 
from the SalesLT.SalesOrderHeader table and the dbo.ufnGetCustomerInformation function. 
Make sure to use the aliases provided, and default column names elsewhere. */
SELECT * FROM [SalesLT].[SalesOrderHeader]
-- -- select SalesOrderID, CustomerID, FirstName, LastName, TotalDue from the appropriate tables

SELECT 
SOH.SalesOrderID,
SOH.CustomerID,
CI.FirstName,
CI.LastName,
SOH.TotalDue
FROM [SalesLT].[SalesOrderHeader] AS SOH
CROSS APPLY [dbo].[ufnGetCustomerInformation](SOH.CustomerID) AS CI
ORDER BY SOH.SalesOrderID
/*
6. Retrieving Customer Information (2)
Use the table-valued user-defined function dbo.ufnGetCustomerInformation again to retrieve details of customers 
based on customer ID values retrieved from tables in the database.

INSTRUCTIONS 50 XP
Retrieve the customer ID, first name, last name, address line 1 and city for all customers from the SalesLT.Address 
and SalesLT.CustomerAddress tables, using the dbo.ufnGetCustomerInformation function. 
Make sure to use the aliases provided, and default column names elsewhere. */

SELECT * FROM [SalesLT].[Address]
SELECT * FROM [SalesLT].[CustomerAddress]

SELECT
CI.CustomerID,
CI.FirstName,
CI.LastName,
A.AddressLine1,
A.City
FROM [SalesLT].[Address] AS A
INNER JOIN [SalesLT].[CustomerAddress] AS CA
ON A.AddressID = CA.AddressID
CROSS APPLY [dbo].[ufnGetCustomerInformation](CA.CustomerID) AS CI
-- THANKS VENKAT FOR EXPLAINING APPLY AND SUBQUERIES IN GREAT DETAIL!!!!