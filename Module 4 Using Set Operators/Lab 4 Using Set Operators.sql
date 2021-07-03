-- Lab 4: Using Set Operators > Exercises
USE [AdventureWorksLT2012]
select * from [SalesLT].[CustomerAddress]
/*
Retrieving Customer Addresses

Customers can have two kinds of address: a main office address and a shipping address. 
The accounts department wants to ensure that the main office address is always used for billing, 
and have asked you to write a query that clearly identifies the different types of address for each customer.

INSTRUCTIONS
50 XP
Write a query that retrieves the company name, first line of the street address, city, and a column 
named AddressType with the value 'Billing' for customers where the address type in the SalesLT.CustomerAddress 
table is 'Main Office'. Make sure to use the aliases provided, and default column names elsewhere.

*/
-- 1. BILLING ADDRESS
SELECT 
C.CompanyName,
A.AddressLine1,
A.City,
'Billing' AS AddressType
FROM [SalesLT].[Customer] AS C
LEFT JOIN [SalesLT].[CustomerAddress] AS CA
ON C.CustomerID = CA.CustomerID
LEFT JOIN  [SalesLT].[Address] AS A
ON CA.AddressID = A.AddressID
WHERE CA.AddressType = 'Main Office'

/*
Retrieving Customer Addresses (2)
The ideal solution to the previous exercise has been included in the sample code on the right. 
Can you adapt it slightly to generate a very similar result?

INSTRUCTIONS
50 XP
Adapt the query to retrieve the company name, first line of the street address, city, 
and a column named AddressType with the value 'Shipping' for customers where the address type 
in the SalesLT.CustomerAddress table is 'Shipping'. Make sure to use the aliases provided, and default column names elsewhere.
*/
-- 2. SHIPPING ADDRESS
SELECT 
C.CompanyName,
A.AddressLine1,
A.City,
'Shipping' AS AddressType
FROM [SalesLT].[Customer] AS C
LEFT JOIN [SalesLT].[CustomerAddress] AS CA
ON C.CustomerID = CA.CustomerID
LEFT JOIN  [SalesLT].[Address] AS A
ON CA.AddressID = A.AddressID
WHERE CA.AddressType != 'Main Office'

-- 3. UNION ALL
SELECT 
C.CompanyName,
A.AddressLine1,
A.City,
'Billing' AS AddressType
FROM [SalesLT].[Customer] AS C
LEFT JOIN [SalesLT].[CustomerAddress] AS CA
ON C.CustomerID = CA.CustomerID
LEFT JOIN  [SalesLT].[Address] AS A
ON CA.AddressID = A.AddressID
WHERE CA.AddressType = 'Main Office'

UNION ALL

SELECT 
C.CompanyName,
A.AddressLine1,
A.City,
'Shipping' AS AddressType
FROM [SalesLT].[Customer] AS C
LEFT JOIN [SalesLT].[CustomerAddress] AS CA
ON C.CustomerID = CA.CustomerID
LEFT JOIN  [SalesLT].[Address] AS A
ON CA.AddressID = A.AddressID
WHERE CA.AddressType != 'Main Office'

--- MUY BIEN!!!

/*
4. Filtering Customer Addresses (1)
You have created a master list of all customer addresses, but now you have been asked 
to create filtered lists that show which customers have only a main office address, 
and which customers have both a main office and a shipping address.

INSTRUCTIONS 100 XP
Write a query that returns the company name of each company that appears in a table of 
customers with a 'Main Office' address, but not in a table of customers with a 'Shipping' address.
*/

SELECT c.CompanyName
FROM SalesLT.Customer AS c
-- join the CustomerAddress table
JOIN [SalesLT].[CustomerAddress] AS ca
ON c.CustomerID = ca.CustomerID
JOIN [SalesLT].[Address] AS a
-- join based on AddressID
ON ca.AddressID = a.AddressID
WHERE ca.AddressType = 'Main Office'

EXCEPT

SELECT c.CompanyName
FROM SalesLT.Customer AS c
-- use the appropriate join to join the CustomerAddress table
JOIN SalesLT.CustomerAddress AS ca
-- join based on CustomerID
ON c.CustomerID = ca.CustomerID
-- use the appropriate join to join the Address table
JOIN SalesLT.Address AS a
ON ca.AddressID = a.AddressID
-- filter for the appropriate AddressType
WHERE ca.AddressType = 'Shipping'

ORDER BY c.CompanyName;
-- WELL DONE!!!!

/*
5. Filtering Customer Addresses (2)
This exercise builds upon your work in the previous exercise.

INSTRUCTIONS
100 XP
Write a query that returns the company name of each company that appears in a table of customers 
with a 'Main Office' address, and also in a table of customers with a 'Shipping' address. 
Make sure to use the aliases provided, and default column names elsewhere.
*/
SELECT c.CompanyName
FROM SalesLT.Customer AS c
-- join the CustomerAddress table
JOIN [SalesLT].[CustomerAddress] AS ca
ON c.CustomerID = ca.CustomerID
JOIN [SalesLT].[Address] AS a
-- join based on AddressID
ON ca.AddressID = a.AddressID
WHERE ca.AddressType = 'Main Office'

INTERSECT

SELECT c.CompanyName
FROM SalesLT.Customer AS c
-- use the appropriate join to join the CustomerAddress table
JOIN SalesLT.CustomerAddress AS ca
-- join based on CustomerID
ON c.CustomerID = ca.CustomerID
-- use the appropriate join to join the Address table
JOIN SalesLT.Address AS a
ON ca.AddressID = a.AddressID
-- filter for the appropriate AddressType
WHERE ca.AddressType = 'Shipping'

ORDER BY c.CompanyName;