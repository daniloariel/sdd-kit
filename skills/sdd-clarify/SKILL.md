---
name: sdd-clarify
description: SDD fase 2 — detectar ambigüedades y huecos en la spec de la feature activa y resolverlos con hasta 5 preguntas dirigidas, una por vez, registrando las respuestas en spec.md. Usala después de /sdd-specify y antes de /sdd-plan, o cuando la spec tiene zonas grises.
argument-hint: "[área en la que enfocarse]"
---

# /sdd-clarify

Convenciones de archivos y flujo completo: skill `sdd`.

Objetivo: reducir el riesgo de retrabajo **antes** de planificar. Si el usuario dice explícitamente que saltea la clarificación (p. ej. un spike), avisale que sube el riesgo y seguí.

## Pasos

1. Resolvé la feature activa y cargá `spec.md`. Si no existe, mandá a `/sdd-specify`.
2. **Escaneo de cobertura**: marcá cada categoría como Clear / Partial / Missing:
   - Alcance funcional y comportamiento (objetivos, fuera de alcance, roles)
   - Dominio y modelo de datos (entidades, atributos, unicidad, ciclo de vida/estados, volumen)
   - Interacción y flujo de UX (journeys, estados vacío/error/carga, accesibilidad)
   - Atributos no funcionales (performance, escala, disponibilidad, observabilidad, seguridad y privacidad, compliance)
   - Integraciones y dependencias externas (modos de falla, formatos, versionado)
   - Edge cases y manejo de fallas (negativos, rate limiting, conflictos de concurrencia)
   - Restricciones y trade-offs (técnicas, alternativas descartadas)
   - Terminología (glosario, sinónimos a evitar)
   - Señales de completitud (criterios de aceptación testeables, Definition of Done)
   - Marcadores `[NEEDS CLARIFICATION]`, TODOs, adjetivos vagos ("robusto", "intuitivo", "rápido") sin cuantificar
3. **Cola de preguntas** (interna, no la muestres): máx. **5**. Solo preguntas cuya respuesta cambie materialmente la arquitectura, el modelo de datos, las tareas, los tests, la UX, la operación o el compliance. Cada una respondible con:
   - opción múltiple de 2–5 opciones excluyentes, o
   - respuesta corta (≤ 5 palabras).
   Priorizá por impacto × incertidumbre. Nada de preguntas de estilo, ni de detalles que el plan resuelve mejor.
4. **Preguntar de a una**:
   - Para opción múltiple, poné primero tu **recomendación** con 1–2 líneas de por qué, y después las opciones (tabla o la herramienta de preguntas del entorno si la hay). Aceptá "sí"/"recomendada" como aceptar tu sugerencia.
   - Para respuesta corta, ofrecé tu sugerencia y pedí ≤ 5 palabras.
   - Si la respuesta es ambigua, pedí una aclaración rápida (no cuenta como pregunta nueva).
   - Pará cuando: se resolvieron las críticas, el usuario dice "listo/basta", o llegaste a 5.
5. **Integrar cada respuesta inmediatamente** (no al final):
   - En spec.md, asegurá una sección `## Clarifications` con un `### Session YYYY-MM-DD` y agregá `- Q: <pregunta> → A: <respuesta>`.
   - Aplicá la respuesta en la sección que corresponde: funcional → Functional Requirements; actor/rol → User Scenarios; datos → Key Entities; no funcional → criterio medible en Success Criteria; edge case → Edge Cases; terminología → normalizá en todo el documento.
   - Si contradice algo existente, **reemplazalo**; no dejes las dos versiones.
   - Guardá después de cada integración.
6. **Validar**: una línea por respuesta en la sesión, ≤ 5 preguntas, ningún marcador resuelto que siga pendiente, encabezados intactos, sin contradicciones.

## Reporte final

Cantidad de preguntas hechas, secciones tocadas, tabla de cobertura (Resolved / Deferred / Clear / Outstanding) y recomendación: `/sdd-plan` si no quedan Outstanding críticos, o correr `/sdd-clarify` de nuevo.
