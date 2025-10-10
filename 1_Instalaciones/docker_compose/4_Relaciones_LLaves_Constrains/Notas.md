## Temas puntuales de la sección
El objetivo de esta sección es comprender sobre las llaves que no son más que constraints (restricciones)



Puntualmente veremos:

Exposición sobre las relaciones de bases de datos

Exposición sobre las llaves y diferentes tipos de llaves

Checks de columnas y tablas

Indices

Llaves foráneas

Restricciones con las relaciones

Eliminaciones y actualizaciones en cascada

Otros tipos de acciones automáticas.

## Introducción a las relaciones

Cuando una base de datos lo mas seguro es que tengamos mas de una tabla,
en este caso, las relaciones entre las tablas son muy importantes.

### Tipos de relaciones:
- Uno a uno -> One to One (1:1)
- Uno a muchos -> One to Many (1:N)
- Relaciones a si mismas -> Self Joining Relationship
- Muchos a muchos -> Many to Many (N:M)

## Relaciones Uno a Uno
Tenemos una tabla por ejemplo students y tenemos un registro en contact_info del estudiante, solo puede aver un registro en contact_info por estudiante, es de uno a uno.
![uno a uno](image.png)

## Relaciones Uno a Muchos
Tenemos una tabla por ejemplo customers y tenemos un registro de varias orders del customer, puede haber muchas orders por customer, es de uno a muchos.
![uno a muchos](image_1.png)

## Relacion Self Joining

Por ejemplo puedo tener una tabla de usuarios, y puedo tener la informacion de que usuario modifica a otro usuario, es de relacion self joining, un usuario puede modificar a otro usuario, y puede haber muchos usuarios que modifiquen a otro usuario.
![self joining](image_2.png)

## Relaciones Muchos a Muchos
Ejemplo tenemos la tabla estudiantes, una tabla intermedia enrollments y una tabla cursos, un estudiante puede matricularse en muchos cursos, y un curso puede tener muchos estudiantes, es de relacion muchos a muchos.
Pero realmete la tabla intermedia enrollments tiene dos llaves foraneas, una a la tabla estudiantes y otra a la tabla cursos, y cada registro en la tabla intermedia enrollments es una matricula de un estudiante en un curso. Solo tenemos relaciones de uno a muchos en la tabla intermedia enrollments, y muchos a uno de la tabla enrollments a clases .
![muchos a muchos](image_3.png)

## En esta seccion estaremos trabajando

Con una estructrura de tres tablas la tabla country, la tabla city, la tabla countryLanguage, donde las relaciones son:
- country y city -> Uno a Muchos (1:N)
- country y countryLanguage -> Uno a Muchos (1:N)

![tabla de trabajo](image_4.png)

## Introducción a las llaves

Para que las relaciones de las base de datos se ocupan las llaves. Se puede trabajar sin llaves, pero eso no es recomendable, ya que las llaves ayudan a mantener la integridad referencial de la base de datos. La integridad referencial se refiere a la relacion entre las tablas, y las llaves ayudan a asegurar que los datos esten relacionados de manera correcta.
![llaves](image_5.png)

Tenemos diferentes tipos de llaves:
- Primary Key (PK)
- Foreign Key (FK)
- Super Key
- Candidate Key
- Composite Key

Hay mas y todas las llaves sirven para identificar registros.
Entre otras: Alternate keys, Artificial Keys.

Una llave no es mas que un constraint (restriccion) que ayuda a identificar registros unicos. Un constrain es solo una restriccion que se aplica a una columna o a varias columnas.

### Primary Key (PK)
-   Identifica un registro de forma unica.
-   Una table puede tener varios identificadores unicos.
-   La llave primaria esta basada en los requerimientos.

![llave primaria](image_6.png)

Los ID que se manejan en mi tabla, no debe depender de terceros, por que estas llaves prueden cambiar, es mejor tener un id idenpendiente controlado por nosotros.

### Candidate Key (CK)
-   Un atributo o cinjunto de ellos que identifica de forma unica
-   Menos la llave primaria, los demas se consideran claves candidatas.

![llave candidata](image_7.png)

### SuperKey
-   Es un conjunto de atributos que pueden identificar de forma unica un registro.
-   Puede contener mas de una llave candidata, es un super conjunto de una clave candidata, ejemplo (employee_id + full_name).
![super key](image_8.png)

### Foreign Key (FK)
-   LLaves foraneas son usadas para apuntar a la llave primaria de otra tabla
-   El departament_id en ambas tablas, debe ser del mismo tipo de datos y longitud. Esto se hace para asegurar integridad referencial.
![llave foranea](image_9.png)

### Composite Key
-   Cuando una clave primaria consta de mas de un atributo, se conoce como clave compuesta.
![llave compuesta](image_10.png)
