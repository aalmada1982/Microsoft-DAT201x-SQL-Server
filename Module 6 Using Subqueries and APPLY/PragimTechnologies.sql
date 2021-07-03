-- https://www.youtube.com/watch?v=JtmfAGM4pfc
-- Subqueries in sql Part 59
USE [PragimTech]
Create Table tblProducts
(
 [Id] int identity primary key,
 [Name] nvarchar(50),
 [Description] nvarchar(250)
)

Create Table tblProductSales
(
 Id int primary key identity,
 ProductId int foreign key references tblProducts(Id),
 UnitPrice int,
 QuantitySold int
)

Insert into tblProducts values ('TV', '52 inch black color LCD TV')
Insert into tblProducts values ('Laptop', 'Very thin black color acer laptop')
Insert into tblProducts values ('Desktop', 'HP high performance desktop')

Insert into tblProductSales values(3, 450, 5)
Insert into tblProductSales values(2, 250, 7)
Insert into tblProductSales values(3, 450, 4)
Insert into tblProductSales values(3, 450, 9)

SELECT * FROM [dbo].[tblProducts]
SELECT * FROM [dbo].[tblProductSales]

--- Retrieve information about the products that haven't been sold

-- NOT CORRELATED SUBQUERY
SELECT 
* 
FROM [dbo].[tblProducts] AS P
WHERE P.Id NOT IN (
SELECT DISTINCT
PS.ProductId
FROM [dbo].[tblProductSales] AS PS)
-- This type of subquery can be replaced by joins
-- in this case an inner join
SELECT 
P.*
FROM [dbo].[tblProducts] AS P
LEFT OUTER JOIN [dbo].[tblProductSales] AS PS
ON P.Id = PS.ProductId
WHERE PS.ProductId IS NULL
/*	Id	Name	Description
	1	TV		52 inch black color LCD TV */
-- WE GOT THE VERY SAME RESULT!!!
-- Now retrieve name of the products and the quantity that was sold
-- using a subquery
-- NOW THE SUBQUERY WILL BE IN THE SELECT STATEMENT
SELECT 
P.*,
(SELECT SUM(PS.QuantitySold) FROM [dbo].[tblProductSales] AS PS
WHERE PS.ProductId = P.Id) AS QtySold
FROM [dbo].[tblProducts] AS P
ORDER BY QtySold DESC
-- NOW THIS IS A CORRELATED SUBQUERY
-- NOTICE THAT SQL STARTS IN [dbo].[tblProducts] ROW 1 AND GOES ALL THE WAY DOWN
/*
Id	Name	Description							QtySold
3	Desktop	HP high performance desktop			18
2	Laptop	Very thin black color acer laptop	7
1	TV		52 inch black color LCD TV			NULL  */

-- NOW REPLACE THIS CORRELATED SUBQUERY USING A JOIN
SELECT 
P.Name as Product,
SUM(PS.QuantitySold) AS QtySold
FROM [dbo].[tblProducts] AS P
LEFT JOIN [dbo].[tblProductSales] AS PS
ON P.Id = PS.ProductId
GROUP BY P.Name
ORDER BY QtySold DESC
/*
Product	QtySold
Desktop	18
Laptop	7
TV		NULL */
-- WHICH IS BASICALLY THE SAME RESULT
-- IN GENERAL SUBQUERIES CAN BE REPLACED WITH JOINS

-- https://www.youtube.com/watch?v=Ra3ISwvcFlM&index=60&list=PL08903FB7ACA1C2FB
-- Correlated subquery in sql Part 60
-- In a non correlated subquery the inner subquery can be executed independently
-- In a correlated subquery both queries cannot be executed without inputs from the other

-- Retrive names of products sold and the total quantity sold
SELECT
P.*,
(SELECT SUM(PS.QuantitySold) FROM [dbo].[tblProductSales] AS PS 
WHERE PS.ProductId = P.Id) AS QtySold
FROM [dbo].[tblProducts] AS P
ORDER BY QtySold DESC

-- https://www.youtube.com/watch?v=kVogo0AbatM
-- Cross apply and outer apply in sql server
-- SQL Script to create the tables and populate with test data
Create table Department
(
    Id int primary key,
    DepartmentName nvarchar(50)
)
Go

