-- Module 1: Introduction to Transact-SQL > The SELECT Statement
-- SELECT ALL COLUMNS
USE [AdventureWorks2012]
SELECT * FROM [Production].[Product]
/*
HERE 
SERVER: [AEA]
DATABASE: [AdventureWorks2012]
SCHEMA: [Production]
TABLE: [Product]
*/

-- SELECT SPECIFIC COLUMNS
SELECT A.Name, A.ListPrice
FROM [Production].[Product] AS A

-- SELECT EXPRESSIONS AND ALIASES
SELECT A.Name AS Product, A.ListPrice*0.9 AS SalePrice
FROM [Production].[Product] AS A

-- WHENEVER A SELECT STATEMENT IS EXECUTED THE RESULT IS A VIRTUAL TABLE, THAT IT'S NOT STORED ANYWHERE

-- Demo: Using SELECT
SELECT 'WOW' AS WHAT
/*
WHAT
WOW
*/
USE [AdventureWorksLT2012]
SELECT * FROM [SalesLT].[Product]
-- NOW ITS WORKING FINE!!!!

USE [AdventureWorksLT2012]
SELECT
A.ProductID,
A.Name,
A.ListPrice,
A.StandardCost,
A.ListPrice - A.StandardCost AS Margin
FROM [SalesLT].[Product] AS A

-- (295 row(s) affected)

USE [AdventureWorksLT2012]
SELECT
A.ProductID,
A.Name,
A.Color,
A.Size,
A.Color + A.Size AS Style -- CONCATENATION OCCURS
FROM [SalesLT].[Product] AS A

-- any sort of calculation involving NULL retrieves NULL

/* Module 1: Introduction to Transact-SQL   Working with Data Types
-- DATA TYPE CONVERSION
-- 1. IMPLICIT CONVERSIONS: OF COMPATBLE DATA TYPES
-- 2. EXPLICIT CONVERSIONS:
CAST / TRY_CAST 
CONVERT / TRY_CONVERT
PARSE / TRY_PARSE
STR

IT IS ADVISABLE NOT TO RELY ON IMPLICIT CONVERSION OF DATES
THE TRY VARIANTS PREVENT THE WHOLE STATEMENT TO FAIL IF DATA CONVERSION IS UNSUCCESSFUL
A NULL WILL BE SHOWN AS THE CONVERSION OUTPUT
*/
-- Demo: Working with Data Types
-- CAST
SELECT 
CAST(A.ProductID AS varchar(5)) + ': ' + A.Name AS ProductName
FROM [SalesLT].[Product] AS A
/*
879: All-Purpose Bike Stand
712: AWC Logo Cap
877: Bike Wash - Dissolver
*/

-- CONVERT
SELECT 
CONVERT(varchar(5), A.ProductID) + ': ' + A.Name AS ProductName
FROM [SalesLT].[Product] AS A
/*
ProductName
879: All-Purpose Bike Stand
712: AWC Logo Cap
*/

SELECT 
A.ProductID + ': ' + A.Name AS ProductName
FROM [SalesLT].[Product] AS A
-- Conversion failed when converting the varchar value ': ' to data type int.

-- THE ADVANTAGE OF CONVERT REALLY COMES WITH DATES

SELECT
A.SellStartDate,
CONVERT(nvarchar(30), A.SellStartDate) AS ConvertedDate,
CONVERT(nvarchar(30), A.SellStartDate, 126) AS ISO8601FormatDate 
FROM [SalesLT].[Product] AS A
/*
SellStartDate			ConvertedDate		ISO8601FormatDate
1998-06-01 00:00:00.000	Jun  1 1998 12:00AM	1998-06-01T00:00:00
1998-06-01 00:00:00.000	Jun  1 1998 12:00AM	1998-06-01T00:00:00
2001-07-01 00:00:00.000	Jul  1 2001 12:00AM	2001-07-01T00:00:00
2001-07-01 00:00:00.000	Jul  1 2001 12:00AM	2001-07-01T00:00:00
*/

