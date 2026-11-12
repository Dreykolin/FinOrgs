# 0003. Montos en bigint y ledger de doble entrada

- **Estado:** Aceptada
- **Fecha:** 2026-11-11

## Contexto

FinOrgs maneja el dinero de organizaciones. Dos problemas son inaceptables en ese contexto: que los cálculos pierdan o inventen pesos por errores de redondeo, y que el saldo de un fondo no se pueda explicar ni reconstruir.

Un número decimal binario no es exacto (`0.1 + 0.2` da `0.30000000000000004`), y esos restos se acumulan al sumar muchos movimientos. Por otro lado, guardar el saldo en una columna que se sobrescribe borra la historia, permite que dos operaciones simultáneas se pisen el valor y no deja detectar si el número está mal.

El peso chileno no usa decimales en la práctica. Un fondo es una cuenta real de la organización (bancaria o de efectivo).

## Decisión

**Montos.** Se guardan en `bigint`, en pesos enteros. Nunca se usa `float`. Se usa `bigint` y no `int` porque las sumas de varios años pueden superar los 2.147 millones, y un desborde en dinero es un error silencioso.

**Saldos.** No se guardan: se calculan sumando las líneas de un **ledger de doble entrada**.

- Cada movimiento de dinero es un **asiento**, compuesto por **líneas** con monto con signo (positivo entra, negativo sale).
- Las líneas de un asiento **siempre suman cero**. El sistema rechaza un asiento que no cuadre.
- Los asientos **solo se insertan**: nunca se editan ni se borran. Un error se corrige con un asiento nuevo que lo revierte y apunta al original (`revierte_a`).

## Alternativas descartadas

- **Decimales (`float`).** Con errores de redondeo que se acumulan.
- **`numeric(12,2)`.** Es exacto, pero guarda centavos que el peso chileno no usa.
- **Columna `saldo` en cada fondo.** Es simple, pero no deja rastro de cómo se llegó al número, es propensa a que dos operaciones se pisen el valor, y corregir un error exige editarlo y perder la historia.

## Consecuencias

**A favor**
- Cada peso se puede rastrear hasta su origen, lo que sostiene la transparencia de cara a los socios.
- El saldo siempre se puede reconstruir y explicar.
- Los errores se corrigen sin perder el rastro del error ni de su corrección.
- Que un asiento no sume cero actúa como alarma automática de un bug.
- Solo se insertan filas, por lo que no hay sobrescrituras que choquen entre operaciones simultáneas.

**En contra**
- Calcular un saldo cuesta más que leer una columna: exige índices y, si crece mucho, consultas optimizadas o saldos de apoyo reconstruibles.
- Si algún día se soporta una moneda con decimales, habrá que guardar la unidad mínima (centavos) y revisar esta decisión.
- El modelo es más complejo que una simple columna de saldo.

## Decisión pendiente

**Plan de cuentas.** Hoy las líneas de un asiento solo apuntan a fondos, pero la contrapartida de un pago (por ejemplo, un gasto en reembolsos) no es un fondo. Se necesita una lista de cuentas donde los fondos sean un tipo más, junto a gastos, ingresos y otras. Se resolverá antes del mes 3, con un ADR propio, antes de implementar el ledger.
