-- Module 5: Using Functions and Aggregating Data  
-- Introduction to Functions
-- Scalar Functions
-- 1 ROW INPUT (1 VALUE) > 1 ROW OUTPUT (1 VALUE)
-- THEY CAN BE USED AS AN EXPRESSION IN QUERIES (PREFERRABLY INDICATING AN ALIAS)
-- THERE ARE ENORMOUS AMOUNTS OF SCALAR FUNCTIONS IN SQL SERVER

-- Scalar Functions Demo
USE [AdventureWorksLT2012]
-- 1.
SELECT
YEAR(P.SellStartDate) AS SellStartYear,
P.ProductID,
P.Name AS ProductName
FROM [SalesLT].[Product] AS P
ORDER BY SellStartYear
-- (295 row(s) affected)

-- 2.
SELECT
YEAR(P.SellStartDate) AS SellStartYear,
DATENAME(MM,P.SellStartDate) AS SellStartMonth,
DAY(P.SellStartDate) AS SellStartDay,
DATENAME(DW,P.SellStartDate) AS SellStartWeekday,
P.ProductID,
P.Name AS ProductName
FROM [SalesLT].[Product] AS P
ORDER BY SellStartYear
/*
SellStartYear	SellStartMonth	SellStartDay	SellStartWeekday	ProductID	ProductName
1998			June			1				Monday				680			HL Road Frame - Black, 58
1998			June			1				Monday				706			HL Road Frame - Red, 58
2001			July			1				Sunday				707			Sport-100 Helmet, Red
2001			July			1				Sunday				708			Sport-100 Helmet, Black
*/

-- 3.
SELECT
DATEDIFF(YY, P.SellStartDate, GETDATE()) AS YearsSold,
P.ProductID,
P.Name AS ProductName
FROM [SalesLT].[Product] AS P
WHERE P.SellStartDate IS NOT NULL
ORDER BY P.ProductID
-- (295 row(s) affected)

SELECT YEAR(GETDATE()) AS PRESENT_YEAR
SELECT YEAR('1982-09-14')
SELECT DATEDIFF(YY,'1982-09-14',GETDATE()) AS MY_AGE
-- 36

-- UPPER CASE
-- USEFUL TO SOLVE PROBLEMS OF CASE SENSITIVITY
SELECT
UPPER(P.Name) AS ProductName
FROM [SalesLT].[Product] AS P
-- LOWERCASE
SELECT
LOWER(P.Name) AS ProductName
FROM [SalesLT].[Product] AS P

-- CONCATENATION
SELECT
C.CustomerID,
CONCAT(C.FirstName + ' ', C.LastName) AS FullName
FROM [SalesLT].[Customer] AS C
/*
CustomerID	FullName
1			Orlando Gee
2			Keith Harris
*/
-- GETTING THE FIRST TWO CHARACTERS FROM THE PRODUCT NUMBER CODE
-- LEFT() / RIGHT()
SELECT
P.Name AS ProductName,
P.ProductNumber,
LEFT(P.ProductNumber,2) AS ProductCategory
FROM [SalesLT].[Product] AS P
/*
ProductName					ProductNumber	ProductCategory
HL Road Frame - Black, 58	FR-R92B-58		FR
HL Road Frame - Red, 58		FR-R92R-58		FR
*/
-- CHARINDEX(), SUBSTRING(), LEN(), REVERSE()

-- CHARINDEX(Transact-SQL)
-- Search for "t" in string "Customer", and return position:
-- SELECT CHARINDEX('t', 'Customer') AS MatchPosition;

SELECT
CHARINDEX('-',P.ProductNumber,1) AS MatchPosition
FROM [SalesLT].[Product] AS P
/* MatchPosition
   3
   3*/ 

-- SUBSTRING(Transact-SQL)
-- Extract 3 characters from a string, starting in position 1:
-- SELECT SUBSTRING('SQL Tutorial', 1, 3) AS ExtractString;
SELECT
SUBSTRING(P.ProductNumber,1,2) AS ProductCategory
FROM [SalesLT].[Product] AS P
ORDER BY P.ProductID
/*	ProductCategory
	FR
	FR
	HL */

-- LEN(Transact-SQL)
-- Return the length of a string:
-- SELECT LEN('W3Schools.com')

SELECT
LEN(P.ProductNumber) AS ProductNumLength
FROM [SalesLT].[Product] AS P
ORDER BY P.ProductID
/*	ProductNumLength
	10
	10
	9   */

-- REVERSE(Transact-SQL)
-- Reverse a string:
-- SELECT REVERSE('SQL Tutorial');

