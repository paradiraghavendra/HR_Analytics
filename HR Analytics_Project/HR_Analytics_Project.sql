create database HRAnalytics;
use hranalytics;

select count(*) from `hr2 data`;
rename table `hr2 data` to hr2data;

select * from hr1data;

select * from hr2data;

 create view hrdata as
select * from hr1data h1
inner join hr2data h2
on h1.employeenumber = h2.employeeid;

select count(distinct employeenumber) from hr1data;

--  1. Average Attrition rate for all Departments
SELECT
	ROUND(
		100 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(DISTINCT EmployeeNumber),
2) as `Attrition Rate %`
FROM hr1data;

-- 2.Average Hourly rate of Male Research Scientist
SELECT
	ROUND(
		AVG(HourlyRate),
2) as `Avg Hourly Rate of Male Research Scientist`
FROM hr1data
WHERE Gender = 'Male' AND JobRole = 'Research Scientist';

-- 3.Attrition rate Vs Monthly income stats
SELECT 
    CASE
        WHEN MonthlyIncome < 10000 THEN 'Low Income (<10000)'
        WHEN MonthlyIncome < 20000 THEN 'Medium Income (<20000)'
        WHEN MonthlyIncome < 35000 THEN 'High Income (<35000)'
        ELSE 'Very High Income (>35000)'
    END AS Income_Group,

    CASE
        WHEN MonthlyIncome < 10000 THEN 1
        WHEN MonthlyIncome < 20000 THEN 2
        WHEN MonthlyIncome < 35000 THEN 3
        ELSE 4
    END AS SortIncomegroup,

    ROUND(
        100 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(distinct EmployeeNumber),
    2) AS Attrition_Rate
FROM hrdata
GROUP BY Income_Group, SortIncomegroup
ORDER BY SortIncomegroup;

 -- 4. Average working years for each Department
SELECT
	Department,
    ROUND(
		AVG(TotalWorkingYears),
	2) as `Avg Working Years`
FROM HRdata            -- Here we are using Created view - 'HRdata'
GROUP BY Department
ORDER BY `Avg Working Years` DESC;

-- 5. job role vs  work life balance
SELECT
	JobRole,
    ROUND(
		AVG(WorkLifeBalance),
	4) as `Avg Work Life Balance`
FROM HRdata
GROUP BY JobRole
ORDER BY `Avg Work Life Balance` DESC;

-- 6. Attrition rate VS year since last promotion relation
WITH PromotionYears AS (
	SELECT
		*,
		CASE
			WHEN YearsSinceLastPromotion < 2 THEN "0-2 Years"
			WHEN YearsSinceLastPromotion < 5 THEN "3-5 Years"
			WHEN YearsSinceLastPromotion < 10 THEN "6-10 Years"
			WHEN YearsSinceLastPromotion < 15 THEN "11-15 Years"
			WHEN YearsSinceLastPromotion < 20 THEN "16-20 Years"
			WHEN YearsSinceLastPromotion < 25 THEN "21-25 Years"
			WHEN YearsSinceLastPromotion < 30 THEN "26-30 Years"
			ELSE "30+ Years"
		END as "PromotionGroup",
		CASE
			WHEN YearsSinceLastPromotion < 2 THEN 1
			WHEN YearsSinceLastPromotion < 5 THEN 2
			WHEN YearsSinceLastPromotion < 10 THEN 3
			WHEN YearsSinceLastPromotion < 15 THEN 4
			WHEN YearsSinceLastPromotion < 20 THEN 5
			WHEN YearsSinceLastPromotion < 25 THEN 6
			WHEN YearsSinceLastPromotion < 30 THEN 7
			ELSE 8
		END as "SortPromotionGroup"
	FROM HRdata
)
SELECT
	PromotionGroup as `Promotion Years Group`,
    ROUND(100 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(DISTINCT EmployeeNumber), 2) as `Attrition Rate`
FROM PromotionYears
GROUP BY PromotionGroup, SortPromotionGroup
ORDER BY SortPromotionGroup ASC;

-- Extra Questions

-- 7. Find the average monthly income for each department
SELECT 
    h1.Department,
    ROUND(AVG(h2.MonthlyIncome), 2) AS Avg_Monthly_Income
FROM hr1data h1
JOIN hr2data h2
    ON h1.EmployeeNumber = h2.EmployeeID
GROUP BY h1.Department
ORDER BY Avg_Monthly_Income DESC;

-- 8. Find the average monthly income by job role
SELECT 
    h1.JobRole,
    ROUND(AVG(h2.MonthlyIncome), 2) AS Avg_Monthly_Income
FROM hr1data h1
JOIN hr2data h2
    ON h1.EmployeeNumber = h2.EmployeeID
GROUP BY h1.JobRole
ORDER BY Avg_Monthly_Income DESC;

-- 9.Find the department with the highest average monthly income
SELECT 
    h1.Department,
    ROUND(AVG(h2.MonthlyIncome), 2) AS Avg_Monthly_Income
FROM hr1data h1
JOIN hr2data h2
    ON h1.EmployeeNumber = h2.EmployeeID
GROUP BY h1.Department
ORDER BY Avg_Monthly_Income DESC
LIMIT 1;

-- 10. find the average age of employees who left the company
SELECT 
    ROUND(AVG(ï»¿Age), 2) AS Avg_Age
FROM hr1data
WHERE Attrition = 'Yes';
