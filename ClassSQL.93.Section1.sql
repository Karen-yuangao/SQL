use AdventureWorks2014;

SELECT *
FROM HumanResources.Employee;

--This is a comment
/*
tjhis is
my very verbose
and poorly spelled
multi-lined comment
*/
SELECT e.JobTitle
FROM HumanResources.Employee e;

SELECT HumanResources.Employee.JobTitle
FROM HumanResources.Employee;

--Multiple columns
SELECT e.JobTitle, e.BirthDate
FROM HumanResources.Employee e;

--Distinct job titles
SELECT DISTINCT
   e.JobTitle
FROM HumanResources.Employee e;

--Distinct: multiple columns
SELECT DISTINCT e.JobTitle, e.Gender
FROM HumanResources.Employee e;

SELECT e.JobTitle, e.BirthDate
FROM HumanResources.Employee e
ORDER BY e.BirthDate
;
-- Date, unix time?

SELECT e.JobTitle, e.BirthDate
FROM HumanResources.Employee e
ORDER BY e.BirthDate ASC
;

-- Descending order
SELECT e.JobTitle, e.BirthDate
FROM HumanResources.Employee e
ORDER BY e.BirthDate DESC
;

-- Two fields
SELECT e.JobTitle, e.Gender
--SELECT e.Gender, e.JobTitle
FROM HumanResources.Employee e
ORDER BY e.Gender, e.JobTitle
;

-- Different operators
SELECT e.JobTitle, e.Gender
FROM HumanResources.Employee e
ORDER BY e.Gender DESC, e.JobTitle ASC;

/*
* THE WHERE CLAUSE
*/
-- List of employees who have at least a week of vacation
SELECT e.BusinessEntityID, e.VacationHours
FROM HumanResources.Employee e
WHERE e.VacationHours >= 40
;

-- Order by vacation hours
SELECT e.BusinessEntityID, e.VacationHours
FROM HumanResources.Employee e
WHERE e.VacationHours >= 40
ORDER BY e.VacationHours DESC
;

-- A week of vacation, and a week of sick leave
SELECT
   e.BusinessEntityID,
   e.SickLeaveHours,
   e.VacationHours
FROM HumanResources.Employee e
WHERE e.SickLeaveHours >= 40
AND e.VacationHours >= 40
ORDER BY e.SickLeaveHours DESC, e.VacationHours DESC
;

-- Week of vacation OR week sick leave
SELECT
   e.BusinessEntityID,
   e.SickLeaveHours,
   e.VacationHours
FROM HumanResources.Employee e
WHERE e.SickLeaveHours >= 40
OR e.VacationHours >= 40
ORDER BY e.SickLeaveHours DESC, e.VacationHours DESC
;

-- NOT
SELECT e.BusinessEntityID, e.SickLeaveHours, e.VacationHours
FROM HumanResources.Employee e
WHERE NOT e.SickLeaveHours >=40
/*
Same as:
WHERE e.SickLeaveHours < 40
*/
;

--Compounding
SELECT e.BusinessEntityID, e.SickLeaveHours, e.VacationHours
FROM HumanResources.Employee e
WHERE NOT e.SickLeaveHours >=40
OR e.VacationHours >=40
;

-- The importance of parentheses
SELECT e.BusinessEntityID,
   e.SickLeaveHours,
   e.VacationHours
FROM HumanResources.Employee e
WHERE NOT (e.SickLeaveHours >=40
           OR e.VacationHours >=40);

-- vacation between 40 and 60
SELECT e.BusinessEntityID, e.SickLeaveHours, e.VacationHours
FROM HumanResources.Employee e
WHERE NOT e.SickLeaveHours >=40
OR (e.VacationHours >=40 AND
    e.VacationHours <= 60)
;

-- NULL vs Blank 
-- How many people in the database?
SELECT *
FROM Person.Person p
ORDER BY p.MiddleName;
-- 19972

-- How many have no middle name?
SELECT p.FirstName, p.MiddleName, p.LastName
FROM Person.Person p
WHERE p.MiddleName is NULL
;
--8499

-- Here are the rest
SELECT p.FirstName, p.MiddleName, p.LastName
FROM Person.Person p
WHERE p.MiddleName is NOT NULL
;
-- 11473

SELECT 1+1;
SELECT 1+0;
SELECT 1-NULL;

-- NULL in the predicate??
SELECT DISTINCT
  p.FirstName,
  p.MiddleName,
  p.LastName
FROM Person.Person p
WHERE (p.FirstName = 'Kim'
OR p.MiddleName = 'B')
;

-- List of people with FN Kim
SELECT DISTINCT
  p.FirstName,
  p.MiddleName,
  p.LastName
FROM Person.Person p
WHERE p.FirstName = 'Kim'
;

-- Just Kim B
SELECT DISTINCT
  p.FirstName,
  p.MiddleName,
  p.LastName
FROM Person.Person p
WHERE p.FirstName = 'Kim'
AND p.MiddleName = 'B'
;

-- What about Kim's without B?

SELECT DISTINCT
  p.FirstName,
  p.MiddleName,
  p.LastName
FROM Person.Person p
WHERE p.FirstName = 'Kim'
AND p.MiddleName != 'B'
;

-- How do we get the other 4 Kims?
SELECT DISTINCT
  p.FirstName,
  p.MiddleName,
  p.LastName
FROM Person.Person p
WHERE p.FirstName = 'Kim'
AND (p.MiddleName != 'B' OR
     p.MiddleName IS NULL)
;
