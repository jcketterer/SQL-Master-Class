-- Avg() function demo 

-- Product manager wants to get an idea of the mean of insurance covers and premium paid across the age groups in year 2014

select									-- Get member count
	count(*)
from
	[dbo].[Member]	

select									-- Get member with cover count 
	count(distinct([MemberKey])) 
from
	[dbo].[MemberCover]
where
	[underwriting_year] = 2014


select									-- Work out the average using the standard math formula 
	sum([total_death_cover]) / (select count(*) from [dbo].[Member])
from
	[dbo].[MemberCover]
where
	[underwriting_year] = 2014


select									-- Now use the average function for better accuracy
	 mem.age
	,avg([total_death_cover])			as AvgDthCover
	,avg([total_death_cover_premium])	as AvgDthPremium
	,avg([total_ip_cover])				as AvgIpCover
	,avg([total_ip_cover_premium])		as AvgIpPrem
	,avg([total_tpd_cover])				as AvgTpdCover
	,avg([total_tpd_cover_premium])		as AvgTpdPrem
from
	[dbo].[MemberCover] mc inner join
	[dbo].[Member] mem on mc.MemberKey = mem.MemberKey
where 
	[underwriting_year] = 2014 
group by
	mem.age
order by
	mem.age


select									-- Now use the average function for better accuracy (Best practice using predicate in join)
	 mem.age
	,avg([total_death_cover])			as AvgDthCover
	,avg([total_death_cover_premium])	as AvgDthPremium
	,avg([total_ip_cover])				as AvgIpCover
	,avg([total_ip_cover_premium])		as AvgIpPrem
	,avg([total_tpd_cover])				as AvgTpdCover
	,avg([total_tpd_cover_premium])		as AvgTpdPrem
from
	[dbo].[MemberCover] mc inner join
	[dbo].[Member] mem on mc.MemberKey = mem.MemberKey and
						  mc.underwriting_year = 2014 
group by
	mem.age
order by
	mem.age


