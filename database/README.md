# GM University Management System — Database

> **Stage 3 status: DESIGN COMPLETE, CORRECTIONS APPLIED FOR REVIEW.** The schema, views, integrity triggers, seed data, demonstrations, and documentation exist as reviewed scripts. **Nothing has been executed against MySQL, and no database is connected.**
> **Rule:** Do not create tables or connect the application until the schema is approved.

## 1. Purpose

This folder holds everything related to the MySQL 8+ database:

- the relational design and ER model,
- the DDL schema,
- fictional seed data,
- reporting views,
- SQL demonstrations for DDL/DML/DQL/DCL/TCL, joins, subqueries, aggregates, and transactions,
- and the documentation needed to explain and defend the database.

## 2. Structure

| Folder | Purpose | Status |
|---|---|---|
| `schema/` | Complete DDL (`001_schema.sql`) | Prepared, not executed |
| `migrations/` | Numbered schema changes | Reserved for Stage 6 |
| `seeds/` | Fictional sample data (`001_sample_data.sql`) | Prepared, not executed |
| `views/` | Reporting views (`001_views.sql`) | Prepared, not executed |
| `demonstrations/` | DDL, DML, DQL, DCL, TCL, join, subquery, aggregate demos | Prepared, not executed |
| `procedures/` | Stored procedures | Reserved for a later stage |
| `triggers/` | Cross-table integrity triggers (`001_integrity_triggers.sql`) | Prepared, not executed |
| `documentation/` | Architecture, ER diagram, data dictionary, normalization, security, mapping | Complete for review |

## 3. Rules

- MySQL 8+ only. Never SQLite.
- InnoDB and `utf8mb4` (`utf8mb4_0900_ai_ci`).
- Every table has a primary key.
- Foreign keys have explicit `ON DELETE` and `ON UPDATE` actions.
- Money uses `DECIMAL`.
- Every schema change is a numbered migration.
- Never edit an applied migration; add a new one.
- Seed data is fictional.
- No real student data.
- No credentials in SQL files.
- The schema stays **design-only** until reviewed and executed in a later stage.

## 4. Recommended execution order (later stage)

1. Create the database and least-privilege users.
2. Run `schema/001_schema.sql`.
3. Create `views/001_views.sql`.
4. Create `triggers/001_integrity_triggers.sql`.
5. Load `seeds/001_sample_data.sql`.
6. Create procedures if required.
7. Run verification queries.
8. Record the results in `docs/testing/`.

This order is planned, not executed.

## 5. Required DBMS demonstrations

The database demonstrates:

- ER modelling
- Relational design
- Primary and foreign keys (51 FKs, including one composite assignment FK)
- Constraints (29 CHECK constraints)
- Normalization to 3NF (with documented business exceptions)
- DDL, DML, DQL, DCL, TCL
- Joins (INNER, LEFT, RIGHT, self)
- Subqueries
- Aggregate functions
- Views
- Triggers (10 cross-table integrity triggers)
- Functional unique index for nullable feedback scope
- Transactions (`COMMIT`, `ROLLBACK`, `SAVEPOINT`)
- `GRANT` and `REVOKE`
- Database security

See `documentation/SQL_CONCEPT_MAPPING.md`.

## 6. Documentation index

Start with `documentation/README.md`. Key documents:

- `DATABASE_ARCHITECTURE.md`
- `ER_DIAGRAM.md`
- `DATA_DICTIONARY.md`
- `TABLE_DESCRIPTIONS_AND_RELATIONSHIPS.md`
- `NORMALIZATION.md`
- `SECURITY.md`
- `REQUIREMENTS_TO_TABLE_MAPPING.md`
- `SQL_CONCEPT_MAPPING.md`