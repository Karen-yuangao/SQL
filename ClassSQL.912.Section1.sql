use AdventureWorks2014;

-- How many employees have we ever had?
select count(*)
from HumanResources.Employee;

-- How many female employees do we have?
select count(*) as FemaleEmployees
from HumanResources.Employee
where Gender = 'F';

-- How many females do we have in Sales?
select count(*) as FemaleSalesEmployees
--select *  
from HumanResources.Employee e
inner join HumanResources.EmployeeDepartmentHistory h
on e.BusinessEntityID = h.BusinessEntityID
inner join HumanResources.Department d
on h.DepartmentID = d.DepartmentID
where d.Name = 'Sales'
and e.Gender = 'F';

-- How many job candidates have we had?
select count(jc.BusinessEntityID)
from HumanResources.JobCandidate jc
-- N.B. the above doesn't work because BEID is null if not hired, so...
select * from HumanResources.JobCandidate;
select count(*)
from HumanResources.JobCandidate jc;

-- How many different days were employees hired?
-- First, build a list
select distinct e.HireDate
from HumanResources.Employee e;

-- Turn it into a count...
select count (distinct e.HireDate) as DistinctHireDays
from HumanResources.Employee e;

-- Order matters - count by definition returns a single value,
-- thus distinct not needed
--select distinct count(e.HireDate) as AllEntries
select count(e.HireDate) as AllEntries
from HumanResources.Employee e;

-- SUM - fun with sum!
-- How many vacation hours do we have outstanding?
select sum(e.vacationhours) as TotalVacation
from HumanResources.Employee e;

-- More than once in the same query...
select sum(e.vacationhours) as TotalVacation,
       sum(e.SickLeaveHours) as TotalSickLeave
from HumanResources.Employee e;

-- Do math with results!
select sum(e.vacationhours) as TotalVacation,
       sum(e.SickLeaveHours) as TotalSickLeave,
	   sum(e.VacationHours) + sum(e.SickLeaveHours) as TotalTimeOff
from HumanResources.Employee e;

-- Order doesn't really matter that much here
select sum(e.vacationhours) as TotalVacation,
       sum(e.SickLeaveHours) as TotalSickLeave,
	   sum(e.VacationHours) + sum(e.SickLeaveHours) as TotalTimeOff,
	   sum(e.VacationHours + e.SickLeaveHours) as TotalTimeOff2,
	   TotalVacation + TotalSickLeave
from HumanResources.Employee e;
-- N.B. the above doesn't work b/c TotalVacation and TotalSickLeave haven't been
-- calculated yet, so the results can't be added together.

-- Min/max/avg
-- What is the birthdate of our youngest employee?
select max(e.birthdate) as youngestemployee
from HumanResources.Employee e
where e.CurrentFlag = 1
;

-- What about youngest and oldest?
select max(e.birthdate) as YoungestEmployee,
       min(e.birthdate) as OldestEmployee
from HumanResources.Employee e
where e.CurrentFlag = 1
;

-- Youngest in R&D?
select max(e.BirthDate) as YoungestRDEmp
from HumanResources.Employee e
inner join HumanResources.EmployeeDepartmentHistory dh
on e.BusinessEntityID = dh.BusinessEntityID
inner join HumanResources.Department d
on dh.DepartmentID = d.DepartmentID
where dh.EndDate is NULL
and d.GroupName = 'Research and Development'
and e.CurrentFlag = 1
;
select * from HumanResources.EmployeeDepartmentHistory;
select * from HumanResources.Department;
-- Can we avoid one of the joins?

-- Less verbose but requires more knowledge about the data structures and codes
select max(e.BirthDate) as YoungestRDEmp
from HumanResources.Employee e
inner join HumanResources.EmployeeDepartmentHistory dh
on e.BusinessEntityID = dh.BusinessEntityID
where dh.EndDate is NULL
and dh.DepartmentID in (1,2,6)
and e.CurrentFlag = 1
;

-- Hire date of our longest-term female employee?
select min(e.hiredate)
from HumanResources.Employee e
where e.CurrentFlag = 1
and e.Gender = 'F';

-- How long has that person been here?
select DATEDIFF(YY,
               min(e.hiredate),
			   getdate()) as YearsTenure
from HumanResources.Employee e
where e.CurrentFlag = 1
and e.Gender = 'F';

-- DATEDIFF compares years, and the date hasn't passed
-- yet...so...
select DATEDIFF(DD,
               min(e.hiredate),
			   getdate())/365.0 as YearsTenure
from HumanResources.Employee e
where e.CurrentFlag = 1
and e.Gender = 'F';
-- need the decimal after 365 to get a decimal
-- in the result set.

-- average tenure of employees
select avg(DATEDIFF(DD,
                     e.HireDate,
					getdate())/365.0) as AverageTenure
from HumanResources.Employee e
where e.CurrentFlag = 1;

-- Who's the youngest in R&D?
-- Less verbose but requires more knowledge about the data structures and codes
select p.FirstName, p.Lastname, e.BirthDate
from HumanResources.Employee e
inner join person.person p
on e.BusinessEntityID = p.BusinessEntityID
where e.BirthDate =
	(select max(e.BirthDate) as YoungestRDEmp
	from HumanResources.Employee e
	inner join HumanResources.EmployeeDepartmentHistory dh
	on e.BusinessEntityID = dh.BusinessEntityID
	where dh.EndDate is NULL
	and dh.DepartmentID in (1,2,6)
	and e.CurrentFlag = 1
	)
;

-- How many employees of each gender?
SELECT e.Gender, count(*) as Total
FROM HumanResources.Employee e
GROUP BY e.Gender
order by total desc;

