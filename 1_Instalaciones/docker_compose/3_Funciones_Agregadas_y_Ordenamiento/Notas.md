### Temas puntuales de la sección
Esta sección tiene por objetivo aprender a realizar agrupaciones, conteos y en general poder extraer información de tablas mediante queries.

Puntualmente veremos:

Aggregation Functions

Count

Min

Max

Avg

Group By

Round

Between

Introducción a subqueries

Distinct

Agrupaciones por partes de strings

Esta sección se preocupará en ayudarlos a poder generar estadísticas que pueden llegar a necesitar a la hora de crear reportes o brindar información a quien lo solicite de una forma digerible y eficiente.

## Agregar los datos

Debemos ejecutar el archivo `31-user-table.sql` para agregar los datos a la tabla `users`.

Para verificar que se agregaron los datos, podemos ejecutar la siguiente query:

```sql
SELECT * FROM users;
```

Tareas realizar los siguientes queries:

-- Nombre, apellido e IP, donde la ultima conexion se dio de 221.XXX.XXX.XXX
```sql
SELECT first_name, last_name, last_connection
FROM users
WHERE last_connection LIKE '221.%';
```

-- Nombre apellido y seguidores(followers) de todos a los que lo siguen mas de 4600 personas
```sql
SELECT first_name, last_name, followers
FROM users
WHERE followers > 4600;
```
## Operador between
El operador between nos permite verificar si un valor se encuentra entre dos valores.



```sql
SELECT first_name, last_name, followers
FROM users
WHERE followers >= 4600 AND followers <= 4700
ORDER BY followers ASC;
```
La instruccion de arriba es equivalente a la de abajo, pero más concisa.

```sql
SELECT first_name, last_name, followers
FROM users
WHERE followers BETWEEN 4600 AND 4700
ORDER BY followers ASC;
```
## Funciones agregadas MAX, MIN COUNT, ROUND, AGV

### MAX
La función max nos permite obtener el valor máximo de una columna.
```sql
-- Obtener el máximo número de seguidores
SELECT MAX(followers) AS max_followers
FROM users;
```
### MIN
La función min nos permite obtener el valor mínimo de una columna.
```sql
-- Obtener el mínimo número de seguidores
SELECT MIN(followers) AS min_followers
FROM users;
```
### COUNT
Saber cuantos usuarios hay en la tabla.
```sql
SELECT COUNT(*) AS total_users
FROM users;
```
## AVG
La función avg nos permite obtener el valor promedio de una columna.
```sql
-- Obtener el promedio de seguidores
SELECT ROUND(AVG(followers), 2) AS avg_followers
FROM users;
```
```SQL
-- Obtener el promedio de seguidores
SELECT ROUND(SUM(followers) / COUNT(*), 2) AS avg_followers
FROM users;
```

### Juntos
Podemos combinar las funciones agregadas con las de ordenamiento para obtener información más detallada.

```sql
SELECT 
    COUNT(*) AS total_users,
    MAX(followers) AS max_followers,
    MIN(followers) AS min_followers,
    ROUND(AVG(followers), 2) AS avg_followers
FROM users;
```

## GROUP BY
La cláusula group by nos permite agrupar los resultados de una query por una o más columnas.

Saber las personas con mas seguidores:
```sql
SELECT first_name, last_name, MAX(followers) AS max_followers
FROM users
WHERE followers = (SELECT MAX(followers) FROM users)
GROUP BY first_name, last_name;
```

Saber las personas con menos seguidores:
```SQL
SELECT first_name, last_name, MIN(followers) AS min_followers
FROM users
WHERE followers = (SELECT MIN(followers) FROM users)
GROUP BY first_name, last_name;
```
Contar las personas con mas y menos seguidores:

```sql
SELECT COUNT(*), followers
FROM users 
WHERE followers = (SELECT MAX(followers) FROM users)
or 
followers = (SELECT MIN(followers) FROM users)
GROUP BY followers;
```

