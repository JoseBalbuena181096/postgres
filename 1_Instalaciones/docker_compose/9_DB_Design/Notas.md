
## Temas puntuales de la sección
Esta sección está diseñada para practicar el diseño y creación de una base de datos, junto a su diagrama de entidad-relación.

- Puntualmente veremos:
- Programas para diseñar bases de datos
- Exportar diagramas a PostgresSQL y otros
- Crear relaciones de forma visual
- Tipos de datos
- Identities
- Estructuras
- Consultas posibles
- Diversas funcionalidades necesarias

Y más
El objetivo principal, es que podamos tener una comprensión de forma visual, del ¿cómo? y ¿por qué? de cada tabla, relación e indice.

## Diagrama de entidad-relación
Luego de diseñar la base de datos, es necesario crear su diagrama de entidad-relación. Este diagrama nos ayudará a visualizar la estructura de la base de datos, y a entender las relaciones entre las tablas.
Sirve para ver como se relacionan las tablas, y como se accede a los datos.

Para leerlo simpre se recomienda:
- Empezar a buscar las tablas con mas peso, como usuarios, productos, los que tienen mas relaciones.
- O analizar las que tienen menos relaciones, como direcciones, telefono, los que tienen menos peso.
- Al ver las relaciones podemos ver como realizar queries, y como se cruza la información entre las tablas.
 
# Software para hacer diagramas entidad relación
### Algunos son gratuitos, otros pagados

Información extraída de [HolisticsBlog](https://www.holistics.io/blog/top-5-free-database-diagram-design-tools/) 

1. [dbdiagram.io](https://dbdiagram.io/home)
2. [Diagrams.net (formerly Draw.io)](https://app.diagrams.net/)
3. [Lucidchart](https://www.lucidchart.com/pages/)
4. [QuickDBD](https://www.quickdatabasediagrams.com/)
5. [ERDPlus](https://erdplus.com/)
6. [Cacoo](https://nulab.com/cacoo/examples/database-diagrams-er-diagram-tool/)
7. [Drawsql.app](https://drawsql.app/)
8. [Miro](https://miro.com/)
9. [gliffy](https://www.gliffy.com/solutions/diagrams-for-software-engineering)
10. [Creately](https://creately.com/)

## Medium database
Vamos hacer un ejemplo de base de datos, simular a la red social medium. Al crear una base de datos crear lo minimo nesesario preferentemente.


``` 
Table users {
  user_id integer [pk, increment] 
  username varchar [not null, unique]
  email varchar [not null, unique]
  password varchar [not null]
  name varchar [not null]
  role varchar [not null]
  gender varchar(10) [not null]
  avatar varchar

  created_at timestamp [default: 'now()']

  // indexes {
  //   (username)[unique]
  // }
}

Table posts {
  post_id integer [pk, increment]
  title varchar(200) [default: '']
  body text [default: '']
  og_image varchar
  slug varchar [not null, unique]
  published boolean

  created_by integer
}

Table claps {
  clap_id integer [pk, increment]
  post_id integer
  user_id integer
  counter integer [default: 0]

  created_at timestamp

  indexes {
    (post_id, user_id) [unique]
    (post_id)
  }
}


Table comments {
  comment_id integer [pk, increment]
  post_id integer
  user_id increment
  content text
  created_at timestamp
  visible boolean

  comment_parent_id integer

  indexes {
    (post_id)
    (visible)
  }
}


Table user_lists {
  user_list_id integer [pk, increment]
  user_id integer
  title varchar(100)

  indexes {
    (user_id, title) [unique]
    (user_id)
  }
}

Table user_list_entry {
  user_list_entry integer [pk, increment]
  user_list_id integer
  post_id integer
}




Ref: "users"."user_id" < "posts"."created_by"

Ref: "posts"."post_id" < "claps"."post_id"

Ref: "users"."user_id" < "claps"."user_id"

Ref: "posts"."post_id" < "comments"."comment_id"

Ref: "users"."user_id" < "comments"."user_id"

Ref: "comments"."comment_id" < "comments"."comment_parent_id"

Ref: "users"."user_id" < "user_lists"."user_id"

Ref: "user_lists"."user_list_id" < "user_list_entry"."user_list_id"

Ref: "posts"."post_id" < "user_list_entry"."post_id"

```

Common table expressions:
Los common table expressions (CTE) son una forma de crear una tabla temporal dentro de una consulta.
Estas tablas temporales solo existen durante la ejecución de la consulta, y luego se eliminan.
Esto nos permite dividir una consulta compleja en varias partes más sencillas, y mejorar la legibilidad y mantenibilidad del código.

# Nota lo mas valioso de la empresa es la data, se puede perder todo menos la base de datos o los datos de la empresa.

### Preguntamos consultas posibles
Realizar todas las preguntas que haria la empresa sobre la base de datos. Para poder responderlas, es necesario tener en cuenta las relaciones entre las tablas, y los tipos de datos. Asi mismo, es necesario tener en cuenta los indices, y las claves primarias y foraneas.

## Indices nesesarios
Para mejorar el rendimiento de las consultas, es necesario crear indices sobre las columnas que se utilizan en las cláusulas WHERE, JOIN, y ORDER BY.
Estos indices nos permiten acceder rápidamente a los datos necesarios, y reducir el tiempo de respuesta de las consultas. Pero solo se deben colocar donde es necesario.

Antes de crear la base de datos con el script generado por dbdiagram.io es necestio borrar todo lo anterior:
```SQL
SELECT * FROM pg_extension;
DROP EXTENSION "uuid-ossp";
```

Esto forza a eliminar la tabla con todo y sus relaciones.
```SQL
DROP TABLE employees CASCADE;
```