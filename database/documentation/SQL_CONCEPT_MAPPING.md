# NEXUS — SQL and DBMS Concept Mapping

> **Status: PLANNING.** This maps each required concept to a planned artifact.
> **No concept is implemented yet.** Status changes only after the artifact runs and is verified.

---

## 1. Concept map

| # | Concept | Planned artifact | Stage | How it will be demonstrated | Status |
|---|---|---|---|---|---|
| 1 | ER modelling | `database/documentation/ER_DIAGRAM.md` | 3 | Mermaid ER diagram and explanation | Planned |
| 2 | Relational database design | `database/documentation/DATABASE_DESIGN.md` | 3 | Table design and rationale | Planned |
| 3 | Primary keys | `database/schema/*.sql` | 3 | Every table has a PK | Planned |
| 4 | Foreign keys | `database/schema/*.sql` | 3 | Relationships with `ON DELETE`/`ON UPDATE` | Planned |
| 5 | Constraints | `database/schema/*.sql` | 3 | `NOT NULL`, `UNIQUE`, `CHECK`, `DEFAULT` | Planned |
| 6 | Normalization to 3NF | `database/documentation/NORMALIZATION.md` | 3 | 1NF → 2NF → 3NF walkthrough | Planned |
| 7 | SQL DDL | `database/schema/`, `database/migrations/` | 3 | `CREATE`, `ALTER` | Planned |
| 8 | SQL DML | `database/seeds/`, application writes | 3–5 | `INSERT`, `UPDATE`, `DELETE` | Planned |
| 9 | SQL DQL | `database/views/`, module queries | 5–6 | `SELECT` with filters and ordering | Planned |
| 10 | SQL DCL | `database/documentation/` DCL script | 6 | `GRANT`, `REVOKE` | Planned |
| 11 | SQL TCL | `database/documentation/` transaction demo | 6 | `COMMIT`, `ROLLBACK`, `SAVEPOINT` | Planned |
| 12 | Joins | `database/views/vw_student_profile.sql` etc. | 5–6 | `INNER`, `LEFT` joins | Planned |
| 13 | Subqueries | Reporting queries | 6 | Correlated and non-correlated subqueries | Planned |
| 14 | Aggregate functions | `vw_attendance_summary`, `vw_fee_status` | 5–6 | `COUNT`, `SUM`, `AVG`, `MIN`, `MAX` | Planned |
| 15 | Views | `database/views/*.sql` | 6 | Reporting views | Planned |
| 16 | Transactions | Fee payment flow | 5–6 | Multi-step write with `COMMIT`/`ROLLBACK` | Planned |
| 17 | `COMMIT` | Transaction demo | 6 | Save a successful payment | Planned |
| 18 | `ROLLBACK` | Transaction demo | 6 | Undo a failed payment | Planned |
| 19 | `SAVEPOINT` | Bulk marks demo | 6 | Partial rollback | Planned |
| 20 | `GRANT` | DCL script | 6 | Grant least-privilege access | Planned |
| 21 | `REVOKE` | DCL script | 6 | Revoke a privilege | Planned |
| 22 | Database security | Schema + DCL + app code | 3–8 | Least privilege, constraints, parameterized queries | Planned |

---

## 2. Planned demonstration scripts

These files do not exist yet. They are listed so the mapping is concrete.

| File (planned) | Purpose |
|---|---|
| `database/schema/001_reference_tables.sql` | Departments, courses, semesters, roles. |
| `database/schema/002_people.sql` | Students, faculty, users. |
| `database/schema/003_academic_structure.sql` | Subjects, assignments, enrolments. |
| `database/schema/004_assessment.sql` | Attendance, assessments, exams, marks. |
| `database/schema/005_finance.sql` | Fee structure and payments. |
| `database/schema/006_feedback.sql` | Feedback. |
| `database/views/vw_student_profile.sql` | Join demonstration. |
| `database/views/vw_attendance_summary.sql` | Aggregate demonstration. |
| `database/views/vw_fee_status.sql` | Aggregate and join demonstration. |
| `database/views/vw_semester_results.sql` | Multi-table performance view. |
| `database/documentation/DEMO_DCL.sql` | `GRANT` and `REVOKE`. |
| `database/documentation/DEMO_TCL.sql` | `COMMIT`, `ROLLBACK`, `SAVEPOINT`. |
| `database/documentation/DEMO_SUBQUERIES.sql` | Subquery examples. |

File names may change when the schema is approved; the mapping must be updated if they do.

---

## 3. Viva explanation notes (to be completed later)

For each concept, prepare:

1. A one-sentence definition.
2. Where it appears in NEXUS.
3. Why it matters.
4. A live example the examiner can run.

This section will be filled in Stage 6 and refined in Stage 10.

---

## 4. Verification rule

A concept is marked **Implemented** only when its artifact exists and runs. It is marked **Tested** only when the output has been checked and recorded. Until then it stays **Planned**.
