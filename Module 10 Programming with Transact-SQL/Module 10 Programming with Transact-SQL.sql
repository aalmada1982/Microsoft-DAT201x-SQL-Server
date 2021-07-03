-- Module 10: Programming with Transact-SQL
-- Batches
-- Batches are sets of commands sent to SQL Server as a unit
-- Batches determine variable scope, name resolution
-- To separate statements into batches, use a separator:
--	SQL Server tools use the GO keyword
--	GO is not a T-SQL command!
--	GO [count] executes the batch the specified number of times

-- Comments
/* No comments */

-- Variables
-- Variables are objects that allow storage of a value for use later in thesame batch
-- Variables are defined with the DECLARE keyword
-- Variables can be declared and initialized in the same statement
-- Variables are always local to the batch in which they're declared and go out of scope when the batch ends

-- Demo: Using variables

-- Search by city using a variable
USE AdventureWorksLT2012
DECLARE @City VARCHAR(20) = 'Toronto'
SET @City = 'Bellevue'

SELECT
C.FirstName + ' ' + C.LastName AS Name,
A.AddressLine1 AS [Address],
A.City
FROM SalesLT.Customer AS C
JOIN SalesLT.CustomerAddress AS CA
ON C.CustomerID = CA.CustomerID
JOIN SalesLT.Address AS A
ON CA.AddressID = A.AddressID
WHERE A.City = @City

-- Use a variables as an output
DECLARE @Result money
SET @Result = 
(SELECT  MAX(SOH.TotalDue)
FROM SalesLT.SalesOrderHeader AS SOH)

PRINT @Result

-- Conditional Branching (IF... ELSE...)
-- IF…ELSE uses a predicate to determine the flow of the code
-- The code in the IF block is executed if the predicate evaluates to TRUE 
-- The code in the ELSE block is executed if the predicate evaluates to FALSE or UNKNOWN

-- Demo: Using conditional branching
-- Simple Logical Test
IF 'Yes' = 'No'
PRINT 'True'
-- Command(s) completed successfully.
-- It doesn´t do anything because there's no specified action in case the statement above is false
IF 'Yes' = 'Yes'
PRINT 'True'
-- True

-- Change code based on a condition
SELECT * FROM SalesLT.Product
WHERE ProductID = 680

UPDATE SalesLT.Product
SET DiscontinuedDate = GETDATE()
WHERE ProductID = 680;

IF @@ROWCOUNT < 1
	BEGIN
		PRINT 'Product was not found'
	END

ELSE
	BEGIN
		PRINT 'Product was updated'
	END
-- (1 row(s) affected)
-- Product was updated

-- Looping
-- the idea is apply the looping logic to sets, not in a row by row basis
-- WHILE enables code to execute in a loop
-- Statements in the WHILE block repeat as the predicate evaluates to TRUE
-- The loop ends when the predicate evaluates to FALSE or UNKNOWN
-- Execution can bealtered by BREAK or CONTINUE

-- Demo: using WHILE
CREATE TABLE SalesLT.DemoTable 
 ([Description] NVARCHAR(5))

DECLARE @Counter int = 1

WHILE @Counter < 6

BEGIN
	INSERT SalesLT.DemoTable([Description])
	VALUES ('Row ' + CONVERT(NVARCHAR(5),@Counter))
	SET @Counter = @Counter +1
END

SELECT [Description] FROM SalesLT.DemoTable

-- In practice, looping operations are not very common in Transact-SQL

-- Stored Procedures
-- Database objects that encapsulate Transact-SQL code
-- Can be parameterized
-- Input parameters
-- Output parameters
-- Executed with the EXECUTE command

-- Demo: Using store procedures

-- Create a store procedure
CREATE PROCEDURE SalesLT.GetProductsByCategorySP (@CategoryID INT = NULL)
AS
IF @CategoryID IS NULL
	SELECT P.ProductID, P.Name AS Product, P.Color, P.Size, P.ListPrice
	FROM SalesLT.Product AS P
ELSE 
	SELECT P.ProductID, P.Name AS Product, P.Color, P.Size, P.ListPrice
	FROM SalesLT.Product AS P
	WHERE P.ProductCategoryID = @CategoryID;
-- Command(s) completed successfully.

-- Execute the procedures without providing a parameter
EXEC SalesLT.GetProductsByCategorySP
-- (298 row(s) affected)

-- Execute the procedures providing a parameter
EXEC SalesLT.GetProductsByCategorySP 6
-- (43 row(s) affected)