SELECT
REVERSE(P.ProductNumber) AS Vesre
FROM [SalesLT].[Product] AS P
ORDER BY P.ProductID
/*	Vesre
	85-B29R-RF
	85-R29R-RF
	R-905U-LH   */

-- EXTRACT ProductType, ModelCode and SizeColor from the ProductNumber
SELECT
P.ProductNumber,
LEN(P.ProductNumber) AS Length
FROM [SalesLT].[Product] AS P
ORDER BY Length ASC
-- MINIMUM LENGTH IS 7, AND THERE'S ALWAYS ProductType-ModelCode
-- AND THE MAXIMUM IS 10, THERE ARE NO STRINGS OF LENGTH 8
-- So to get SizeColor column I will select the substring begining in the 9th character


SELECT
P.Name AS ProductName,
P.ProductNumber,
SUBSTRING(P.ProductNumber,1,2) AS ProductType,
SUBSTRING(P.ProductNumber,CHARINDEX('-',P.ProductNumber)+1,4) ModelCode,
SUBSTRING(P.ProductNumber,9,2) AS SizeColor
FROM [SalesLT].[Product] AS P
ORDER BY P.ProductID
/*	ProductName					ProductNumber	ProductType	ModelCode	SizeColor
	HL Road Frame - Black, 58	FR-R92B-58		FR			R92B		58
	HL Road Frame - Red, 58		FR-R92R-58		FR			R92R		58
	Sport-100 Helmet, Red		HL-U509-R		HL			U509		R     */
-- I've got exactly what I was asked for!!!

-- Logical Functions
-- OUTPUT IS DETERMINED BY COMPARATIVE LOGIC
-- ISNUMERIC(), IIF(), CHOOSE()

-- Demo using Logical Functions
-- ISNUMERIC()
-- Tests whether the expression is numeric:
-- SELECT ISNUMERIC(4567)

SELECT DISTINCT ISNUMERIC(P.Size) AS ISNUMERIC FROM [SalesLT].[Product] AS P
/*
ISNUMERIC
0
1 */

SELECT
P.Name AS ProductName,
P.Size AS NumericSize
FROM [SalesLT].[Product] AS P
WHERE ISNUMERIC(P.Size) = 1
-- (177 row(s) affected)

-- IIF(Transact-SQL)
-- IIF ( boolean_expression, true_value, false_value )
-- SIMILAR TO THE IF IN EXCEL

SELECT
P.Name AS ProductName,
IIF(P.ProductCategoryID IN (5,6,7),'Bicycle','Other') AS ProductCategory
FROM [SalesLT].[Product] AS P
ORDER BY P.ProductCategoryID 
/*	ProductName	ProductCategory
	Mountain-100 Silver, 38	Bicycle
	Mountain-100 Silver, 42	Bicycle */

-- IFF AND ISNUMERIC NESTED
-- SIZE TYPE
SELECT
P.Name AS ProductName,
IIF(ISNUMERIC(P.Size)=1,'Numeric','Non-Numeric') AS SizeType
FROM [SalesLT].[Product] AS P
/*	ProductName					SizeType
	HL Road Frame - Black, 58	Numeric
	HL Road Frame - Red, 58		Numeric
	Sport-100 Helmet, Red		Non-Numeric */

-- CHOOSE (Transact-SQL)
-- CHOOSE ( index, val_1, val_2 [, val_n ] )
-- index: Is an integer expression that represents a 1-based index into the list of the items following it.
SELECT
P.Name AS ProductName,
PC.Name AS Category,
PC.ParentProductCategoryID AS ProductTypeID,
CHOOSE(PC.ParentProductCategoryID,'Bikes','Components','Clothing','Accessories') AS ProductType
FROM [SalesLT].[Product] AS P
LEFT JOIN [SalesLT].[ProductCategory] AS PC
ON P.ProductCategoryID = PC.ProductCategoryID
ORDER BY PC.ParentProductCategoryID

-- Window Functions
-- they are applied to a set of rows

-- Demo using window functions
-- RANK(Transact-SQL)
-- RANK ( ) OVER ( [ partition_by_clause ] order_by_clause )

SELECT
P.ProductID,
P.Name AS ProductName,
P.ListPrice,
RANK() OVER(ORDER BY P.ListPrice DESC) AS RankByPrice
FROM [SalesLT].[Product] AS P
ORDER BY RankByPrice 

