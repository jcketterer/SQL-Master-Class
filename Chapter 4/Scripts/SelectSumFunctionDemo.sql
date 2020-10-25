-- Demo SQL Sum() function

-- The foundation query 

use [Chapter 4 - Insurance] ;

select 
	* 
from
	[dbo].[MemberClaims] cl
order by 
	claimpaiddate desc

-- The claims manager requested the total claims $ paid for Death and TPD claim type during the 
-- year 2014 

select 
	 year(claimpaiddate) as [Year]
	,cl.claimtype
	,sum([claimpaidamount]) as TotalClaimPaid
from
	[dbo].[MemberClaims] cl
where
	cl.claimtype in ('TPD','DTH') and
	 year(claimpaiddate) = 2014
group by
	 year(claimpaiddate)
	,cl.claimtype
order by 
	year(claimpaiddate) desc

-- The claims manager has requested a list of the top 5 claim cause categories for claim type TPD for 2014
-- and grouped by the member gender

-- TOP(n) restricts the rows returned from your query

-- 1: Using Where clause

select 
	 TOP(5) year(claimpaiddate) as [Year]
	,[ClaimCauseCategory]
	,cl.claimtype
	,mem.gender
	,sum([claimpaidamount]) as TotalClaimPaid
from
	[dbo].[MemberClaims] cl inner join 
	[dbo].[Member] mem on cl.MemberKey = mem.MemberKey
where
	cl.claimtype in ('TPD') and
	 year(claimpaiddate) = 2014
group by
	 year(claimpaiddate)
	,[ClaimCauseCategory]
	,cl.claimtype
	,mem.gender
order by
	TotalClaimPaid desc

-- 2: Using predicates in the join , same result better performance

select 
	 TOP(5) year(claimpaiddate) as [Year]
	,[ClaimCauseCategory]
	,cl.claimtype
	,mem.gender
	,sum([claimpaidamount]) as TotalClaimPaid
from
	[dbo].[MemberClaims] cl inner join 
	[dbo].[Member] mem on cl.MemberKey = mem.MemberKey and
						  cl.claimtype in ('TPD') and 	 
						  year(cl.claimpaiddate) = 2014
group by
	 year(claimpaiddate)
	,[ClaimCauseCategory]
	,cl.claimtype
	,mem.gender
order by
	TotalClaimPaid desc