SELECT e.Gender, e.MaritalStatus, count(*)
FROM HumanResources.Employee e
GROUP BY e.Gender, e.MaritalStatus

-- Let's make it more complicated!
-- How many employees did we hire each year?
select DATEPART(yy,
                e.HireDate) as Year,
	   count(*)
from HumanResources.Employee e
group by datepart(yy,e.HireDate) -- can't do Year here because it's part of the calculation
order by Year--datepart(yy,e.HireDate) Asc;

-- Hires by quarter for 2009, showing both quarter and year
select DATEPART(qq, e.HireDate) as Quarter,
       DATEPART(yy, e.HireDate) as Year,
	   count(*) as Hires
from HumanResources.Employee e
--where DATEPART(yy, e.HireDate) = '2009'
--group by DATEPART(yy, e.HireDate),datepart(qq,e.HireDate), -- Order matters because of subsetting
group by datepart(qq,e.HireDate), DATEPART(yy, e.HireDate) 
order by quarter Asc;

-- Do we consistently hire fewer people in Q2?
select DATEPART(qq, e.HireDate) as Quarter,
       DATEPART(yy, e.HireDate) as Year,
	   count(*) as Hires
from HumanResources.Employee e
group by datepart(qq,e.HireDate), DATEPART(yy, e.HireDate) 
order by quarter Asc;

-- In what quarters did we hire more than 50?
select DATEPART(qq, e.HireDate) as Quarter,
       DATEPART(yy, e.HireDate) as Year,
	   count(*) as Hires
from HumanResources.Employee e
where count(*) > 50 -- This doesn't work - what are we counting??
group by datepart(qq,e.HireDate), DATEPART(yy, e.HireDate) 
order by quarter Asc;

-- Enter the HAVING clause!
-- In what quarters did we hire more than 50?
select DATEPART(qq, e.HireDate) as Quarter,
       DATEPART(yy, e.HireDate) as Year,
	   count(*) as Hires
from HumanResources.Employee e
group by datepart(qq,e.HireDate), DATEPART(yy, e.HireDate) 
having count(*) > 50
order by quarter Asc;

-- gender of married employees using having
select e.Gender, e.MaritalStatus, count(*) as total
from HumanResources.Employee e
group by e.Gender, e.MaritalStatus
HAVING e.MaritalStatus = 'M';

select e.Gender, e.MaritalStatus, count(*) as total
from HumanResources.Employee e
WHERE e.MaritalStatus = 'M'
group by e.Gender, e.MaritalStatus;

-- Additional questions...
-- Youngest employee in the R&D group?
SELECT max(e.BirthDate) as YoungestRDEmp
FROM HumanResources.Employee e
INNER JOIN HumanResources.EmployeeDepartmentHistory dh
on e.BusinessEntityID = dh.BusinessEntityID
INNER JOIN HumanResources.Department d
on dh.DepartmentID = d.DepartmentID
WHERE dh.EndDate IS NULL
and d.GroupName = 'Research and Development'
and e.CurrentFlag = 1;
-- Can we simplify?
select * from HumanResources.EmployeeDepartmentHistory;
select * from HumanResources.Department;
select DepartmentID from HumanResources.Department
where GroupName = 'Research and Development';

SELECT max(e.BirthDate) as YoungestRDEmp
FROM HumanResources.Employee e
INNER JOIN HumanResources.EmployeeDepartmentHistory dh
on e.BusinessEntityID = dh.BusinessEntityID
WHERE dh.EndDate IS NULL
and dh.DepartmentID in (1,2,6) -- hard coded...dangerous
and e.CurrentFlag = 1;
-- Is there a function that returns odd/even?
-- One way is with a subselect and modulo operator, as follows:
select d.DepartmentID
from HumanResources.Department d
where d.DepartmentID % 2 = 0;

select d.DepartmentID
from HumanResources.Department d
where d.DepartmentID % 2 != 0;

SELECT max(e.BirthDate) as YoungestRDEmp
FROM HumanResources.Employee e
INNER JOIN HumanResources.EmployeeDepartmentHistory dh
on e.BusinessEntityID = dh.BusinessEntityID
WHERE dh.EndDate IS NULL
and dh.DepartmentID in (select DepartmentID
						from HumanResources.Department
					where GroupName = 'Research and Development')
and e.CurrentFlag = 1;

-- What if you want percentage as well as count??
select  e.Gender, e.MaritalStatus,
        count(*)*100/(select CAST(count(*) as NUMERIC) from HumanResources.Employee)
from HumanResources.Employee e
group by e.Gender, e.MaritalStatus;

-- From the homework, what if you want totals by role?
SELECT  COUNT(*) AS Total, 'Chiefs' as Role
FROM HumanResources.Employee e
WHERE (e.JobTitle LIKE '%chief%' 
AND e.JobTitle NOT LIKE '%assistant%')
UNION
SELECT COUNT(*) AS Total, 'Managers' as Role
FROM HumanResources.Employee e
WHERE (e.JobTitle LIKE '%manager%'
AND e.JobTitle NOT LIKE '%assistant%')
UNION
SELECT COUNT(*) AS Total, 'Supervisors' as Role
FROM HumanResources.Employee e
WHERE (e.JobTitle LIKE '%supervisor%'
AND e.JobTitle NOT LIKE '%assistant%')
UNION
SELECT COUNT(*) AS 'Vice Total', 'Vice Presidents' as Role
FROM HumanResources.Employee e
WHERE (e.JobTitle LIKE '%vice president%'
AND e.JobTitle NOT LIKE '%assistant%');

