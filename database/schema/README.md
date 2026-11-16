# Schema

> **Status: PREPARED — not executed.** No DDL has been run against MySQL.

This folder holds the table definitions for the GM University Management System.

## Files

| File | Purpose |
|---|---|
| `001_schema.sql` | Complete schema: `CREATE DATABASE`, 24 tables, 51 FKs, 32 unique keys, 29 CHECK constraints, indexes, and `FOREIGN_KEY_CHECKS` handling. |

## Rules

- MySQL 8.0.16+ syntax only (CHECK constraints are enforced from 8.0.16).
- InnoDB and `utf8mb4` (`utf8mb4_0900_ai_ci`).
- Explicit primary keys, foreign keys, unique keys, checks, and defaults.
- No real data.
- No credentials.
- Do not create these tables until the schema is approved.
- Run the integrity triggers after the schema and before the seed data.

## Verification when built

- Run on a clean MySQL 8 database.
- Check every table with `SHOW CREATE TABLE`.
- Confirm foreign key behaviour.
- Confirm constraints reject invalid data.
- Confirm the integrity triggers compile and reject mismatched attendance, marks, fees, and notification targets.
- Confirm all views in `../views/001_views.sql` compile.
- Record results in `docs/testing/`.

## Related documentation

- `../documentation/DATABASE_ARCHITECTURE.md`
- `../documentation/ER_DIAGRAM.md`
- `../documentation/DATA_DICTIONARY.md`
- `../documentation/TABLE_DESCRIPTIONS_AND_RELATIONSHIPS.md`