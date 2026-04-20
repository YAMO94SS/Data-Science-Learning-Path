USE AdventureWorks2022;

-- Ejercicio 1: Obtener nombres y puestos con INNER JOIN
SELECT 
    p.FirstName,
    p.LastName,
    e.JobTitle
FROM HumanResources.Employee e
INNER JOIN Person.Person p
    ON e.BusinessEntityID = p.BusinessEntityID;
    -- Ejercicio 2: Obtener nombres de todos los clientes con LEFT JOIN
SELECT 
    c.CustomerID,
    p.FirstName,
    p.LastName
FROM Sales.Customer c
LEFT JOIN Person.Person p
    ON c.PersonID = p.BusinessEntityID;
    -- Ejercicio 3: Órdenes y Clientes asegurando traer todos los clientes con RIGHT JOIN
SELECT 
    soh.SalesOrderID,
    c.CustomerID
FROM Sales.SalesOrderHeader soh
RIGHT JOIN Sales.Customer c
    ON soh.CustomerID = c.CustomerID;
    -- Ejercicio 4: Productos y Reseñas asegurando traer ambos lados con FULL OUTER JOIN
SELECT 
    p.Name,
    pr.Comments
FROM Production.Product p
FULL OUTER JOIN Production.ProductReview pr
    ON p.ProductID = pr.ProductID;
    -- Ejercicio 5: Combinación total de productos y categorías usando CROSS JOIN
SELECT 
    p.Name AS ProductName,
    pc.Name AS CategoryName
FROM Production.Product p
CROSS JOIN Production.ProductCategory pc;

-- Ejercicio 6a: Combinar nombres eliminando duplicados (UNION)
SELECT Name
FROM Production.Product
UNION
SELECT Name
FROM Production.ProductModel;

-- Ejercicio 6b: Combinar nombres manteniendo todos los registros (UNION ALL)
SELECT Name
FROM Production.Product
UNION ALL
SELECT Name
FROM Production.ProductModel;

-- Ejercicio 7: Clasificación condicional de puestos con CASE y protección contra nulos con COALESCE
SELECT 
    BusinessEntityID,
    COALESCE(JobTitle, 'No Title') AS JobTitle,
    CASE 
        WHEN JobTitle LIKE '%Manager%' THEN 'Manager'
        ELSE 'Not Manager'
    END AS JobCategory
FROM HumanResources.Employee;

-- Ejercicio 8: Identificar cuotas de ventas nulas usando ISNULL y CAST
SELECT 
    BusinessEntityID,
    SalesQuota,
    ISNULL(CAST(SalesQuota AS VARCHAR), 'No Quota') AS QuotaStatus
FROM Sales.SalesPerson;