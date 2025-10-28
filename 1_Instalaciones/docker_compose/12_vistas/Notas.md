## Vistas
Una vista es una tabla virtual que se basa en una consulta SQL.
## Vistas materializadas
Una vista materializada es una tabla física que se actualiza periódicamente con los resultados de la consulta SQL. La data no se actualiza automáticamente, por lo que es necesario actualizarla manualmente. Una vez creada, la vista materializada puede ser consultada como si fuera una tabla regular.

## Common table expressions (CTE)
Una common table expression (CTE) es una consulta SQL que se define temporalmente y se puede referenciar en la misma consulta. Las CTEs pueden ser utilizadas para mejorar la legibilidad y la mantenibilidad de las consultas complejas. El query principal puede referenciar a la CTE como si fuera una tabla regular.

## Common table expressions recursive
Una common table expression recursive (CTE recursive) es una consulta SQL que se define temporalmente y se puede referenciar en la misma consulta. Las CTEs recursivas pueden ser utilizadas para mejorar la legibilidad y la mantenibilidad de las consultas complejas. El query principal puede referenciar a la CTE recursiva como si fuera una tabla regular. Se usa cuando se tiene una estructura jerárquica en los datos, como por ejemplo, una tabla de empleados que tiene una relación de padre-hijo.

## Temas puntuales de la sección
Esta sección tiene por objetivo aprender sobre dos temas principales que a su vez, tienen variaciones:

- Vistas
- Vistas Materializadas
- CTE - Common Table Expressions
- CTE - Recursivos

Es una sección que puede sentirse algo complicada, pero los ejemplo que realizaremos tienen por objetivo aprender a trabajar con ellos de una forma simple.

Lo que esperaría, es que sepan encontrar cuándo un problema se puede resolver con un query recursivo y cuando se puede hacer sin recursividad para la facilidad de lectura.

## Preparación
Antes de comenzar, es necesario tener instalado PostgresSQL y Docker Compose.

restaurar desde la base de datos medium-db.sql y  comments-table.sql

## Vistas
Agrupar los post por semana y mostrar la cantidad de posts publicados en cada semana. La vista solo almacena el query no es una tabla física.
```SQL
CREATE VIEW comments_per_week as
SELECT date_trunk('week', posts.created_at) as weeks,
	COUNT(DISTINCT posts.post_id) AS number_of_posts,
	SUM(claps.counter) AS total_claps
FROM POSTS
INNER JOIN claps ON claps.post_id = posts.post_id
GROUP BY weeks
ORDER BY weeks DESC;
```
Seleccionar el numero de posts y clamps por semana
```SQL
SELECT * FROM comments_per_week;
```

Elimnar la vista comments_per_week
```SQL
DROP VIEW comments_per_week;
```

## Vistas materializadas
Una vista materializada es una tabla física que se actualiza periódicamente con los resultados de la consulta SQL. La data no se actualiza automáticamente, por lo que es necesario actualizarla manualmente. Una vez creada, la vista materializada puede ser consultada como si fuera una tabla regular.
Ejemplo de uso un aeropuerto, se puede crear una vista materializada que muestre los vuelos que salen de un aeropuerto en una determinada fecha. Pero si quiero esta informacion rapidamente, puedo consultar la vista materializada. Esta vista materializada se actualiza cuando no tenemos un trafico en el sistema del araeropuerto.

```SQL
CREATE MATERIALIZED VIEW comments_per_week_mat AS
 SELECT date_trunc('week'::text, posts.created_at) AS weeks,
    count(DISTINCT posts.post_id) AS number_of_posts,
    sum(claps.counter) AS total_claps
   FROM (posts
     JOIN claps ON ((claps.post_id = posts.post_id)))
  GROUP BY (date_trunc('week'::text, posts.created_at))
  ORDER BY (date_trunc('week'::text, posts.created_at)) DESC;
```
```SQL
  SELECT * FROM comments_per_week;
```
Para actualizar la vista materializada comments_per_week_mat
```SQL
REFRESH MATERIALIZED VIEW comments_per_week_mat;
```
## Cambiar el nombre de la vista materializada y vista normal


```SQL
ALTER VIEW comments_per_week RENAME TO posts_per_week;
```
```SQL
ALTER MATERIALIZED VIEW comments_per_week_mat RENAME TO posts_per_week_mat;
```