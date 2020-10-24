--Cross Joins w/ Other Joins

-- Insight into product sales across all territories using cross join

SELECT 
	SalesTerritoryKey,
	ProductKey,
	SUM(SalesAmount) AS TotalSales
FROM OnlineSales
WHERE OrderDate BETWEEN '2014-01-01' AND '2014-01-31'
GROUP BY
	SalesTerritoryKey,
	ProductKey

--Only products that have a sale are shown, which does not answer the actual question
--Hence us a cross join Sales Territory to Products, resulting in a combonation across all Territories and Products

SELECT 
	st.SalesTerritoryKey,
	prod.ProductKey
FROM SalesTerritory st
CROSS JOIN Product prod

--Final Solution

SELECT 
	st.SalesTerritoryKey,
	prod.ProductKey,
	prod.ProductName,
	ISNULL(TerritorySales.TotalSales,0)
FROM SalesTerritory st
CROSS JOIN Product prod
LEFT JOIN (
	SELECT 
		SalesTerritoryKey,
		ProductKey,
		SUM(SalesAmount) AS TotalSales
	FROM OnlineSales
	WHERE OrderDate BETWEEN '2014-01-01' AND '2014-01-31'
	GROUP BY
		SalesTerritoryKey,
		ProductKey
) AS TerritorySales 
	ON TerritorySales.SalesTerritoryKey = st.SalesTerritoryKey AND 
	   TerritorySales.ProductKey = prod.ProductKey
ORDER BY TerritorySales.TotalSales DESC


