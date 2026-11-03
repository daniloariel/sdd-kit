---
name: sdd
description: Spec-Driven Development (SDD) basado en GitHub spec-kit — el flujo constitución → spec → clarify → plan → tasks → analyze → implement → converge, y las convenciones de archivos que comparten las skills sdd-*. Usala cuando el usuario quiera arrancar un proyecto o una feature "con SDD / spec-driven / spec-kit", pregunte qué paso sigue, o cuando haya una carpeta `specs/` o `.specify/` en el repo.
argument-hint: "[idea del proyecto o feature]"
---

# Spec-Driven Development (SDD)

En SDD la **especificación es la fuente de verdad**: el código se deriva de ella, no al revés. Cada fase produce un artefacto en Markdown que la siguiente consume. No se escribe código hasta que el *qué* (spec) y el *cómo* (plan) estén acordados y descompuestos en tareas.

Este kit adapta [github/spec-kit](https://github.com/github/spec-kit) a skills de Claude Code, sin la CLI `specify`, sin scripts y sin sistema de extensiones/hooks.

## El flujo

| # | Skill | Produce | Cuándo |
|---|---|---|---|
| 0 | `/sdd-constitution` | `.specify/memory/constitution.md` | Una vez por proyecto (y al cambiar principios) |
| 1 | `/sdd-specify <descripción>` | `specs/NNN-nombre/spec.md` + `checklists/requirements.md` | Una por feature. **Qué** y **por qué**, sin tecnología |
| 2 | `/sdd-clarify` | Sección `## Clarifications` en spec.md | Recomendado antes de planificar; hasta 5 preguntas |
| 3 | `/sdd-plan <stack y restricciones>` | `plan.md`, `research.md`, `data-model.md`, `contracts/`, `quickstart.md` | Acá entra el **cómo** técnico |
| 4 | `/sdd-tasks` | `tasks.md` | Tareas por user story, con IDs, `[P]` y rutas |
| 5 | `/sdd-analyze` | Reporte (no escribe) | Consistencia spec ↔ plan ↔ tasks antes de implementar |
| 6 | `/sdd-implement` | Código + `[X]` en tasks.md | Ejecuta las tareas fase por fase |
| 7 | `/sdd-converge` | Fase de convergencia en tasks.md | Después de implementar: lo que falta vs la spec |
| — | `/sdd-checklist <dominio>` | `checklists/<dominio>.md` | Opcional: "tests unitarios para los requisitos" (ux, security, api…) |

Orden mínimo para una feature: `specify → plan → tasks → implement`. Lo demás sube la calidad; saltearlo es decisión del usuario, pero avisale qué riesgo corre.

## Carriles: la ceremonia se escala al tamaño del cambio

Antes de arrancar, elegí el carril **más chico que alcance**, decile al usuario cuál elegiste en una línea (puede cambiarlo) y seguí. Ante la duda, el más chico: siempre se puede subir.

| Carril | Cuándo | Qué se hace |
|---|---|---|
| **0 — Sin SDD** | Bug, ajuste de UI/texto, campo o cambio local que se explica en ≤ 3 líneas (qué pasa, qué debería pasar, dónde) | No se crea spec ni plan. Se implementa directo con las reglas anti-sobreingeniería de abajo. Si al leer el código resulta ser más grande, subí de carril. |
| **1 — Liviano** | Feature mediana: 1–2 user stories, sin decisiones de dominio nuevas | `/sdd-specify` en modo corto → `/sdd-plan` en modo corto (solo `plan.md`) → `/sdd-tasks` → `/sdd-implement`. Sin clarify / analyze / checklist salvo que el usuario los pida. |
| **2 — Completo** | Feature grande, que toca varios módulos o fija una decisión de dominio nueva (entidades, reglas o flujos de los que después dependen otras cosas) | El flujo completo de arriba. |

Si el ticket (p. ej. de Trello) ya trae criterios claros, usalo como base de la spec en vez de reescribirlo.

## Convenciones de archivos (las comparten todas las skills sdd-*)

```
<repo>/
├── .specify/
│   ├── memory/constitution.md     # principios no negociables del proyecto
│   ├── memory/domain.md           # (opcional) reglas de dominio y convenciones del proyecto, 10–20 líneas
│   ├── feature.json               # {"feature_directory": "specs/003-user-auth"}  ← feature activa
│   └── templates/                 # (opcional) overrides de plantillas del proyecto
└── specs/
    └── 003-user-auth/
        ├── spec.md
        ├── checklists/requirements.md
        ├── plan.md  research.md  data-model.md  quickstart.md
        ├── contracts/
        └── tasks.md
```

**Resolver la feature activa** (todas las fases después de specify):
1. Si el usuario nombró una feature o ruta (`003`, `user-auth`, `specs/003-user-auth`) → esa.
2. Si no, `.specify/feature.json` → `feature_directory`.
3. Si no existe, el directorio de `specs/` con número más alto; confirmalo con el usuario en una línea.
4. Si no hay `specs/`, decile que arranque con `/sdd-specify`.

**Plantillas**: cada skill trae la suya en `templates/` dentro de su propio directorio (el "Base directory" que te informa Claude Code al cargar la skill). Si el proyecto tiene `.specify/templates/<nombre>-template.md`, esa gana.

**Dominio**: si `.specify/memory/domain.md` existe, todas las fases lo leen junto con la constitución. Es corto (10–20 reglas: glosario, decisiones de negocio, convenciones; p. ej. "cliente = dueño, paciente = animal; un turno es por animal"). Cuando una clarificación o decisión fije una regla que aplica más allá de la feature, proponé agregarla ahí; no la agregues sin que el usuario lo confirme.

**Constitución**: si `.specify/memory/constitution.md` existe, todas las fases la leen y la respetan. Una violación de un principio con MUST es un error bloqueante, no una sugerencia.

## Reglas de fondo

- **Spec sin tecnología.** spec.md describe usuarios, comportamiento y resultados medibles. Lenguajes, frameworks, APIs y bases de datos van recién en plan.md.
- **Incertidumbre explícita.** Lo que no se sabe se marca `[NEEDS CLARIFICATION: pregunta concreta]` en vez de inventarlo. Máximo 3 en la spec; el resto se resuelve con defaults razonables documentados en *Assumptions*.
- **User stories independientes y priorizadas (P1, P2, P3…).** Cada una debe poder implementarse, testearse y entregarse sola: P1 es el MVP.
- **Trazabilidad.** Requisitos `FR-###`, criterios `SC-###`, tareas `T###` con `[US#]`. Cada tarea apunta a un archivo concreto.
- **Anti-sobreingeniería.** La solución más simple que cumpla la spec. Seguí los patrones, nombres y utilidades que el repo ya usa; reutilizá antes de crear. No agregues abstracciones, capas, configuración, dependencias, archivos ni "por si acaso" que la spec o una tarea no pidan. Si creés que hace falta algo más, **preguntá antes**; no lo hagas para explicarlo después.
- **Fuera de alcance explícito.** Toda spec dice qué NO entra. Lo que está ahí no se planifica, no se convierte en tarea y no se implementa.
- **Los artefactos se actualizan, no se contradicen.** Si durante el plan o la implementación cambia el *qué*, primero se corrige spec.md y después se sigue.
- **Idioma.** Los encabezados de las plantillas quedan como están (para que las skills los encuentren); el contenido se escribe en el idioma del usuario.

## Qué hacer cuando invocan esta skill

- Primero elegí el carril (ver arriba). Si es carril 0, no invoques el resto de las skills.
- Con una idea de proyecto nuevo: verificá si existe la constitución; si no, proponé empezar por `/sdd-constitution` y después `/sdd-specify` con la idea.
- Sin argumentos: inspeccioná `.specify/` y `specs/`, decí en qué fase está la feature activa (qué artefactos existen, cuántas tareas `[X]` vs `[ ]`) y cuál es el siguiente paso.
- No ejecutes varias fases de corrido sin que el usuario lo pida: cada fase termina con un artefacto que el usuario debería poder revisar.
