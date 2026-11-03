---
name: sdd-checklist
description: SDD (opcional) — generar un checklist de calidad de requisitos para un dominio (ux, api, security, performance, accesibilidad…) de la feature activa — "tests unitarios para los requisitos" que verifican si la spec y el plan están completos, claros y consistentes, no si el código funciona. Usala cuando el usuario quiera auditar la calidad de los requisitos en un área antes de implementar.
argument-hint: "<dominio y foco, p. ej. 'security para el login'>"
---

# /sdd-checklist

Convenciones de archivos y flujo completo: skill `sdd`.

## Concepto clave

Un checklist acá es un **test unitario de los requisitos escritos**. Evalúa la calidad de spec/plan, **no** el comportamiento del sistema.

- ❌ "Verificar que el botón muestra el spinner" (eso es un test de implementación)
- ✅ "¿Están definidos los requisitos de estado de carga para todas las acciones asíncronas? [Completeness, Spec §FR-007]"
- ✅ "¿Está cuantificado 'carga rápida' con un umbral concreto? [Clarity, Spec §SC-002]"

Si un ítem empieza con "Verificar / Testear / Confirmar que el sistema…", está mal formulado: reescribilo como pregunta sobre el requisito.

## Pasos

1. Resolvé la feature activa; cargá spec.md y, si existen, plan.md y tasks.md (solo las partes relevantes al dominio).
2. **Aclarar intención** (hasta 3 preguntas, solo si el pedido no alcanza): dominio y foco, profundidad (pre-commit liviano vs. gate formal de release), público (autor, revisor de PR, QA). Saltealas si el pedido ya lo dice.
3. **Generar** `checklists/<dominio>.md` usando `templates/checklist-template.md`. Si el archivo existe, agregá ítems continuando la numeración; no lo pises.
4. **Ítems** `CHK001…`, agrupados por dimensión de calidad:
   - **Completeness**: ¿están todos los requisitos necesarios?
   - **Clarity**: ¿son específicos y sin ambigüedad?
   - **Consistency**: ¿se contradicen entre sí o con el plan?
   - **Measurability / Acceptance Criteria**: ¿se pueden verificar objetivamente?
   - **Scenario Coverage**: flujos alternativos, de error y de recuperación.
   - **Edge Cases**: límites, vacíos, concurrencia.
   - **Non-Functional**: performance, seguridad, accesibilidad, observabilidad (según dominio).
   - **Dependencies & Assumptions**: ¿están documentados y validados?
   - **Ambiguities & Conflicts**: lo que hay que resolver.
5. **Trazabilidad**: ≥ 80 % de los ítems con referencia — `[Spec §FR-001]`, `[Plan §Technical Context]`, o marcadores `[Gap]`, `[Ambiguity]`, `[Conflict]`, `[Assumption]`.
6. Mantenelo enfocado: preferí 15–30 ítems de alto valor a 80 genéricos. Fusioná ítems casi duplicados.

## Ciclo de vida

- El revisor tilda `[x]` cuando el criterio de calidad del requisito se cumple (no cuando el código está hecho).
- `/sdd-implement` lee estos checklists como **gate de solo lectura**: si hay ítems sin tildar, pregunta antes de seguir.
- `checklists/requirements.md` es el checklist propio de `/sdd-specify` y `/sdd-clarify`; no lo uses para un dominio.

## Reporte final

Ruta del archivo, cantidad de ítems por dimensión, huecos `[Gap]`/`[Conflict]` más importantes y sugerencia: resolverlos en la spec (`/sdd-clarify` o edición directa) antes de implementar.
