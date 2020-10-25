-- Demo SQL NTILE() ranking function


use [Chapter 3 - Sales (Keyed) ] ;					--<<< Sales db for this excercise

-- The Senior data analyst requires a list of Customer sales by quartile across Country/Province for France			

-- Base query from the purpose created view
-- The view is a list of all sales totals across the globe

/*
	Quartiles tell us about the spread of a data by breaking the data set into quarters, just like the median breaks it in half (2 Groups).
		
	In SQL we can use the NTILE() ranking function

	The groups are numbered, starting at one. 
	For each row, NTILE returns the number of the group to which the row belongs i.e. the Quartile.

	
*/

	-- Base view, these can be useful when abstracting the complexity of an SQL query
	-- Learn about creating a view in the last chapter of this course

	select
		*
	from
		[dbo].[CustomerPurchasesAllTime]

	-- Summary query answers part of the question 

	select
		sum(cp.[PurchaseTotal]) as TotalPurchased
		,geo.CountryRegionName
		,geo.StateProvinceName
	from
		[dbo].CustomerPurchasesAllTime cp inner join
		[dbo].[Geography] geo on cp.GeographyKey = geo.GeographyKey and 
								 geo.CountryRegionName='France'
	group by	
		 geo.CountryRegionName
		,geo.StateProvinceName
	order by
   		 geo.CountryRegionName

	-- Introduce the NTILE() function to divide our sales into quartile groups

	select
		 NTILE(4) OVER(partition by geo.CountryRegionName ORDER BY sum(cp.[PurchaseTotal]) asc) as Quartile
		,sum(cp.[PurchaseTotal]) as TotalPurchased
		,geo.CountryRegionName
		,geo.StateProvinceName
	from
		[dbo].CustomerPurchasesAllTime cp inner join
		[dbo].[Geography] geo on cp.GeographyKey = geo.GeographyKey and 
								 geo.CountryRegionName='France'
	group by	
		 geo.CountryRegionName
		,geo.StateProvinceName
	order by
   		 geo.CountryRegionName







