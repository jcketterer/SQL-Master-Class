--Promo manager would like to know if repeat customers purchased again during certain promos 

SELECT 
	DISTINCT(cust.CustomerKey),
	cust.LastName,
	os.OrderQuantity,
	(select min([OrderDate]) from [dbo].[OnlineSales] os1 where os1.[CustomerKey] = cust.[Customerkey] and [OrderDate] between '2014-01-01' and '2014-01-31' ) as FirstOrdered,
	(select max([OrderDate]) from [dbo].[OnlineSales] os1 where os1.[CustomerKey] = cust.[Customerkey] and [OrderDate] between '2014-01-01' and '2014-01-31' ) as MostRecentOrdered
FROM Customer cust
LEFT JOIN OnlineSales os
	ON cust.CustomerKey = os.CustomerKey
	AND os.OrderDate BETWEEN '2014-01-01' AND '2014-01-31'

-- Using outer apply is like a left join (as above but nicer to code and easy to add more columns as needed)

SELECT 
	DISTINCT(cust.CustomerKey),
	cust.LastName,
	CA.OrderQuantity,
	CA.FirstOrder,
	CA.MostRecent
FROM Customer cust

OUTER APPLY 
	(
		SELECT 
			MIN(OrderDate) AS FirstOrder,
			MAX(OrderDate) AS MostRecent,
			os.OrderQuantity 
		FROM OnlineSales os 
		WHERE os.CustomerKey = cust.CustomerKey AND
		      os.OrderDate BETWEEN '2014-01-01' AND '2014-01-31' 
		GROUP BY os.OrderQuantity

	) AS CA

ORDER BY ca.MostRecent desc

--Inner Join and correlated sub Query

SELECT 
	DISTINCT(cust.CustomerKey),
	cust.LastName,
	os.OrderQuantity,
	(select min([OrderDate]) from [dbo].[OnlineSales] os1 where os1.[CustomerKey] = cust.[Customerkey] and [OrderDate] between '2014-01-01' and '2014-01-31' ) as FirstOrdered,
	(select max([OrderDate]) from [dbo].[OnlineSales] os1 where os1.[CustomerKey] = cust.[Customerkey] and [OrderDate] between '2014-01-01' and '2014-01-31' ) as MostRecentOrdered
FROM Customer cust
INNER JOIN OnlineSales os
	ON cust.CustomerKey = os.CustomerKey
	AND os.OrderDate BETWEEN '2014-01-01' AND '2014-01-31'

--Cross apply working like an inner join 

SELECT 
	DISTINCT(cust.CustomerKey),
	cust.LastName,
	CA.OrderQuantity,
	CA.FirstOrder,
	CA.MostRecent,
	CA.MinFreight,
	CA.MaxFreight
FROM Customer cust

CROSS APPLY 
	(
		SELECT 
			MIN(OrderDate) AS FirstOrder,
			MAX(OrderDate) AS MostRecent,
			MIN(os.Freight) AS MinFreight,
			MAX(os.Freight) AS MaxFreight,
			os.OrderQuantity 
		FROM OnlineSales os 
		WHERE os.CustomerKey = cust.CustomerKey AND
		      os.OrderDate BETWEEN '2014-01-01' AND '2014-01-31' 
		GROUP BY os.OrderQuantity

	) AS CA

ORDER BY ca.MostRecent desc