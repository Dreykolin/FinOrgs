# Decisiones de arquitectura (ADR)

Cada archivo registra **una decisión técnica importante**: qué problema había, qué se eligió, qué se descartó y qué consecuencias tiene. El código muestra qué se hizo; los ADR explican por qué.

Reglas:
- Uno por decisión, numerado y en orden.
- No se editan una vez aceptados. Si cambia la decisión, se escribe un ADR nuevo que reemplaza al anterior y se marca el viejo como *Reemplazada*.
- Solo para decisiones difíciles de revertir.

| # | Decisión | Estado |
|---|---|---|
| [0001](0001-monolito-modular.md) | Monolito modular en vez de microservicios | Aceptada |
| [0002](0002-dominio-hexagonal-con-mvc.md) | Dominio hexagonal aislado de NestJS, con MVC como capa externa | Aceptada |
| [0003](0003-montos-bigint-y-ledger-doble-entrada.md) | Montos en bigint y ledger de doble entrada | Aceptada |
| [0004](0004-minio-almacenamiento-compatible-s3.md) | MinIO como almacenamiento compatible con S3 | Aceptada |
| [0005](0005-sin-dependencia-de-nube.md) | Sin dependencia de servicios de nube en el núcleo | Aceptada |
