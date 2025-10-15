## Fechas -Date -DateTime -Funciones e intervalos de tiempo

## Para comenzar creamos las base de datos:
Usamos la tabla 01-estructura.sql

## Importamos los datos
Usamos la tabla 02-datos.sql

## Funciones de fechas

```SQL 
SELECT 'Fernando' as nombre;
```

Traer el total de empleados y la suma de salarios
```SQL
SELECT 
(SELECT count(*) FROM employees) as total,
(SELECT SUM(salary) FROM employees) as suma_salarios;
```

## USO DEL NOW()
Devuelve la fecha y hora actual de la base de datos.

```SQL
SELECT NOW();
```

## Current Date
Devuelve la fecha actual de la base de datos.
```SQL
SELECT CURRENT_DATE;
```

## Current Time
Devuelve la hora actual de la base de datos.
```SQL
SELECT CURRENT_TIME;
```

## Current user
Devuelve el usuario actual de la base de datos.
```SQL
SELECT CURRENT_USER;
```

## Date part
Devuelve una parte de la fecha.
```SQL
SELECT 
    DATE_PART('year', NOW()) as anio,
    DATE_PART('month', NOW()) as mes,
    DATE_PART('day', NOW()) as dia,
    DATE_PART('hour', NOW()) as hora,
    DATE_PART('minute', NOW()) as minuto,
    DATE_PART('second', NOW()) as segundo;
```

## Consultas con fechas
```SQL
    
SELECT * FROM employees
WHERE hire_date > '1998-02-05'
ORDER BY hire_date;
```

Es lo mismo que:
```SQL
SELECT * FROM employees
WHERE hire_date > date ('1998-02-05')
ORDER BY hire_date;
```

## Funciones agregas 

El empleado mas nuevo y el mas antiguo
```SQL
SELECT 
    MIN(hire_date) as mas_antiguo,
    MAX(hire_date) as mas_nuevo
FROM employees;
```
Traer empleador entre fechas 
```SQL
SELECT * FROM employees
WHERE hire_date BETWEEN '1999-01-01' AND '2000-01-01'
ORDER BY hire_date DESC;
```
## Intervalos de tiempo

Sumar dias, horas, mes, year, etc.


Sumar un dia a la fecha mas reciente
```SQL
SELECT 
    MAX(hire_date) + 1
FROM employees;
```

Sumar un mes a la fecha mas reciente
```SQL
SELECT 
    MAX(hire_date) + INTERVAL '1 month'
FROM employees;
```

Sumar 1.5 año a la fecha mas reciente
```SQL
SELECT 
    mas_ante,
    mas_ante + INTERVAL '6 month' as mas_nuevo 
FROM (
    SELECT MAX(hire_date) + INTERVAL '1 year' as mas_ante
    FROM employees
) t;
```

O 

```SQL
SELECT 
    MAX(hire_date) + INTERVAL '1 year' as mas_ante, 
    MAX(hire_date) + INTERVAL '1 year' + INTERVAL '6 month' as mas_nuevo 
FROM employees;
```

## Make interval
Determina el intervalo entre dos fechas, y permite agregarlo a una fecha.
```SQL
SELECT 
    MAX(hire_date),
    DATE_PART('year', NOW()),
    MAKE_INTERVAL(YEARS := DATE_PART('year', NOW())::INTEGER),
    MAX(hire_date) + MAKE_INTERVAL(YEARS := DATE_PART('year', NOW())::INTEGER)
FROM employees;
```

Lo correcto seria:
```SQL
SELECT 
    MAX(hire_date),
    DATE_PART('year', NOW()),
    MAKE_INTERVAL(YEARS := (DATE_PART('year', NOW()) - DATE_PART('year', MAX(hire_date)))::INTEGER),
    MAX(hire_date) + MAKE_INTERVAL(YEARS := (DATE_PART('year', NOW()) - DATE_PART('year', MAX(hire_date)))::INTEGER)
FROM employees;
```

## Diferencia entre fechas

Scar la diferencia en años entre la fecha actual y la fecha de contratacion el empleado mas antiguo
```SQL
SELECT
	(DATE_PART('year', NOW()) - DATE_PART('year', MIN(hire_date)))
	::INTEGER as diff_years
FROM employees;
```

Se puede hacer tambien asi, para todos:
```SQL
SELECT
    hire_date,
    MAKE_INTERVAL(YEARS := DATE_PART('year', NOW())::INTEGER  - EXTRACT(YEARS FROM hire_date)::INTEGER)
FROM employees;
```
Actualizar la base de datos el hire date numero de años de antiguedad, para todos los empleados 
```SQL
UPDATE employees
SET hire_date = hire_date + MAKE_INTERVAL(YEARS := DATE_PART('year', NOW())::INTEGER  - EXTRACT(YEARS FROM hire_date)::INTEGER);
```

Actualizar la base de datos el hire date numero de años de antiguedad, para todos los empleados 
```SQL
UPDATE employees
SET hire_date = MAKE_INTERVAL(YEARS := (DATE_PART('year', NOW()) - DATE_PART('year', hire_date))::INTEGER);
```

Verificar la actualizacion
```SQL
SELECT * FROM employees;
```

## CASE - THEN 
Por cada tiempo de empleado, clasificarlo en:
- Nuevo si es menor a 1 año
- Experto si es mayor a 5 años
- Semi experto si es mayor a 3 años y menor a 5 años
- Novato si es menor a 3 años
```SQL
SELECT
    first_name,
    last_name,
    hire_date,
    CASE
        WHEN (DATE_PART('year', NOW()) - DATE_PART('year', hire_date))::INTEGER < 1 THEN 'Nuevo'
        WHEN (DATE_PART('year', NOW()) - DATE_PART('year', hire_date))::INTEGER > 5 THEN 'Experto'
        WHEN (DATE_PART('year', NOW()) - DATE_PART('year', hire_date))::INTEGER > 3 THEN 'Semi experto'
        ELSE 'Novato'
    END as categoria
FROM employees;
```

Con intervalo de tiempo
```SQL
SELECT
    first_name,
    last_name,
    hire_date,
    CASE
        WHEN hire_date > now() - INTERVAL '1 year' THEN  'Nuevo'
        WHEN hire_date > now() - INTERVAL '5 year' THEN  'Experto'
        WHEN hire_date > now() - INTERVAL '3 year' THEN  'Semi experto'
        ELSE 'Novato'
    END as categoria
FROM employees;
```