-- COUNT

SELECT 
	COUNT(claimnotificationdate)
FROM MemberClaims mc
INNER JOIN Member m
	ON m.MemberKey = mc.MemberKey
WHERE claimnotificationdate BETWEEN '2014-01-01' AND '2014-12-31' AND
	  age BETWEEN 33 AND 48

-- SUM

SELECT 
	YEAR(claimpaiddate) as [Year],
	cl.claimtype,
	SUM(claimpaidamount) as TotalClaimPaid
FROM MemberClaims cl
WHERE cl.ClaimType IN ('TPD', 'DTH')
	  AND YEAR(claimpaiddate) = 2014
GROUP BY 
	cl.claimtype,
	YEAR(claimpaiddate)
ORDER BY YEAR(claimpaiddate) desc

SELECT 
	TOP(5) YEAR(claimpaiddate) as [Year],
	Claimcausecategory,
	gender,
	cl.claimtype,
	SUM(claimpaidamount) as TotalClaimPaid
FROM MemberClaims cl
INNER JOIN Member m
	ON cl.MemberKey = m.MemberKey
WHERE cl.ClaimType IN ('TPD')
	  AND YEAR(claimpaiddate) = 2014
GROUP BY 
	cl.claimtype,
	gender,
	YEAR(claimpaiddate),
	ClaimCauseCategory
ORDER BY TotalClaimPaid DESC

--Write a query to aggregate the Claim paid for the year 2010 where the claimants reside in postal code 4061, ensure Claim Cause is returned in the query

SELECT 
	YEAR(claimpaiddate) AS ClaimYear,
	ClaimCause,
	postal_code,
	SUM(claimpaidamount)
FROM MemberClaims mc
INNER JOIN Member m
	ON mc.MemberKey = m.MemberKey
WHERE 
	YEAR(claimpaiddate) = 2010 AND
	postal_code = 4061
GROUP BY 
	ClaimCause,
	postal_code,
	YEAR(claimpaiddate)

-- AVG

--Write a query to find the average Claim Paid amount and Total Death Cover amount where claimants have insurance cover for death in the underwriting year of 2012 and were paid.
--The claim type to return is 'DTH' and the Cause Category is 'FATALITY'

SELECT 
	ROUND(AVG(Claimpaidamount), 2) AS AvgClaimPaid,
	ROUND(AVG(total_death_cover), 2) AvgDeathCover,
	ClaimType,
	claimstatus,
	ClaimCauseCategory
FROM MemberClaims mcl
INNER JOIN MemberCover mco
	ON mcl.memberkey = mco.memberkey
WHERE underwriting_year = 2012 AND
	  ClaimType = 'DTH' AND
	  ClaimCauseCategory = 'FATALITY'
GROUP BY 
	ClaimType,
	claimstatus,
	ClaimCauseCategory

--MIN 
--Write a query to find the minimum salary and date joined fund for the members with the status of '2) Medium Earner'

SELECT 
	MIN(annual_salary) as MinSalary,
	date_joined_fund
FROM Member
WHERE employee_status = '2) Medium Earner'
GROUP BY date_joined_fund
ORDER BY 1 

--MAX
--Write a query to return the maximum IP cover premium for the underwriting year of 2012

SELECT 
	ROUND(MAX(total_ip_cover_premium),2),
	underwriting_year
FROM MemberCover
WHERE underwriting_year = 2012
GROUP BY underwriting_year

--Calculating Median value

select
	age,
	count(MemberKey)	as CountMember,
	max(annual_salary)	as MaxSalary,
	min(annual_salary)	as MinSalary,
	avg(annual_salary)	as MeanSalary,
	(SELECT TOP(1) PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY annual_salary DESC) OVER (PARTITION BY age) FROM Member mem1 where mem1.age = mem.age) as MedianSalary
from
	Member as Mem
group by
	age
order by
	age

--Write a query to sum all claim paid amounts for the cause of 'Shoulder Injury' and calculate the Median claim paid amount for this cause

SELECT 
	SUM(claimpaidamount) AS TotalPaid,
	(SELECT TOP(1) PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY claimpaidamount) OVER (PARTITION BY ClaimCause) FROM MemberClaims mc1 WHERE mc1.ClaimCause = mc.ClaimCause) AS MedianClaimPaid
FROM MemberClaims mc
WHERE ClaimCause = 'Shoulder Injury'
GROUP BY ClaimCause

--CASE Statements

/* Write a query to use a search case to create an abbreviated band where the age band is '(49 - 58) Baby boomers' , set the new band equal to 'Boomer' 
and ensure the else is included for the non matched age bands otherwise a NULL will appear in the band value , include the member key in the column and order by this key*/

SELECT 
	MemberKey,
	age_band,
	CASE
		WHEN age_band = '(49 - 58) Baby boomers' THEN 'Boomer'
		ELSE 'NULL'
	END AS AgeAbbrev
FROM Member

--Quartiles

use [Chapter 3 - Sales (Keyed) ];
 
SELECT *
FROM CustomerPurchasesAllTime

SELECT 
	NTILE(4) OVER(partition by geo.countryregionname ORDER BY SUM(cp.purchasetotal)) as Quartile,
	SUM(cp.PurchaseTotal) as TotalPurchased,
	geo.CountryRegionName,
	geo.StateProvinceName
FROM CustomerPurchasesAllTime cp
INNER JOIN Geography geo
	ON cp.GeographyKey = geo.GeographyKey AND
	geo.CountryRegionName = 'France'
GROUP BY 
	geo.CountryRegionName,
	geo.StateProvinceName
ORDER BY 
	geo.CountryRegionName

--Write a query that will provide a list of Occupations, Purchase Total across countryregions then calculate the quartile sales for each occupation

SELECT
	NTILE(4) OVER(PARTITION BY geo.countryregionname ORDER BY SUM(cp.purchasetotal)) as Quartile,
	CountryRegionName,
	Occupation,
	ROUND(SUM(PurchaseTotal),2) AS TotalSales
FROM CustomerPurchasesAllTime cp
INNER JOIN Geography geo
	ON cp.GeographyKey = geo.GeographyKey
GROUP BY 
	Occupation,
	CountryRegionName
ORDER BY 
	Quartile,
	CountryRegionName