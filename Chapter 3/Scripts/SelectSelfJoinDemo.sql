-- Self join

-- Phase 1 , same products supplied by different suppliers, just reveals keys 

select distinct 
	 ps1.productKey
--  ,'' as ProductName
--	,0 as ListPrice
	,ps1.SupplierKey
--	,'' as Name
from 
	[dbo].[ProductSupplier] ps1 inner join 
	[dbo].[ProductSupplier] ps2 ON ps1.ProductKey = ps2.ProductKey and 
								   ps1.SupplierKey != ps2.SupplierKey  

-- Phase 2 , same products supplied by different suppliers and show the supplier name

-- UNION 

select distinct 
	 ps1.productKey
--  ,'' as ProductName
--	,0 as ListPrice
	,ps1.SupplierKey
	,sup.Name
from 
	[dbo].[ProductSupplier] ps1 inner join 
	[dbo].[ProductSupplier] ps2 ON ps1.ProductKey = ps2.ProductKey and 
								   ps1.SupplierKey != ps2.SupplierKey inner join
	[dbo].[Supplier] sup ON ps1.SupplierKey = sup.SupplierKey	
	
-- UNION

--  Phase 3 , same products supplied by different suppliers and show the product name and supplier name

select distinct 
	 ps1.productKey
	,prod.ProductName
	,prod.ListPrice
	,ps1.SupplierKey
	,sup.Name
from 
	[dbo].[ProductSupplier] ps1 inner join 
	[dbo].[ProductSupplier] ps2 ON ps1.ProductKey = ps2.ProductKey and 
								   ps1.SupplierKey != ps2.SupplierKey inner join
	[dbo].[Supplier] sup ON ps1.SupplierKey = sup.SupplierKey inner join
	[dbo].[Product]	prod ON ps1.ProductKey = prod.ProductKey						    