## Exposicion y terminologia
- Aggregation Functions: Funciones que permiten realizar operaciones sobre un conjunto de valores y devolver un único valor.
- Count: Funcion que cuenta la cantidad de filas en una tabla.
- Max: Funcion que devuelve el valor máximo de una columna.
- Min: Funcion que devuelve el valor mínimo de una columna.
- Group By: Cláusula que agrupa los resultados de una consulta por una o más columnas.
- Having: Cláusula que filtra los resultados de una consulta agrupada.
- Order By: Cláusula que ordena los resultados de una consulta por una o más columnas.

- Filtrado de datos: Cláusula que filtra los resultados de una consulta por una o más condiciones.
- Like: Operador que verifica si una cadena de texto contiene un patrón específico.
- IN: Operador que verifica si un valor se encuentra en una lista de valores.
- IS NULL: Operador que verifica si un valor es nulo.
- AND: Operador lógico que verifica si dos condiciones son verdaderas.
- OR: Operador lógico que verifica si alguna de dos condiciones es verdadera.
- NOT: Operador lógico que niega el resultado de una condición.
- WHERE: Cláusula que filtra los resultados de una consulta por una o más condiciones.
- BETWEEN: Operador que verifica si un valor se encuentra entre dos valores.

## Estructura de un select
```sql
SELECT column1, column2, alias, ...
FROM table_name
WHERE condition, like, in, is null, and, or, not
GROUP BY column1, column2, ...
HAVING condition 
ORDER BY expression [ASC | DESC], ...
LIMIT number
OFFSET punto_de_partida
```


- DDL: Data Definition Language. Lenguaje de definición de datos. Permite crear, modificar y eliminar objetos de la base de datos.
- DML: Data Manipulation Language. Lenguaje de manipulación de datos. Permite insertar, actualizar y eliminar datos en una tabla.
- TCL: Transaction Control Language. Lenguaje de control de transacciones. Permite controlar el inicio, commit y rollback de transacciones.
- DQL: Data Query Language. Lenguaje de consulta de datos. Permite recuperar datos de una tabla.

## Having
El having es similar al where, pero se usa para filtrar los resultados de una consulta agrupada.

Ser el numero de personas por pais
```sql
SELECT country, COUNT(*)
FROM users 
GROUP BY country
ORDER BY COUNT(*) DESC;
```

Solo los paises con mas de 5 personas
```sql
SELECT 
	country,
	COUNT(*) AS total_users
FROM users
GROUP BY country
HAVING COUNT(*) > 5
ORDER BY COUNT(*) DESC;
```

Paises com poblaciones entre 5 y 7 personas
```sql
SELECT 
	country,
	COUNT(*) AS total_users
FROM users
GROUP BY country
HAVING COUNT(*) BETWEEN 5 and 7
ORDER BY COUNT(*) DESC;
```

## DISTINC
La cláusula distinct permite obtener los valores únicos de una columna.
```sql
SELECT DISTINCT country
FROM users;
```

## GROUP BY con otras funciones 

Obtener los dominios de correos electronicos
```SQL
SELECT 
    email,
    SUBSTRING(email FROM POSITION('@' IN email) + 1) AS domain
FROM users;
```
Obtener los dominios de correos electronicos y saber cuantos usuarios tienen cada dominio Y solo los que tienen mas de 1 usuario
```sql
SELECT 
	COUNT(*) AS total_users,
	SUBSTRING(email FROM POSITION('@' IN email) + 1) AS domain
FROM users
GROUP BY domain
HAVING COUNT(*) > 1
ORDER BY total_users DESC;
```

## SUBQUERIES
Una subconsulta es una consulta dentro de otra consulta. Permite realizar operaciones más complejas y obtener resultados más precisos.

