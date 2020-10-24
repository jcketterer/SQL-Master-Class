-- Demo the cross join

select
	 LastName
	,Gender
	,city
from
	[dbo].[Customer] cust cross join
	[dbo].[Geography] geo 



	--- WARNING : Cartesian joins can degrade server performance quickly and cause issues for other server processes and users, and you DBA will be CROSS!