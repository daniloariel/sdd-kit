---
name: sdd-implement
description: SDD fase 6 — ejecutar las tareas de tasks.md de la feature activa fase por fase, respetando dependencias y paralelismo [P], verificando cada fase y marcando [X] lo completado. Usala cuando spec, plan y tasks están listos y el usuario quiere empezar a codear la feature.
argument-hint: "[alcance: 'MVP', 'US1', 'T010-T020', 'fase 3'…]"
---

# /sdd-implement

Convenciones de archivos y flujo completo: skill `sdd`.

Si el usuario acota el alcance (`MVP`, `US1`, rango de tareas, una fase), ejecutá solo eso. Sin acotar: todas las tareas pendientes, pero parando al final de cada user story para que el usuario pueda validar el incremento.

## Pasos

1. **Resolver feature** y verificar que existan `tasks.md` y `plan.md`. Si no, mandá a la skill que falta.
2. **Gate de checklists** (si existe `checklists/`) — solo lectura, no toques los checkboxes:

   | Checklist | Total | Tildados | Pendientes | Estado |
   |-----------|-------|----------|------------|--------|
   | requirements.md | 16 | 16 | 0 | ✓ PASS |
   | security.md | 10 | 7 | 3 | ✗ FAIL |

   Si alguno tiene pendientes: mostrá la tabla y **preguntá** si seguir. Esperá la respuesta. Si todos pasan, seguí.
3. **Cargar contexto**: tasks.md y plan.md (obligatorios); data-model.md, contracts/, research.md, quickstart.md y la constitución si existen.
4. **Preparar el proyecto** según el stack del plan:
   - Si es repo git, verificá que `.gitignore` cubra lo esencial del stack (dependencias, builds, `.env*`, archivos del SO). Si existe, agregá solo patrones críticos que falten; no lo reescribas.
   - Lo mismo para `.dockerignore`, `.prettierignore`, etc., solo si esas herramientas están en uso.
5. **Parsear tasks.md**: fases, IDs, `[P]`, `[US#]`, rutas y dependencias. Saltá las ya marcadas `[X]`.
6. **Ejecutar fase por fase**:
   - Una fase no empieza hasta que la anterior está completa (Setup → Foundational → stories → Polish).
   - Dentro de la fase: secuenciales en orden; las `[P]` pueden ir juntas (o delegarse a subagentes en paralelo) **solo si tocan archivos distintos**.
   - Si hay tareas de test: van antes de su implementación y deben fallar primero (TDD).
   - Seguí la estructura y rutas del plan; respetá los contratos y las restricciones de campo citadas en las tareas.
7. **Después de cada tarea**: marcá `- [X]` en tasks.md en el momento (no en bloque al final).
8. **Checkpoint por fase/story**: corré el mecanismo de verificación del proyecto (tests, build, linter) y, al cerrar una story, su *Independent Test*. Reportá el resultado real con evidencia.
9. **Errores**:
   - Una tarea secuencial que falla **detiene** la fase: reportá el error con contexto y proponé el siguiente paso.
   - Una `[P]` que falla: seguí con las demás y reportá las fallidas al final.
   - Si descubrís que la spec o el plan están mal o incompletos, **no improvises**: pará, explicá la discrepancia y proponé actualizar el artefacto (`/sdd-specify`, `/sdd-plan`, `/sdd-tasks`) antes de seguir.
10. **Cierre**: verificá que todas las tareas del alcance estén `[X]`, que lo implementado cumpla la spec (FRs y success criteria aplicables) y que los tests pasen. Si existe `quickstart.md`, recorré sus escenarios.

## Reglas

- **Lo más simple que cumpla la tarea.** Seguí los patrones, nombres y utilidades que el repo ya tiene; reutilizá antes de crear. No agregues abstracciones, capas, configuración, dependencias ni archivos que la tarea no pida, ni refactorices código no relacionado. Si creés que hace falta algo más, parate y preguntá.
- **Diff revisable.** Si una tarea produce un cambio que no se puede leer entero en pocos minutos, partila en tasks.md antes de seguir.
- Lo de *Out of Scope* en spec.md no se implementa.
- No implementes nada que no esté en una tarea. Si hace falta algo nuevo, agregá la tarea a tasks.md (con su ID siguiente) y decilo.
- No marques `[X]` algo que no verificaste.
- No commitees ni pushees salvo que el usuario lo pida.

## Reporte final

Tareas completadas / pendientes / fallidas, resultado de tests y build, qué stories quedaron entregables, y siguiente paso: `/sdd-converge` para detectar lo que falta respecto de la spec.
