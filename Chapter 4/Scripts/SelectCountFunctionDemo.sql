-- Demo SQL Count()

use [Chapter 4 - Insurance] ;

-- The foundation query 

select 
	* 
from
	[dbo].[Member]


-- Policy manager wants a count of members by gender

select 
	 count(*) as gCount
	,Gender 
from
	[dbo].[Member]
group by
	Gender

-- Policy manager wants a count of distinct occupations

select 
	count(distinct(occupation)) as uOccupationCount
from
	[dbo].[Member]

-- Policy manager wants a list of duplicated member biz keys

select 
	 count([member_biz_key]) as CountMemBizKey
	,member_biz_key
from
	[dbo].[Member]
group by
	member_biz_key
having
	count([member_biz_key]) > 1
order by 2

-- Policy manager wants a count members spread across countries  

select 
	count(country) as CountCountry 
from
	[dbo].[Member]


 -- The sales manager wants a list of product count in each online sales order
 -- to evaluate the greatest product count overall 

 use [Chapter 3 - Sales (Keyed) ] ;


 select
	 distinct count([ProductKey]) OVER(PARTITION BY [SalesOrderNumber] ) as ProdCount
	,[SalesOrderNumber]
 from
	[dbo].[OnlineSales]
 order by 1 desc
