
-- Attempt to sum the Char field , fails as we cannot sum string types

select
	sum([HouseOwnerFlag])
from
	[dbo].[Customer]

-- Use cast to convert the Char field to a number , in this case an Integer, now the SUM will work

select
	sum(
	    cast([HouseOwnerFlag] as integer) 
	   )
from
	[dbo].[Customer]


