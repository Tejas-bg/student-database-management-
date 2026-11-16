# Stage 3 — MySQL Database Architecture and ER Design

> **Status:** Saved for the Stage 3 kickoff. **Not executed.** Stage 2 (frontend shell and role dashboards) is complete for review.
> Use this prompt as the scope and acceptance record for Stage 3. Do not begin until the user explicitly starts Stage 3.

## Goal

Act as a senior DBMS architect, MySQL developer, and software engineer.

The login page and Student, Faculty, and Admin dashboards have already been developed. Design the complete MySQL database architecture for the existing GM University Management System.

**IMPORTANT: This stage is DATABASE DESIGN ONLY. Do not connect or modify the live application database yet.**

## 1. Inspect the existing project

Before designing the database:

- Inspect the complete project folder structure.
- Examine Student, Faculty, and Admin dashboards.
- Identify all existing pages, forms, tables, fields, and actions.
- Understand the existing frontend technology and planned Flask backend.
- Identify what data each dashboard needs.
- Avoid designing duplicate or unnecessary database tables.

## 2. Database technology

Use:

- MySQL 8.0 or newer.
- InnoDB storage engine.
- UTF-8 using `utf8mb4`.
- Proper primary keys and foreign keys.
- Appropriate data types.
- Normalized relational database design.

## 3. Design database modules

Design tables for:

1. Users and roles.
2. Student personal information.
3. Faculty information.
4. Departments.
5. Courses.
6. Subjects.
7. Semesters and academic years.
8. Student enrolments.
9. Faculty-subject assignments.
10. Attendance.
11. Internal assessment marks.
12. Semester examination marks.
13. Fees and payments.
14. Timetables.
15. Notifications.
16. Student feedback.

Review whether additional tables are necessary based on the existing application.

## 4. Authentication database design

Design a secure account structure supporting:

- Student accounts.
- Faculty accounts.
- Administrator accounts.
- Common login identifier.
- Password hashes.
- Role-based access control.
- Account activation and deactivation.
- Password reset support.

The role must be determined from the registered database account, not from a user-selected role.

Do not store plaintext passwords.

Do not use Aadhaar as a login identifier unless its necessity and authorization are established.

## 5. ER diagram

Create a complete ER diagram showing:

- All entities.
- Primary keys.
- Foreign keys.
- One-to-one relationships.
- One-to-many relationships.
- Many-to-many relationships.
- Cardinality.
- Optional and mandatory relationships.

Save the ER diagram in a suitable format such as Mermaid ER diagram source.

## 6. Normalization

Explain and demonstrate:

- First Normal Form (1NF).
- Second Normal Form (2NF).
- Third Normal Form (3NF).

Identify potential insertion, update, and deletion anomalies and explain how the design avoids them.

## 7. SQL deliverables

Prepare:

- Complete database schema SQL script.
- `CREATE DATABASE` statements.
- `CREATE TABLE` statements.
- Primary and foreign key definitions.
- `NOT NULL`, `UNIQUE`, and `CHECK` constraints where appropriate.
- Index definitions.
- Views for useful academic reports.
- Sample `INSERT` statements using clearly identified fictional data.

Prepare example SQL demonstrations for:

- DDL.
- DML.
- DQL.
- DCL.
- TCL.
- `INNER JOIN`.
- `LEFT JOIN`.
- `RIGHT JOIN`.
- Subqueries.
- Aggregate functions.
- `GROUP BY` and `HAVING`.
- Transactions.
- `COMMIT`.
- `ROLLBACK`.
- `SAVEPOINT`.
- `GRANT` and `REVOKE`.

## 8. Documentation

Create a database documentation folder containing:

- ER diagram.
- Database architecture.
- Data dictionary.
- Table descriptions.
- Relationship explanations.
- Normalization report.
- SQL scripts.
- Requirements-to-table mapping.
- Security considerations.

## 9. Quality checks

Verify:

- Every table has an appropriate primary key.
- Foreign keys reference valid tables.
- Data types are appropriate.
- Duplicate records are prevented where necessary.
- Relationships are logically correct.
- Database design supports all three dashboards.
- Database design is compatible with future Flask integration.

## 10. Strict restrictions

- Do not delete or overwrite existing frontend files.
- Do not change the login page.
- Do not redesign dashboards.
- Do not modify existing authentication functionality.
- Do not connect to or modify an existing live database.
- Do not execute destructive SQL commands.
- Do not invent real university data.
- Do not claim the database is connected or operational.

## 11. Final report

After completion, report:

1. Tables designed.
2. Relationships created.
3. ER diagram location.
4. SQL files generated.
5. Normalization results.
6. DBMS requirements covered.
7. Any unresolved design decisions.
8. Actual validation performed.

Work carefully and incrementally. Preserve the existing project structure and make the database design ready for the next stage: MySQL implementation and Flask integration.

## Read first

1. `.github/copilot-instructions.md`
2. `project-context/PROJECT_OVERVIEW.md`
3. `project-context/PROJECT_REQUIREMENTS.md`
4. `project-context/PROJECT_SCOPE.md`
5. `project-context/SYSTEM_ARCHITECTURE.md`
6. `project-context/TECHNOLOGY_STACK.md`
7. `project-context/CURRENT_STATUS.md`
8. `TASKS.md`
9. `database/documentation/` (existing planning draft)
10. `docs/design/GMU_DASHBOARD_DESIGN.md` (Stage 2 page and data inventory)

## Expected file areas

- `database/schema/` — schema and DDL scripts.
- `database/seeds/` - fictional sample data.
- `database/views/` — reporting views.
- `database/documentation/` — architecture, ER source, data dictionary, normalization, security.
- `database/demonstrations/` — DDL/DML/DQL/DCL/TCL and join demonstrations.
- `CHANGELOG.md`, `TASKS.md`, `project-context/CURRENT_STATUS.md`.

Do not modify `frontend/`, `backend/`, or the login page in this stage.

## Verification

- Every table has a primary key.
- Every foreign key references an existing table and column.
- Data types and constraints match the documented rules.
- The design covers every Stage 2 page and form field.
- The ER source renders without errors.
- No destructive SQL is executed.
- No claim is made that the database is connected or operational.

## Stop condition

Stop after the design, scripts, and documentation are complete and validated. Wait for approval before Stage 4 (Flask backend and database connection).
