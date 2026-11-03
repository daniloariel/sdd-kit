---
name: sdd-specify
description: SDD fase 1 — convertir una descripción en lenguaje natural en la especificación de una feature (specs/NNN-nombre/spec.md) con user stories priorizadas, requisitos testeables y criterios de éxito medibles, más su checklist de calidad. Usala cuando el usuario describe qué quiere construir y trabaja con SDD/spec-kit.
argument-hint: "<descripción de la feature>"
---

# /sdd-specify

Convenciones de archivos y flujo completo: skill `sdd`.

El texto que acompaña la invocación **es** la descripción de la feature. Si está vacío, pedila; no inventes una.

Una invocación = una feature.

## Modo corto (carril 1)

Si el carril es liviano: spec de ≤ 1 página, 1–2 user stories, Given/When/Then solo de los flujos principales, FRs mínimos, *Out of Scope* y como mucho 1 `[NEEDS CLARIFICATION]`. No crees `checklists/requirements.md` (aplicá mentalmente los mismos ítems). Si no entra en una página, probablemente es carril 2: decíselo al usuario.

## Pasos

1. **Nombre corto** (2–4 palabras, kebab-case, formato acción-sustantivo): "quiero que los usuarios se registren con Google" → `google-signup`. Conservá siglas técnicas (oauth2, api).
2. **Directorio**: siguiente número de 3 dígitos libre en `specs/` → `specs/NNN-nombre/`. Crealo y escribí `.specify/feature.json` con `{"feature_directory": "specs/NNN-nombre"}`. No crees ramas de git salvo que el usuario lo pida.
3. **Contexto**: leé `.specify/memory/constitution.md` y `.specify/memory/domain.md` si existen. Leé `templates/spec-template.md` (de esta skill, u override en `.specify/templates/`) y copialo a `spec.md`.
4. **Redactar la spec** respetando orden y encabezados de la plantilla:
   1. Extraé actores, acciones, datos y restricciones.
   2. **User Scenarios & Testing** (obligatorio): user stories priorizadas P1, P2, P3…, cada una *independientemente testeable* (si solo implementás esa, ¿entrega valor?). Para cada una: por qué esa prioridad, cómo se testea sola, escenarios Given/When/Then. Si no podés derivar ningún flujo de usuario, frená y pedí más detalle.
   3. **Edge cases**.
   4. **Functional Requirements** `FR-001…`: cada uno testeable y sin ambigüedad ("MUST permitir…", no "debería ser rápido").
   5. **Key Entities** si hay datos: qué representan y cómo se relacionan, sin tipos ni tablas.
   6. **Success Criteria** `SC-001…`: medibles, centrados en el usuario y **agnósticos de tecnología** ("el usuario completa el checkout en menos de 3 min", no "la API responde en 200 ms").
   7. **Assumptions**: cada default razonable que tomaste.
   8. **Out of Scope** (obligatorio): lista corta de lo que **no** entra en esta feature, incluido lo que alguien podría asumir razonablemente que sí ("notificaciones por email", "edición masiva", "soporte mobile"). Es lo que más frena que la implementación agregue de más.
   - Secciones opcionales que no aplican: borralas, no pongas "N/A".
5. **Incertidumbre**: ante algo no especificado, decidí con un default razonable de la industria y documentalo en Assumptions. Usá `[NEEDS CLARIFICATION: pregunta concreta]` **solo** si el impacto en alcance/UX es grande, hay varias interpretaciones razonables con consecuencias distintas y no hay default sensato. **Máximo 3**, priorizadas: alcance > seguridad/privacidad > UX > detalles técnicos.
   No preguntes por: retención de datos estándar, performance típica web/mobile, manejo de errores amigable, auth estándar, patrones de integración habituales.
6. **Validación de calidad**: creá `checklists/requirements.md` con `templates/checklist-template.md` como estructura y estos ítems:
   - *Content Quality*: sin detalles de implementación (lenguajes, frameworks, APIs); enfocada en valor de usuario/negocio; entendible por no técnicos; secciones obligatorias completas.
   - *Requirement Completeness*: sin `[NEEDS CLARIFICATION]` pendientes; requisitos testeables y no ambiguos; criterios de éxito medibles y agnósticos de tecnología; escenarios de aceptación definidos; edge cases identificados; alcance acotado y *Out of Scope* definido; dependencias y supuestos explícitos.
   - *Feature Readiness*: cada FR tiene criterio de aceptación claro; los escenarios cubren los flujos primarios; no se filtra implementación en la spec.

   Evaluá cada ítem citando la parte de la spec que falla. Corregí la spec y re-validá (máx. 3 iteraciones); si algo sigue fallando, anotalo en *Notes* del checklist y avisá.
7. **Si quedan `[NEEDS CLARIFICATION]`**: presentá todas las preguntas juntas (Q1…Q3), cada una con contexto citado y una tabla de opciones:

   | Opción | Respuesta | Implicancias |
   |--------|-----------|--------------|
   | A | … | … |
   | B | … | … |
   | Custom | Tu propia respuesta | … |

   Esperá la respuesta ("Q1: A, Q2: Custom – …"), reemplazá cada marcador por la decisión, y re-validá. Si el entorno tiene una herramienta de preguntas con opciones, usala en lugar de la tabla.
8. Actualizá el checklist con el estado final.

## Reporte final

Directorio de la feature, ruta de spec.md, resultado del checklist (pasa / qué quedó), y siguiente paso: `/sdd-clarify` si hay zonas grises, si no `/sdd-plan <stack>`.

## Recordatorio

**Qué** y **por qué**, nunca **cómo**. Escribí para alguien de negocio. Pensá como un tester: todo requisito vago debería fallar el ítem "testeable y no ambiguo".
