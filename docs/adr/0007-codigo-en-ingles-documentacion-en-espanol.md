# 0007. Código en inglés, documentación en español

- **Estado:** Aceptada
- **Fecha:** 2026-11-11

## Contexto

FinOrgs es un proyecto de portafolio cuyo público principal son equipos de ingeniería en Chile y Latinoamérica. El dominio (tesorería de organizaciones) nace en español, con términos como solicitud, fondo, tesorero o rendición.

Los frameworks y librerías que se usan están escritos en inglés (`controller`, `repository`, `findOne`, `@Injectable`). Si el código se escribe en español, queda mezclado de todos modos, con nombres como `SolicitudesController.aprobar()`.

## Decisión

**En inglés:** todo lo que vive en el código y lo que lo rodea técnicamente.
- Nombres de clases, funciones, variables, archivos, tablas, columnas y rutas de la API.
- Comentarios dentro del código.
- El tipo y el alcance de los commits (`feat(requests): …`).

**En español:** la prosa escrita para personas.
- README, ADRs y la explicación de los diagramas.
- Descripciones de commits, issues y pull requests.
- Los textos que ve el usuario final en la interfaz, separados del código para poder traducirlos después.

Un **glosario** fija la traducción de los términos de dominio, para que el mismo concepto tenga siempre el mismo nombre en el código. Se amplía a medida que aparecen conceptos nuevos.

| Español | Inglés |
|---|---|
| organización | organization |
| membresía | membership |
| administrador · tesorero · solicitante · lector | admin · treasurer · requester · viewer |
| solicitud | request |
| reembolso · compra directa · anticipo | reimbursement · direct purchase · advance |
| borrador · enviada · aprobada · pagada · rechazada | draft · submitted · approved · paid · rejected |
| observada (devuelta con comentarios) | returned |
| comprobante | receipt |
| fondo | fund |
| asiento · línea de asiento | ledger entry · entry line |

## Alternativas descartadas

- **Todo en español, código incluido.** Queda mezclado con el inglés de los frameworks y se aparta de la convención de la industria.
- **Todo en inglés, documentación incluida.** Es la opción para un público internacional. Se descarta por ahora porque el público principal es chileno, la documentación es donde se razona mejor en el idioma propio, y obligaría a traducir lo ya escrito. Pasar a esta opción más adelante es barato: se traduce el README y los ADRs sin tocar el código.

## Consecuencias

**A favor**
- El código sigue la convención de la industria y no mezcla idiomas dentro de un mismo nombre.
- La documentación se escribe y se defiende en el idioma en que se razona.
- No hay costo de traducción ahora.
- El glosario evita que el mismo concepto tenga dos nombres.

**En contra**
- Un lector que no hable español entiende el código, pero no la documentación.
- Los diagramas actuales usan los términos en español: sus nombres de tablas y entidades se actualizarán al inglés cuando se escriban las primeras migraciones.
- Hay que mantener el glosario al día.

## Cuándo reconsiderar

Si el proyecto pasa a dirigirse a un público internacional, se traducirá la documentación y se registrará en un ADR nuevo que reemplace a este.
