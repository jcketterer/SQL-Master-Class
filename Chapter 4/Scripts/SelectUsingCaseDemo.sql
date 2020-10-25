-- Using the CASE statement 

-- The policy manager has observed that the data in member cover does not show a column for CoverType 
-- how can we create a list of member covers that shows the cover type abbreviation e.g. DTH,   for the under writing year 2014 ?


-- Searched Case Expression  (Within a SELECT statement, the searched CASE expression allows for values to be replaced in the result set based on comparison values)

select
	 MemberKey
	,total_death_cover
	,'Cover Type' = 
	case
		when total_death_cover != 0 then 'DTH'
	end

from
	[dbo].[MemberCover]
where
	[underwriting_year] = 2014 and
	[total_death_cover] != 0

-- Simple Case Expression	(Within a SELECT statement, a simple CASE expression allows for only an equality check; no other comparisons are made) 
-- The product manager requests an abbreviated gender value in the members table

select
	 memberkey
	 ,Gender
	,case gender
	  WHEN 'Male' then 'M' 
	  WHEN 'Female' then 'F'
	 else
	  '?'
	 end  as GenderAbbrev
from
	[dbo].[Member]
