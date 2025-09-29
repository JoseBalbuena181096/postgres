### Notas de instalacion de PostgreSQL

Links de materiales:

https://gist.github.com/Klerith/591fff6e2a393f19beb698ed44f0aa5e


Descargar imágenes de Docker

docker pull postgres:15.3
docker pull dpage/

## Almacenamiento
Aqui donde almacenamos la base de datos de forma fisica de nuestro contenedor
volumes:
      - ./postgres:/var/lib/postgresql/data

## Levantamiento
Esto es para levantar nuestro contenedor con la base de datos:
-d es para que la base de datos que levantemos no este amarrada al la terminal que la levanta

```bash
docker compose up -d
```

### Bajar la base de datos
Uno puede realizar cambios en la configuracion de la base de datos, para realizarlo se en el compose se baja el contenedor y se vuelve a levantar

```bash
docker compose down
```

### Commit 
Una vez realizados cambios en table plus, se debe realizar un commit que es realizar los cambios y aplicarlos en la  base de datos, estos cambios estan en memoria al hacer el comit se aplican a la base de datos
En table plus es:

```
ctrl + s
```

## Para usar con pgAdmin postgres
Como dentro nuestro contenedor los dos contenedores el de postgres y el de pgAdmin estan conectados dentro del contenor por una red que docker conecta internamete el host name, debe tner el nombre como aparece en el docker compose el nombre de mi contenedor de la base de datos my-database

### Para eliminar una tabla seleccionamos
Drop cascade

Para recargar  y ver cambios en pgAdmin
```
ctrl + R
```
Para guardar cambios en pgAdmin click en Save Data Changes 
```
F6
```

Para realizar un commit en el script de SQL de pgAdmin
```
F5
```

### Base de datos postgres 
Para usar una base de datos serveless usamos neon, lo que quiere decir serveless es que nostros no tenemos ese servidor para que corra postgres.

### PSQL
Es para escribir codigo de postgres desde una terminal.
