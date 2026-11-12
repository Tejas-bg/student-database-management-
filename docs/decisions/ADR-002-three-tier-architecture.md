# ADR-002 — Three-Tier Architecture

- **Date:** 2026-11-12
- **Status:** Approved
- **Supersedes:** None
- **Superseded by:** None

## Context

The project must be structured so that the browser, the application logic, and the database are clearly separated. The student must be able to explain the separation in a viva, and the design must support security and testing.

## Options considered

| Option | Pros | Cons |
|---|---|---|
| Single-tier / monolith | Simplest to start. | Mixes UI, logic, and SQL; hard to test and explain. |
| Two-tier client–server | Fewer moving parts. | The client would need database access or a very thick server; poor security. |
| Three-tier | Clear separation, better security, testable layers, matches the brief. | More files and concepts to learn. |

## Decision

Use a **three-tier architecture**:

1. Presentation — HTML, CSS, JavaScript, Bootstrap 5, Chart.js.
2. Application — Flask routes, services, validation, authentication, repositories.
3. Data — MySQL 8+ tables, keys, constraints, views, transactions.

The browser never connects to MySQL directly.

## Reasons

- It matches the project brief.
- It keeps database credentials on the server.
- It allows each layer to be tested independently.
- It makes the architecture diagram and viva explanation straightforward.

## Consequences

### Positive

- Clear responsibility boundaries.
- Better security posture.
- Easier to explain and grade.

### Negative

- More structure than a small script.
- The student must understand the flow between layers.

### Follow-up work

- Keep routes thin and SQL in repositories.
- Record any layer-boundary change in a new ADR.

## Related decisions

- ADR-001 — Technology Stack
- ADR-005 — Database Access Strategy
