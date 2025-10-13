# Separación de data en otras tablas

## Temas puntuales de la sección
Esta sección tiene por objetivo realizar labores cotidianas que sucederán si ustedes tienen que darle mantenimiento a alguna tabla o base de datos.


Puntualmente veremos:
- Actualizaciones masivas
- Creación y volcado de información
- Alteración de índices y checks
- Eliminación de checks
- Modificación de columnas mediante GUI y manualmente
- Creación de tablas
- Relaciones
- Alteración de índices y checks
- Eliminación de checks
- Modificación de columnas mediante GUI y manualmente
- Creación de tablas

Relaciones
El objetivo es darles a ustedes dos ejercicios, el cual el primero lo haremos juntos y el segundo será una aventura para que ustedes experimenten de primera mano este trabajo.

Debemos eliminar primero las dependencias es decir las tablas con las llaves foráneas.
```sql
DROP TABLE city;
DROP TABLE countrylanguage;
DROP TABLE country;
```

Cargamos los datos de la base de datos world-db-complete.sql
```sql
\i world-db-complete.sql
```

## Tabla continentes

Primero verificamos todas las tablas agregadas:
```sql
SELECT * FROM city;
SELECT * FROM countrylanguage;
SELECT * FROM country;
```

Seleccionamos los continentes :
```sql
SELECT DISTINCT continent FROM country
ORDER BY continent ASC; 
```
## Creamos una nueva tabla llamada continent
```sql
CREATE TABLE continent(
	code SERIAL PRIMARY KEY NOT NULL,
	name TEXT NOT NULL
);
```

Insertamos los continentes
```sql
INSERT INTO continent(name)
SELECT DISTINCT continent 
FROM country ORDER BY continent ASC;
```

Mostramos los continentes
```sql
SELECT * FROM continent;
```
## Realizaremos la relacion entre country y continent

Si la tabla esta en produccion debemos realizar una respaldo de la base de datos. 

Creamos una copia de la copia de la tabla country, con un script de creacion.

```sql
-- Table Definition
CREATE TABLE "public"."country_bk" (
    "code" bpchar(3) NOT NULL,
    "name" text NOT NULL,
    "continent" text NOT NULL CHECK ((continent = 'Asia'::text) OR (continent = 'South America'::text) OR (continent = 'North America'::text) OR (continent = 'Oceania'::text) OR (continent = 'Antarctica'::text) OR (continent = 'Africa'::text) OR (continent = 'Europe'::text) OR (continent = 'Central America'::text)),
    "region" text NOT NULL,
    "surfacearea" float4 NOT NULL CHECK (surfacearea >= (0)::double precision),
    "indepyear" int2,
    "population" int4 NOT NULL,
    "lifeexpectancy" float4,
    "gnp" numeric(10,2),
    "gnpold" numeric(10,2),
    "localname" text NOT NULL,
    "governmentform" text NOT NULL,
    "headofstate" text,
    "capital" int4,
    "code2" bpchar(2) NOT NULL,
    PRIMARY KEY ("code")
);
```

Volcamos toda la información de la tabla country a la tabla country_bk
```sql
INSERT INTO country_bk
SELECT * FROM country;
```
Verificamos que se hayan volcado los datos
```sql
SELECT * FROM country_bk;
```

Para comenzar a  relacionar la tabla country con la tabla continent, debemos eliminar el check de la tabla country_bk
```sql
ALTER TABLE country
DROP CONSTRAINT country_continent_check;
```

Verificamos las relaciones correctas de la tabla country con la tabla continent
```sql
SELECT 
	a.name, a.continent, 
	(SELECT "code" FROM continent b WHERE b.name = a.continent)
FROM country a;
```


Realizar la actualizacion masiva para actualizar la columna continent de la tabla country con el valor de la tabla continent
```sql
UPDATE country a
SET continent = (SELECT "code" FROM continent b WHERE b.name = a.continent);
```

Cambiamos el tipo de de dato de la columna continent de la tabla country a int4
```sql
AlTER TABLE country
ALTER COLUMN continent TYPE int4
USING continent::INTEGER;
```
Agregamos la relacion entre country y continent
```sql
ALTER TABLE country
ADD CONSTRAINT country_continent_fk
FOREIGN KEY (continent) REFERENCES continent (code);
```
 
Como no usamos la tabla country_bk debido a que no fallo nuestra relacion, la eliminamos
```sql
DROP TABLE country_bk;
```
## Tarea 

-- Tarea con countryLanguage

-- Crear la tabla de language

-- Sequence and defined type
```sql
CREATE SEQUENCE IF NOT EXISTS language_code_seq;
```

-- Table Definition
```sql
CREATE TABLE "public"."language" (
    "code" int4 NOT NULL DEFAULT 	nextval('language_code_seq'::regclass),
    "name" text NOT NULL,
    PRIMARY KEY ("code")
);
```
-- Crear una columna en countrylanguage
```sql
ALTER TABLE countrylanguage
ADD COLUMN languagecode varchar(3);
```

-- Empezar con el select para confirmar lo que vamos a actualizar
```sql
SELECT * FROM countrylanguage;
```
--LENGUAJES UNICOS
```sql
SELECT DISTINCT language FROM countrylanguage
ORDER BY language ASC;
```
-- Insertar los lenguajes unicos en la tabla language
```sql
INSERT INTO language(name)
SELECT DISTINCT language FROM countrylanguage
ORDER BY language ASC;
```
-- Verificar que se hayan insertado los lenguajes unicos
```sql
SELECT * FROM language;
```

Subconsulta puede acceder correctamente al campo language de la tabla countrylanguage usando el alias a.
```SQL
SELECT 
	a.countrycode, a.language, 
	(SELECT b.name FROM language b  WHERE name = a.language)
FROM countrylanguage a;
```
Lo verificamos con el codigo
```SQL
SELECT 
	a.countrycode, a.language, 
	(SELECT b.code FROM language b  WHERE name = a.language)
FROM countrylanguage a;
```

-- Actualizar todos los registros
```sql
UPDATE countrylanguage a
SET languagecode = (
    SELECT b.code FROM language b  WHERE name = a.language
);
```
Verificamos que se hayan actualizado los registros
```sql
SELECT * FROM countrylanguage;
```

-- Cambiar tipo de dato en countrylanguage - languagecode por int4
```sql
ALTER TABLE countrylanguage
ALTER COLUMN languagecode TYPE int4
USING languagecode::INTEGER;
```

-- Crear el forening key y constraints de no nulo el language_code
```sql
ALTER TABLE countrylanguage
ADD CONSTRAINT countrylanguage_languagecode_fk
FOREIGN KEY (languagecode) REFERENCES language (code);
```

-- Revisar lo creado
```sql
SELECT * FROM countrylanguage;
```
