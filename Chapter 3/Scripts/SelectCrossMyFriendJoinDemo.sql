-- Gaining insight into product sales across all territories using a cross join

select
	 [SalesTerritoryKey]
	,[ProductKey]
	,sum([SalesAmount]) as TotalSales
from
	[dbo].[OnlineSales]
where 
	[OrderDate] between '2014-01-01' and '2014-01-31'
group by
	 [SalesTerritoryKey]
	,[ProductKey]

-- Clearly only products that have a sale are shown, which does not answer the original question
-- Hence let us cross join Sales Territories to Products, the result is a combination across all Territories and Products 

select
	 st.SalesTerritoryKey
	,prod.ProductKey
from
	[dbo].[SalesTerritory] st CROSS join
	[dbo].[Product] prod


-- Final solution incorporating the above queries

select
	 st.SalesTerritoryKey
	,prod.ProductKey
	,prod.ProductName
	,isnull(TerritorySales.TotalSales,0)
from
	[dbo].[SalesTerritory] st CROSS join
	[dbo].[Product] prod left join
	(
		select
			 [SalesTerritoryKey]
			,[ProductKey]
			,sum([SalesAmount]) as TotalSales
		from
			[dbo].[OnlineSales]
		where 
			[OrderDate] between '2014-01-01' and '2014-01-31'
		group by
			 [SalesTerritoryKey]
			,[ProductKey]		
	) as TerritorySales ON TerritorySales.SalesTerritoryKey = st.SalesTerritoryKey and
						   TerritorySales.ProductKey = prod.ProductKey
order by 						   
	TerritorySales.TotalSales desc					   	

