-- Lab 5: Using Functions and Aggregating Data
/*	1. Retrieving Product Information
	Your reports are returning the correct records, but you would like to modify how these records are displayed.
	INSTRUCTIONS
	50 XP
	Write a query to return the product ID of each product, together with the product name formatted as upper case 
	and a column named ApproxWeight with the weight of each product rounded to the nearest whole unit. 
	Make sure to use the aliases provided, and default column names elsewhere. */
-- select ProductID and use the appropriate functions with the appropriate columns
SELECT , ___(___) AS ProductName, ___(___, 0) AS ApproxWeight
FROM SalesLT.Product;

SELECT
P.ProductID,
UPPER(P.Name) AS ProductName,
ROUND(P.Weight,0) AS ApproxWeight
FROM [SalesLT].[Product] AS P
-- (295 row(s) affected)

/*	2. Retrieving Product Information (2)
	It would be useful to know when AdventureWorks started selling each product.

	INSTRUCTIONS 50 XP
	Extend your query to include columns named SellStartYear and SellStartMonth containing the year and month 
	in which AdventureWorks started selling each product. The month should be displayed as the month name (e.g. 'January'). 
	Make sure to use the aliases provided, and default column names elsewhere. */
SELECT
P.ProductID,
UPPER(P.Name) AS ProductName,
ROUND(P.Weight,0) AS ApproxWeight,
P.SellStartDate,
YEAR(P.SellStartDate) AS SellStartYear,
DATENAME(MM,P.SellStartDate) AS SellStartMonth
FROM [SalesLT].[Product] AS P

/* 3. Retrieving Product Information (3)
	It would also be useful to know the type of each product.

	INSTRUCTIONS 50 XP
	Extend your query to include a column named ProductType that contains the leftmost two characters 
	from the product number. Make sure to use the aliases provided, and default column names elsewhere. */
SELECT
P.ProductID,
UPPER(P.Name) AS ProductName,
ROUND(P.Weight,0) AS ApproxWeight,
P.SellStartDate,
YEAR(P.SellStartDate) AS SellStartYear,
DATENAME(MM,P.SellStartDate) AS SellStartMonth,
LEFT(P.ProductNumber,2) AS ProductType
FROM [SalesLT].[Product] AS P

/*	4. Retrieving Product Information (4)
	Categorical data can be less useful in certain cases. Here, you only want to look at numeric product size data.

	INSTRUCTIONS 50 XP
	Extend your query to filter the product returned so that only products with a numeric size are included. 
	Make sure to use the aliases provided, and default column names elsewhere. */

SELECT
P.Size,
ISNUMERIC(P.Size)
FROM [SalesLT].[Product] AS P
WHERE ISNUMERIC(P.Size) = 1

SELECT
P.ProductID,
UPPER(P.Name) AS ProductName,
ROUND(P.Weight,0) AS ApproxWeight,
P.SellStartDate,
YEAR(P.SellStartDate) AS SellStartYear,
DATENAME(MM,P.SellStartDate) AS SellStartMonth,
LEFT(P.ProductNumber,2) AS ProductType
FROM [SalesLT].[Product] AS P
WHERE ISNUMERIC(P.Size) = 1

/*	5. Ranking Customers By Revenue
	The sales manager would like a list of customers ranked by sales.

	INSTRUCTIONS 100 XP
	Write a query that returns a list of company names with a ranking of their place in a list of highest TotalDue values 
	from the SalesOrderHeader table. Make sure to use the aliases provided, and default column names elsewhere. */
SELECT
c.CompanyName,
soh.TotalDue AS Revenue,
RANK() OVER (ORDER BY soh.TotalDue DESC) AS RankByRevenue
FROM [SalesLT].[SalesOrderHeader] AS soh
RIGHT JOIN [SalesLT].[Customer] AS c
ON soh.CustomerID = c.CustomerID

-- select CompanyName and TotalDue columns
SELECT C.CompanyName, SOH.TotalDue AS Revenue,
       -- get ranking and order by appropriate column
       RANK() OVER (ORDER BY Revenue DESC) AS RankByRevenue
FROM SalesLT.SalesOrderHeader AS SOH
-- use appropriate join on appropriate table
LEFT JOIN SalesLT.Customer AS C
ON SOH.CustomerID = C.CustomerID;

/*	6. Aggregating Product Sales
	The product manager would like aggregated information about product sales.
	INSTRUCTIONS 50 XP
	Write a query to retrieve a list of the product names and the total revenue calculated as the sum of the 
	LineTotal from the SalesLT.SalesOrderDetail table, with the results sorted in descending order of total revenue. 
	Make sure to use the aliases provided, and default column names elsewhere. 
-- select the Name column and use the appropriate function with the appropriate column
SELECT P. , ___ AS TotalRevenue
FROM SalesLT.SalesOrderDetail AS SOD
-- use the appropriate join
 SalesLT.Product AS P
-- join based on ProductID
ON ___ = ___
GROUP BY P.Name
ORDER BY ___ DESC; */

SELECT
P.Name,
SUM(SOD.LineTotal) AS TotalRevenue
FROM [SalesLT].[Product] AS P
RIGHT JOIN [SalesLT].[SalesOrderDetail] AS SOD
ON P.ProductID = SOD.ProductID
GROUP BY P.Name
ORDER BY TotalRevenue DESC

/*	7. Aggregating Product Sales (2)
	The product manager would like aggregated information about product sales.

	INSTRUCTIONS 50 XP
	Modify the previous query to include sales totals for products that have a list price of more than 1000. 
	Make sure to use the aliases provided, and default column names elsewhere. */

SELECT
P.Name,
SUM(SOD.LineTotal) AS TotalRevenue
FROM [SalesLT].[Product] AS P
RIGHT JOIN [SalesLT].[SalesOrderDetail] AS SOD
ON P.ProductID = SOD.ProductID
WHERE P.ListPrice > 1000
GROUP BY P.Name
ORDER BY TotalRevenue DESC

-- 8.
SELECT Name, SUM(LineTotal) AS TotalRevenue
FROM SalesLT.SalesOrderDetail AS SOD
JOIN SalesLT.Product AS P
ON SOD.ProductID = P.ProductID
WHERE P.ListPrice > 1000
GROUP BY P.Name
-- add having clause as per instructions
HAVING SUM(LineTotal) > 20000
ORDER BY TotalRevenue DESC;