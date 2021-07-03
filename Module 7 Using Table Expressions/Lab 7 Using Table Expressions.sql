-- Lab 7: Using Table Expressions
/*
1. Retrieving Product Information
AdventureWorks sells many products that are variants of the same product model. You must write queries that retrieve information 
about these products.

INSTRUCTIONS 50 XP
Retrieve the product ID, product name, product model name, and product model summary for each product from the SalesLT.Product table 
and the SalesLT.vProductModelCatalogDescription view. Make sure to use the aliases provided, and default column names elsewhere. */

SELECT
P.ProductID,
P.Name AS ProductName,
PC.Name AS ProductModel,
PC.Summary
FROM [SalesLT].[Product] AS P
INNER JOIN [SalesLT].[vProductModelCatalogDescription] AS PC
ON P.ProductModelID = PC.ProductModelID

/*
2. Retrieving Product Information (2)
You are only interested in products which have a listed color in the database. */
DECLARE @Colors AS TABLE (Color nvarchar(15))

INSERT INTO @Colors
SELECT DISTINCT
P.Color 
FROM [SalesLT].[Product] AS P

SELECT P.ProductID, P.Name, P.Color 
FROM [SalesLT].[Product] AS P
WHERE P.Color IN (SELECT Color FROM @Colors)

/*
3. Retrieving Product Information (3)
The AdventureWorksLT database includes a table-valued function named dbo.ufnGetAllCategories, 
which returns a table of product categories (e.g. 'Road Bikes') and parent categories (for example 'Bikes').


*/

SELECT C.ParentProductCategoryName AS ParentCategory,
       C.ProductCategoryName AS Category,
       P.ProductID, P.Name AS ProductName
FROM SalesLT.Product AS P
JOIN [dbo].[ufnGetAllCategories]() AS C
ON P.ProductCategoryID = C.ProductCategoryID
ORDER BY ParentCategory, Category, ProductName;

SELECT * FROM [dbo].[ufnGetAllCategories]()

/*
4. Retrieving Customer Sales Revenue
Each AdventureWorks customer is a retail company with a named contact. 
You must create queries that return the total revenue for each customer, including the company and customer contact names.

INSTRUCTIONS 100 XP
Retrieve a list of customers in the format Company (Contact Name) together with the total revenue for each customer. 
Use a derived table or a common table expression to retrieve the details for each sales order, 
and then query the derived table or CTE to aggregate and group the data. Make sure to use the aliases provided, 
and default column names elsewhere. */

SELECT CompanyContact, SUM(SalesAmount) AS Revenue
FROM
	(SELECT CONCAT(c.CompanyName, CONCAT(' (' + c.FirstName + ' ', c.LastName + ')')), SOH.TotalDue
	 FROM SalesLT.SalesOrderHeader AS SOH
	 JOIN SalesLT.Customer AS c
	 ON SOH.CustomerID = c.CustomerID) AS CustomerSales(CompanyContact, SalesAmount)
GROUP BY CompanyContact
ORDER BY CompanyContact;
