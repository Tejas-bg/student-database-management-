---
applyTo: "database/**,**/*.sql"
---

# GM University Management System â€” Database Instructions

These rules apply to every file under `database/` and every `.sql` file.

## Before writing SQL

1. Read `project-context/SYSTEM_ARCHITECTURE.md`.
2. Read `database/documentation/DATABASE_DESIGN.md` and `TABLE_RELATIONSHIPS.md`.
3. Check `database/documentation/NORMALIZATION.md`.
4. Confirm the schema is approved in `CURRENT_STATUS.md`. If it is still "PLANNING", do not execute it.

## Non-negotiable rules

- Target **MySQL 8+** only. Never write SQLite-specific syntax.
- Use `InnoDB` and `utf8mb4`.
- Every table needs a primary key.
- Foreign keys must have an explicit `ON DELETE` and `ON UPDATE` action.
- Use `CHECK` constraints where MySQL 8 supports them.
- Use `NOT NULL` unless `NULL` is genuinely meaningful.
- Use `DECIMAL` for money, never `FLOAT`/`DOUBLE`.
- Use `DATE`/`DATETIME` for dates, not strings.
- Add indexes for foreign keys and frequent filters.
- Never hardcode passwords, hostnames, or usernames in SQL scripts.
- Never include real student data in seed files. Use clearly fake sample data.
- Every schema change must be a numbered migration in `database/migrations/`.
- Do not edit an applied migration. Add a new one.

## Naming conventions

- Tables: `snake_case`, plural (`students`, `courses`, `attendance_records`).
- Columns: `snake_case`, singular (`student_id`, `created_at`).
- Primary key: `<table_singular>_id`.
- Foreign key: same name as the referenced primary key.
- Views: `vw_<purpose>`.
- Procedures: `sp_<verb>_<entity>`.
- Triggers: `trg_<table>_<timing>_<event>`.

## Verification

- Run the migration against a real MySQL 8 instance.
- Confirm tables, keys, and constraints with `SHOW CREATE TABLE`.
- Confirm sample queries return the expected shape.
- Record what was run and what happened.
