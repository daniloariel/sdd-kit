---
name: sdd-plan
description: SDD fase 3 — generar el plan técnico de la feature activa (plan.md) a partir de su spec y la constitución, con research.md, data-model.md, contracts/ y quickstart.md. Usala cuando la spec está lista y el usuario indica stack, arquitectura o restricciones técnicas.
argument-hint: "<stack, arquitectura y restricciones técnicas>"
---

# /sdd-plan

Convenciones de archivos y flujo completo: skill `sdd`.

El texto del usuario trae las decisiones técnicas (lenguaje, framework, base de datos, hosting, restricciones). Si el repo ya tiene stack, el plan lo **respeta**: verificá manifests (`package.json`, `composer.json`, `pyproject.toml`, etc.) en vez de suponer.

## Precondiciones

- Feature activa con `spec.md`. Si no hay sección `## Clarifications` y la spec tiene ambigüedades visibles, sugerí `/sdd-clarify` primero (el usuario puede seguir igual).
- Si `checklists/requirements.md` tiene ítems sin tildar, avisalo.

## Pasos

1. **Cargar contexto**: spec.md, `.specify/memory/constitution.md` y `.specify/memory/domain.md` (si existen) y `templates/plan-template.md` (u override en `.specify/templates/`). Copiá la plantilla a `plan.md`.
2. **Technical Context**: completá cada campo (lenguaje/versión, dependencias principales, storage, testing, plataforma, tipo de proyecto, metas de performance, restricciones, escala). Lo que no sepas: `NEEDS CLARIFICATION`.
3. **Constitution Check (gate)**: para cada principio aplicable, ¿el plan lo cumple? Toda violación va a *Complexity Tracking* con justificación y la alternativa más simple descartada y por qué. Una violación de un MUST sin justificación válida es **ERROR**: pará y planteáselo al usuario.
4. **Fase 0 — research.md**: por cada `NEEDS CLARIFICATION`, dependencia relevante o integración externa, investigá (docs oficiales, el propio repo; con subagentes si son varias en paralelo). Cada hallazgo:
   - **Decision**: qué se eligió
   - **Rationale**: por qué
   - **Alternatives considered**: qué más se evaluó
   Al terminar no puede quedar ningún `NEEDS CLARIFICATION` en el plan.
5. **Fase 1 — diseño**:
   - `data-model.md`: entidades de la spec → campos, relaciones, reglas de validación derivadas de los FR, transiciones de estado.
   - `contracts/`: las interfaces que el sistema expone hacia afuera, en el formato que corresponda al tipo de proyecto (OpenAPI/endpoints para un servicio, esquema de comandos para una CLI, API pública para una librería, contratos de UI). Omitilo si es puramente interno.
   - `quickstart.md`: escenarios de validación ejecutables que prueban la feature de punta a punta — prerequisitos, setup, comandos y resultado esperado. Referenciá contratos y modelo en vez de duplicarlos; nada de código de implementación.
   - **Project Structure**: elegí una de las opciones de la plantilla, borrá las otras y poné las rutas reales.
6. **Re-evaluar Constitution Check** después del diseño.
7. **Contexto para el agente**: si el repo tiene `CLAUDE.md`, agregá (o actualizá) una sección corta con el stack y comandos nuevos que introduce esta feature, sin pisar contenido manual. Si no tiene, no lo crees sin preguntar.

## Reglas

- La spec manda: el plan no agrega funcionalidad que la spec no pide. Si algo del *qué* tiene que cambiar, corregí spec.md primero y avisá.
- **Lo más simple que cumpla la spec.** Seguí los patrones y la estructura que el repo ya tiene; reutilizá antes de crear. No introduzcas capas, abstracciones, dependencias, configuración ni archivos nuevos que la spec no requiera; cada uno que sí quede se justifica en *Complexity Tracking*. Lo de *Out of Scope* no se planifica.
- **Artefactos solo si aportan.** `research.md`, `data-model.md`, `contracts/` y `quickstart.md` se generan únicamente si hay algo no trivial que registrar (una entidad nueva, una integración externa, un contrato público, una decisión con alternativas reales). No generes archivos de relleno. En carril 1 (modo corto) alcanza con `plan.md`: Technical Context, archivos que se tocan o crean y decisiones clave.
- `plan.md` es la vista de alto nivel; los detalles van en los archivos de Fase 0/1, enlazados.
- `tasks.md` **no** se crea acá.

## Reporte final

Rutas de los artefactos generados, **complejidad agregada** (lista de archivos, capas o dependencias nuevas que introduce el plan, para que el usuario pueda recortar antes de `/sdd-tasks`), decisiones clave de research, resultado del gate de constitución y siguiente paso: `/sdd-tasks` (y opcionalmente `/sdd-checklist <dominio>`).
