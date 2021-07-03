-- Lab 1: Introduction to Transact-SQL   Exercises
USE [AdventureWorksLT2012]
SELECT * FROM [SalesLT].[Customer]

SELECT Title, FirstName, MiddleName, LastName, Suffix
FROM [SalesLT].[Customer]

SELECT SalesPerson, Title + ' ' + LastName AS CustomerName, Phone
FROM SalesLT.Customer;

SELECT CAST(A.CustomerID AS varchar) + ': ' + A.CompanyName AS CustomerCompany
FROM SalesLT.Customer AS A

SELECT
A.SalesOrderNumber + ' (' + STR(A.RevisionNumber,1) + ')' AS OrderRevision,
CONVERT(nvarchar(30), A.OrderDate, 102) AS OrderDate
FROM [SalesLT].[SalesOrderHeader] AS A

SELECT
A.FirstName + ' ' + ISNULL(A.MiddleName + ' ','') + A.LastName
FROM [SalesLT].[Customer] AS A

SELECT
A.CustomerID, COALESCE(A.EmailAddress, A.Phone) AS PrimaryContact
FROM [SalesLT].[Customer] AS A

SELECT SalesOrderID, OrderDate,
  CASE
    WHEN ShipDate IS NULL THEN 'Awaiting Shipment'
    ELSE 'Shipped'
  END AS ShippingStatus
FROM SalesLT.SalesOrderHeader;