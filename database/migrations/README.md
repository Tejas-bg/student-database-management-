# Migrations

> **Status: PLANNING.** No migration has been executed.

Migrations are numbered SQL scripts that change the schema in order. They make the database reproducible.

## Naming

```
NNN_short_description.sql
```

Examples:

```
001_create_departments.sql
002_create_courses.sql
003_create_students.sql
```

## Rules

- Run in numeric order.
- Never edit an applied migration. Add a new one.
- Each migration should do one logical change.
- Include a comment with the purpose and author.
- Test on a clean database.
- Back up before destructive changes.
- No secrets.
- No real data.

## Planned verification

- Apply all migrations to a fresh database.
- Confirm the final schema matches `documentation/DATABASE_DESIGN.md`.
- Confirm rollback or recovery steps for destructive migrations.
