use AdventureWorks2014;

-- Intersection
SELECT e.JobTitle
FROM HumanResources.Employee e
where e.JobTitle like '%Sales%'
INTERSECT
SELECT e2.JobTitle
FROM HumanResources.Employee e2
where e2.JobTitle like 'Vice President%';


-- Union
SELECT e.JobTitle
FROM HumanResources.Employee e
where e.JobTitle like '%Sales%'
UNION 
SELECT e2.JobTitle
FROM HumanResources.Employee e2
where e2.JobTitle like 'Vice President%';

-- Difference
SELECT e.JobTitle
FROM HumanResources.Employee e
where e.JobTitle like '%Sales%'
EXCEPT
SELECT e2.JobTitle
FROM HumanResources.Employee e2
where e2.JobTitle like 'Vice President%';

-- UNION
SELECT e.JobTitle
FROM HumanResources.Employee e
where e.JobTitle like '%Sales%'
UNION
SELECT e2.Gender
FROM HumanResources.Employee e2
where e2.JobTitle like 'Vice President%';

-- Let's get Gender
SELECT e.JobTitle, e.Gender
FROM HumanResources.Employee e
where e.JobTitle like '%Sales%'
UNION
SELECT e2.Gender
FROM HumanResources.Employee e2
where e2.JobTitle like 'Vice President%';

-- Let's get Gender
SELECT e.JobTitle, e.Gender
FROM HumanResources.Employee e
where e.JobTitle like '%Sales%'
UNION
SELECT e2.JobTitle, e2.Gender
FROM HumanResources.Employee e2
where e2.JobTitle like 'Vice President%';

use SalesOrdersExample;
SELECT *
FROM Orders o
INNER JOIN Customers c
ON o.CustomerID = c.CustomerID;

use AdventureWorks2014;
-- Name and sick/vacation
SELECT p.FirstName,
       p.LastName,
	   e.SickLeaveHours,
	   e.VacationHours
FROM Person.Person p
INNER JOIN HumanResources.Employee e
ON p.BusinessEntityID = e.BusinessEntityID;

-- job title/hourly rate who earn < $20/hr
SELECT e.JobTitle, ep.Rate
FROM HumanResources.EmployeePayHistory ep
INNER JOIN HumanResources.Employee e
ON ep.BusinessEntityID = e.BusinessEntityID
WHERE  ep.Rate < 20
ORDER BY ep.Rate DESC;

-- Please refrain from doing this, even though it works.
select e.jobtitle, ep.rate
from HumanResources.Employee e, HumanResources.EmployeePayHistory ep
where e.BusinessEntityID = ep.BusinessEntityID;

--List of employees with same birth date
SELECT e.BusinessEntityID, e2.BusinessEntityID, e.BirthDate, e2.BirthDate
FROM HumanResources.Employee e
INNER JOIN
HumanResources.Employee e2
ON e.BirthDate = e2.BirthDate
-- Need to specify where clause...
WHERE e.BusinessEntityID <> e2.BusinessEntityID
;

-- Still have dupes!!!  How do we get rid of them??
SELECT e.BusinessEntityID, e2.BusinessEntityID, e.BirthDate, e2.BirthDate
FROM HumanResources.Employee e
INNER JOIN
HumanResources.Employee e2
ON e.BirthDate = e2.BirthDate
-- Need to specify where clause...
WHERE e.BusinessEntityID <> e2.BusinessEntityID
-- Get rid of the duplicates:
AND e.BusinessEntityID > e2.BusinessEntityID
;

-- Can this be simplified?
SELECT e.BusinessEntityID, e2.BusinessEntityID, e.BirthDate, e2.BirthDate
FROM HumanResources.Employee e
INNER JOIN
HumanResources.Employee e2
ON e.BirthDate = e2.BirthDate
-- Need to specify where clause...
WHERE e.BusinessEntityID > e2.BusinessEntityID
;

/*
** BEWARE: Danger ahead!
** CROSS JOIN
*/
-- Every possible pair of employees
SELECT e.BusinessEntityID, e2.BusinessEntityID
FROM HumanResources.Employee e
CROSS JOIN
HumanResources.Employee e2
;

/*
Show names, genders, and hashed passwords of all current employees
*/

SELECT pp.FirstName,
   pp.LastName,
   he.gender,
   ppw.PasswordHash
FROM HumanResources.employee he
INNER JOIN person.Person pp
   ON he.BusinessEntityID = pp.BusinessEntityID
INNER JOIN Person.[Password] ppw
   ON he.BusinessEntityID = ppw.BusinessEntityID
WHERE he.CurrentFlag = 1 -- need to make sure employees are current
;

/*
Show the names, titles, and department names
of all current employees in the R&D group.
*/

SELECT pp.FirstName,
	pp.LastName,
	pp.Title,
	d.GroupName,
	e2.JobTitle,
	pp.BusinessEntityID
FROM HumanResources.Department d
--WHERE d.GroupName = 'Research and Development'
INNER JOIN
HumanResources.EmployeeDepartmentHistory e
ON d.DepartmentID = e.DepartmentID
INNER JOIN
HumanResources.Employee e2
ON e2.BusinessEntityID = e.BusinessEntityID
INNER JOIN
Person.Person pp
ON e2.BusinessEntityID = pp.BusinessEntityID
WHERE d.GroupName = 'Research and Development'
--AND E2.CurrentFlag = 1
AND e.EndDate is NULL;

-- All job candidates
SELECT * 
FROM HumanResources.JobCandidate j
LEFT OUTER JOIN HumanResources.Employee e
on j.BusinessEntityID = e.BusinessEntityID;