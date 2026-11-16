# GM University Management System — Roadmap

This is a one-page summary. The detailed version, with tasks, deliverables, dependencies, acceptance criteria, and testing requirements, is in `project-context/DEVELOPMENT_WORKFLOW.md`.

---

## Stages

| Stage | Name | Status |
|---|---|---|
| 0 | Project Workspace and Context Setup | Complete and approved |
| 1 | UI/UX Design System and Visual Identity | Complete and approved |
| 2 | Frontend Development | Complete and approved |
| 3 | MySQL Database Design and Implementation | Design complete, corrected, and statically validated; not executed |
| 4 | Flask Backend and Database Connection | Not started |
| 5 | Functional Module Development | Not started |
| 6 | SQL and DBMS Concept Demonstration | Not started |
| 7 | Integration and Testing | Not started |
| 8 | Security and Performance Review | Not started |
| 9 | Documentation and College Submission | Not started |
| 10 | Final Demonstration and Viva Preparation | Not started |

---

## Stage gates

Do not start the next stage until:

- [ ] The current stage's acceptance criteria are met.
- [ ] Tests are run and recorded.
- [ ] `TASKS.md`, `CHANGELOG.md`, and `CURRENT_STATUS.md` are updated.
- [ ] Documentation reflects reality.
- [ ] The user has approved the next stage.

---

## Immediate next step

Stage 3 database design is complete, corrected, and statically validated (24 tables, 51 FKs, 8 views, 10 integrity triggers). Nothing has been executed against MySQL, and Stage 4 awaits explicit user approval.

Review these first:

- `database/documentation/DATABASE_ARCHITECTURE.md`
- `database/documentation/ER_DIAGRAM.md`
- `database/documentation/DATA_DICTIONARY.md`
- `database/documentation/NORMALIZATION.md`
- `database/schema/001_schema.sql`
- `database/views/001_views.sql`
- `database/seeds/001_sample_data.sql`
- `database/demonstrations/`

The design supports every Stage 2 student, faculty, and administration page. It is **not** connected to the application and no tables have been created.

When you are satisfied, approve Stage 4:

> "Start Stage 4: Flask Backend and Database Connection."

Until then, do not execute the schema, create the database, or connect the application.
