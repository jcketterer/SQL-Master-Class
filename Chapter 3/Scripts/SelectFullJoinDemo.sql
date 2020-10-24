-- Demo the full outer join in a select

select
	 LastName
	,TotalChildren
	,city
	,CountryRegionName
From
	[dbo].[Customer] cust full outer join
	[dbo].[Geography] geo ON cust.GeographyKey = geo.GeographyKey order by city

-- Without the OUTER keyword

select
	 LastName
	,TotalChildren
	,city
	,CountryRegionName
From
	[dbo].[Customer] cust full  join
	[dbo].[Geography] geo ON cust.GeographyKey = geo.GeographyKey order by city
