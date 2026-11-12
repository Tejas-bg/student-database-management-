# GM University Management System — Project Overview

> **Status:** Authoritative project overview. Read this first.
> **Last reviewed:** Stage 1 (design system and login preview).
> **Do not mark any implementation work as done here.** See `CURRENT_STATUS.md` for the verified state.

---

## 1. What is the GM University Management System?

The GM University Management System is a **college DBMS project** for **GM University, Davanagere, Karnataka**. It builds a web-based, centralized university student and academic management application.

It is a practical demonstration of database management concepts: modelling data with entities and relationships, designing normalized relational tables, enforcing integrity with keys and constraints, and querying data with SQL. The application is the visible layer on top of that database work.

The tagline is **"Empowering Education Through Connected Technology"** — the idea is that student records, courses, faculty, attendance, marks, fees, and feedback all live in one connected system instead of in separate spreadsheets.

The short display name **GMU Management System** is used in compact interface areas such as the sidebar, page titles, and browser tabs. Formal documentation uses the full name.

> **Independence:** this is a student project built for the university. It is not an official university service and must not imply university endorsement.

---

## 2. What problem does it solve?

A college typically stores student information in disconnected places: paper registers, spreadsheets, and separate software for fees or attendance. That causes:

- Duplicate and inconsistent student records.
- Slow report generation.
- Difficulty tracking attendance and internal marks.
- Weak auditability of fee payments.
- No single view of a student's academic performance.

The GM University Management System brings those records into one normalized MySQL database and exposes them through a clean web interface.

---

## 3. Who is it for?

| User | Main needs |
|---|---|
| Student | View own profile, subjects, attendance, marks, fees, and feedback status. |
| Faculty | View assigned subjects, record attendance and marks, see class performance. |
| Administrator | Manage students, faculty, departments, courses, subjects, enrolments, fees, and reports. |
| Examiner / evaluator | See the DBMS concepts demonstrated clearly in schema and SQL. |

Everyone signs in through **one common login page**. There is no student/faculty/admin selection. The backend looks up the registered MySQL account, verifies the password hash, reads the stored role, and redirects to the correct dashboard. The role is never decided by the login ID format or by frontend JavaScript.

---

## 4. What will the system manage?

- Student personal information
- Departments
- Courses
- Subjects
- Semesters
- Faculty
- Faculty–subject assignments
- Student enrolments
- Attendance
- Internal assessment marks
- Semester examination marks
- Academic performance
- Fee records and payments
- Student feedback
- Reports and analytics

---

## 5. What makes this a DBMS project?

The application is not only a CRUD website. It must visibly demonstrate:

| Concept | Where it appears |
|---|---|
| ER modelling | `database/documentation/ER_DIAGRAM.md` |
| Relational design | `database/documentation/DATABASE_DESIGN.md` |
| Primary keys | Every table |
| Foreign keys | Relationship tables and child tables |
| Constraints | `NOT NULL`, `UNIQUE`, `CHECK`, `DEFAULT` |
| Normalization to 3NF | `database/documentation/NORMALIZATION.md` |
| SQL DDL | `database/schema/` and migrations |
| SQL DML | Seed and application writes |
| SQL DQL | Reports and listing queries |
| SQL DCL | `GRANT` / `REVOKE` scripts |
| SQL TCL | `COMMIT`, `ROLLBACK`, `SAVEPOINT` flows |
| Joins | Multi-table reports |
| Subqueries | Filtered reports and analytics |
| Aggregate functions | Counts, averages, totals |
| Views | Reporting views |
| Transactions | Fee payment and marks entry |
| Database security | Least-privilege users and input safety |

---

## 6. Technology at a glance

| Layer | Technology |
|---|---|
| Presentation | HTML5, CSS3, JavaScript, Bootstrap 5, Chart.js |
| Application | Python, Flask, MySQL Connector/Python |
| Data | MySQL 8+ |

The full list, with versions and rules, is in `TECHNOLOGY_STACK.md`.

---

## 7. Architecture at a glance

The GM University Management System uses a **three-tier architecture**:

1. **Presentation layer** — what the user sees in the browser.
2. **Application layer** — Flask routes, services, validation, and authorization.
3. **Data layer** — MySQL tables, keys, constraints, views, and transactions.

The browser never talks to MySQL directly. The full design, with diagrams, is in `SYSTEM_ARCHITECTURE.md`.

---

## 8. Design direction at a glance

The visual language combines **Apple-style calm and precision** with **Nothing-style monochrome technical detail**, anchored by the official GM University identity.

The palette is derived from the official logo — gold artwork on university maroon:

- University Maroon `#5B2020`
- Deep Maroon `#421919`
- University Gold `#E3B559`
- Warm Ivory `#F8F6F0`
- White `#FFFFFF`
- Graphite `#242424`
- Muted Grey `#8A8580`

The official logo is used unmodified. Full rules: `DESIGN_PRINCIPLES.md`, `../docs/design/GMU_BRAND_GUIDELINES.md`, and `../docs/design/GMU_LOGIN_DESIGN.md`.

---

## 9. Current stage

**Stage 1 — UI/UX Design System and Visual Identity.**

The design system, dashboard preview, component reference, and common login preview are implemented and awaiting user approval. No backend, authentication, or database implementation has started. See `CURRENT_STATUS.md` for the verified state.

---

## 10. Related documents

- `PROJECT_REQUIREMENTS.md` — requirements and traceability.
- `PROJECT_SCOPE.md` — what is in and out of scope.
- `SYSTEM_ARCHITECTURE.md` — layers, flows, and folder responsibilities.
- `TECHNOLOGY_STACK.md` — approved tools.
- `MODULE_SPECIFICATIONS.md` — functional modules.
- `DESIGN_PRINCIPLES.md` — visual language.
- `CODING_STANDARDS.md` — code rules.
- `SECURITY_STANDARDS.md` — security rules.
- `DEVELOPMENT_WORKFLOW.md` — stages and workflow.
- `CURRENT_STATUS.md` — verified state.
- `GLOSSARY.md` — beginner-friendly terms.
