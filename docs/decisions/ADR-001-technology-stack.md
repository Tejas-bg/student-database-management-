# ADR-001 — Technology Stack

- **Date:** 2026-11-12
- **Status:** Approved (baseline)
- **Supersedes:** None
- **Superseded by:** None

## Context

The GM University Management System is a college DBMS project. The student is a beginner. The project must demonstrate database concepts, not hide them behind an ORM or a heavy framework. It must run locally on a typical student laptop and be explainable in a viva.

## Options considered

| Option | Pros | Cons |
|---|---|---|
| Python + Flask + MySQL Connector/Python | Small, readable, explicit request/response model, strong SQL visibility, beginner-friendly. | Fewer built-in features than Django; the student must write more wiring. |
| Python + Django + ORM | Batteries included; admin panel. | The ORM hides SQL, which conflicts with the DBMS demonstration goal. Heavier to learn. |
| Node.js + Express + MySQL | Modern JavaScript end to end. | Splits the student's learning across two languages; less common for college DBMS projects. |
| PHP + MySQL | Classic LAMP stack; widely taught. | Older patterns; weaker structure for a clean layered project. |

## Decision

Use **Python 3.10+, Flask, and MySQL Connector/Python** for the backend; **HTML5, CSS3, JavaScript, Bootstrap 5, and Chart.js** for the frontend; **MySQL 8+** for the database; **Visual Studio Code with AI Agent Mode** as the development environment.

## Reasons

- Flask keeps the layers visible, which helps the student explain the architecture.
- Raw SQL through MySQL Connector/Python is compatible with the DBMS demonstration requirement.
- The frontend stack is standard, widely documented, and does not require a build step.
- The stack is free, local, and easy to set up.

## Consequences

### Positive

- The student can see and explain every layer.
- SQL is written explicitly, which supports the viva.
- The dependency list stays small.

### Negative

- More manual wiring than Django.
- The student must learn Flask patterns (blueprints, application factory).
- No built-in admin panel; the UI must be built.

### Follow-up work

- Pin exact versions in `backend/requirements.txt` when the backend is created.
- Confirm the local Python and MySQL versions before Stage 3.
- Record any deviation in a new ADR.

## Related decisions

- ADR-002 — Three-Tier Architecture
- ADR-003 — MySQL Database Selection
- ADR-005 — Database Access Strategy
