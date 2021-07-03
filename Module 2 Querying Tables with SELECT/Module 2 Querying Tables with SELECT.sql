-- Module 2: Querying Tables with SELECT > Removing Duplicates

-- SELECT (ALL) (SELECT default behavior includes duplicates)
USE [AdventureWorksLT2012]
SELECT ALL A.Color
FROM [SalesLT].[Product] AS A
-- (295 row(s) affected)
SELECT A.Color
FROM [SalesLT].[Product] AS A
-- (295 row(s) affected)
SELECT DISTINCT A.Color
FROM [SalesLT].[Product] AS A
-- (10 row(s) affected)
-- DISTINTC IS DEFINED AT A ROW, NOT PARTICULAR COLUMN LEVEL

-- Module 2: Querying Tables with SELECT > Sorting Results
-- IT IS ALWAYS ADVISED TO EXPLICITLY SORT THE RESULTS OF A QUERY
-- ORDER BY SORTS THE RESULTS BY ONE OR MORE COLUMNS
-- Aliases created in SELECT are visible in the order by clause
-- Columns that are not selected can be used to order the results
-- ORDER BY order DESC ASC (ASC is default)

-- LIMIING SORTED RESULTS: TOP FUNCTION
-- TOP MUST BE ALWAYS USED IN TANDEM WITH ORDER BY, OTHERWISE IT WILL NOT BE CLEAR WHAT FIRST RESULTS WE'LL BE SENDING
-- SELECT TOP n WITH TIES RETRIEVES DUPLICATES (IF THERE ARE ANY)
-- PAGING THROUGH RESULTS: OFFSET - FETCH ALLOWS FILTERING SELECTED NUMBER OF ROWS

-- Demo: Eliminating Duplicates and Sorting Results

SELECT DISTINCT
ISNULL(A.Color,'None') AS Color
FROM [SalesLT].[Product] AS A
ORDER BY Color
-- (10 row(s) affected)

SELECT DISTINCT
ISNULL(A.Color,'None') AS Color,
ISNULL(A.Size,'-') AS Size
FROM [SalesLT].[Product] AS A
ORDER BY Color ASC, Size ASC
-- (68 row(s) affected)

-- DISPLAY THE TOP 100 PRODUCTS BY LIST PRICE
SELECT TOP 100
A.Name,
A.ListPrice
FROM [SalesLT].[Product] AS A
ORDER BY A.ListPrice DESC
-- (100 row(s) affected)

-- PAGING: WE DISPLAY THE FIRST TEN PRODUCTS USING "OFFSET - FETCH NEXT"
SELECT
A.Name,
A.ListPrice
FROM [SalesLT].[Product] AS A
ORDER BY A.ListPrice DESC
OFFSET 0 ROWS FETCH NEXT 10 ROW ONLY
-- A TOP can not be used in the same query or sub-query as a OFFSET.
-- OFFSET 0 ROWS = TOP
-- (10 row(s) affected)

-- AND WE THEN DISPLAY THE NEXT 10 PRODUCTS
SELECT
A.Name,
A.ListPrice
FROM [SalesLT].[Product] AS A
ORDER BY A.ListPrice DESC
OFFSET 10 ROWS FETCH NEXT 10 ROW ONLY

-- Module 2: Querying Tables with SELECT >  Filtering and Using Predicates
-- SPECIFY PREDICATES IN THE WHERE CLAUSE
SELECT
A.Name,
A.ListPrice,
A.Color
FROM [SalesLT].[Product] AS A
WHERE A.Color = 'Red'
-- (38 row(s) affected)

-- NULLS WILL NOT OCCUR IN EITHER THE "IN" OR THE "NOT IN" LIST, BECAUSE THEY ARE UNKNOWN

-- Demo: Filtering and Using Predicates

-- 1. list Information about Product Model 6
SELECT A.Name, A.Color, A.Size
FROM [SalesLT].[Product] AS A
WHERE A.ProductModelID = 6
-- (11 row(s) affected)

-- 2. List information about products that have product number begining in FR
SELECT 
A.ProductNumber, 
A.Name, 
A.ListPrice
FROM [SalesLT].[Product] AS A
WHERE A.ProductNumber LIKE 'FR%'

-- 3. Filtering the previous query to ensure that the product number contains two sets of two digits
SELECT 
A.ProductNumber, 
A.Name, 
A.ListPrice
FROM [SalesLT].[Product] AS A
WHERE A.ProductNumber LIKE 'FR-_[0-9][0-9]_-[0-9][0-9]'
-- (79 row(s) affected)

-- 4. Find products that have no sell end date
SELECT 
A.Name
FROM [SalesLT].[Product] AS A
WHERE A.SellEndDate IS NULL
-- (197 row(s) affected)

-- 5. Find products that have sell end date in 2003 (range search)
SELECT 
A.SellEndDate
FROM [SalesLT].[Product] AS A
WHERE A.SellEndDate BETWEEN '2003/1/1' AND '2003/12/31'
-- (69 row(s) affected)

-- 6. Find products that have a category ID like 5, 6 or 7
SELECT 
A.ProductCategoryID,
A.Name,
A.ListPrice
FROM [SalesLT].[Product] AS A
WHERE A.ProductCategoryID IN (5,6,7)
-- (97 row(s) affected)

-- 7. Find products that have a category ID like 5, 6 or 7 AND have a sell end date
SELECT 
A.ProductCategoryID,
A.Name,
A.ListPrice
FROM [SalesLT].[Product] AS A
WHERE A.ProductCategoryID IN (5,6,7)
AND A.SellEndDate IS NOT NULL
-- (37 row(s) affected)

-- 7. Find products that have a category ID like 5, 6 or 7 OR that have product number that begins with FR
SELECT 
A.ProductCategoryID,
A.Name,
A.ProductNumber
FROM [SalesLT].[Product] AS A
WHERE A.ProductCategoryID IN (5,6,7)
OR A.ProductNumber LIKE 'fr%'
-- (176 row(s) affected)