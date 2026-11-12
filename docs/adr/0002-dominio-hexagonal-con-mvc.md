# 0002. Dominio hexagonal aislado de NestJS, con MVC como capa externa

- **Estado:** Aceptada
- **Fecha:** 2026-11-11

## Contexto

FinOrgs tiene reglas de negocio que importan: una máquina de estados para las solicitudes, separación de funciones (nadie aprueba lo propio), aprobar exactamente lo que se revisó, y un ledger con invariantes. Además, tiene una operación crítica que se dispara desde más de un lugar (la API y el worker).

La estructura por defecto de NestJS (controller → service → repository) tiende a mezclar las reglas con el acceso a datos dentro de los services, y a dejar las entidades como simples bolsas de datos (modelo anémico). Eso hace que probar una regla exija una base de datos o muchas simulaciones.

## Decisión

Cada módulo se divide en tres capas, con las dependencias apuntando hacia adentro:

- **`domain/`**: entidades ricas que protegen sus propias reglas, políticas y errores de dominio. TypeScript puro: no importa NestJS, Kysely ni nada de infraestructura.
- **`application/`**: casos de uso que coordinan, y los **puertos** (interfaces) que necesitan, como `SolicitudRepository`. Solo importa `domain/`.
- **`infrastructure/`**: los **adaptadores**: controllers HTTP, repositorios PostgreSQL, almacenamiento de archivos y el cableado de NestJS. Implementa los puertos.

Los puertos los define quien los necesita (la capa de aplicación), no quien los implementa.

**MVC es la estructura de la capa externa.** La Vista es el cliente (`web/` en React, y Android a futuro); el Controlador es el controller de NestJS, que valida el formato, llama a un caso de uso y arma la respuesta, sin reglas de negocio; el Modelo es lo que hay en `domain/` y `application/`, y no las tablas del ORM.

La regla de dependencias se verifica con lint en el CI.

## Alternativas descartadas

- **Estructura por defecto de NestJS (controller → service → repository).** Es más corta y todos la conocen, pero las reglas terminan acopladas a la base de datos y al framework, y se pierde la posibilidad de probarlas de forma aislada.
- **DDD completo con CQRS y event sourcing.** Excede lo que el problema necesita. Se toma de DDD lo que rinde (entidades ricas, puertos y adaptadores) sin el resto del aparato.

## Consecuencias

**A favor**
- Las reglas se prueban en milisegundos, sin base de datos ni Docker, lo que permite hacer TDD en el dominio.
- El dominio no depende de NestJS: las actualizaciones o cambios del framework se quedan en los bordes.
- Cada regla existe una sola vez, aunque se dispare desde la API o desde el worker.
- Cambiar un adaptador no toca el núcleo. Ya hay cambios previstos: MinIO por S3 (ADR 0004) y la cartola CSV por una API bancaria.

**En contra**
- Más archivos y traducción entre capas (controller, caso de uso, entidad y repositorio) que en el estilo por defecto de NestJS.
- Requiere disciplina para no filtrar dependencias hacia el dominio; el lint cubre ese riesgo.

## Cuándo reconsiderar

Si un módulo resulta no tener reglas de negocio propias (solo guardar y mostrar datos), puede simplificarse sin las tres capas. En ese caso se dejará constancia en el ADR que lo decida.
