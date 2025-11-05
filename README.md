# Práctica: Docker Compose

Arrancas con un `docker compose` que solo levanta el servicio web de Apache. Tu objetivo es completar la configuración para integrar una base de datos PostgreSQL que trabaje junto al sitio web.

## Tarea: Añade el servicio `db`

Modifica `compose.yml` e incorpora un servicio `db` basado en la imagen oficial `postgres:16`. Asegúrate de:

- Declarar las variables necesarias en la sección `environment` (nombre de la base de datos, usuario y ruta al fichero de contraseña de la bd que inyectarás como secreto).
- Montar la carpeta `./db-init` dentro del contenedor en el directorio de inicialización (`/docker-entrypoint-initdb.d`, en modo solo lectura) para que se ejecuten automáticamente los scripts SQL suministrados la primera vez que arranque el contenedor.
- Conectar el servicio a un secreto con la contraseña de la base de datos a través de la sección `secrets`.
