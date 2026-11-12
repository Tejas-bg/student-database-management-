# NEXUS Database

> **Schema state: PLANNING.** Nothing in this folder has been executed against MySQL.
> **Rule:** Do not create tables until the schema is reviewed and approved.

---

## 1. Purpose

This folder holds everything related to the MySQL 8+ database:

- the relational design,
- the DDL and migrations,
- fake seed data,
- reporting views,
- stored procedures and triggers,
- and the documentation needed to explain the database in a viva.

---

## 2. Structure

| Folder | Purpose | Status |
|---|---|---|
| `schema/` | Table definitions (DDL). | Planning |
| `migrations/` | Numbered, ordered schema changes. | Planning |
| `seeds/` | Fake sample data. | Planning |
| `views/` | Reporting views. | Planning |
| `procedures/` | Stored procedures. | Planning |
| `triggers/` | Triggers. | Planning |
| `documentation/` | ER diagram, design, normalization, relationships, SQL concept map, data dictionary. | Planning |

---

## 3. Rules

- MySQL 8+ only. Never SQLite.
- InnoDB and `utf8mb4`.
- Every table has a primary key.
- Foreign keys have explicit `ON DELETE` and `ON UPDATE` actions.
- Money uses `DECIMAL`.
- Every schema change is a numbered migration.
- Never edit an applied migration; add a new one.
- Seed data is fake.
- No real student data.
- No credentials in SQL files.
- The schema stays **PLANNING** until reviewed.

---

## 4. Recommended execution order (later stage)

1. Create the database and users.
2. Run migrations in numeric order.
3. Load seed data.
4. Create views.
5. Create procedures and triggers.
6. Run verification queries.
7. Record the results.

This order is planned, not executed.

---

## 5. Required DBMS demonstrations

The database must demonstrate:

- ER modelling
- Relational design
- Primary and foreign keys
- Constraints
- Normalization to 3NF
- DDL, DML, DQL, DCL, TCL
- Joins
- Subqueries
- Aggregate functions
- Views
- Transactions (`COMMIT`, `ROLLBACK`, `SAVEPOINT`)
- `GRANT` and `REVOKE`
- Database security

See `documentation/SQL_CONCEPT_MAPPING.md`.
