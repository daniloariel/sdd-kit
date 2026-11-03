---
name: sdd-tasks
description: SDD fase 4 — descomponer el plan de la feature activa en tasks.md, tareas accionables organizadas por user story, con IDs, marcas de paralelismo [P], etiquetas [US#], rutas de archivo y orden de dependencias. Usala cuando plan.md está listo y antes de implementar.
argument-hint: "[indicaciones extra, p. ej. 'con TDD']"
---

# /sdd-tasks

Convenciones de archivos y flujo completo: skill `sdd`.

## Pasos

1. **Cargar** de la feature activa:
   - Obligatorios: `plan.md` (stack, estructura) y `spec.md` (user stories con prioridad). Si falta plan.md, mandá a `/sdd-plan`.
   - Opcionales: `data-model.md`, `contracts/`, `research.md`, `quickstart.md`, constitución.
   - Plantilla: `templates/tasks-template.md` (u override en `.specify/templates/`).
2. **Generar `tasks.md`** con la estructura de la plantilla:
   - **Phase 1 — Setup**: inicialización del proyecto, dependencias, configuración.
   - **Phase 2 — Foundational**: prerequisitos bloqueantes para **todas** las stories (esquema base, auth, routing, infraestructura compartida). Nada de stories arranca antes de cerrarla.
   - **Phase 3+ — una fase por user story**, en orden de prioridad (P1 = MVP 🎯). Cada fase incluye: objetivo, *Independent Test* (cómo se verifica sola), tests (si corresponde) y tareas de implementación en orden: tests → modelos → servicios → endpoints/UI → integración.
   - **Fase final — Polish & Cross-Cutting** (solo si hace falta): tareas que salgan de un FR/SC o decisión del plan (docs que la spec pida, validación con quickstart.md si existe). Nada de refactors, performance ni hardening por default. Si no hay nada que poner, omití la fase.
   - Secciones de **Dependencies & Execution Order**, **Parallel Example** por story e **Implementation Strategy** (MVP primero, entrega incremental).
   - Borrá las tareas de ejemplo de la plantilla.

## Formato de cada tarea (obligatorio)

```
- [ ] T012 [P] [US1] Crear modelo User en src/models/user.py
```

1. Checkbox `- [ ]`.
2. ID secuencial `T001, T002…` en orden de ejecución.
3. `[P]` **solo** si es paralelizable: otro archivo y sin dependencias de tareas incompletas.
4. `[US#]` obligatorio en las fases de user story; prohibido en Setup, Foundational y Polish.
5. Descripción con acción concreta y **ruta exacta de archivo** (según Project Structure del plan).

Incorrecto: `- [ ] Crear modelo User` (sin ID, story ni ruta) · `T001 [US1] Crear modelo` (sin checkbox).

## Reglas de generación

- **Organización por user story** es la regla principal: cada story tiene que poder implementarse y testearse sola.
- **Tests opcionales**: generá tareas de test solo si la spec/constitución lo exige o el usuario pide TDD. En ese caso van antes de la implementación y deben fallar primero.
- **De contracts/**: cada contrato → la story que sirve (y un test de contrato `[P]` si hay tests).
- **De data-model.md**: cada entidad → la primera story que la necesita (o Foundational si la usan varias). Si un campo tiene restricciones (largo máximo, nullable, enum, validación), **citalas textual** en la tarea para que no queden a criterio del implementador.
- **De research.md**: decisiones → tareas de setup.
- **Trazabilidad estricta**: toda tarea responde a un FR/SC o a una decisión del plan. Nada de tareas "por las dudas" ni de lo listado en *Out of Scope*.
- Mismo archivo ⇒ secuenciales, nunca `[P]` entre sí.
- Una tarea = un cambio que se puede completar y verificar en una sesión. Si es más grande, partila.
- Cobertura: cada FR de la spec debe estar cubierto por al menos una tarea; si no, agregala o marcá el hueco.

## Reporte final

Ruta de tasks.md, total de tareas, tareas por story, oportunidades de paralelismo, criterio de test independiente por story y alcance MVP sugerido (normalmente solo US1). Siguiente paso: `/sdd-analyze` (recomendado) o `/sdd-implement`.
