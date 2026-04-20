SELECT 
    first_name, 
    last_name 
FROM actor;

SELECT 
    CONCAT(first_name, ' ', last_name) AS Nombre_Completo 
FROM actor;

SELECT 
    first_name, 
    last_name 
FROM actor
WHERE first_name LIKE 'D%';

SELECT 
    first_name, 
    COUNT(first_name) AS Cantidad_Homónimos
FROM actor
GROUP BY first_name
HAVING COUNT(first_name) > 1
ORDER BY Cantidad_Homónimos DESC;

SELECT 
    MAX(rental_rate) AS Costo_Maximo 
FROM film;

SELECT 
    title AS Titulo_Pelicula, 
    rental_rate AS Costo_Renta
FROM film
WHERE rental_rate = (
    SELECT MAX(rental_rate) 
    FROM film
);

SELECT 
    rating AS Clasificacion, 
    COUNT(film_id) AS Cantidad_Peliculas
FROM film
GROUP BY rating
ORDER BY Cantidad_Peliculas DESC;

SELECT 
    title AS Titulo_Pelicula, 
    rating AS Clasificacion
FROM film
WHERE rating NOT IN ('R', 'NC-17')
ORDER BY rating;

SELECT 
    store_id AS Tienda, 
    COUNT(customer_id) AS Cantidad_Clientes
FROM customer
GROUP BY store_id;

SELECT TOP 1
    f.title AS Titulo_Pelicula,
    COUNT(r.rental_id) AS Cantidad_Rentas
FROM film f
INNER JOIN inventory i ON f.film_id = i.film_id
INNER JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY Cantidad_Rentas DESC;

SELECT 
    f.title AS Pelicula_Sin_Rentas
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.rental_id IS NULL
ORDER BY f.title;

SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS Nombre_Cliente,
    c.email
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
WHERE r.rental_id IS NULL;

SELECT 
    a.actor_id,
    CONCAT(a.first_name, ' ', a.last_name) AS Nombre_Actor,
    COUNT(fa.film_id) AS Cantidad_Peliculas
FROM actor a
INNER JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY 
    a.actor_id, 
    a.first_name, 
    a.last_name
HAVING COUNT(fa.film_id) > 30
ORDER BY Cantidad_Peliculas DESC;

SELECT 
    s.store_id AS Tienda,
    SUM(CAST(p.amount AS DECIMAL(10,2))) AS Ventas_Totales
FROM store s
INNER JOIN staff st ON s.store_id = st.store_id
INNER JOIN payment p ON st.staff_id = p.staff_id
GROUP BY s.store_id;

WITH a AS (
    SELECT 
        r.customer_id,
        i.film_id,
        COUNT(r.rental_id) AS veces_rentada
    FROM rental r
    INNER JOIN inventory i ON r.inventory_id = i.inventory_id
    GROUP BY 
        r.customer_id, 
        i.film_id
    HAVING COUNT(r.rental_id) > 1
)
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS Nombre_Cliente,
    f.title AS Pelicula_Rentada_Varias_Veces,
    a.veces_rentada AS Total_Rentas
FROM a
INNER JOIN customer c ON a.customer_id = c.customer_id
INNER JOIN film f ON a.film_id = f.film_id
ORDER BY a.veces_rentada DESC;