-- NOW WE ADD A PARTITION BY PRODUCT CATEGORY
SELECT
PC.Name AS Category,
P.ProductID,
P.Name AS ProductName,
P.ListPrice,
RANK() OVER(PARTITION BY PC.Name ORDER BY P.ListPrice DESC) AS RankByPrice
FROM [SalesLT].[Product] AS P
JOIN [SalesLT].[ProductCategory] AS PC
ON P.ProductCategoryID = PC.ProductCategoryID
ORDER BY Category, RankByPrice DESC

-- Aggregate Functions
-- FUNCTIONS THAT OPPERATE OVER SUBSETS OF ROWS
-- ALLOW FOR SUMMARIZING THE VALUES
-- WITHOUT GROUP BY all rows are arranged as one group

-- Aggregate functions Demo
SELECT 
COUNT(*) AS Records,
COUNT(P.ProductCategoryID) CategoriesWDuplicates,
COUNT(DISTINCT P.ProductCategoryID) Categories
FROM [SalesLT].[Product] AS P
/*	Records	CategoriesWDuplicates	Categories
	295		295						37        */
-- NULL VALUES ARE NOT COUNTED

SELECT
COUNT(*) AS TotalRows,
SUM(NULLS) AS CountingNulls
FROM (
SELECT
NULL AS NULLS, 
P.ProductCategoryID
FROM [SalesLT].[Product] AS P
) AS TABLE1
-- Operand data type NULL is invalid for count operator.
-- NULLS ARE NORMALLY IGNORED

/*
Key PointS

Scalar functions return a single value based on zero or more input parameters.

Logical functions return Boolean values (true or false) based on an expression or column value.

Window functions are used to rank rows across partitions or "windows". 
Window functions include RANK, DENSE_RANK, NTILE, and ROW_NUMBER.

Aggregate functions are used to provide summary values for mulitple rows - 
for example, the total cost of products or the maximum number of items in an order. 
Commonly used aggregate functions include SUM, COUNT, MIN, MAX, and AVG.
*/

-- Grouping Aggregated Data
-- using group by details are lost
-- anything not agregated in the select clause must be in the group by clause
-- when using group by variables must be either aggregated or in the select list and grouped by

-- GROUP BY DEMO
USE [AdventureWorksLT2012]
SELECT
c.SalesPerson,
ISNULL(SUM(oh.SubTotal),0.00) AS SalesRevenue
FROM [SalesLT].[Customer] AS c
LEFT JOIN [SalesLT].[SalesOrderHeader] AS oh
ON c.CustomerID = oh.CustomerID
GROUP BY c.SalesPerson
ORDER BY SalesRevenue DESC
-- Warning: Null value is eliminated by an aggregate or other SET operation.
-- (9 row(s) affected)

SELECT
c.SalesPerson,
CONCAT(c.FirstName + ' ', c.LastName) AS Customer,
ISNULL(SUM(oh.SubTotal),0.00) AS SalesRevenue
FROM [SalesLT].[Customer] AS c
LEFT JOIN [SalesLT].[SalesOrderHeader] AS oh
ON c.CustomerID = oh.CustomerID
GROUP BY c.SalesPerson, CONCAT(c.FirstName + ' ', c.LastName) 
ORDER BY SalesRevenue DESC, Customer DESC
-- Warning: Null value is eliminated by an aggregate or other SET operation.
-- (440 row(s) affected)

-- Filtering Groups
-- HAVING filters over the results of a group by
-- whereas WHERE occurs before the aggregation and grouping HAVING takes place after

-- HAVING demo
-- NOTICE THE COMMENTS TO THE RIGHT, THEY REFLECT THE ORDER IN WHICH DE DATABASE ENGINE
-- RUNS THE COMMANDS

SELECT									-- 3º
od.ProductID,
SUM(od.OrderQty) AS Quantity
FROM [SalesLT].[SalesOrderDetail] od	-- 1º
JOIN [SalesLT].[SalesOrderHeader] oh
ON od.SalesOrderID = oh.SalesOrderID
WHERE YEAR(oh.OrderDate) = 2004			-- 2º
GROUP BY od.ProductID					-- 4º
HAVING SUM(od.OrderQty) > 50			-- 5º
ORDER BY Quantity DESC					-- 6º
-- ORDER BY Quantity DESC

/*
Key Points
You can use GROUP BY with aggregate functions to return aggregations grouped by one or more columns or expressions.
All columns in the SELECT clause that are not aggregate function expressions must be included in a GROUP BY clause.
The order in which columns or expressions are listed in the GROUP BY clause determines the grouping hierarchy.
You can filter the groups that are included in the query results by specifying a HAVING clause.
*/