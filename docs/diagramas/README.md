# Diagramas

Diseño de FinOrgs antes del código. Cada diagrama tiene tres archivos:

| Archivo | Para qué |
|---|---|
| `NN-nombre.drawio` | **La fuente.** Se edita con [draw.io](https://www.drawio.com/) |
| `NN-nombre.drawio.svg` | La imagen que se ve en GitHub. Se genera desde el `.drawio` |
| `NN-nombre.md` | La explicación: reglas, tablas y decisiones |

| # | Diagrama | Responde |
|---|---|---|
| 1 | [Contexto](01-contexto.md) | ¿Quién lo usa y con qué sistemas habla? |
| 2 | [Módulos](02-modulos.md) | ¿En qué partes se divide y quién depende de quién? |
| 3 | [Capas hexagonales y MVC](03-hexagonal.md) | ¿Cómo se organiza el código dentro de un módulo? |
| 4 | [Ciclo de una solicitud](04-ciclo-solicitud.md) | ¿Qué estados existen y quién mueve cada transición? |
| 5 | [Modelo de datos](05-modelo-datos.md) | ¿Qué se guarda y qué se calcula? |
| 6 | [Aprobar una solicitud](06-aprobar-solicitud.md) | ¿Cómo se evita aprobar algo dos veces o sin fondos? |

## Cómo editarlos

1. Abre el `.drawio` con draw.io Desktop (o con la extensión *Draw.io Integration* de VS Code) y haz los cambios.
2. Regenera las imágenes: `./exportar.ps1`
3. Haz commit de los tres archivos que cambiaron.

El `.svg` se exporta con tema claro y sin fuentes embebidas, para que se vea igual en cualquier visor.
