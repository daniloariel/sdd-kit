---
name: sdd-constitution
description: SDD fase 0 — crear o actualizar la constitución del proyecto (.specify/memory/constitution.md), los principios no negociables que gobiernan spec, plan, tareas e implementación. Usala al arrancar un proyecto con SDD o cuando el usuario quiera definir o cambiar principios de desarrollo.
argument-hint: "[principios o cambios a aplicar]"
---

# /sdd-constitution

Convenciones de archivos y flujo completo: skill `sdd`.

## Entrada

El texto del usuario (principios, restricciones, cambios). Puede venir vacío: entonces se infiere del repo y se pregunta lo que falte.

## Pasos

1. **Cargar**: si `.specify/memory/constitution.md` existe, partí de él. Si no, copiá `templates/constitution-template.md` (de esta skill, o `.specify/templates/constitution-template.md` si el proyecto lo sobreescribe) y creá `.specify/memory/`.
2. **Identificar placeholders** `[TODO_EN_MAYÚSCULAS]`. La cantidad de principios no es fija: si el usuario pide 3 o 7, ajustá la plantilla, no fuerces 5.
3. **Obtener valores**, en este orden:
   - lo que dijo el usuario;
   - el contexto del repo (README, CLAUDE.md, docs, stack evidente) — solo lo verificable;
   - si no hay ningún principio de simplicidad, proponé uno (p. ej. *Simplicidad*: MUST la solución más simple que cumpla la spec, seguir los patrones del repo, sin abstracciones ni dependencias sin justificar) — así el *Constitution Check* de `/sdd-plan` frena la sobreingeniería;
   - `RATIFICATION_DATE`: fecha original de adopción (si se desconoce, preguntá o dejá `TODO(RATIFICATION_DATE): ...`);
   - `LAST_AMENDED_DATE`: hoy si hubo cambios;
   - `CONSTITUTION_VERSION` con semver:
     - **MAJOR**: se elimina o redefine un principio de forma incompatible;
     - **MINOR**: se agrega un principio o sección, o se amplía materialmente;
     - **PATCH**: aclaraciones, redacción, typos.
     Si el bump es ambiguo, explicá el razonamiento antes de fijarlo.
4. **Redactar**:
   - Sin placeholders sin resolver (salvo `TODO(...)` deliberados, listados al final).
   - Cada principio: nombre corto + reglas no negociables + una línea de *por qué*.
   - Usá MUST / SHOULD con criterio: un "should" vago no gobierna nada. Cada MUST tiene que ser verificable.
   - Secciones de gobernanza: cómo se enmienda, versionado, cómo se verifica cumplimiento.
5. **Propagar consistencia**: revisá las plantillas que usa el proyecto (`.specify/templates/` si existe; si no, las de las skills `sdd-plan`, `sdd-specify`, `sdd-tasks` solo como referencia de lectura) y señalá dónde un principio nuevo exige algo — p. ej. la *Constitution Check* de plan-template, categorías de tareas obligatorias (tests si hay Test-First). No edites las plantillas de las skills instaladas; si hace falta, creá el override en `.specify/templates/`.
6. **Sync Impact Report**: anteponé un comentario HTML al archivo:
   ```
   <!-- Sync Impact Report
   Version: 1.0.0 → 1.1.0
   Principios modificados: ...   Agregados: ...   Eliminados: ...
   Plantillas que requieren ajuste: ✅ actualizada / ⚠ pendiente (ruta)
   TODOs: ...
   -->
   ```
7. **Validar**: no quedan `[...]` sin explicar; versión coherente con el reporte; fechas ISO `YYYY-MM-DD`; principios declarativos y testeables.
8. **Escribir** `.specify/memory/constitution.md` (sobrescribe).

## Reporte final

Versión nueva y motivo del bump, archivos que quedaron pendientes de ajustar, y mensaje de commit sugerido (`docs: amend constitution to vX.Y.Z (...)`). Siguiente paso: `/sdd-specify <feature>`.
