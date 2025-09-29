## Temas puntuales de la sección
El objetivo de esta sección es empezar nuestro camino en las bases de datos con las sentencias más comunes y explicaciones generales para comprender a qué nos estamos metiendo.

Puntualmente veremos:

Queries
Creación de tablas
Drop / Truncate

SELECT
INSERT
DELETE
UPDATE

Funciones y operadores como:
Substring
Position
Concat
||
Constrains básicos
Serial
La idea principal es tener nuestra introducción en un ambiente controlado que nos permita jugar y aprender desde cero y poco a poco, ir escribiendo sentencias más específicas.

## Introduccion de Base de datos

### Que es una base de datos?
Una base de datos es una coleccion estructurada de informacion organizada y almacenada de manera sistematica en un sistema de gestion de base de datos (SGBD).

La forma de almacenar la informacion hace la diferecia, tenemos dos principales tipos de base de datos:

### SQL:
Son base de datos relacionales, almacena la informacion en tablas, estas tablas  tienen relaciones claras, estructuradas, estrictas y bien definidas unas con otras. Pueden lucir mucho como sheets de excel.

![relacionales](image.png)

### NoSQL:
Almacen la informacion en objetos que usalmente se llaman documentos. Este tipo de informacion luce similar a objetos JSON.

![relacionales](image-1.png)


## SQL

| SQL | Esquema predifinido| Consistencia | Almacenamiento | Indices |
|-----------|--------------|--------------|----------------|---------|
| significa | Antes de usarla | Enfoque | Forma | Velocidad |
| Structured Query Language | Se craean tablas con la estructura que usaremos de antemano | Se enfocan en garantizar integridad y consistencia de informacion  |    Se graban en forma de tablas y los regiatros en filas | Llaves primarias, foraneas, indices compuestos, etc |
| Todas estas base de datos ejecutan sentencias "queries" de forma similar | | | Tambien conocidos como entidades y atributos | Permite velocidades de transacciones |

### NoSQL

| Almacenamiento | Esquema flexible | Enfoque | Tolerancia | 
|----------------|------------------|---------|------------|
|   Docuementos  |  No es rigido    |  Rendimiento | A fallos |
| Usualmente conocidos como colecciones y documentos. La infromacion se almacena en estos objetos JSON | Puedes crear documentos y colecciones sin tener que definirlas | Escalabilidad horizontal, rendimiento, velocidad y disponibilidad | Gran flexibilidad permite una gran tolerancia a fallos y valores nulos o inexistentes. |

### Escalabilidad Horizontal
En lugar de comprar una computadora mas poderosa para almacenar mi base de datos, se crean otro nodo, la informacion esta no en un solo nodo, sino que se encuetra distribuida en diferentes nodos.

### Cual es mejor?
No hay una respuesta en concreto, Depende del uso, flexibilidad, vision, mision, no hay una restriccion en especifico que te impida irte por una SQL o NoSQL.

### SQL
Aprender a trabajar con base de datos relacionales, normalizacion, escribir queries y ensi, todo lo que se necesita para empezar a trabajar en cualquier base de datos relacional.


