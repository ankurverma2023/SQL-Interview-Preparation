CREATE DATABASE MASTERING_SQL
USE MASTERING_SQL

--1. What is SQL, and why is it important in data analytics?
--Answer: SQL (Structured Query Language) is a standard language for managing and manipulating relational,
-- databases. It allows you to query, update, and organize data, making it essential in data analytics for,
-- extracting meaningful insights.

--🎯 Mastering SQL for Interviews: Essential Guide for 0-5 Years of Experience 🚀
-- 💡 Are you preparing for a SQL interview? Whether you're a fresher or have up to 5 years of,
-- experience, SQL skills are essential for excelling in data-related roles. Here's a curated guide to help,
-- you ace SQL interview questions with confidence!

-- Table:1 Employees (Used for Salary and Join-related Queries)
Create Table Employees
(
ID INT PRIMARY KEY,
Name VARCHAR(50),
DepartmentID INT,
Salary DECIMAL(10,2)
)
INSERT INTO Employees VALUES(1,'Alice',1,70000),
(2,'Bob',2,80000),
(3,'Charlie',NULL,60000),
(4,'David',3,90000),
(5,'Eve',2,70000)

SELECT * FROM Employees

--Table:2 Departments (Used for Join-related Queries)
Create Table Departments
(
ID INT PRIMARY KEY,
DeptName VARCHAR(50)
)
INSERT INTO Departments Values(1,'HR'),
(2,'Finance'),
(3,'IT')

SELECT * FROM Departments

--Table:3 Sales (Used for Aggregate, Group By and Window Functions)
Create Table Sales
(
ID INT PRIMARY KEY,
Product VARCHAR(50),
SaleDate DATE,
Amount DECIMAL(10,2)
)
INSERT INTO Sales VALUES(1,'ProductA','2024-01-15',250),
(2,'ProductB','2024-01-16',350),
(3,'ProductC','2024-01-17',450),
(4,'ProductD','2024-02-01',550),
(5,'ProductE','2024-02-10',650)

SELECT * FROM Sales

--Table:4 Products (Used for Distinct and Filtering Exampples)
Create Table Products
(
ProductID INT PRIMARY KEY,
ProductName VARCHAR(50),
Category VARCHAR(50),
)
INSERT INTO Products VALUES(1,'ProductA','Electronics'),
(2,'ProductB','Electronics'),
(3,'ProductsC','Furniture'),
(4,'ProductsD','Furniture'),
(5,'ProductsE','Appliances')

SELECT * FROM Products

--Table:5 Logs (Used for Null Handling Examples)
Create Table Logs
(
LogID INT PRIMARY KEY,
EventDate DATE,
UserAction VARCHAR(50),
Value INT
)
INSERT INTO Logs VALUES(1,'2024-01-01','Login',NULL),
(2,'2024-01-02','Logout',5),
(3,'2024-01-03','Login',10),
(4,'2024-01-04','Purchase',NULL),
(5,'2024-01-05','Login',20)

SELECT * FROM Logs

--Basics SQL Queries

-- Explain the difference between INNER JOIN, LEFT JOIN, RIGHT JOIN, and FULL OUTER JOIN.

--INNER JOIN - Returns only matching rows.

SELECT Employees.Name, Departments.DeptName
FROM Employees
INNER JOIN Departments ON Employees.ID = Departments.ID

--LEFT JOIN - Returns all rows from the left table and matching rows from the right table.

SELECT Employees.Name, Departments.DeptName
FROM Employees
LEFT JOIN Departments ON Employees.ID = Departments.ID

--RIGHT JOIN - Returns all rows from the right table and matching rows from the left table.

SELECT Employees.Name, Departments.DeptName
FROM Employees
RIGHT JOIN Departments ON Employees.DepartmentID = Departments.ID

-- FULL OUTER JOIN - Returns all rows from both tables.

SELECT Employees.Name, Departments.DeptName
FROM Employees
FULL OUTER JOIN Departments ON Employees.DepartmentID = Departments.ID

-- What is the difference between WHERE and HAVING clauses?

-- WHERE filters rows before grouping (used with SELECT).

SELECT Product, SUM(Amount) AS TOTAL
FROM Sales
WHERE Amount > 250
GROUP BY Product

-- HAVING filters groups after grouping (used with GROUP BY).

