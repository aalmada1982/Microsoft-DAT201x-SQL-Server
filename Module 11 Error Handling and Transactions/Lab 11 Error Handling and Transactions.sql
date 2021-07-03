-- Lab 11: Error Handling and Transactions
-- Logging Errors
DECLARE @OrderID int = 0

-- Declare a custom error if the specified order doesn't exist
DECLARE @error VARCHAR(30) = 'Order #' + cast(@OrderID as VARCHAR) + ' does not exist';

IF NOT EXISTS (SELECT * FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @OrderID)
	BEGIN
		THROW 50001, @error, 0
	END
ELSE
	BEGIN
		DELETE FROM SalesLT.SalesOrderDetail WHERE SalesOrderID = @OrderID;
		DELETE FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @OrderID;
	END 
-- Score successfully sent

-- Logging Errors (2)
/*
Instructions (50 XP)
Add a TRY...CATCH to the code:
Include the IF-ELSE block in the TRY part.
In the CATCH part, print the error with ERROR_MESSAGE();
*/

GO
DECLARE @OrderID int = 71774
DECLARE @error VARCHAR(30) = 'Order #' + cast(@OrderID as VARCHAR) + ' does not exist';

-- Wrap IF ELSE in a TRY block
BEGIN TRY
  IF NOT EXISTS (SELECT * FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @OrderID)
	BEGIN
		THROW 50001, @error, 0
	END
  ELSE
	BEGIN
		DELETE FROM SalesLT.SalesOrderDetail WHERE SalesOrderID = @OrderID;
		DELETE FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @OrderID;
	END
END TRY
-- Add a CATCH block to print out the error
BEGIN CATCH
  PRINT ERROR_MESSAGE();
END CATCH
-- Score successfully sent

-- Ensuring Data Consistency
/* Instructions (100 XP)
Add BEGIN TRANSACTION and COMMIT TRANSACTION to treat the two DELETE statements as a single transactional unit of work.
In the error handler, modify the code so that if a transaction is in process, it is rolled back. 
If no transaction is in process the error handler should continue to simply print the error message.
*/
GO
DECLARE @OrderID int = 0
DECLARE @error VARCHAR(30) = 'Order #' + cast(@OrderID as VARCHAR) + ' does not exist';

BEGIN TRY
  IF NOT EXISTS (SELECT * FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @OrderID)
  BEGIN
    THROW 50001, @error, 0
  END
  ELSE
  BEGIN
    BEGIN TRANSACTION
    DELETE FROM SalesLT.SalesOrderDetail
    WHERE SalesOrderID = @OrderID;
    DELETE FROM SalesLT.SalesOrderHeader
    WHERE SalesOrderID = @OrderID;
    COMMIT TRANSACTION
  END
END TRY
BEGIN CATCH
  IF @@TRANCOUNT > 0
  BEGIN
    ROLLBACK TRANSACTION;
  END
  ELSE
  BEGIN
    PRINT ERROR_MESSAGE();
  END
END CATCH