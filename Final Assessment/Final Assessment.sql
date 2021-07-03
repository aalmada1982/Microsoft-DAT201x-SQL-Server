-- Final Assessment
-- Section 1
-- Final Assessment Exercises for Section 1 (External resource)  (11.0 points possible)

-- Question 1
-- Select the quantity per unit for all products in the Products table.
/*	Question 7
Use STR, CONVERT, and NVARCHAR(30) where appropriate to display the first name, employee ID and birthdate 
(as Unicode in ISO 8601 format) for each employee in the Employees table.
Each result should be a single string in the following format, where each <<value>> 
is replaced by the appropriately converted value:
<<FirstName>> has an EmployeeID of <<EmployeeID>> and was born <<BirthDate>> */
USE [AdventureWorks2012]
SELECT P.FirstName + ' has an EmployeeID of ' + STR(P.BusinessEntityID, LEN(P.BusinessEntityID)) + 
' and was born on ' + CONVERT(nvarchar(30),E.BirthDate, 126) AS String
FROM [Person].[Person] AS P 
JOIN [HumanResources].[Employee] AS E
ON P.BusinessEntityID = E.BusinessEntityID

SELECT ISNULL(ISNULL(P.FirstName, P.BusinessEntityID),E.BirthDate)
FROM [Person].[Person] AS P 
JOIN [HumanResources].[Employee] AS E
ON P.BusinessEntityID = E.BusinessEntityID

-- Question 9  
-- Instructions 100 XP
-- Select the ship name and ship postal code from the Orders table. If the postal code is missing, display 'unknown'.
USE [AdventureWorksLT2012]  
SELECT ProductNumber, ISNULL(CONVERT(NVARCHAR(MAX),[Weight]),'unknown'), [Weight] 
FROM [SalesLT].[Product]

SELECT SOH.OrderDate, DATENAME(MM,SOH.OrderDate) OrderMonth
FROM SalesLT.SalesOrderHeader AS SOH

SELECT 'Average Unit Price' as [Per Category],
ROUND([5],2) AS [5],
ROUND([6],2) AS [6],
ROUND([7],2) AS [7]
FROM
(SELECT ProductCategoryID ,
ListPrice AS ListPrice
FROM SalesLT.Product) AS NN
PIVOT (AVG(ListPrice) FOR ProductCategoryID
IN ([5],[6],[7])) AS APC

-- https://campus.datacamp.com/courses/querying-with-transact-sql-final-lab/16678?ex=8
-- Question 8
SELECT * FROM [dbo].[Region]

-- Declare a custom region
DECLARE @region nvarchar(25) = 'Space'

IF NOT EXISTS (SELECT * FROM [dbo].[Region] WHERE RegionDescription  = @region)
	BEGIN
		THROW 50001, 'Error!', 0
	END
ELSE
	BEGIN
		SELECT * FROM [dbo].[Region] WHERE RegionDescription  = @region
	END  