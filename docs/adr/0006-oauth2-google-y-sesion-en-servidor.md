# 0006. Login con Google (OAuth2) y sesión en el servidor

- **Estado:** Aceptada
- **Fecha:** 2026-11-11

## Contexto

FinOrgs necesita saber quién es cada persona, y las personas pertenecen a una o más organizaciones con un rol distinto en cada una. La app tendrá un cliente web (React) y, más adelante, uno Android, ambos contra la misma API.

Manejar contraseñas propias obliga a almacenarlas y protegerlas, y la seguridad casera es una fuente de errores. Además, en una tesorería, quien sale de la directiva debe perder el acceso de inmediato, no cuando venza un token.

En el proyecto anterior (Finance) el token viajaba en la URL y se guardaba en `localStorage`, lo que lo expone en el historial, en los registros de servidores intermedios y a ataques XSS.

## Decisión

**Autenticación.** El inicio de sesión se delega a **Google mediante OAuth2**. FinOrgs no almacena contraseñas. Cada usuario se identifica internamente por el identificador estable de Google (`google_sub`).

**Sesión.** Tras autenticarse, el servidor crea una **sesión con un token opaco**:

- El token es un valor aleatorio de 256 bits, sin datos ni significado.
- En la base de datos solo se guarda su **hash**, en la tabla `sesiones`, junto con el usuario, el vencimiento y la fecha de revocación.
- En **cada petición** se busca la sesión y se verifica la membresía y el rol del usuario en la base de datos, en una sola consulta indexada.
- Cerrar sesión o expulsar a alguien marca la sesión como revocada y surte efecto de inmediato.

**Transporte.**
- **Web:** cookie `httpOnly`, `Secure` y `SameSite`. El token nunca aparece en la URL ni es accesible desde JavaScript.
- **Android:** el mismo token en el header `Authorization`, guardado en el almacén seguro del dispositivo. La aplicación obtiene la identidad de Google en el teléfono y el servidor la valida antes de crear la sesión.

## Alternativas descartadas

- **Usuario y contraseña propios.** Obliga a custodiar credenciales y a implementar recuperación y protección contra fuerza bruta.
- **JWT sin estado.** Ahorra una consulta, pero no se puede revocar antes de su vencimiento. La solución habitual, un token de acceso corto más un refresh token, exige guardar sesiones en la base de datos de todos modos, y se necesita consultar la membresía en cada petición, con lo que la ventaja desaparece. Además, la clave de firma pasa a ser un secreto crítico.
- **Token en `localStorage` o en la URL.** Expuesto a XSS y a quedar registrado en historiales y logs.

## Consecuencias

**A favor**
- No se custodian contraseñas, y se hereda lo que Google ofrece, como la verificación en dos pasos.
- Revocación inmediata de accesos y cierre de sesión real.
- Los permisos se evalúan siempre con el estado actual de la membresía.
- Web y Android comparten un único mecanismo de sesión.
- Si se roba una copia de la base de datos, los hashes no sirven para iniciar sesión.

**En contra**
- Cada petición consulta la base de datos; se mitiga con un índice sobre el hash del token.
- Dependencia de Google: quien no tenga cuenta de Google no puede entrar.
- La web, al usar cookies, requiere medidas contra CSRF (`SameSite` y verificación del origen).
- Hay que operar la limpieza periódica de sesiones vencidas.
