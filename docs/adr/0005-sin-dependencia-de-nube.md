# 0005. Sin dependencia de servicios de nube en el núcleo

- **Estado:** Aceptada
- **Fecha:** 2026-11-11

## Contexto

FinOrgs es un proyecto personal, sin ingresos que respalden costos variables. Debe poder desarrollarse y probarse por completo en un computador, y poder publicarse con un costo fijo y predecible.

Los servicios gestionados de un proveedor de nube (bases de datos, almacenamiento, funciones, colas) tienen costo variable que puede sorprender, crean dependencia de un proveedor y no se pueden levantar completos en local. El autor ya cuenta con un VPS.

## Decisión

El núcleo del proyecto **no depende de servicios gestionados de ningún proveedor de nube**. Todo el sistema (API, worker, PostgreSQL, MinIO y la web) corre con Docker Compose, y funciona igual en un computador local que en un servidor.

Si el proyecto se publica, se despliega en el VPS existente, con el mismo `docker compose` que se usa en local.

Esto no excluye la nube a futuro: los puertos del ADR 0002 permiten sumar adaptadores de un proveedor si algún día hace falta.

## Alternativas descartadas

- **Servicios gestionados de AWS desde el inicio** (RDS, S3, Lambda). Es la ruta habitual en producción, pero introduce costo variable, dependencia del proveedor y obliga a tener una cuenta de nube para probar el proyecto.
- **Hosting compartido.** No permite ejecutar Node, PostgreSQL ni MinIO como procesos propios.

## Consecuencias

**A favor**
- Costo fijo y predecible, y ningún gasto necesario para desarrollar.
- El entorno local y el de publicación son el mismo: `docker compose up`.
- Sin dependencia de un proveedor concreto.
- Cualquiera puede clonar el repositorio y levantarlo sin cuenta de nube.

**En contra**
- No se practican servicios gestionados de AWS dentro del proyecto. Esa experiencia se cubre aparte, con la preparación de la certificación Solutions Architect Associate.
- Operar el VPS (actualizaciones, respaldos, HTTPS, firewall) es responsabilidad propia.
- Al ser el repositorio público y el servidor accesible desde internet, hay que mantener los secretos fuera del repositorio y cuidar la exposición del servidor.

## Cuándo reconsiderar

Si el proyecto llegara a tener usuarios reales con requisitos de disponibilidad, respaldos o escala que un único servidor no cubra, se evaluará mover piezas concretas a servicios gestionados, empezando por la base de datos y el almacenamiento. Se registrará en un ADR nuevo.
