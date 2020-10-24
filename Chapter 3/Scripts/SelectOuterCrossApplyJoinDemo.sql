
-- Using outer apply is like a left join (as above but nicer to code and easy to add more columns as needed)

-- The promotions manager wants to know if customers purchased products again during a specific promo month and if so does it correlate to the promo ?

select
	 distinct(cust.[CustomerKey]) 
	,[LastName]
	,[OrderQuantity]
	,(select min([OrderDate]) from [dbo].[OnlineSales] os1 where os1.[CustomerKey] = cust.[Customerkey] and [OrderDate] between '2014-01-01' and '2014-01-31' ) as FirstOrdered
	,(select max([OrderDate]) from [dbo].[OnlineSales] os1 where os1.[CustomerKey] = cust.[Customerkey] and [OrderDate] between '2014-01-01' and '2014-01-31' ) as MostRecentOrdered
from
	[dbo].[Customer] cust left join
	[dbo].[OnlineSales] os ON cust.CustomerKey = os.CustomerKey and
							  os.OrderDate between '2014-01-01' and '2014-01-31' 


-- Using outer apply is like a left join (as above but nicer to code and easy to add more columns as needed)

select
	 distinct(cust.[CustomerKey]) 
	,CUST.[LastName]
	,CA.[OrderQuantity]
	,CA.[FirstOrdered]
	,CA.[MostRecentOrdered]
FROM
	[dbo].[Customer] cust

OUTER APPLY

	(
		select
			 min([OrderDate]) as FirstOrdered
			,max([OrderDate]) as MostRecentOrdered			
			,os.OrderQuantity
		from			
			[dbo].[OnlineSales] os
		where
			os.CustomerKey = cust.CustomerKey and
			os.OrderDate between '2014-01-01' and '2014-01-31' 
		group by
			os.OrderQuantity

	) as CA

order by ca.MostRecentOrdered desc

-- Inner Join and correlated sub query 

select
	 distinct(cust.[CustomerKey]) 
	,[LastName]
	,[OrderQuantity]
	,(select min([OrderDate]) from [dbo].[OnlineSales] os1 where os1.[CustomerKey] = cust.[Customerkey] and [OrderDate] between '2014-01-01' and '2014-01-31' ) as FirstOrdered
	,(select max([OrderDate]) from [dbo].[OnlineSales] os1 where os1.[CustomerKey] = cust.[Customerkey] and [OrderDate] between '2014-01-01' and '2014-01-31' ) as MostRecentOrdered
from
	[dbo].[Customer] cust inner join
	[dbo].[OnlineSales] os ON cust.CustomerKey = os.CustomerKey and
							  os.OrderDate between '2014-01-01' and '2014-01-31' 


-- Using cross apply is like inner join (as above but nicer to code and easy to add more columns as needed)

select
	 distinct(cust.[CustomerKey]) 
	,CUST.[LastName]
	,CA.[OrderQuantity]
	,CA.[FirstOrdered]
	,CA.[MostRecentOrdered]
	,CA.MinFreight
	,CA.MaxFreight
FROM
	[dbo].[Customer] cust

CROSS APPLY

	(
		select
			 min([OrderDate]) as FirstOrdered
			,max([OrderDate]) as MostRecentOrdered
			,min(os.Freight) as MinFreight	
			,max(os.Freight) as MaxFreight			
			,os.OrderQuantity
		from			
			[dbo].[OnlineSales] os
		where
			os.CustomerKey = cust.CustomerKey and
			os.OrderDate between '2014-01-01' and '2014-01-31' 
		group by
			os.OrderQuantity

	) as CA

order by ca.MostRecentOrdered desc








