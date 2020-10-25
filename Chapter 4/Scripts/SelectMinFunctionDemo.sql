-- Min() function demo
-- Stats note : Whilst range as a measure of spread is limited, 
--              min() and max() can be used to return range, i.e. The upper and lower boundaries in a data set


select 
	*
from
	[dbo].[Member]

-- The policy manager wants to know the lowest annual salary of our members

select 
	min([annual_salary]) MinAnnualSalary
from
	[dbo].[Member]

-- Claims manager looking for detail around the Claim categories/causes that paid the smallest amount , and
-- what was the % contribution of claims paid by the cause


select 
	 [ClaimCauseCategory]
	,[ClaimCause]
	,[claimstatus]
	,min([claimpaidamount]) as SmallestClaimPaid
	,sum([claimpaidamount]) as TotalClaimsPaid
	,count(claimCause)		as ClaimCount
	,((min([claimpaidamount])) / sum([claimpaidamount])) * 100 as PctOfAllCauses
from 
	[dbo].[MemberClaims]
where
	[claimstatus] = 'Paid'
group by
	 [ClaimCauseCategory]
	,[ClaimCause]
	,[claimstatus]
order by
	1