SELECT Product, SUM(Amount) AS TOTAL
FROM Sales
GROUP BY Product
HAVING SUM(Amount) > 350

--How do you use GROUP BY and HAVING in a query?
-- GROUP BY is used to group rows, and HAVING applies conditions to these groups

SELECT Product, SUM(Amount) AS TOTAL
FROM Sales
GROUP BY Product
HAVING SUM(Amount) > 250

--Write a query to find duplicate records in a table.

SELECT Product, COUNT(*)
FROM Sales
GROUP BY Product
HAVING COUNT(*) > 1

--How do you retrieve unique values from a table using SQL?

SELECT DISTINCT Product
FROM Sales

--Explain the use of aggregate functions like COUNT(), SUM(), AVG(), MIN(), and MAX().

SELECT
    COUNT(*) AS TotalRows,
    SUM(Amount) AS TotalAmount,
    AVG(Amount) AS AvgAmount,
    MIN(Amount) AS MinAmount,
    MAX(Amount) AS MaxAmount
FROM Sales

-- What is the purpose of a DISTINCT keyword in SQL?
--DISTINCT eliminates duplicate values.

SELECT DISTINCT Product
FROM Sales
---------------------------------------------------------------------------------------------------------------------------
--Intermediate SQL Queries

--Write a query to find the second-highest salary from an employee table.

SELECT MAX(Salary) AS SecondHighest
FROM Employees
WHERE Salary < (SELECT MAX(Salary) FROM Employees)

-- What are subqueries and how do you use them?
--A subquery is a query nested within another query.

SELECT Name
FROM Employees
WHERE ID IN (SELECT ID FROM Departments WHERE DeptName = 'HR')

--  What is a Common Table Expression (CTE)? Give an example of when to use it.
-- CTE provides a temporary result set that can be referred to in the main query.

WITH SalesCTE AS (
SELECT Product, SUM(Amount) AS TOTAL
FROM Sales
GROUP BY Product
)
SELECT Product,Total
FROM SalesCTE
WHERE TOTAL > 250

-- Explain window functions like ROW_NUMBER(), RANK(), and DENSE_RANK().
-- Window functions perform calculations across a set of rows.

SELECT
Name, Salary,
ROW_NUMBER() OVER (ORDER BY Salary DESC) AS RowNumber,
RANK() OVER (ORDER BY Salary DESC) AS RANK,
DENSE_RANK() OVER (ORDER BY Salary DESC) AS DenseRank
FROM Employees

-- How do you combine results of two queries using UNION and UNION ALL?
--UNION: Removes duplicates.
--UNION ALL: Includes duplicates.

SELECT Name FROM Employees
UNION
SELECT DeptName FROM Departments

--What are indexes in SQL, and how do they improve query performance?
-- Indexes speed up data retrieval.

CREATE INDEX idx_Product ON Sales(Product)

--Write a query to calculate the total sales for each month using GROUP BY.

SELECT
MONTH(SaleDate) AS MONTH,
SUM(Amount) AS TotalSales
FROM Sales
GROUP BY MONTH(SaleDate)
-------------------------------------------------------------------------------------------------------------------------
--Advanced SQL Queries

-- What are views in SQL, and when would you use them?
-- Views are virtual tables.

CREATE VIEW SalesView AS
SELECT Product, SUM(Amount) AS TOTAL
FROM Sales
GROUP BY Product

-- What is the difference between a stored procedure and a function in SQL?
-- Stored Procedure: Performs tasks; may not return a value.
-- Function: Returns a single value.

CREATE FUNCTION GetTotalSales()
RETURNS INT
AS
BEGIN
    RETURN (SELECT SUM(Amount) FROM Sales)
END

-- What are windowing functions, and how are they used in analytics?
-- Used for running totals, rankings, etc.

SELECT
Product, Amount,
SUM(AMOUNT) OVER (PARTITION BY Product ORDER BY SaleDate) AS RunningTotal
FROM Sales

--How do you use PARTITION BY and ORDER BY in window functions?

SELECT
Name, Salary,
RANK() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) AS DeptRank 
FROM Employees

--  How do you handle NULL values in SQL, and what functions help with that (e.g., COALESCE, ISNULL)?
-- COALESCE: Returns the first non-NULL value.
-- ISNULL: Checks for NULL values.

SELECT COALESCE(Amount, 0) AS Amount
FROM Sales
