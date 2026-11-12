# ADR-003 — MySQL Database Selection

- **Date:** 2026-11-12
- **Status:** Approved
- **Supersedes:** None
- **Superseded by:** None

## Context

The GM University Management System is a relational academic records system. The project must demonstrate primary keys, foreign keys, constraints, normalization, joins, subqueries, views, transactions, and access control. The database must run locally and be familiar to the evaluator.

## Options considered

| Option | Pros | Cons |
|---|---|---|
| MySQL 8+ | Required by the brief; widely taught; strong relational features; good tooling. | Some advanced syntax differs from PostgreSQL. |
| PostgreSQL | Excellent standards compliance and features. | Not the selected database; would conflict with the brief. |
| SQLite | Zero setup. | Not a server DBMS; weaker access control and concurrency story; explicitly forbidden by the project rules. |
| MongoDB | Flexible documents. | Not relational; cannot demonstrate the required relational concepts. |

## Decision

Use **MySQL 8+** with the InnoDB storage engine and the `utf8mb4` character set.

## Reasons

- It is the database named in the project brief.
- It supports every required DBMS concept.
- It is easy to install and inspect locally.
- It is familiar to college evaluators.

## Consequences

### Positive

- All required DBMS concepts can be demonstrated.
- The student can use MySQL Workbench or the command line.
- The schema can be exported and documented easily.

### Negative

- The student must install and run a MySQL server.
- `CHECK` constraint enforcement depends on MySQL 8.0.16+.
- Some features (for example, full outer joins) are not native and need workarounds.

### Follow-up work

- Confirm the local MySQL version before Stage 3.
- Create least-privilege users.
- Never use SQLite as a substitute, including in tests.

## Related decisions

- ADR-001 — Technology Stack
- ADR-005 — Database Access Strategy
