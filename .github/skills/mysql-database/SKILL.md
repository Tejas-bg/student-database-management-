---
name: mysql-database
description: Use when working with the NEXUS MySQL 8+ server itself: connection setup, database and user creation, privileges, transactions, views, stored procedures, triggers, backups, or migration execution. Do not use it for ER modelling or normalization decisions.
---

# NEXUS Skill — MySQL Database Operations

## Purpose

Operate the NEXUS MySQL 8+ database safely: create the schema, manage users and privileges, run transactions, build views, procedures, and triggers, and keep the database reproducible.

## When to use

- Setting up the local MySQL database.
- Creating least-privilege database users.
- Running migrations.
- Writing `GRANT` and `REVOKE` scripts.
- Creating views, procedures, or triggers.
- Demonstrating `COMMIT`, `ROLLBACK`, and `SAVEPOINT`.
- Backing up or restoring the database.
- Diagnosing a connection problem.

## Required project context

1. `project-context/TECHNOLOGY_STACK.md`.
2. `project-context/SECURITY_STANDARDS.md`.
3. `project-context/SYSTEM_ARCHITECTURE.md` (Data Layer).
4. `database/documentation/DATABASE_DESIGN.md`.
5. `.github/instructions/database.instructions.md`.

## Workflow

1. **Confirm the stage.** Schema work starts in Stage 3.
2. **Confirm the schema is approved.** If it is marked PLANNING, do not create tables.
3. **Check the MySQL version.** `SELECT VERSION();` must be 8.0 or later.
4. **Create the database.** Use InnoDB and `utf8mb4`.
5. **Create users with least privilege.** Separate admin, app, and reporting users.
6. **Apply migrations in order.** Never edit an applied migration.
7. **Verify structure.** Use `SHOW CREATE TABLE` and `SHOW GRANTS`.
8. **Add views, procedures, and triggers** only when the schema is stable.
9. **Demonstrate transactions** with a controlled script and observable results.
10. **Record what ran and what happened.**
11. **Back up before destructive changes.**

## Rules and restrictions

- MySQL 8+ only. Never SQLite.
- InnoDB and `utf8mb4`.
- Every table has a primary key.
- Foreign keys have explicit `ON DELETE`/`ON UPDATE`.
- Money uses `DECIMAL`.
- No real student data.
- No credentials in SQL files.
- Do not run destructive commands without confirmation.
- Do not create tables in Stage 0.
- Do not grant `ALL PRIVILEGES` to the application user.

## Quality checklist

- [ ] MySQL version is 8.0+.
- [ ] Database uses InnoDB and `utf8mb4`.
- [ ] Users follow least privilege.
- [ ] `SHOW GRANTS` confirms the intended rights.
- [ ] Migrations run in order on a clean database.
- [ ] Constraints exist and behave correctly.
- [ ] Transaction demo shows `COMMIT`, `ROLLBACK`, and `SAVEPOINT`.
- [ ] Views return the expected columns.
- [ ] No secrets or real data in scripts.
- [ ] Backup exists before destructive work.
- [ ] Every command and result is recorded.

## Expected deliverables

- `database/schema/*.sql`
- `database/migrations/*.sql`
- `database/seeds/*.sql`
- `database/views/*.sql`
- `database/procedures/*.sql`
- `database/triggers/*.sql`
- DCL scripts with `GRANT`/`REVOKE`
- A run record in `database/documentation/`

## Common mistakes to avoid

- Creating tables before the schema is reviewed.
- Using `FLOAT` for money.
- Granting `ALL PRIVILEGES` to the app user.
- Editing an applied migration.
- Running `DROP` without a backup.
- Forgetting `ON DELETE` behaviour.
- Claiming a migration succeeded without checking the result.
- Mixing SQLite syntax into MySQL scripts.
