# Práctica: Docker Compose

## ¿Qué hemos hecho en esta tarea?

En esta tarea hemos modificado el archivo de configuración `compose.yml` integrándole una base de datos. 

Para ello, la he incorporado como servicio, para que use una imagen oficial de PostgreSQL y con las variables de entorno que crea una base de datos (`ejemplo`), un usuario (`usuario`), y el archivo secreto desde el que se leerá la contraseña.

También se ha montado una carpeta local dentro del contenedor en modo solo lectura, con tal de que el contenedor no modifique los archivos locales.

En cuanto al secreto, hemos declarado `pg_pass`, que contiene la contraseña que se montará en la ruta que pusimos anteriormente.

En resumen, este es mi código:

```
  db:
    image: postgres:16
    environment:
      POSTGRES_DB: ejemplo
      POSTGRES_USER: usuario
      POSTGRES_PASSWORD_FILE: /run/secrets/pg_pass
    volumes:
      - ./db-init:/docker-entrypoint-initdb.d:ro
    secrets:
      - pg_pass
```