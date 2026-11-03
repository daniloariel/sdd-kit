---
name: sdd-converge
description: SDD fase 7 — evaluar el código actual contra spec.md, plan.md y tasks.md de la feature activa y agregar al final de tasks.md, como nueva fase de convergencia, todo lo que falta o quedó parcial, para que /sdd-implement lo complete. Usala después de /sdd-implement.
argument-hint: "[foco opcional]"
---

# /sdd-converge

Convenciones de archivos y flujo completo: skill `sdd`.

Cierra la brecha entre lo que piden los artefactos y lo que el código realmente implementa. spec.md, plan.md y tasks.md son la **única fuente de intención** (con la constitución como restricción). No es un diff: no mira git ni historial, evalúa el estado presente del código.

## Restricción: solo agregar

La **única** escritura permitida es agregar una sección `## Phase N: Convergence` al final de tasks.md. No podés:
- modificar spec.md ni plan.md;
- reescribir, renumerar, reordenar ni borrar tareas existentes (incluidas convergencias previas);
- crear, modificar o borrar código — eso es trabajo de `/sdd-implement`.

## Pasos

1. Resolvé la feature activa. Requiere spec.md y tasks.md completos y que `/sdd-implement` ya haya corrido sobre ellos. Si no, indicá el paso que falta.
2. **Inventario de intención**: FRs, success criteria, escenarios de aceptación de cada story, edge cases, decisiones del plan (estructura, contratos, modelo de datos) y tareas existentes con su estado.
3. **Evaluar el código** (buscar → leer lo justo): para cada ítem del inventario, buscá evidencia concreta en el código (archivo y símbolo/línea). Clasificá:
   - **Met**: implementado y con evidencia;
   - **Partial**: existe pero incompleto (falta validación, caso de error, campo, test pedido…);
   - **Unmet**: no hay implementación;
   - **Divergent**: implementado distinto a lo que dicen spec/plan.
   Una tarea marcada `[X]` cuyo resultado no aparece en el código cuenta como Partial/Unmet.
4. **Generar tareas** para cada Partial / Unmet / Divergent, en el formato de `/sdd-tasks`:
   ```
   ## Phase N: Convergence

   - [ ] T047 [US2] Agregar validación de largo máximo (120) a title en src/models/task.py — FR-006 (Partial: falta validación)
   ```
   - IDs continuando el último existente; `[P]` y `[US#]` con las mismas reglas.
   - Cada tarea cita el requisito/decisión que la origina y el estado detectado.
   - Si algo es **Divergent** y parece que el código tiene razón (la spec quedó vieja), no generes tarea para "deshacer" el código: listalo aparte para que el usuario decida si actualizar la spec.
   - Convergir es completar la spec, no ampliarla: no generes tareas por mejoras, refactors ni "buenas prácticas" que ningún FR/SC o decisión del plan pida, ni por nada de *Out of Scope*.
5. Si todo está Met, no escribas nada.

## Reporte final

Tabla resumida (ítem → estado → evidencia), cantidad de tareas agregadas, divergencias que requieren decisión del usuario y siguiente paso: `/sdd-implement` para la fase de convergencia, o "feature convergida" si no quedó nada.
