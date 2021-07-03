-- Module 8: Grouping Sets and Pivoting Data
-- Overview of Grouping Sets and Pivoting Data
-- Grouping Sets
-- GROUPING SETS subclause builds on GROUP BY clause
-- Allows multiple groupings to be defined in same query
-- ROLLUP provides shortcut for defining grouping sets with combinations that assume input columns form a hierarchy
-- CUBE provides shortcut for defining grouping sets in which all possible combinations of grouping sets created
-- Identifying Groupings in Results
-- Multiple grouping sets present a problem in identifying the source of each row in the result set
-- NULLs could come from the source data or could be a placeholder in the grouping set
-- The GROUPING_ID function provides a method to mark a row with a 1 or 0 to identify which grouping set for the row

-- Demo: Grouping Sets
SELECT 
C.ParentProductCategoryName,
C.ProductCategoryName,
COUNT(P.ProductCategoryID) AS Products
FROM SalesLT.vGetAllCategories AS C
JOIN SalesLT.Product AS P
ON C.ProductCategoryID = P.ProductCategoryID
-- GROUP BY C.ParentProductCategoryName, C.ProductCategoryName
---GROUP BY GROUPING SETS (C.ParentProductCategoryName, C.ProductCategoryName, ())
-- GROUP BY ROLLUP (C.ParentProductCategoryName, C.ProductCategoryName)
GROUP BY CUBE (C.ParentProductCategoryName, C.ProductCategoryName)
ORDER BY C.ParentProductCategoryName, C.ProductCategoryName

-- Pivoting Data
-- Pivoting data is rotating data from a rows-based orientation to a columns-based orientation
-- Distinct values from a single column are projected across as headings for other columns—may include aggregation

-- Unpivoting Data
-- Unpivoting data is rotating data from a columns-based orientation to a rows-based orientation
-- Some details present in the original data might be lost

-- Demo: Pivoting Data
SELECT * FROM (
SELECT
P.ProductID,
PC.Name,
ISNULL(P.Color,'Uncolored') AS Color
FROM SalesLT.ProductCategory AS PC
JOIN SalesLT.Product AS P
ON PC.ProductCategoryID = P.ProductCategoryID 
) AS PPC
PIVOT( COUNT(ProductID) FOR Color IN(
[Uncolored],[Black],[Blue],[Grey],[Multi],[Red],
[Silver],[Silver/Black],[White],[Yellow])) AS PVT
ORDER BY Name 

-- Creating a table based on th pivot just sketched
CREATE TABLE #ProductColorPivot
(Name varchar(50), [Uncolored] int, [Black] int, [Blue] int, [Grey] int, [Multi] int, [Red] int, 
[Silver] int, [Silver/Black] int, [White] int, [Yellow] int)
INSERT INTO #ProductColorPivot
SELECT * FROM (
SELECT
P.ProductID,
PC.Name,
ISNULL(P.Color,'Uncolored') AS Color
FROM SalesLT.ProductCategory AS PC
JOIN SalesLT.Product AS P
ON PC.ProductCategoryID = P.ProductCategoryID 
) AS PPC
PIVOT( COUNT(ProductID) FOR Color IN(
[Uncolored],[Black],[Blue],[Grey],[Multi],[Red],
[Silver],[Silver/Black],[White],[Yellow])) AS PVT
ORDER BY Name 
-- (37 row(s) affected)
SELECT * FROM #ProductColorPivot

-- Unpivoting data
SELECT Name, Color, ProductCount FROM
(SELECT * FROM #ProductColorPivot) AS PCP
UNPIVOT
(ProductCount FOR Color IN(
[Uncolored],[Black],[Blue],[Grey],[Multi],[Red],
[Silver],[Silver/Black],[White],[Yellow]))
AS ProductsCount