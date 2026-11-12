# 0008. Saldo, aprobado y disponible se calculan; aprobar no baja el saldo

- **Estado:** Aceptada
- **Fecha:** 2026-11-11

## Contexto

Cuando el tesorero aprueba una solicitud, el dinero queda comprometido, pero todavía no ha salido del fondo: eso ocurre recién cuando se paga. El sistema debe saber cuánto se puede seguir aprobando, y debe impedir que dos aprobaciones simultáneas superen lo que hay en el fondo.

El saldo debe coincidir con la realidad (por ejemplo, con la cartola del banco). Si se descontara al aprobar, el sistema mostraría una cifra distinta de la del banco, y la conciliación nunca cuadraría.

Según el ADR 0003, los saldos no se guardan, se calculan desde el ledger.

## Decisión

Cada fondo tiene tres cifras:

| Cifra | Qué es | Cómo se obtiene |
|---|---|---|
| **Saldo** | El dinero que realmente hay en el fondo | Suma de las líneas del ledger del fondo |
| **Aprobado** | Dinero comprometido, que aún no sale | Suma de las solicitudes aprobadas y todavía no pagadas |
| **Disponible** | Lo que aún se puede aprobar | Saldo − aprobado |

Ejemplo: con un saldo de 100.000, aprobar 20.000 deja el saldo en 100.000, el aprobado en 20.000 y el disponible en 80.000. Al pagar esos 20.000, el saldo pasa a 80.000 y el aprobado vuelve a 0.

**Aprobar no cambia el saldo; pagar sí.** Aprobar solo reduce el disponible.

**Ninguna de las tres cifras se guarda.** Se calculan en cada consulta.

**Al aprobar,** dentro de la misma transacción, se bloquea la fila del fondo (`SELECT … FOR UPDATE`) y se verifica que el disponible alcance para el monto. Así, dos aprobaciones simultáneas sobre el mismo fondo se ejecutan una detrás de otra y no pueden dejarlo en negativo.

## Alternativas descartadas

- **Descontar del saldo al aprobar.** El saldo dejaría de coincidir con el banco, y no habría forma de distinguir el dinero que está de lo que está prometido.
- **Guardar `aprobado` y `disponible` en columnas.** Habría dos fuentes de verdad para un mismo dato. Tarde o temprano se desincronizarían, y los valores guardados no se podrían contrastar con nada.
- **Un saldo guardado y actualizado en cada operación.** Descartado en el ADR 0003.

## Consecuencias

**A favor**
- El saldo siempre coincide con la realidad y se puede conciliar con el banco.
- Las tres cifras nacen de los mismos datos, así que no pueden contradecirse: todo cuadra por construcción.
- Cero columnas redundantes que mantener.
- El bloqueo del fondo hace que la regla "no aprobar más de lo disponible" se cumpla incluso con peticiones simultáneas.

**En contra**
- Cada consulta calcula las cifras, lo que exige índices y, si el volumen crece, consultas optimizadas o un resumen de apoyo que siempre se pueda reconstruir.
- El bloqueo del fondo serializa las aprobaciones de un mismo fondo. Es aceptable con el volumen esperado: una organización tiene pocos tesoreros.
- Una solicitud aprobada que nunca se paga mantiene dinero comprometido; se resolverá con el estado `Anulada` previsto en el diagrama del ciclo de vida.
