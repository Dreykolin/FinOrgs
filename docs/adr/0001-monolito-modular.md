# 0001. Monolito modular en vez de microservicios

- **Estado:** Aceptada
- **Fecha:** 2026-11-11

## Contexto

FinOrgs parte con un alcance acotado: solicitudes, fondos, un ledger contable y comprobantes. Lo desarrolla una persona y debe poder levantarse completo en un computador, sin costo de nube.

Las operaciones centrales, como aprobar o pagar una solicitud, tocan varios módulos y deben ser **atómicas**: o ocurre todo, o no ocurre nada. No puede quedar una solicitud aprobada sin que el fondo haya comprometido el monto.

Con una sola base de datos, eso es una transacción ACID. Con servicios separados, cada uno con su propia base, esa transacción no existiría: habría que coordinar los pasos y verificar el estado de cada uno (una *saga*), con reintentos idempotentes y compensaciones si algo falla a medias.

## Decisión

Se construye un **monolito modular**: una sola base de código y una sola base de datos, dividida en módulos con fronteras explícitas. Se despliega en dos procesos del mismo código: la **API** (peticiones HTTP) y el **worker** (trabajos en segundo plano).

Los módulos se comunican solo por interfaces públicas y nunca leen las tablas de otro. Las dependencias entre módulos no forman ciclos y se verifican con lint en el CI.

## Alternativas descartadas

- **Microservicios desde el inicio.** La aprobación pasaría a ser un proceso distribuido, con más código, más casos de error y más estados intermedios, justo lo que una tesorería no tolera. Además, habría que operar varios servicios sin que el producto lo justifique.
- **Monolito sin fronteras internas.** Es más simple hoy, pero con el tiempo cualquier cambio rompe partes no relacionadas y se cierra la posibilidad de evolucionar.

## Consecuencias

**A favor**
- Las operaciones críticas son transacciones simples, y el comportamiento ante fallos es fácil de razonar.
- Un solo artefacto y una sola versión: no hay que cuidar la compatibilidad entre servicios ni coordinar migraciones.
- Un solo entorno que operar y depurar: `docker compose up` levanta todo.
- Las fronteras entre módulos mantienen cada parte comprensible y probable por separado.

**En contra**
- Un módulo no puede escalar de forma independiente del resto.
- Todos los módulos comparten el mismo ciclo de despliegue.
- Mantener las fronteras requiere disciplina; por eso se verifican con lint en lugar de confiar en la buena voluntad.

## Cuándo reconsiderar

Se evaluará extraer un módulo como servicio separado, con lo que la arquitectura pasaría a ser híbrida, solo si ocurre alguno de estos casos:

- **Escalado independiente:** un módulo necesita mucha más capacidad que el resto (por ejemplo, el procesamiento de cartolas en la conciliación).
- **Ritmo de despliegue distinto:** un módulo cambia con una frecuencia muy diferente a los demás.
- **Aislamiento de fallos:** la caída de un módulo no debe afectar a las operaciones críticas.
- **Equipos separados:** hay más de un equipo y las fronteras técnicas ya coinciden con las organizativas.

En cada caso se escribirá un ADR nuevo que reemplace a este.
