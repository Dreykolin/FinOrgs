# FinOrgs

Tesorería para organizaciones pequeñas (centros de alumnos, directivas, clubes y agrupaciones): solicitudes de gasto, aprobaciones, fondos y un ledger contable transparente para todos los socios.

> **Estado:** en construcción, fase 1 (cimientos). Este README crece junto con el proyecto.

## El problema

En una organización chica, la plata la maneja una sola persona y el resto no ve nada. Los reembolsos se piden por chat, las boletas se pierden y el registro vive en una planilla. El resultado es desconfianza.

FinOrgs ordena ese flujo:

1. Un miembro **solicita** un reembolso, una compra directa o un anticipo, con su comprobante.
2. El tesorero lo **revisa** en su bandeja: lo aprueba, lo observa o lo rechaza.
3. Al **pagarse**, se genera un asiento contable inmutable.
4. Cualquier socio puede ver **saldos, montos aprobados y el historial completo**.

## Stack

| Capa | Tecnología |
|---|---|
| API | NestJS + TypeScript |
| Base de datos | PostgreSQL |
| Archivos | MinIO (compatible con S3) |
| Web | React |
| Infraestructura local | Docker Compose |
| CI | GitHub Actions |

## Estructura

```
api/    API NestJS: monolito modular con dominio hexagonal
web/    Frontend React
docs/   Decisiones de arquitectura (ADR) y diagramas
```

## Decisiones de arquitectura

Las decisiones relevantes se registran como ADR en [`docs/adr/`](docs/adr/).

## Licencia

[MIT](LICENSE)