Insert into Department values (1, 'IT')
Insert into Department values (2, 'HR')
Insert into Department values (3, 'Payroll')
Insert into Department values (4, 'Administration')
Insert into Department values (5, 'Sales')
Go

Create table Employee
(
    Id int primary key,
    Name nvarchar(50),
    Gender nvarchar(10),
    Salary int,
    DepartmentId int foreign key references Department(Id)
)
Go

Insert into Employee values (1, 'Mark', 'Male', 50000, 1)
Insert into Employee values (2, 'Mary', 'Female', 60000, 3)
Insert into Employee values (3, 'Steve', 'Male', 45000, 2)
Insert into Employee values (4, 'John', 'Male', 56000, 1)
Insert into Employee values (5, 'Sara', 'Female', 39000, 2)
Go

SELECT * FROM [dbo].[Department]
SELECT * FROM [dbo].[Employee]

-- FIRST A VERY SIMPLE JOIN QUERY
SELECT 
D.DepartmentName,
E.Name,
E.Gender,
E.Salary
FROM [dbo].[Department] AS D
INNER JOIN [dbo].[Employee] AS E
ON D.Id = E.DepartmentId
ORDER BY E.Salary DESC

SELECT 
D.DepartmentName,
E.Name,
E.Gender,
E.Salary
FROM [dbo].[Department] AS D
LEFT JOIN [dbo].[Employee] AS E
ON D.Id = E.DepartmentId
ORDER BY E.Salary DESC

Create function fn_GetEmployeesByDepartmentId(@DepartmentId int)
Returns Table
as
Return
(
 Select Id, Name, Gender, Salary, DepartmentId 
 from Employee where DepartmentId = @DepartmentId
)
Go
-- Command(s) completed successfully.
SELECT * FROM fn_GetEmployeesByDepartmentId(1)

-- This table valued function cannot be combined with other tables through joins
-- if we try to do it will get an error
SELECT 
D.DepartmentName,
E.Name,
E.Gender,
E.Salary
FROM [dbo].[Department] AS D
INNER JOIN fn_GetEmployeesByDepartmentId(D.Id) AS E
ON D.Id = E.DepartmentId
ORDER BY E.Salary DESC
-- we try to run the query and we get the error
-- The multi-part identifier "D.Id" could not be bound.

-- but now the CROSS APPLY operator will hopefully render better results!
-- CROSS APPLY OPERATOR WILL SEMANTICALLY BEHAVE LIKE AN INNER JOIN
-- WHEREAS AN OUTER APPLY OPERATOR WILL BEHAVE AS A LEFT JOIN
SELECT 
D.DepartmentName,
E.Name,
E.Gender,
E.Salary
FROM [dbo].[Department] AS D
CROSS APPLY fn_GetEmployeesByDepartmentId(D.Id) AS E -- the table valued function gets passed every row from the D table, one by one
-- ON D.Id = E.DepartmentId -- The ON clause is not needed
ORDER BY E.Salary DESC
/* we got the expected results
DepartmentName	Name	Gender	Salary
Payroll			Mary	Female	60000
IT				John	Male	56000
IT				Mark	Male	50000
HR				Steve	Male	45000
HR				Sara	Female	39000 */

-- AND USING OUTER APPLY 
SELECT 
D.DepartmentName,
E.Name,
E.Gender,
E.Salary
FROM [dbo].[Department] AS D
OUTER APPLY fn_GetEmployeesByDepartmentId(D.Id) AS E -- the table valued function gets passed every row from the D table, one by one
-- ON D.Id = E.DepartmentId -- The ON clause is not needed
ORDER BY E.Salary DESC
/*	DepartmentName	Name	Gender	Salary
	Payroll			Mary	Female	60000
	IT				John	Male	56000
	IT				Mark	Male	50000
	HR				Steve	Male	45000
	HR				Sara	Female	39000
	Administration	NULL	NULL	NULL
	Sales			NULL	NULL	NULL */
-- THE APPLY OPERATOR WAS INTRODUCED IN SQL SERVER 2005
-- THE TABLE VALUED FUNCTION TO THE RIGHT OF THE APPLY OPERATOR GETS CALLED FOR EACH AND EVERY ROW FROM THE LEFT TABLE
