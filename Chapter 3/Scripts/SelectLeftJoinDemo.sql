-- Demo the left outer join in a select

select
	 [LastName]
	,[Gender]
	,geo.City
from
	[dbo].[Customer] cust left outer join 
	[dbo].[Geography] geo ON  cust.[GeographyKey] = geo.GeographyKey

-- The JOIN

select
	 [LastName]
	,[Gender]
	,geo.City
from
	[dbo].[Customer] cust left join 
	[dbo].[Geography] geo ON  cust.[GeographyKey] = geo.GeographyKey


