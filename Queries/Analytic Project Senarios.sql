

 --Practice Project 1 Challenge 1
 /*Construct an ordered (by DateKey asc) query to return the following metrics…

1: DateKey

2: Sum of Page views

3: Mean of Bounce rate pct*/


SELECT 
	(c.DateKey),
	SUM(pa.PageViews) AS TotalViews,
	AVG(pa.BounceRatePct) AS BounceRate
FROM Calendar c
INNER JOIN PageAnalysis pa
	ON c.DateKey = pa.DateKey
GROUP BY c.DateKey
ORDER BY 
	DateKey,
	TotalViews

--Practice Project 1 Challenge 2

/*Construct an ordered (by MonthYearName asc) query to return the following metrics…

1: MonthYearName

2: Sum of Page views

3: Mean of Bounce rate pct*/

SELECT 
	c.MonthYearName,
	SUM(PageViews) AS TotalViews,
	AVG(BounceRatePct) AS BounceRate
FROM Calendar c
INNER JOIN PageAnalysis pa
	ON c.DateKey = pa.DateKey
GROUP BY c.MonthYearName
ORDER BY c.MonthYearName ASC

--Practice Project 1 Challenge 3
/*Construct an ordered (by Year,Week asc) query to return the following metrics …

1: YearNum

2: WeekNum

3: Average session duration (in seconds)

4: Count of ‘Returning visitor’*/

SELECT 
	YEAR(DateKey) AS YearNum,
	DATEPART(week,DateKey) AS WeekNum,
	AVG(DATEDIFF(millisecond,0,AvgSessionDuration))/1000 AS AvgSessionDuration,
	COUNT(va.UserTypeKey) AS WeeklyNewVisitor 
FROM VisitorAnalysis va
INNER JOIN UserType ut
	ON va.UserTypeKey = ut.UserTypeKey AND ut.UserType = 'New Visitor'
GROUP BY 
	YEAR(DateKey),
	DATEPART(week,DateKey)
ORDER BY 
	YEAR(DateKey),
	DATEPART(week,DateKey)

--Practice Project 1 Challenge 4
/*Construct an ordered (by Year,Week asc) query to return the following metrics …

1: YearNum

2: WeekNum

3: Sum of new users

4: Sum of Page views*/

SELECT
	YEAR(DateKey) AS YearNum,
	DATEPART(week,DateKey) AS WeekNum,
	SUM(NewUsers) AS NewUsers,
	SUM(PageViews) AS TotalViews
FROM PageAnalysis
GROUP BY 
	YEAR(DateKey),
	DATEPART(week,DateKey) 

--*************************************************************************

--Insurance claims profit analysis 

USE [Chapter 4 - Insurance]

--Practice Project 2 Challenge 1

/*Construct a query to provide insight as to the profitability of the DTH insurance for the years 2012 to 2014.
You will need to compare claim paid for these years to the premium collected overall for these years.
The query has to return the following metrics …
1: Underwriting year
2: Claim type (DTH)
3: Claim count (DTH)
4: Total Death premium value
5: Count of policy holders (Death policies)
6: Total claim paid (DTH)
7: The margin value (Profit)*/


SELECT
	YearlyPremium.underwriting_year,
	cl.ClaimType,
	COUNT(ClaimType) AS ClaimCount,
	YearlyPremium.DTHCover,
	DTHPolicyHolders,
	SUM(claimpaidamount) AS TotalClaimPaid,
	YearlyPremium.DTHCover - SUM(cl.claimpaidamount) as CoverProfit
FROM MemberClaims cl

OUTER APPLY

	(SELECT
		underwriting_year,
		SUM(total_death_cover_premium) AS DTHCover,
		SUM(total_tpd_cover_premium) AS TPDCover,
		SUM(total_ip_cover_premium) AS IPCover,
		COUNT(total_death_cover_premium) AS DTHPolicyHolders,
		COUNT(total_tpd_cover_premium) AS TPDPolicyHolders,
		COUNT(total_ip_cover_premium) AS IPPolicyHolders
	FROM MemberCover mc
	WHERE mc.underwriting_year = year(cl.claimpaiddate)
	GROUP BY underwriting_year
	)AS YearlyPremium

WHERE 
	YEAR(cl.claimpaiddate) in (2012,2013,2014) AND
	cl.ClaimType = 'DTH'
GROUP BY 
	YearlyPremium.underwriting_year,
	YearlyPremium.DTHCover,
	YearlyPremium.DTHPolicyHolders,
	cl.ClaimType

--***************************************************************

--Practice Project 3 Challenge 1

use [Chapter 3 - Sales (Keyed) ] ;	

