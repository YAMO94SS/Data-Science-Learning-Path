USE AdventureWorks2022;
GO

-- Punto 1: Listado de productos que han sido ordenados al menos una vez
SELECT 
    Name,
    ProductID
FROM 
    Production.Product
WHERE 
    ProductID IN (
        SELECT ProductID 
        FROM Sales.SalesOrderDetail
    )
ORDER BY 
    Name ASC;

USE AdventureWorks2022;
GO

-- Punto 2: Listado de empleados y su departamento actual
SELECT 
    e.BusinessEntityID,
    p.FirstName + ' ' + p.LastName AS Empleado,
    d.Name AS Departamento
FROM 
    HumanResources.Employee e
INNER JOIN 
    Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
INNER JOIN 
    HumanResources.EmployeeDepartmentHistory edh ON e.BusinessEntityID = edh.BusinessEntityID
INNER JOIN 
    HumanResources.Department d ON edh.DepartmentID = d.DepartmentID
WHERE 
    edh.EndDate IS NULL;

USE AdventureWorks2022;
GO

-- Punto 3: Listado de empleados y su departamento actual (Usando CTE)
WITH DepartamentoActual AS (
   
    SELECT 
        BusinessEntityID, 
        DepartmentID
    FROM 
        HumanResources.EmployeeDepartmentHistory
    WHERE 
        EndDate IS NULL
)
SELECT 
    e.BusinessEntityID,
    p.FirstName + ' ' + p.LastName AS Empleado,
    d.Name AS Departamento
FROM 
    HumanResources.Employee e
INNER JOIN 
    Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
INNER JOIN 
    DepartamentoActual da ON e.BusinessEntityID = da.BusinessEntityID
INNER JOIN 
    HumanResources.Department d ON da.DepartmentID = d.DepartmentID;

USE AdventureWorks2022;
GO

-- Eliminar las tablas temporales si ya existen en la sesión actual
IF OBJECT_ID('tempdb..#ProductosOrdenados') IS NOT NULL DROP TABLE #ProductosOrdenados;
IF OBJECT_ID('tempdb..##ProductosOrdenadosGlobal') IS NOT NULL DROP TABLE ##ProductosOrdenadosGlobal;

-- 1. Creación de la Tabla Temporal Local
CREATE TABLE #ProductosOrdenados (
    ProductID INT,
    Name NVARCHAR(255)
);

-- 2. Creación de la Tabla Temporal Global
CREATE TABLE ##ProductosOrdenadosGlobal (
    ProductID INT,
    Name NVARCHAR(255)
);

-- 3. Inserción de datos en la Tabla Temporal Local (Solo productos con ventas)
INSERT INTO #ProductosOrdenados (ProductID, Name)
SELECT 
    ProductID, 
    Name
FROM 
    Production.Product
WHERE 
    ProductID IN (SELECT ProductID FROM Sales.SalesOrderDetail);

-- 4. Inserción de datos en la Tabla Temporal Global
INSERT INTO ##ProductosOrdenadosGlobal (ProductID, Name)
SELECT 
    ProductID, 
    Name
FROM 
    Production.Product
WHERE 
    ProductID IN (SELECT ProductID FROM Sales.SalesOrderDetail);

-- 5. Consulta a la tabla temporal local para el reporte (Ordenado por ID como tu Tabla 3)
SELECT 
    ProductID,
    Name
FROM 
    #ProductosOrdenados
ORDER BY 
    ProductID ASC;

USE AdventureWorks2022;
GO

-- Punto 5: Números de orden y compra exclusivamente del año 2011
SELECT 
    SalesOrderNumber,
    PurchaseOrderNumber
FROM 
    Sales.SalesOrderHeader
WHERE 
    YEAR(OrderDate) = 2011;

USE AdventureWorks2022;
GO

-- Punto 6: Limpieza de prefijos de texto en los números de orden
SELECT 
    SUBSTRING(SalesOrderNumber, 3, LEN(SalesOrderNumber)) AS NewSalesOrderNumber,
    SUBSTRING(PurchaseOrderNumber, 3, LEN(PurchaseOrderNumber)) AS NewPurchaseOrderNumber
FROM 
    Sales.SalesOrderHeader
WHERE 
    PurchaseOrderNumber IS NOT NULL; -- Filtramos los nulos para replicar tu Tabla 5