-- TRY_CAST
SELECT
A.Name,
CAST(A.Size AS int) AS NumericSize
FROM [SalesLT].[Product] AS A
-- Conversion failed when converting the nvarchar value 'M' to data type int.
-- it couldn't convert size M as a number
-- But now, using TRY_CAST instead
SELECT
A.Name,
A.Size,
TRY_CAST(A.Size AS int) AS NumericSize
FROM [SalesLT].[Product] AS A
/*
Name						Size	NumericSize
HL Road Frame - Black, 58	58		58
HL Road Frame - Red, 58		58		58
Sport-100 Helmet, Red		NULL	NULL
Sport-100 Helmet, Black		NULL	NULL
Mountain Bike Socks, M		M		NULL
*/
/* Module 1: Introduction to Transact-SQL   Working with NULLs
NULL represents a missing or an unknown value
ANSI STANDARD: the result of any expression containing NULL should be NULL

NULL = NULL RETURNS FALSE (because it can be known)
NULL IS NULL returns TRUE
*/

-- FUNCTIONS TO HANDLE NULLS
-- FUNCTION "IS NULL": ISNULL(COLUMN/VARIABLE, VALUE) > RETURNS A SPECIFIED VALUE IF THE VARIABLE IS NULL
-- FUNCTION NULLIF: NULLIF(COLUMN/VARIABLE, VALUE) > RETURNS MULL IF THE COLUMN OR VARIABLE HAS THE SPECIFIED VALUE

-- COALESCE(COLUMN/VARIABLE 1, COLUMN/VARIABLE 2,...) RETURNS THE VALUE OF THE FIRST NON NULL VARIABLE IN THE LIST
-- STARTING IN NUMBER 1

-- Demo: Working with NULLs
-- NULL NUMBERS = 0
USE [AdventureWorksLT2012]
SELECT
A.Name,
ISNULL(TRY_CAST(A.Size AS int),0) AS NumericSize
FROM [SalesLT].[Product] AS A
/*
Name						NumericSize
HL Road Frame - Black, 58	58
HL Road Frame - Red, 58		58
Sport-100 Helmet, Red		0
Sport-100 Helmet, Black		0
*/

-- NULL STRINGS AS BLANK STRINGS
SELECT
A.ProductNumber,
ISNULL(A.Color,'') + ', ' + ISNULL(A.Size,'') AS ProductDetails
FROM [SalesLT].[Product] AS A
/*
ProductNumber	ProductDetails
FR-R92B-58		Black, 58
FR-R92R-58		Red, 58
HL-U509-R		Red, 
*/

-- MULTICOLOR = NULL
SELECT
A.Name,
NULLIF(A.Color, 'Multi') AS SingleColor
FROM [SalesLT].[Product] AS A

SELECT
A.Name,
A.Color
FROM [SalesLT].[Product] AS A
WHERE A.Color LIKE 'Multi' 
/*
Name						Color
AWC Logo Cap				Multi
Long-Sleeve Logo Jersey, S	Multi
*/
SELECT
A.Name,
NULLIF(A.Color, 'Multi') AS SingleColor
FROM [SalesLT].[Product] AS A
WHERE A.Color LIKE 'Multi' 
/*
Name						SingleColor
AWC Logo Cap				NULL
Long-Sleeve Logo Jersey, S	NULL
*/

SELECT
A.Name,
COALESCE(A.DiscontinuedDate, A.SellEndDate, A.SellStartDate) AS LastActivity
FROM [SalesLT].[Product] AS A
/*
Name						LastActivity
HL Road Frame - Black, 58	1998-06-01 00:00:00.000
HL Road Frame - Red, 58		1998-06-01 00:00:00.000
*/

-- Searched case
SELECT
A.Name,
	CASE
		WHEN A.SellEndDate IS NULL THEN 'On Sale'
		ELSE 'Discontinued'
	END AS SalesStatus
FROM [SalesLT].[Product] AS A
/*
Name					SalesStatus
Sport-100 Helmet, Red	On Sale
Sport-100 Helmet, Black	On Sale
Mountain Bike Socks, M	Discontinued
Mountain Bike Socks, L	Discontinued
*/

-- ANOTHER VARIANT OF THE CASE STATEMENT
SELECT
A.Name,
	CASE A.Size
		WHEN 'S' THEN 'Small' 
		WHEN 'M' THEN 'Medium'
		WHEN 'L' THEN 'Large'
		WHEN 'XL' THEN 'Extra-Large'
		ELSE ISnULL(A.Size, 'n/a')
	END AS ProductSize
FROM [SalesLT].[Product] AS A
/*
Name						ProductSize
HL Road Frame - Black, 58	58
HL Road Frame - Red, 58		58
Sport-100 Helmet, Red		n/a
Sport-100 Helmet, Black		n/a
*/