--	  Now the Product manager wants a ranked list of all products including product name, cost and listprice sold $ 
--	  during the month of Nov 2013 the ranking is grouped by Product Category	
---   Prac - Ranked list of product sales over country Nov 2013

SELECT
	ProductCategoryName,
	ProductName,
	SUM(SalesAmount) AS TotalSales,
	RANK() OVER (PARTITION by pc.ProductCategoryName ORDER BY SUM(SalesAmount) DESC) AS ProductRank
FROM Product prod
INNER JOIN OnlineSales os
	ON prod.ProductKey = os.ProductKey AND os.OrderDate BETWEEN '2013-12-01' AND '2013-12-31'
INNER JOIN ProductSubcategory psc
	ON prod.ProductSubcategoryKey = psc.ProductSubcategoryKey
INNER JOIN ProductCategory pc
	ON pc.ProductCategoryKey = psc.ProductCategoryKey
GROUP BY 
	pc.ProductCategoryName,
	ProductName

--Practice Project 4 Challenge 1

/*	-- Scenario --- 

	-- As a large an online retailer, our CEO of wants a performance analysis of DAILY sales by
	-- product grouped by product category for the year 2013 , the CEO also wants to see when the 
	-- product was first sold																				Paul **

	-- Our CEO has requested when was the product first stocked levels be added to the summary as well		Student **
	-- do CSQ on [dbo].[ProductInventory] 


*/

-- Initial build up

SELECT
	OrderDate,
	ProductName, 
	SUM(SalesAmount) AS TotalSales 
FROM OnlineSales os
INNER JOIN Product p
	ON os.ProductKey = p.ProductKey
GROUP BY 
	OrderDate,
	ProductName
Order BY 
	OrderDate,
	ProductName

-- Add product categories 

SELECT
	CONVERT(date,OrderDate) AS PurchaseDate,
	ProductName,
	pc.ProductCategoryName,
	SUM(SalesAmount) AS TotalSales 
FROM OnlineSales os
INNER JOIN Product p
	ON os.ProductKey = p.ProductKey AND YEAR(OrderDate) = 2013
INNER JOIN ProductSubcategory psc
	ON p.ProductSubcategoryKey = psc.ProductSubcategoryKey
INNER JOIN ProductCategory pc
	ON pc.ProductCategoryKey = psc.ProductCategoryKey
GROUP BY 
	OrderDate,
	pc.ProductCategoryName,
	ProductName
Order BY 
	OrderDate,
	pc.ProductCategoryName,
	ProductName

-- Add product first sold using correlated sub query

SELECT
	CONVERT(date,OrderDate) AS PurchaseDate,
	ProductName,
	pc.ProductCategoryName,
	(SELECT MIN(CAST(os1.OrderDate as Date)) FROM OnlineSales os1 WHERE os1.ProductKey = os.ProductKey) AS FirstSoldDate,
	SUM(SalesAmount) AS TotalSales 
FROM OnlineSales os
INNER JOIN Product p
	ON os.ProductKey = p.ProductKey AND YEAR(OrderDate) = 2013
INNER JOIN ProductSubcategory psc
	ON p.ProductSubcategoryKey = psc.ProductSubcategoryKey
INNER JOIN ProductCategory pc
	ON pc.ProductCategoryKey = psc.ProductCategoryKey
GROUP BY 
	OrderDate,
	pc.ProductCategoryName,
	ProductName,
	os.ProductKey
Order BY 
	OrderDate,
	pc.ProductCategoryName,
	ProductName
	   	  
-- Prac work, item was first stocked 

SELECT
	CONVERT(date,OrderDate) AS PurchaseDate,
	ProductName,
	pc.ProductCategoryName,
	(SELECT MIN(CAST(os1.OrderDate as Date)) FROM OnlineSales os1 WHERE os1.ProductKey = os.ProductKey) AS FirstSoldDate,
	SUM(SalesAmount) AS TotalSales,
	(SELECT MIN(pin.DateKey) FROM ProductInventory pin WHERE pin.ProductKey = os.ProductKey) AS FirstStockedDate
FROM OnlineSales os
INNER JOIN Product p
	ON os.ProductKey = p.ProductKey AND YEAR(OrderDate) = 2013
INNER JOIN ProductSubcategory psc
	ON p.ProductSubcategoryKey = psc.ProductSubcategoryKey
INNER JOIN ProductCategory pc
	ON pc.ProductCategoryKey = psc.ProductCategoryKey
GROUP BY 
	OrderDate,
	pc.ProductCategoryName,
	ProductName,
	os.ProductKey
Order BY 
	OrderDate,
	pc.ProductCategoryName,
	ProductName
