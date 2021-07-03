-- Module 9: Modifying Data
-- Inserting Data into Tables
/*
Inserts explicit values
You can omit identity columns, columns that allow NULL, and columns with default constraints.
You can also explicitly specify NULL and DEFAULT

INSERT…SELECT / INSERT…EXEC
Inserts the results returned by the query or stored procedure into an existing table

SELECT…INTO
Creates a new table from the results of a query

Generating Identifiers
Using Identity Columns
*/
-- Demo: Inserting Data
-- Create table for the demo
USE [AdventureWorksLT2012]
CREATE TABLE SalesLT.CallLog
(
	CallID INT IDENTITY PRIMARY KEY NOT NULL,
	CallTime DATETIME NOT NULL DEFAULT GETDATE(),
	SalesPerson NVARCHAR(256) NOT NULL,
	CustomerID INT NOT NULL REFERENCES SalesLT.Customer(CustomerID),
	PhoneNumber NVARCHAR(25) NOT NULL,
	Notes NVARCHAR(MAX) NULL
);
GO
-- Command(s) completed successfully.

-- Insert a row
INSERT INTO SalesLT.CallLog
VALUES
('2015-01-01T12:30:00','adventure-works\pamela0',1,'245-555-0173','Returning Call Re: enquiry about new bike models')
-- (1 row(s) affected)
SELECT * FROM SalesLT.CallLog

-- Insert defaults and nulls
INSERT INTO SalesLT.CallLog
VALUES
(DEFAULT,'adventure-works\david8',1,'170-555-0127',NULL)

-- Insert a row with explicit columns
INSERT INTO SalesLT.CallLog (SalesPerson, CustomerID, PhoneNumber)
VALUES
('adventure-works\jillian0',3,'279-555-0130');

-- Insert multiple rows
INSERT INTO SalesLT.CallLog
VALUES
(DATEADD(mi,2,GETDATE()),'adventure-works\jillian0',4,'710-555-0173',NULL),
(DEFAULT,'adventure-works\shu0',5,'828-555-0186','Calles to arrange delivery of order 10987');

SELECT * FROM SalesLT.CallLog

-- Insert results of a query
INSERT INTO SalesLT.CallLog (SalesPerson, CustomerID, PhoneNumber, Notes)
SELECT SalesPerson, CustomerID, Phone, 'Sales Promotion Call'
FROM SalesLT.Customer
WHERE CompanyName = 'Big-Time Bike Store'
-- (2 row(s) affected)

-- Retrieving inserted identity
INSERT INTO SalesLT.CallLog (SalesPerson, CustomerID, PhoneNumber)
VALUES
('adventure-works\josé1',10,'150-555-0127');

SELECT SCOPE_IDENTITY();

-- Overriding Identity
SET IDENTITY_INSERT SalesLT.CallLog ON;

INSERT INTO SalesLT.CallLog (CallID, SalesPerson, CustomerID, PhoneNumber)
VALUES
(9,'adventure-works\josé1',11,'926-555-0159');

SET IDENTITY_INSERT SalesLT.CallLog OFF;

SELECT * FROM SalesLT.CallLog;

-- Updating and Deleting Data
/*
The UPDATE Statement
Updates all rows in a table or view
Set can be filtered with a WHERE clause
Set can be defined with a FROM clause
Only columns specified in the SET clause are modified

The MERGE Statement ("UPSERT": update and insert)

Deleting Data From a Table
DELETE without a WHERE clause deletes all rows
Use a WHERE clause to delete specific rows
*/
-- Demo: Updating and Deleting Data
-- Update a table
UPDATE SalesLT.CallLog
SET Notes = 'No notes'
WHERE Notes IS NULL
-- (5 row(s) affected)
SELECT * FROM SalesLT.CallLog

-- Update multiple columns
-- not a good example was presented

UPDATE SalesLT.CallLog 
SET SalesPerson = C.SalesPerson, PhoneNumber = C.Phone
FROM SalesLT.Customer AS C
WHERE C.CustomerID = SalesLT.CallLog.CustomerID
-- (9 row(s) affected)

SELECT * FROM SalesLT.CallLog

-- Delete rows
DELETE FROM SalesLT.CallLog
WHERE CallTime < DATEADD(dd,-7,GETDATE());
-- (1 row(s) affected)
SELECT * FROM SalesLT.CallLog