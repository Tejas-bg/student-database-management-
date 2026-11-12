# NEXUS — Project Overview

> **Status:** Authoritative project overview. Read this first.
> **Last reviewed:** Stage 0 (workspace setup).
> **Do not mark any implementation work as done here.** See `CURRENT_STATUS.md` for the verified state.

---

## 1. What is NEXUS?

NEXUS is a **college DBMS project** that builds a web-based **Student Management Database System**.

It is a practical demonstration of database management concepts: modelling data with entities and relationships, designing normalized relational tables, enforcing integrity with keys and constraints, and querying data with SQL. The application is the visible layer on top of that database work.

The tagline is **"Education, connected."** — the idea is that student records, courses, faculty, attendance, marks, fees, and feedback all live in one connected system instead of in separate spreadsheets.

---

## 2. What problem does it solve?

A college typically stores student information in disconnected places: paper registers, spreadsheets, and separate software for fees or attendance. That causes:

- Duplicate and inconsistent student records.
- Slow report generation.
- Difficulty tracking attendance and internal marks.
- Weak auditability of fee payments.
- No single view of a student's academic performance.

NEXUS brings those records into one normalized MySQL database and exposes them through a clean web interface.

---

## 3. Who is it for?

| User | Main needs |
|---|---|
| Student | View own profile, subjects, attendance, marks, fees, and feedback status. |
| Faculty | View assigned subjects, record attendance and marks, see class performance. |
| Administrator | Manage students, faculty, departments, courses, subjects, enrolments, fees, and reports. |
| Examiner / evaluator | See the DBMS concepts demonstrated clearly in schema and SQL. |

Authentication and role-based access are part of the design. The exact role model is confirmed during later stages.

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

NEXUS uses a **three-tier architecture**:

1. **Presentation layer** — what the user sees in the browser.
2. **Application layer** — Flask routes, services, validation, and authorization.
3. **Data layer** — MySQL tables, keys, constraints, views, and transactions.

The browser never talks to MySQL directly. The full design, with diagrams, is in `SYSTEM_ARCHITECTURE.md`.

---

## 8. Design direction at a glance

The visual language is a hybrid of **Apple-style minimalism** and **Nothing-style monochrome technical detail**.

- Obsidian `#111111`
- Paper `#F5F5F2`
- White `#FFFFFF`
- Silver `#BDBDBD`
- Graphite `#292929`
- Signal Lime `#D7FF35` (accent only)

Full rules: `DESIGN_PRINCIPLES.md`.

---

## 9. Current stage

**Stage 0 — Project Workspace and Context Setup.**

No application, backend, or database implementation has started. See `CURRENT_STATUS.md` for the verified state.

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
