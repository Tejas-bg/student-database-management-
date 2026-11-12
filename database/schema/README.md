# Schema

> **Status: PLANNING.** No DDL has been executed.

This folder will hold the table definitions for NEXUS.

## Planned files

| File | Purpose |
|---|---|
| `001_reference_tables.sql` | Departments, courses, semesters, roles. |
| `002_people.sql` | Students, faculty, users. |
| `003_academic_structure.sql` | Subjects, assignments, enrolments. |
| `004_assessment.sql` | Attendance, internal assessments, semester exams, marks. |
| `005_finance.sql` | Fee structure and payments. |
| `006_feedback.sql` | Student feedback. |

File names and grouping are proposals. They are confirmed when the schema is approved.

## Rules

- MySQL 8+ syntax only.
- InnoDB and `utf8mb4`.
- Explicit primary keys, foreign keys, and constraints.
- No real data.
- No credentials.
- Do not create these tables until the schema is approved.

## Verification when built

- Run on a clean MySQL 8 database.
- Check every table with `SHOW CREATE TABLE`.
- Confirm foreign key behaviour.
- Confirm constraints reject invalid data.