```SQL
SELECT * FROM Tabla A WHERE (SUB QUERY FROM TABLE B);
```
Son altamente ineficientes, por lo que se debe evitar su uso en consultas grandes.

```SQL
SELECT 
    *
FROM 
    (
        SELECT 
	        COUNT(*) AS total_users,
	        SUBSTRING(email FROM POSITION('@' IN email) + 1) AS domain
        FROM users
        GROUP BY domain
        HAVING COUNT(*) > 1
        ORDER BY total_users DESC
    )
AS domains_users;
```

Contar el total de usuarios en los dominios obtenidos
```sql
SELECT 
    SUM(total_users) AS total_users
FROM 
    (
        SELECT 
	        COUNT(*) AS total_users,
	        SUBSTRING(email FROM POSITION('@' IN email) + 1) AS domain
        FROM users
        GROUP BY domain
        HAVING COUNT(*) > 1
        ORDER BY total_users DESC
    )
AS domains_users;
```

### Tarea

-- 1. Cuantos usuarios tenemos con cuentas @google.com
-- Tip: count, like
```sql
SELECT 
    COUNT(*) AS total_users
FROM 
    users
WHERE 
    email LIKE '%@google.com';
```

-- 2. De qué países son los usuarios con cuentas de @google.com
-- Tip: distinct
```sql
SELECT 
    DISTINCT country,
FROM
    users
WHERE
    email LIKE '%@google.com';
```

-- 3. Cuantos usuarios hay por país (country)
-- Tip: Group by
```SQL
SELECT 
	country,
	COUNT(*) AS total_users
FROM
	users
GROUP BY 
	country
ORDER BY total_users DESC;
```

-- 4. Listado de direcciones IP de todos los usuarios de Iceland
-- Campos requeridos first_name, last_name, country, last_connection

```sql
SELECT 
    first_name,
    last_name,
    country,
    last_connection
FROM 
    users 
WHERE 
    country = 'Iceland';
```

-- 5. Cuantos de esos usuarios (query anterior) tiene dirección IP
-- que incia en 112.XXX.XXX.XXX

```sql
SELECT COUNT(*) AS total_users
FROM users 
WHERE country = 'Iceland'
  AND last_connection LIKE '112.%';
```

-- 6. Listado de usuarios de Iceland, tienen dirección IP
-- que inicia en 112 ó 28 ó 188
-- Tip: Agrupar condiciones entre paréntesis 
```sql
SELECT 
	first_name,
	last_name,
	country,
	last_connection
FROM 
	users
WHERE
	country =  'Iceland'
    AND (
    last_connection LIKE '112.%'
    OR
    last_connection LIKE '28.%'
    OR
    last_connection LIKE '188.%'
  	); 
```
-- 7. Ordenar el resultado anterior por apellido (last_name) ascendente y luego el first_name ascendente
```sql
SELECT 
	first_name,
	last_name,
	country,
	last_connection
FROM 
	users
WHERE
	country =  'Iceland'
    AND (
    last_connection LIKE '112.%'
    OR
    last_connection LIKE '28.%'
    OR
    last_connection LIKE '188.%'
  	)
ORDER BY
	last_name ASC,
	first_name ASC;
```
-- 8. Listado de personas cuyo pais esta en este listado
-- (Mexico, Honduras, Costa Rica)
-- Ordenar los resultados por pais asc, primer nombre asc, apellido asc, usar in

```sql
SELECT 
	first_name,
	last_name,
	country,
	last_connection
FROM 
	users
WHERE
	country in ('Mexico', 'Honduras', 'Costa Rica')
ORDER BY
	country ASC,
	first_name ASC,
	last_name ASC;
```

-- 9. Del listado anterior cuantas personas hay por pais

```sql
	
SELECT 
	country, 
	count(*) AS total_users
FROM 
	users
WHERE
	country in ('Mexico', 'Honduras', 'Costa Rica')
GROUP BY
	country
ORDER BY total_users DESC;
```