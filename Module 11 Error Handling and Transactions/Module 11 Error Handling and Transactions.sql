-- Module 11: Error Handling and Transactions
-- Errors and Transactions Overview
-- Errors and Error Messages
-- Demo: Raising Errors

-- View a system error
USE [AdventureWorksLT2012]
INSERT INTO SalesLT.SalesOrderDetail (SalesOrderID, OrderQty, ProductID, UnitPrice, UnitPriceDiscount)
VALUES (100000,1,680,1431.50,0.00)
/*
Msg 547, Level 16, State 0, Line 6
The INSERT statement conflicted with the FOREIGN KEY constraint "FK_SalesOrderDetail_SalesOrderHeader_SalesOrderID". 
The conflict occurred in database "AdventureWorksLT2012", table "SalesLT.SalesOrderHeader", column 'SalesOrderID'.
The statement has been terminated.
*/

/*
What if I try to do something that is
perfectly legitimate in terms of Transact-SQL, it isn't going to break any
constraints or change any data consistency,
but my business rules are such that I want to you know mark that as an error and then do
something about it?
*/
-- Raise an error with RAISERROR
UPDATE SalesLT.Product
SET DiscontinuedDate = GETDATE()
WHERE ProductID = 0;

IF @@ROWCOUNT < 1
	RAISERROR ('The product was not found - No products have been updated',16,0)

-- Raise an error with THROW
UPDATE SalesLT.Product
SET DiscontinuedDate = GETDATE()
WHERE ProductID = 0;

IF @@ROWCOUNT < 1
	THROW 50001, 'The product was not found - No products have been updated', 0;

-- Catching and Handling Errors
-- Demo: Catching and Handling Errors
-- Catch an error

BEGIN TRY
	UPDATE SalesLT.Product
	SET ProductNumber = ProductID / ISNULL([Weight],0);
END TRY

BEGIN CATCH
	PRINT 'The following error occurred: ';
	PRINT ERROR_MESSAGE();
END CATCH

-- Catch and rethrow
-- Same batch of code as before but now a trow statement is added at the end
BEGIN TRY
	UPDATE SalesLT.Product
	SET ProductNumber = ProductID / ISNULL([Weight],0);
END TRY

BEGIN CATCH
	PRINT 'The following error occurred: ';
	PRINT ERROR_MESSAGE();
	THROW; -- The THROW statement indicates SQL SERVER to rethrow the last caught error, so the client application can handled it
END CATCH
/*
It's more insidious than. There are two errors going on here, but
the first error has been handled by my code and the way it handled it was
to write a message.
And then the second time, once I read through the error
the SQL Server Management Studio caught the error and it handled it in the way that
it handles errors which happens to be to to write out the error message
but this time in red. And the client only saw that second one.
*/

-- Catch, log and throw a custom error
BEGIN TRY
	UPDATE SalesLT.Product
	SET ProductNumber = ProductID / ISNULL([Weight],0);
END TRY

BEGIN CATCH
	DECLARE @ErrorLogID INT, @ErrorMsg varchar(250);
	EXECUTE dbo.uspLogError @ErrorLogID OUTPUT;
	SET @ErrorMsg = 'The update failed because of an error. View error #'
					+ CAST(@ErrorLogID AS varchar)
					+ ' in the error log for details.';
	THROW 50001, @ErrorMsg, 0;
END CATCH;

-- View the error log
SELECT * FROM dbo.ErrorLog;

-- Transactions
-- A transaction is a group of tasks defining a unit of work
-- The entire unit must succeed or fail together —no partial completion is permitted
--Two tasks that make up a unit of work
-- INSERT INTO Sales.Order ...
-- INSERT INTO Sales.OrderDetail ...
-- Individual data modification statements are automatically treated as standalone transactions.

-- Demo: Implementing Transactions
-- No transacctions
BEGIN TRY
	INSERT INTO SalesLT.SalesOrderHeader (DueDate, SalesOrderID, ShipMethod)
	VALUES
	(DATEADD(DD,7,GETDATE()),1,'STD DELIVEY');

	DECLARE @SalesOrderID int SCOPE_IDENTITY();

	INSERT INTO SalesLT.SalesOrderDetail (SalesOrderID, OrderQty, ProductID, UnitPrice, UnitPriceDiscount)
	VALUES
	(@SalesOrderID, 1, 99999, 11431.50, 0.00)
END TRY

BEGIN CATCH

END CATCH

