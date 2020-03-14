-- Connect to AdventureWorks
USE AdventureWorks2014;

-- Show the full contents of the Employee table
SELECT *
FROM HumanResources.Employee;

-- Get Job Titles
SELECT HumanResources.Employee.JobTitle
FROM HumanResources.Employee;

-- Use a table alias
SELECT e.JobTitle
FROM HumanResources.Employee e;

-- Get Job Title and Birth Date
SELECT e.JobTitle, e.BirthDate
FROM HumanResources.Employee e;

-- Get unique Job Titles
SELECT DISTINCT e.JobTitle
FROM HumanResources.Employee e;

-- Use distinct on multiple columns
SELECT DISTINCT e.JobTitle, e.Gender
FROM HumanResources.Employee e;

-- How to clear results?

-- Employees sorted by age
SELECT e.BusinessEntityID, e.BirthDate
FROM HumanResources.Employee e
ORDER BY e.BirthDate;
-- ORDER BY default is ascending

SELECT e.BusinessEntityID, e.BirthDate
FROM HumanResources.Employee e
ORDER BY e.BirthDate ASC;

-- Reverse order
--SELECT e.BusinessEntityID, e.BirthDate
SELECT e.BirthDate, e.BusinessEntityID
FROM HumanResources.Employee e
ORDER BY e.BirthDate DESC;

-- Sort by multiple fields
SELECT e.JobTitle, e.Gender
FROM HumanResources.Employee e
ORDER BY e.Gender ASC, e.JobTitle DESC
;

-- Just the females!
SELECT e.JobTitle, e.Gender
FROM HumanResources.Employee e
WHERE e.Gender = 'F'
ORDER BY e.Gender ASC, e.JobTitle DESC
;

-- Employees with at least a week of vacation
SELECT e.BusinessEntityID, e.VacationHours
FROM HumanResources.Employee e
WHERE e.VacationHours >= 40
;

-- Order this so it makes sense
-- Who has the most?
SELECT e.BusinessEntityID, e.VacationHours
FROM HumanResources.Employee e
WHERE e.VacationHours >= 40
ORDER BY e.VacationHours DESC
;

-- Logical operators
-- Employees with a week of vacation
-- and a week of sick leave
SELECT e.BusinessEntityID, e.VacationHours, e.SickLeaveHours
FROM HumanResources.Employee e
WHERE e.VacationHours >= 40
AND e.SickLeaveHours >= 40
ORDER BY e.SickLeaveHours DESC, e.VacationHours DESC
;

-- Employees with a week of vacation
-- or a week of sick leave
SELECT e.BusinessEntityID, e.VacationHours, e.SickLeaveHours
FROM HumanResources.Employee e
WHERE e.VacationHours >= 40
OR e.SickLeaveHours >= 40
ORDER BY e.SickLeaveHours DESC, e.VacationHours DESC
;

-- We can use NOT
SELECT e.BusinessEntityID, e.SickLeaveHours, e.VacationHours
FROM HumanResources.Employee e
WHERE NOT e.SickLeaveHours >= 40
;

-- Add logical operators including NOT
-- We can use NOT
SELECT e.BusinessEntityID, e.SickLeaveHours, e.VacationHours
FROM HumanResources.Employee e
WHERE NOT e.SickLeaveHours >= 40
OR e.VacationHours >= 40
;

-- Oh the parentheses
-- We can use NOT
SELECT e.BusinessEntityID, e.SickLeaveHours, e.VacationHours
FROM HumanResources.Employee e
WHERE NOT (e.SickLeaveHours >= 40
OR e.VacationHours >= 40)
;

-- What about AND as an operator?
SELECT e.BusinessEntityID, e.SickLeaveHours, e.VacationHours
FROM HumanResources.Employee e
WHERE  e.SickLeaveHours < 40
AND e.VacationHours >= 40
;

-- NULL
-- People in the database?
SELECT *
from Person.Person p;
--19972

-- People without a middle name?
SELECT p.FirstName, p.MiddleName, p.LastName
FROM Person.Person p
WHERE p.MiddleName IS NULL
;
--8499

-- People with a middle name
SELECT p.FirstName, p.MiddleName, p.LastName
FROM Person.Person p
WHERE p.MiddleName IS NOT NULL
;
--11473

-- Math with SQL
SELECT 1+1;
SELECT 1+NULL;

-- NULL and OR
SELECT DISTINCT p.FirstName, p.MiddleName, P.LastName
FROM Person.Person p
WHERE p.FirstName = 'Kim'
OR p.MiddleName = 'B'
;

-- People named Kim
SELECT DISTINCT p.FirstName, p.MiddleName, P.LastName
FROM Person.Person p
WHERE p.FirstName = 'Kim'
;

-- Kim B?
SELECT DISTINCT p.FirstName, p.MiddleName, P.LastName
FROM Person.Person p
WHERE p.FirstName = 'Kim'
AND p.MiddleName = 'B'
;

-- Kims who are not Kim B?
SELECT DISTINCT p.FirstName, p.MiddleName, P.LastName
FROM Person.Person p
WHERE p.FirstName = 'Kim'
AND p.MiddleName != 'B'
;

-- We want to include the nulls!  How??
SELECT DISTINCT
   p.FirstName,
   p.MiddleName,
   P.LastName
FROM Person.Person p
WHERE p.FirstName = 'Kim'
AND (p.MiddleName != 'B' 
OR p.MiddleName is NULL)
;

-- Concatenation
SELECT p.FirstName + p.LastName
FROM Person.Person p;

-- Add a space?
-- Concatenation
SELECT p.FirstName + ' ' + p.LastName
/*
SELECT p.FirstName || ' ' || p.LastName
The || is the concatenation operator for Oracle
*/
FROM Person.Person p;

-- Adding a column name
SELECT p.FirstName + ' ' + p.LastName
AS FullName
FROM Person.Person p;