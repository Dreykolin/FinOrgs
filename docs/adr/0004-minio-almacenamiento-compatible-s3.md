# 0004. MinIO como almacenamiento compatible con S3

- **Estado:** Aceptada
- **Fecha:** 2026-11-11

## Contexto

Las solicitudes llevan comprobantes: fotos o archivos de boletas y facturas. Hay que decidir dónde guardarlos.

Los comprobantes son privados por organización: solo deben verlos quienes tienen permiso. Además, el proyecto debe poder levantarse completo en un computador, sin costo de nube (ADR 0005).

## Decisión

Los archivos se guardan en **MinIO**, un almacén de objetos con la API de S3, que corre en local con Docker Compose.

- El código habla con un **puerto de almacenamiento** (`AlmacenamientoArchivos`), definido en la capa de aplicación. MinIO es un adaptador de ese puerto, según el ADR 0002.
- La base de datos **no guarda los archivos**: solo la clave del objeto (`storage_key`) y su hash `sha256`.
- Los archivos se sirven con **URLs firmadas de corta duración** (minutos), emitidas solo a quien tiene permiso.
- Los comprobantes de una solicitud aprobada no se reemplazan.

## Alternativas descartadas

- **Guardar los archivos dentro de PostgreSQL.** Es más simple y mantiene una sola transacción, pero hace crecer la base de datos, vuelve más lentos los respaldos y las réplicas, y obliga a que cada descarga pase por la API.
- **Una carpeta en el servidor.** No sobrevive a contenedores efímeros, no escala a varias instancias y no ofrece URLs firmadas.
- **S3 de AWS desde el inicio.** Exige una cuenta de nube y puede generar costos, lo que contradice el ADR 0005.

## Consecuencias

**A favor**
- Portabilidad: pasar a S3 real es cambiar el adaptador, sin tocar el dominio ni los casos de uso.
- Los archivos salen directo del almacén al navegador, sin cargar la API, y el acceso expira solo.
- La base de datos se mantiene liviana y rápida.
- Todo el entorno sigue levantándose con `docker compose up`, sin costo.

**En contra**
- El archivo y la fila de la base de datos ya no forman una sola transacción: puede quedar un archivo huérfano (subido, pero sin solicitud guardada) o una referencia sin archivo.
- Hay un servicio más que operar en local.
- Se necesita un trabajo del worker que limpie archivos huérfanos.
