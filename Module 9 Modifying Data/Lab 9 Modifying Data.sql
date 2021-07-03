-- Lab 9: Modifying Data
/*
Inserting Products (1)
Each AdventureWorks product is stored in the SalesLT.Product table, and each product has a unique ProductID identifier, 
which is implemented as an IDENTITY column in the SalesLT.Product table.

Products are organized into categories, which are defined in the SalesLT.ProductCategory table.

The products and product category records are related by a common ProductCategoryID identifier, 
which is an IDENTITY column in the SalesLT.ProductCategory table.

The new product to be inserted is shown in this table:

Instructions 100 XP
AdventureWorks has started selling the new product shown in the table above. Insert it into the SalesLT.Product table, 
using default or NULL values for unspecified columns.

Once you've inserted the product, run SELECT SCOPE_IDENTITY(); to get the last identity value that was inserted.
Add a query to view the row for the product in the SalesLT.Product table. */

USE [AdventureWorksLT2012]
SELECT * FROM SalesLT.Product

INSERT INTO SalesLT.Product (Name, ProductNumber, StandardCost, ListPrice, ProductCategoryID, SellStartDate)
VALUES
('LED Lights','LT-L123',2.56,12.99,37,GETDATE())
-- (1 row(s) affected)

SELECT SCOPE_IDENTITY()

SELECT * FROM SalesLT.Product
WHERE ProductID = SCOPE_IDENTITY();
-- score succesfully sent

/*
Inserting Products (2)
The code from the previous exercise to insert the product category is already included. 
This new category includes the following two new products.
Can you add these products?

Instructions 50 XP
Insert the two new products with the appropriate ProductCategoryID value, based on the product details above.
Finish the query to join the SalesLT.Product and SalesLT.ProductCategory tables. That way, you can verify that 
the data has been inserted. Make sure to use the aliases provided, and default column names elsewhere.
*/

SELECT TOP 2 * FROM SalesLT.Product
ORDER BY SalesLT.Product.ProductID DESC

SELECT c.Name AS Category, p.Name AS Product
FROM SalesLT.Product AS p JOIN SalesLT.ProductCategory AS c
ON p.ProductCategoryID = c.ProductCategoryID
WHERE c.ProductCategoryID = IDENT_CURRENT('SalesLT.ProductCategory')
 

-- Insert product category
INSERT INTO SalesLT.ProductCategory (ParentProductCategoryID, Name)
VALUES
(4, 'Bells and Horns');

-- Insert 2 products
INSERT INTO SalesLT.Product (Name, ProductNumber, StandardCost, ListPrice, ProductCategoryID, SellStartDate)
VALUES
('Bicycle Bell', 'BB-RING', 2.47, 4.99, IDENT_CURRENT('SalesLT.ProductCategory'), GETDATE()),
('Bicycle Horn', 'BB-PARP', 1.29, 3.75, IDENT_CURRENT('SalesLT.ProductCategory'), GETDATE());

-- Check if products are properly inserted
SELECT c.Name As Category, p.Name AS Product
FROM SalesLT.Product AS p
JOIN SalesLT.ProductCategory as c ON p.ProductCategoryID = c.ParentProductCategoryID
WHERE p.ProductCategoryID = IDENT_CURRENT('SalesLT.ProductCategory');
-- score succesfully sent

-- Update the SalesLT.Product table
UPDATE SalesLT.Product
SET ListPrice = ListPrice * 1.1
WHERE ProductCategoryID =
  (SELECT ProductCategoryID FROM SalesLT.ProductCategory WHERE Name = 'Bells and Horns');

SELECT * FROM SalesLT.Product AS p
WHERE p.ProductCategoryID = IDENT_CURRENT('SalesLT.ProductCategory');

-- score succesfully sent
-- score succesfully sent
-- score succesfully sent