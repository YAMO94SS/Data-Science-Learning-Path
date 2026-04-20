/* =================================================
TAREA M7 – YAMIL SALOMON
Módulo 35: Introducción al lenguaje SQL
=================================================
*/

-- 1. CONFIGURACIÓN: Establecer la base de datos de trabajo 
USE AdventureWorks2022;
GO

-- 2. REQUERIMIENTO: Comando SELECT [cite: 372]
-- Objetivo: Consultar la información básica de todos los empleados.
-- Interpretación: Este comando permite al analista tener una visión 
-- general de la plantilla para auditorías iniciales.
SELECT * FROM HumanResources.Employee;

-- 3. REQUERIMIENTO: Comando WHERE
-- Objetivo: Filtrar empleados que tienen el título de 'Design Engineer'.
-- Interpretación: Permite al departamento de ingeniería identificar 
-- perfiles específicos para asignación de proyectos técnicos.
SELECT * FROM HumanResources.Employee
WHERE JobTitle = 'Design Engineer';

-- 4. REQUERIMIENTO: Comando BETWEEN
-- Objetivo: Identificar empleados con horas de enfermedad (SickLeaveHours) entre 40 y 80.
-- Interpretación: Herramienta de control para RH para monitorear el 
-- bienestar del personal y detectar posibles ausentismos recurrentes.
SELECT * FROM HumanResources.Employee
WHERE SickLeaveHours BETWEEN 40 AND 80;

-- 5. REQUERIMIENTO: Comando ORDER BY
-- Objetivo: Listar a todos los empleados ordenados por su fecha de nacimiento (antigüedad de edad).
-- Interpretación: Útil para planeación de jubilaciones o programas 
-- de beneficios por rangos generacionales.
SELECT * FROM HumanResources.Employee
ORDER BY BirthDate ASC;
