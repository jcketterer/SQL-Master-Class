-- Median calculation demo

-- Marketing want to understand the Counts, Max, Min, Mean Salaries for all members of age range 19 to 65 grouped by age 

select
	 age
	,count(MemberKey)       as MemberCount
	,max([annual_salary])	as MaxAnnualSalary
	,min([annual_salary])	as MinAnnualSalary
	,avg([annual_salary])	as MeanAnnualSalary
from 
	Member
where
	age between 19 and 65
group by
	age
order by 
	age 

-- Marketing called up and asked for MEDIAN salary to be added to the data set 
-- To answer this ,  we use the percentile_cont statement 

---
--- Def : Calculates a percentile based on a continuous distribution of the column value 
---

select								-- This will error as we did not issue a TOP(n) statement in the sub query
	 age
	,count(MemberKey)       as MemberCount
	,max([annual_salary])	as MaxAnnualSalary
	,min([annual_salary])	as MinAnnualSalary
	,avg([annual_salary])	as MeanAnnualSalary
	,(select PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY [annual_salary] DESC) OVER (PARTITION BY age) from Member mem1 where mem1.age = mem.age) as MedianSalary
from 
	Member mem
where
	age between 19 and 65
group by
	age
order by 
	age 

select								-- This will work as we selected the Top(1) row from the sub query 
	 age
	,count(MemberKey)       as MemberCount
	,max([annual_salary])	as MaxAnnualSalary
	,min([annual_salary])	as MinAnnualSalary
	,avg([annual_salary])	as MeanAnnualSalary
	,(select TOP(1) PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY [annual_salary] DESC) OVER (PARTITION BY age) from Member mem1 where mem1.age = mem.age) as MedianSalary
from 
	Member mem
where
	age between 19 and 65
group by
	age
order by 
	age 

-- Prove the median is correct

select 
	annual_salary
from	
	member
where 
	age = 19
order by 1


