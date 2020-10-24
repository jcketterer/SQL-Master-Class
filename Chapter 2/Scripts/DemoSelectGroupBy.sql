-- Income vs Education level by gender

select
	*
from
	[dbo].[Customer]

-- fields interested in

select
	 [YearlyIncome]
	,[EducationLevel]
	,[Gender]
from
	[dbo].[Customer]

-- Aggregation - AVG income

select
	 avg([YearlyIncome]) as [YearlyIncome]
	,[EducationLevel]
	,[Gender]
from
	[dbo].[Customer]
group by
	 [EducationLevel]
	,[Gender]	
having
	[EducationLevel]='Graduate Degree'
order by [YearlyIncome] desc

-- Calc AVG over the group

select
	 avg([YearlyIncome]) as [YearlyIncome]
	,[EducationLevel]
	,[Gender]
from
	[dbo].[Customer]
group by rollup ([EducationLevel],[Gender])	
