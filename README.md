# sdd-kit

Spec-Driven Development para Claude Code, como skills. Adaptación de [github/spec-kit](https://github.com/github/spec-kit) (MIT, ver `LICENSE-spec-kit`; plantillas tomadas del commit `222a973`, 2026-10-27) sin la CLI `specify`, sin scripts de shell y sin el sistema de extensiones/hooks: solo las skills y sus plantillas.

## Instalar

```bash
cd ~/Documents/proyectos/sdd-kit && ./install.sh
```

Crea symlinks en `~/.claude/skills/` (editar el kit actualiza las skills). Alternativas: `--copy`, `--project <dir>` (copia en `<dir>/.claude/skills` para versionarlas con el repo), `--uninstall`. Abrí una sesión nueva de Claude Code para que aparezcan.

## Usar

**Primero elegí el carril** (la skill `sdd` lo hace por vos y te lo dice en una línea):

| Carril | Cuándo | Flujo |
|---|---|---|
| 0 — Sin SDD | Bug, ajuste, cambio local de ≤ 3 líneas | Directo a implementar, con las reglas anti-sobreingeniería |
| 1 — Liviano | Feature mediana, 1–2 stories | `specify` (corto) → `plan` (solo plan.md) → `tasks` → `implement` |
| 2 — Completo | Feature grande o decisión de dominio nueva | Todo el flujo de abajo |

Opcional: `.specify/memory/domain.md` con las reglas de dominio del proyecto (10–20 líneas); todas las fases lo leen.

Flujo completo (carril 2):

En el repo del proyecto, en orden:

```text
/sdd-constitution  Código simple, tests para lógica de negocio, Laravel + MySQL, sin dependencias innecesarias
/sdd-specify       Quiero que los clientes reserven turnos online y reciban recordatorio por WhatsApp
/sdd-clarify
/sdd-plan          Laravel 11, Livewire, MySQL, cola con Redis, gateway de WhatsApp existente
/sdd-tasks
/sdd-analyze
/sdd-implement     MVP
/sdd-converge
```

`/sdd` sin argumentos te dice en qué fase está la feature activa y qué sigue. `/sdd-checklist <dominio>` es opcional, para auditar requisitos de un área (security, ux, api…).

| Skill | Hace | Escribe |
|---|---|---|
| `sdd` | Flujo y convenciones compartidas; estado actual | — |
| `sdd-constitution` | Principios no negociables del proyecto | `.specify/memory/constitution.md` |
| `sdd-specify` | Qué y por qué (sin tecnología) | `specs/NNN-x/spec.md`, `checklists/requirements.md`, `.specify/feature.json` |
| `sdd-clarify` | ≤ 5 preguntas para cerrar ambigüedades | `spec.md` (§ Clarifications) |
| `sdd-plan` | Cómo: stack, diseño, contratos | `plan.md`, `research.md`, `data-model.md`, `contracts/`, `quickstart.md` |
| `sdd-tasks` | Tareas por user story | `tasks.md` |
| `sdd-analyze` | Consistencia spec ↔ plan ↔ tasks | nada (solo reporte) |
| `sdd-checklist` | "Tests unitarios" de los requisitos | `checklists/<dominio>.md` |
| `sdd-implement` | Ejecuta tareas y las marca `[X]` | código, `tasks.md` |
| `sdd-converge` | Lo que falta vs la spec | `tasks.md` (fase Convergence, solo agrega) |

## Diferencias con spec-kit

- **Sin CLI ni scripts**: lo que hacían `create-new-feature.sh` / `check-prerequisites.sh` (numerar `specs/NNN-…`, resolver la feature activa, validar prerequisitos) lo hace cada skill directamente. La feature activa vive en `.specify/feature.json`, como en spec-kit.
- **Sin ramas automáticas**: el directorio de la spec no crea una rama de git; si la querés, pedila.
- **Sin extensiones/hooks/presets**: el único mecanismo de personalización es poner plantillas propias en `.specify/templates/<nombre>-template.md` del proyecto, que ganan sobre las del kit.
- **Fuera**: `taskstoissues` (convertir tareas en issues de GitHub).
- Se mantienen las rutas de spec-kit (`.specify/memory/constitution.md`, `specs/`), así que un repo ya inicializado con spec-kit funciona con estas skills y viceversa.
- Plantillas en inglés (originales) para que los encabezados sean estables; el contenido se escribe en el idioma de la conversación.

## Actualizar plantillas desde upstream

```bash
git clone --depth 1 https://github.com/github/spec-kit /tmp/spec-kit
for p in constitution:constitution specify:spec specify:checklist plan:plan tasks:tasks checklist:checklist; do s=${p%%:*}; t=${p##*:}; perl -pe 's/__SPECKIT_COMMAND_([A-Z]+)__/"\/sdd-".lc($1)/ge' /tmp/spec-kit/templates/$t-template.md > skills/sdd-$s/templates/$t-template.md; done
```

Los `SKILL.md` son una reescritura de `templates/commands/*.md` de spec-kit: si upstream cambia el comportamiento de un comando, hay que portarlo a mano.
