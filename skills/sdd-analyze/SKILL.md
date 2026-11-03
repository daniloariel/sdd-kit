---
name: sdd-analyze
description: SDD fase 5 — análisis de solo lectura de consistencia y calidad entre spec.md, plan.md y tasks.md de la feature activa (y la constitución) — duplicaciones, ambigüedades, huecos de cobertura, contradicciones. Usala después de /sdd-tasks y antes de /sdd-implement. No modifica archivos.
argument-hint: "[foco opcional]"
---

# /sdd-analyze

Convenciones de archivos y flujo completo: skill `sdd`.

**Estrictamente de solo lectura.** No modificás ningún archivo. Al final ofrecés un plan de remediación y el usuario decide si aplicarlo.

La constitución es **no negociable** en este análisis: un conflicto con un MUST es siempre CRITICAL. Si el principio en sí está mal, eso se cambia aparte con `/sdd-constitution`, no se reinterpreta acá.

## Pasos

1. Resolvé la feature activa. Requiere `spec.md`, `plan.md` y `tasks.md`; si falta alguno, indicá qué skill lo genera y pará.
2. **Cargá solo lo necesario**:
   - spec: overview, FRs, success criteria, user stories, edge cases;
   - plan: stack, arquitectura, fases, restricciones;
   - tasks: IDs, descripciones, fases, `[P]`, rutas;
   - constitución: principios MUST/SHOULD.
3. **Modelo interno** (no lo vuelques entero): inventario de requisitos con clave estable (`FR-001` o slug), inventario de stories, mapeo tarea → requisito/story, reglas de la constitución.
4. **Detección** (máx. 50 hallazgos; el resto, resumido):
   - **A. Duplicación**: requisitos casi iguales; quedate con la mejor redacción.
   - **B. Ambigüedad**: adjetivos sin métrica ("rápido", "seguro", "escalable"), placeholders sin resolver (TODO, ???, `[NEEDS CLARIFICATION]`).
   - **C. Subespecificación**: requisitos con verbo pero sin objeto o resultado medible; stories sin criterio de aceptación; tareas que referencian archivos o componentes que el plan/spec no definen.
   - **D. Constitución**: cualquier cosa que contradiga un MUST; secciones u obligaciones que la constitución exige y faltan.
   - **E. Cobertura**: requisitos sin tareas; tareas sin requisito/story; tareas o componentes del plan que implementan algo de *Out of Scope* (HIGH); success criteria no funcionales sin tareas que los aborden.
   - **F. Inconsistencia**: terminología que deriva entre archivos; entidades en el plan que no están en la spec (o al revés); orden de tareas contradictorio (p. ej. integración antes que setup sin dependencia declarada); requisitos que se contradicen (p. ej. Next.js vs Vue).
5. **Severidad**:
   - **CRITICAL**: viola un MUST de la constitución, falta un artefacto núcleo, o un requisito que bloquea funcionalidad base tiene cero cobertura.
   - **HIGH**: requisito duplicado o contradictorio, atributo de seguridad/performance ambiguo, criterio de aceptación no testeable.
   - **MEDIUM**: drift de terminología, falta cobertura de un requisito no funcional, edge case subespecificado.
   - **LOW**: redacción, redundancia menor que no afecta el orden de ejecución.

## Reporte (Markdown, sin escribir archivos)

```
## Specification Analysis Report

| ID | Categoría | Severidad | Ubicación | Resumen | Recomendación |
|----|-----------|-----------|-----------|---------|---------------|
| A1 | Duplicación | HIGH | spec.md:L120-134 | ... | ... |
```

Después:
- **Tabla de cobertura**: requisito → ¿tiene tarea? → IDs de tarea → notas.
- **Alineación con la constitución** (si hay problemas).
- **Tareas sin mapear**.
- **Métricas**: total de requisitos, total de tareas, % de cobertura, cantidad de ambigüedades, duplicaciones y CRITICAL.

## Próximas acciones

- Con CRITICAL: recomendá resolverlos antes de `/sdd-implement`, indicando qué skill usar (`/sdd-specify` para refinar, `/sdd-plan` para ajustar arquitectura, `/sdd-tasks` para cobertura).
- Solo LOW/MEDIUM: se puede seguir, con las sugerencias listadas.
- Preguntá: "¿Querés que proponga las ediciones concretas para los N hallazgos principales?" — y no las apliques sin un sí explícito.

Si no hay hallazgos, reportá éxito con las métricas de cobertura. Determinismo: correrlo dos veces sin cambios debe dar los mismos IDs y conteos.
