-- Lab 10: Programming with Transact-SQL
USE [AdventureWorksLT2012]
/*
Writing a Script to Insert an Order Header
You want to create reusable scripts that make it easy to insert sales orders. 
You plan to create a script to insert the order header record, and a separate 
script to insert order detail records for a specified order header.

Both scripts will make use of variables to make them easy to reuse. 
Your script to insert an order header must enable users to specify 
values for the order date, due date, and customer ID.

You are asked to include the following sales order:

Instructions (100 XP)
Fill in the variable names to complete the DECLARE statements. 
You can infer these names from the INSERT statement further down the script.
Finish the INSERT query. Because SalesOrderID is an IDENTITY column, this ID will automatically be generated for you. 
You can use the hardcoded value 'CARGO TRANSPORT 5' for the ShipMethod field.
Use SCOPE_IDENTITY() to print out the ID of the new sales order header.
*/

DECLARE @OrderDate datetime = GETDATE();
DECLARE @DueDate datetime = DATEADD(dd, 7, GETDATE());
DECLARE @CustomerID int = 1;

INSERT INTO SalesLT.SalesOrderHeader (OrderDate, DueDate, CustomerID, ShipMethod)
VALUES (@OrderDate, @DueDate, @CustomerID, 'CARGO TRANSPORT 5');

PRINT SCOPE_IDENTITY();

SELECT  OrderDate, DueDate, CustomerID, ShipMethod
FROM SalesLT.SalesOrderHeader
WHERE SalesOrderID = SCOPE_IDENTITY();
-- Score sent successfully

/*
Extend Script to Insert an Order Detail
As a next step, you want to insert an order detail. The script for this must enable users 
to specify a sales order ID, a product ID, a quantity, and a unit price.

The script should check if the specified sales order ID exists in the SalesLT.SalesOrderHeader 
table. This can be done with the EXISTS predicate.

If it does, the code should insert the order details into the SalesLT.SalesOrderDetail table 
(using default values or NULL for unspecified columns).

If the sales order ID does not exist in the SalesLT.SalesOrderHeader table, 
the code should print the message 'The order does not exist'.

Instructions (100 XP)
Slightly adapted code from the previous exercise is available; it defines the OrderID with SCOPE_IDENTITY().
Complete the IF-ELSE block:
The test should check to see if there is a SalesOrderDetail with a SalesOrderID that is equal to the OrderID 
exists in the SalesLT.SalesOrderHeader table.
Finish the statement to insert a record in the SalesOrderDetail table when this is the case.
Print out 'The order does not exist' when this is not the case.
*/
-- Code from previous exercise
DECLARE @OrderDate datetime = GETDATE();
DECLARE @DueDate datetime = DATEADD(dd, 7, GETDATE());
DECLARE @CustomerID int = 1;
INSERT INTO SalesLT.SalesOrderHeader (OrderDate, DueDate, CustomerID, ShipMethod)
VALUES (@OrderDate, @DueDate, @CustomerID, 'CARGO TRANSPORT 5');
DECLARE @OrderID int = SCOPE_IDENTITY();

-- Additional script to complete
DECLARE @ProductID int = 760;
DECLARE @Quantity int = 1;
DECLARE @UnitPrice money = 782.99;

IF EXISTS (SELECT * FROM SalesLT.SalesOrderDetail WHERE SalesOrderID = @OrderID)
BEGIN
	INSERT INTO SalesLT.SalesOrderDetail (SalesOrderID, OrderQty, ProductID, UnitPrice)
	VALUES (@OrderID, @Quantity, @ProductID, @UnitPrice)
END
ELSE
BEGIN
	PRINT 'The order does not exist'
END
-- Score successfully sent

-- Updating Bike Prices
SELECT DISTINCT ParentProductCategoryName FROM SalesLT.vGetAllCategories


DECLARE @MarketAverage money = 2000;
DECLARE @MarketMax money = 5000;
DECLARE @AWMax money;
DECLARE @AWAverage money;

SELECT @AWAverage = AVG(ListPrice), @AWMax = MAX(ListPrice)
FROM SalesLT.Product
WHERE ProductCategoryID IN
	(SELECT DISTINCT ProductCategoryID
	 FROM SalesLT.vGetAllCategories
	 WHERE ParentProductCategoryName = 'Bikes');

WHILE @AWAverage < @MarketAverage
BEGIN
   UPDATE SalesLT.Product
   SET ListPrice = ListPrice * 1.1
   WHERE ProductCategoryID IN
	(SELECT DISTINCT ProductCategoryID
	 FROM SalesLT.vGetAllCategories
	 WHERE ParentProductCategoryName = 'Bikes');

	SELECT @AWAverage = AVG(ListPrice), @AWMax = MAX(ListPrice)
	FROM SalesLT.Product
	WHERE ProductCategoryID IN
	(SELECT DISTINCT ProductCategoryID
	 FROM SalesLT.vGetAllCategories
	 WHERE ParentProductCategoryName = 'Bikes');

   IF @AWMax >= @MarketMax
      BREAK
   ELSE
      CONTINUE
END

PRINT 'New average bike price:' + CONVERT(VARCHAR, @AWAverage);
PRINT 'New maximum bike price:' + CONVERT(VARCHAR, @AWMax);