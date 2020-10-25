-- Max() function demo

select
	*
from
	[dbo].[Member]


-- The product manager needs to know max salary for the members

select
	max([annual_salary])
from
	[dbo].[Member]


-- Marketing want to understand the Counts, Max, Min, Mean Salaries for all members of age range 19 to 65 grouped by age 


select
	 age
	,count([MemberKey])		as CountMember
	,max([annual_salary])	as MaxSalary
	,min([annual_salary])	as MinSalary
	,avg([annual_salary])	as MeanSalary
from
	[dbo].[Member]
group by
	age
order by
	age