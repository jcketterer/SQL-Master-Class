--- Search based on a simple equality condition

select 
	*
from
	[dbo].[Customer]
where 
	[Gender] = 'F'

--- Search based on the LIKE condition

select 
	*
from
	[dbo].[Customer]
where 
	Occupation like '%Prof%'

--- Search based on a comparison operator

select 
	*
from
	[dbo].[Customer]
where 
	TotalChildren >= 4	

--- Search meeting any of 3 conditions

select 
	*
from
	[dbo].[Customer]
where 
	TotalChildren >= 4 or
	[YearlyIncome] <= 60000 or
	HouseOwnerFlag = '1'

--- Search must meet 3 conditions

select 
	*
from
	[dbo].[Customer]
where 
	TotalChildren >= 4 and
	[YearlyIncome] <= 60000 and
	HouseOwnerFlag = '0'

--- Search via using a range check

select 
	*
from
	[dbo].[Customer]
where
	YearlyIncome between 40000 and 80000

















	