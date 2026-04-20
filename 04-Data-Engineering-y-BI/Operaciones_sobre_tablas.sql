-- Apuntamos a la base de datos solicitada
USE AdventureWorks2022;
GO

-- Creación de la tabla en el esquema dbo
CREATE TABLE dbo.Ventas (
    NumeroOrden INT PRIMARY KEY, -- Identificador único
    FechaOrden DATETIME NOT NULL,
    FechaEntrega DATE,
    EstatusOrden NVARCHAR(50) NOT NULL,
    NombreCliente NVARCHAR(100) NOT NULL,
    DomicilioEntrega NVARCHAR(255),
    CompraOnline CHAR(1) CHECK (CompraOnline IN ('S', 'N')), -- Validamos que solo acepte S o N
    MetodoPago NVARCHAR(50),
    Subtotal DECIMAL(18, 2) NOT NULL, -- 18 dígitos en total, 2 decimales
    Observaciones NVARCHAR(MAX)
);
GO

-- Verificamos la creación
SELECT * FROM dbo.Ventas;
GO

USE AdventureWorks2022;
GO

INSERT INTO dbo.Ventas (NumeroOrden, FechaOrden, FechaEntrega, EstatusOrden, NombreCliente, DomicilioEntrega, CompraOnline, MetodoPago, Subtotal, Observaciones)
VALUES 
(12345, '2022-08-05 18:58:46.867', '2022-08-15', 'Completada', 'Juan Pérez', 'Avenida Siempre Viva 742 Springfield', 'S', 'Tarjeta de Crédito', 20565.62, 'El cliente indica que solo puede recibir el envío entre semana.'),
(12346, GETDATE(), '2024-05-20', 'Pendiente', 'Maria Gomez', 'Calle Falsa 123, CDMX', 'N', 'Efectivo', 1500.00, 'Llamar antes de entregar.'),
(12347, '2023-11-10 10:30:00.000', '2023-11-12', 'Cancelada', 'Carlos Slim', 'Polanco 456, CDMX', 'S', 'Tarjeta de Débito', 55400.99, 'Cliente canceló por retraso.'),
(12348, GETDATE(), NULL, 'En Proceso', 'Ana Torres', 'Insurgentes Sur 789', 'S', 'Tarjeta de Crédito', 890.50, 'Sin observaciones.'),
(12349, '2024-01-15 09:15:00.000', '2024-01-18', 'Completada', 'Luis Miguel', 'Acapulco Diamante 1', 'N', 'Efectivo', 125000.00, 'Entregar en recepción.');
GO

-- Verificamos la carga de datos
SELECT * FROM dbo.Ventas;
GO

USE AdventureWorks2022;
GO

-- Ejecutamos el procedimiento almacenado para renombrar la tabla
EXEC sp_rename 'dbo.Ventas', 'Ordenes';
GO

-- Verificamos que la tabla ahora responde al nuevo nombre
SELECT * FROM dbo.Ordenes;
GO

USE AdventureWorks2022;
GO

-- Agregamos la nueva columna permitiendo valores nulos (ya que las órdenes pasadas no la tienen)
ALTER TABLE dbo.Ordenes
ADD FechaDeEnvio DATE;
GO

-- Verificamos la nueva estructura
SELECT * FROM dbo.Ordenes;
GO

USE AdventureWorks2022;
GO

-- PASO A: Buscar y eliminar la regla (constraint) que bloquea el renombramiento
DECLARE @NombreRestriccion NVARCHAR(200);

SELECT @NombreRestriccion = name 
FROM sys.check_constraints 
WHERE parent_object_id = OBJECT_ID('dbo.Ordenes') 
AND definition LIKE '%CompraOnline%';

IF @NombreRestriccion IS NOT NULL
BEGIN
    DECLARE @ComandoSQL NVARCHAR(MAX) = 'ALTER TABLE dbo.Ordenes DROP CONSTRAINT ' + @NombreRestriccion;
    EXEC sp_executesql @ComandoSQL;
END
GO

-- PASO B: Ahora sí, renombramos la columna libre de dependencias
EXEC sp_rename 'dbo.Ordenes.CompraOnline', 'BanderaCompraOnline', 'COLUMN';
GO

-- PASO C: Verificamos que el cambio de nombre en la cabecera fue exitoso
SELECT * FROM dbo.Ordenes;
GO

USE AdventureWorks2022;
GO

-- Creamos una tabla efímera
CREATE TABLE dbo.Prueba (
    ColumnaAleatoria INT
);
GO

-- Insertamos 5 registros
INSERT INTO dbo.Prueba (ColumnaAleatoria)
VALUES (10), (20), (30), (40), (50);
GO

-- Verificamos los datos
SELECT * FROM dbo.Prueba;
GO

USE AdventureWorks2022;
GO

-- Vaciamos los datos velozmente, conservando la estructura
TRUNCATE TABLE dbo.Prueba;

-- Verificamos que esté vacía
SELECT * FROM dbo.Prueba;
GO

-- Eliminamos la tabla del servidor de forma definitiva
DROP TABLE dbo.Prueba;
GO

USE AdventureWorks2022;
GO

-- Buena práctica: Hacemos un SELECT previo para ver qué vamos a borrar
SELECT * FROM dbo.Ordenes WHERE EstatusOrden = 'Cancelada';
GO

-- Ejecutamos el borrado quirúrgico
DELETE FROM dbo.Ordenes
WHERE EstatusOrden = 'Cancelada';
GO

-- Verificamos que el registro 12347 ya no existe, pero los demás sí.
SELECT * FROM dbo.Ordenes;
GO

