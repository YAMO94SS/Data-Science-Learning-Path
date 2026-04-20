-- Ejercicio 1
USE AdventureWorks2022;
GO

SELECT 
    ProductID, 
    SUM(OrderQty) AS TotalQuantity, 
    SUM(LineTotal) AS TotalSales
FROM 
    Sales.SalesOrderDetail
GROUP BY 
    ProductID;

-- Ejercicio 2
USE AdventureWorks2022;
GO

SELECT 
    ProductID, 
    SUM(OrderQty) AS TotalQuantity
FROM 
    Sales.SalesOrderDetail
GROUP BY 
    ProductID
HAVING 
    SUM(OrderQty) > 50;

--Ejercicio 3
USE AdventureWorks2022;
GO

SELECT 
    SalesOrderID, 
    ProductID, 
    LineTotal, 
    SUM(LineTotal) OVER (PARTITION BY SalesOrderID) AS TotalOrderValue
FROM 
    Sales.SalesOrderDetail;

-- Ejercicio 4
-- Uso de ROW_NUMBER() para numerar las líneas de pedido dentro de cada orden.
-- Nota: ROW_NUMBER exige un ORDER BY dentro de la función de ventana.

SELECT 
    SalesOrderID, 
    SalesOrderDetailID, 
    ProductID, 
    LineTotal,
    ROW_NUMBER() OVER (PARTITION BY SalesOrderID ORDER BY SalesOrderDetailID) AS NumeroDeLinea
FROM 
    Sales.SalesOrderDetail;

-- Ejercicio 5
-- Uso de RANK() para asignar un rango a los productos dentro de cada orden basado en su LineTotal.

SELECT 
    SalesOrderID, 
    ProductID, 
    LineTotal,
    RANK() OVER (PARTITION BY SalesOrderID ORDER BY LineTotal DESC) AS RangoPorMonto
FROM 
    Sales.SalesOrderDetail;

-- Ejercicio 6
-- Uso de DENSE_RANK() para asignar un rango a los productos dentro de cada 
-- orden basado en su LineTotal, sin dejar huecos en la numeración.

SELECT 
    SalesOrderID, 
    ProductID, 
    LineTotal,
    DENSE_RANK() OVER (PARTITION BY SalesOrderID ORDER BY LineTotal DESC) AS RangoDensoPorMonto
FROM 
    Sales.SalesOrderDetail;

-- Ejercicio 7
-- Agrupación por producto obteniendo el valor total de ventas,
-- filtrado con HAVING para totales > 5000 
-- y ordenado de mayor a menor.

SELECT 
    ProductID, 
    SUM(LineTotal) AS ValorTotalVentas
FROM 
    Sales.SalesOrderDetail
GROUP BY 
    ProductID
HAVING 
    SUM(LineTotal) > 5000
ORDER BY 
    ValorTotalVentas DESC;