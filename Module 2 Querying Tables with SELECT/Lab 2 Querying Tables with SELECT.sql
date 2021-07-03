-- Lab 2: Querying Tables with SELECT > Exercises
USE [AdventureWorksLT2012]
-- Lab 2.1
SELECT DISTINCT
A.City,
A.StateProvince
FROM [SalesLT].[Address] AS A

-- Lab 2.2.
SELECT TOP 10 PERCENT
A.Name
FROM [SalesLT].[Product] AS A
ORDER BY A.Weight DESC

/*
Tweak the last query to list the heaviest 100 products not including the ten most heavy ones.
*/
SELECT
A.Name
FROM [SalesLT].[Product] AS A
ORDER BY A.Weight DESC
OFFSET 10 ROWS FETCH NEXT 100 ROWS ONLY

-- Retrieving Product Data
-- Write a query to find the names, colors, and sizes of the products with a product model ID of 1.
SELECT A.Name, A.Color , A.Size
FROM SalesLT.Product AS A
WHERE A.ProductID = 1

SELECT * FROM SalesLT.Product

/*
-- select the ProductNumber, Name, and ListPrice columns
SELECT ProductNumber, Name, ListPrice
FROM SalesLT.Product
-- filter for ProductNumbers
WHERE ___ LIKE ___;

Modify your previous query to retrieve the product number, name, and list price of products with product number beginning with 'BK-' followed by any character other than 'R', and ending with a '-' followed by any two numerals.
Remember:
to match any string of zero or more characters, use %
to match characters that are not R, use [^R]
to match a numeral, use [0-9]
*/
