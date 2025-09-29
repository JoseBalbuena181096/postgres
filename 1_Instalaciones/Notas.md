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