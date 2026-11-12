# ADR-005 — Database Access Strategy

- **Date:** 2026-11-12
- **Status:** Proposed — awaiting user approval
- **Supersedes:** None
- **Superseded by:** None

## Context

The project must demonstrate real SQL while staying secure and maintainable. A beginner might be tempted to put SQL directly in Flask routes, or to use an ORM that hides SQL entirely. Both choices have problems for this project.

## Options considered

| Option | Pros | Cons |
|---|---|---|
| Raw SQL in routes | Fast to write; obvious. | Mixes HTTP and data concerns; hard to test; easy to duplicate; easy to introduce injection. |
| ORM (SQLAlchemy) | Less boilerplate; safer defaults. | Hides the SQL the project must demonstrate; adds a large dependency; can obscure what the student is learning. |
| Repository layer with parameterized raw SQL | Keeps SQL explicit and testable; separates concerns; supports the DBMS demonstration. | More files; the student must learn the pattern. |
| Stored procedures only | Strong database encapsulation; demonstrates advanced SQL. | Harder to debug; less visible to the application; overkill for every operation. |

## Decision (proposed)

Use a **repository/data-access layer** that contains parameterized raw SQL executed through **MySQL Connector/Python**. Routes call services; services call repositories. Stored procedures may be used for selected demonstrations in Stage 6, but they are not the default access path.

## Reasons

- SQL stays visible for the DBMS requirement.
- Parameterized queries are easier to enforce consistently.
- Repositories can be tested independently.
- The application is not coupled to a specific ORM.

## Consequences

### Positive

- Clear separation between HTTP, business rules, and SQL.
- Easier to audit for SQL injection.
- The student can explain each query.

### Negative

- More boilerplate than an ORM.
- The student must manage connections and transactions manually.
- The repository pattern is a proposed choice, not a requirement from the brief.

### Follow-up work

- Get user approval before implementing.
- Document connection and transaction handling in `SYSTEM_ARCHITECTURE.md`.
- Add tests for repositories in Stage 4.

## Related decisions

- ADR-002 — Three-Tier Architecture
- ADR-003 — MySQL Database Selection
