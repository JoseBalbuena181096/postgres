
## Temas puntuales de la sección
Esta sección está enfocada en uniones y joins entre tablas, explicaremos los más comunes y haremos ejercicios hasta con 4 tablas relacionadas entre sí.

Puntualmente veremos:
- Unions
- Conteos
- Joins
- Inner
- Left
- Right
- Outer
- Full

Y más

También trato de hacer un esfuerzo de enseñarles que la forma de resolver queries complejos, es empezar desde poco y pequeño, y poco a poco ir acercándonos a la solución final

## Preparacion la base de datos:

Ejecutamos el script `6_Uniones/word-db.sql` para crear la base de datos y las tablas necesarias.

## Clausula UNION

Es una clausula que nos permite combinar el resultado de dos o más consultas en una sola tabla.
Cada consulta debe tener el mismo número de columnas, y las columnas deben tener el mismo tipo de datos.

Mostrar todos los paices de America:

```sql
SELECT * FROM continent WHERE name LIKE '%America%';
```
```SQL
SELECT * FROM continent WHERE code in (3,5);
```

Unimos los dos resultados teniendo todos los continentes y ordenamos:
```sql
SELECT name FROM continent WHERE name LIKE '%America%'
UNION 
SELECT name FROM continent WHERE code in (3,5)
ORDER BY name ASC;
```

## UNION DE TABLAS - WHERE 

Hacer una consulta que muestre el nombre de cada país y su continente correspondiente.

```SQL

SELECT a.name as country, b.name as continent  FROM country a, continent b
WHERE a.continent = b.code
ORDER BY b.name ASC;
```

## INNER JOIN

El inner join nos permite combinar dos tablas basandonos en una condición. Donde la condición es que los valores de una columna de una tabla coincidan con los valores de otra columna de otra tabla.

```SQL
SELECT a.name as country, b.name as continent  FROM country a
INNER JOIN continent b on a.continent = b.code
ORDER BY b.name ASC;
```

## Alterar secuencias - Insertar nuevo continente


Reset la secuencia de la tabla continent:

```SQL
ALTER SEQUENCE continent_code_seq RESTART WITH 9;
```


```SQL
INSERT INTO continent (code, name)
VALUES 
    (9, North Asia),
    (10, 'Central Asia'),
	(11, 'South  Asia');	
```

## FULL OUTER JOIN

El full outer join nos permite combinar dos tablas basandonos en una condición. Donde la condición es que los valores de una columna de una tabla coincidan con los valores de otra columna de otra tabla.

-- country a  - name, continentCode (codigo numerico)
-- continent b - name as continentName 

```SQL
SELECT a.name as continentCode, b.name as continentName FROM country a
FULL OUTER JOIN continent b on a.continent = b.code
ORDER BY a.name ASC;
```

## RIGHT OUTER JOIN CON EXCLUSION
RIGHT OUTER JOIN nos permite combinar dos tablas basandonos en una condición. Donde la condición es que los valores de una columna de una tabla coincidan con los valores de otra columna de otra tabla.


Traer todos los continentes que no tengan paises:
```SQL
SELECT a.name as continetCode, b.name as continentName 	FROM country a
RIGHT JOIN continent b on a.continent = b.code 
WHERE a.continent IS NULL;
```

## Agregations + JOINS
Se pueden aplicar funciones de agregacion sobre los resultados de un join, como si esta fuera una unica tabla.

Contamos tosos los continetes y sus paices
```SQL
SELECT count(*), continent FROM country 
GROUP BY continent
ORDER BY CONTINENT;
```

-- Order by count(*) Y AGREGAR NOMBRE DE CONTINENTE
```SQL
SELECT count(*), b.name as continentName FROM country a
INNER JOIN continent b ON a.continent = b.code
GROUP BY  continentName
ORDER BY  continentName;
```

Contar los que no tienen paices:

```SQL

SELECT count(*), b.name as continentName FROM country a
RIGHT JOIN continent b ON a.continent = b.code
WHERE a.continent IS NULL
GROUP BY  continentName;
```

Juntamos los paices que si tiene con los que no tiene para contar adecuadamente:
```SQL
(SELECT count(*) AS count, b.name as continentName FROM country a
INNER JOIN continent b ON a.continent = b.code
GROUP BY  continentName)
UNION
(SELECT 0 AS count, b.name as continentName FROM country a
RIGHT JOIN continent b ON a.continent = b.code
WHERE a.continent IS NULL
GROUP BY  continentName)
ORDER BY  count ASC;
```


## Tarea conseguir el siguiente resultado
-- Count Union - Tarea
-- Total |  Continent
-- 5	  | Antarctica
-- 28	  | Oceania
-- 46	  | Europe
-- 51	  | America
-- 51	  | Asia
-- 58	  | Africa

```sql
(SELECT count(*) AS total, b.name as "Continent" FROM country a
INNER JOIN continent b ON a.continent = b.code 
WHERE b.name NOT IN ('South America', 'Central America', 'North America')
GROUP BY "Continent")
UNION
(SELECT count(*) AS total, 'America' as "Continent" FROM country a
INNER JOIN continent b ON a.continent = b.code 
WHERE b.name  IN ('South America', 'Central America', 'North America')
GROUP BY "Continent")
ORDER BY total ASC;
```
## Cual es el pais con mas ciudades 
-- Campos: total de ciudades y el nombre del pais con INNER JOIN
```SQL
SELECT count(*) AS total, a.name as "Country" FROM country a
INNER JOIN city b ON a.code = b.countrycode
GROUP BY "Country"
ORDER BY total DESC
LIMIT 1;
```

```SQL
SELECT count(*) as total, b.name as country FROM city a
INNER JOIN country b ON a.countrycode = b.code
GROUP BY country
ORDER BY total DESC
LIMIT 1;
```

## Multiples joins
-- Saber los idiomas oficiales que se hablan por continente?

```SQL
SELECT * FROM countrylanguage WHERE isofficial = true;
SELECT * FROM country;
SELECT * FROM continent;
```

```SQL
SELECT DISTINCT a."language", c."name" as continent FROM countrylanguage a
INNER JOIN country b ON a.countrycode = b.code
INNER JOIN continent c ON b.continent = c.code
WHERE a.isofficial = true
ORDER BY continent ASC;
```

```SQL
SELECT count(*) as total, continent FROM (SELECT DISTINCT d.code, c."name" as continent FROM countrylanguage a
INNER JOIN country b ON a.countrycode = b.code
INNER JOIN continent c ON b.continent = c.code
INNER JOIN language d ON a.language = d.name
WHERE a.isofficial = true
ORDER BY continent ASC) AS totales
GROUP BY continent
ORDER BY total ASC;
```

## Cuarta relacion 

```SQL
SELECT count(*) as total, continent FROM (SELECT DISTINCT a."language", c."name" as continent FROM countrylanguage a
INNER JOIN country b ON a.countrycode = b.code
INNER JOIN continent c ON b.continent = c.code
WHERE a.isofficial = true
ORDER BY continent ASC) AS totales
GROUP BY continent
ORDER BY total ASC;
```

## Cual es el idioma (y codigo de idioma) ofical mas hablado por diferentes paices de europa 
```SQL
SELECT count(*) as total, a."language", d.code FROM countrylanguage a
INNER JOIN country b ON a.countrycode = b.code
INNER JOIN continent c ON b.continent = c.code
INNER JOIN language d ON a.language = d.name
WHERE c.name = 'Europe' AND a.isofficial = true
GROUP BY a."language", d.code
ORDER BY total DESC
LIMIT 1;
```
