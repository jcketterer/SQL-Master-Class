--Self Joins 

--Phase 1, same products supplied by different suppliers, just revealing keys

SELECT DISTINCT
	ps1.ProductKey,
	ps1.SupplierKey
FROM ProductSupplier ps1
INNER JOIN ProductSupplier ps2
	ON ps1.ProductKey = ps2.ProductKey AND ps1.SupplierKey != ps2.SupplierKey


-- Phase 2, same products supplied by different suppliers, showing supplier name

SELECT DISTINCT
	ps1.ProductKey,
	ps1.SupplierKey,
	s.Name
FROM ProductSupplier ps1
INNER JOIN ProductSupplier ps2
	ON ps1.ProductKey = ps2.ProductKey AND ps1.SupplierKey != ps2.SupplierKey
INNER JOIN Supplier s
	ON s.SupplierKey = ps1.SupplierKey

--Phase 3, same products different suppliers and show the product name supplier name.

SELECT DISTINCT
	ps1.ProductKey,
	prod.ProductName,
	prod.ListPrice,
	ps1.SupplierKey,
	s.Name
FROM ProductSupplier ps1
INNER JOIN ProductSupplier ps2
	ON ps1.ProductKey = ps2.ProductKey AND ps1.SupplierKey != ps2.SupplierKey
INNER JOIN Supplier s
	ON s.SupplierKey = ps1.SupplierKey
INNER JOIN Product prod
	ON ps1.ProductKey = prod.ProductKey

-- Practice Problem Create a SELF JOIN on tables ProductSupplier where 1 product has more than one supplier reduce the list to product 405

SELECT 
	p1.ProductKey,
	p1.SupplierKey
FROM ProductSupplier p1
INNER JOIN ProductSupplier p2
	ON p1.ProductKey = p2.ProductKey AND p1.SupplierKey != p2.SupplierKey
WHERE p1.ProductKey = 405
ORDER By p1.SupplierKey

