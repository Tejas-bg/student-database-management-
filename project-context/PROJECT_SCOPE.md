# GM University Management System — Project Scope

> **Status:** Baseline scope. Changes require user approval and an ADR if they affect architecture.
> **Last reviewed:** Stage 1.

---

## 1. Purpose of this document

This file defines what the GM University Management System will and will not include. It prevents scope creep — the gradual addition of features that were never planned — and protects the college submission from becoming too large to finish well.

---

## 2. In scope (baseline)

### 2.1 Core academic records

- Student personal information and academic profile.
- Departments, courses, subjects, and semesters.
- Faculty records and faculty–subject assignments.
- Student enrolments in subjects.

### 2.2 Identity and access

- One common login page for students, faculty, and administrators.
- Backend account lookup in MySQL.
- Password hashing and server-verified sessions (Stage 4).
- Automatic role detection from the registered account.
- Server-side role checks on every protected route.

The Stage 1 login page is a **design preview only**. It does not authenticate, store credentials, or create accounts.

### 2.3 Academic operations

- Attendance recording and viewing.
- Internal assessment marks.
- Semester examination marks.
- Academic performance summaries and analytics.

### 2.4 Administration

- Fee records and payments.
- Student feedback submission and review.
- Reports for students, faculty, and administrators.

### 2.5 DBMS demonstration

- ER model and relational schema.
- Normalization to 3NF.
- Primary keys, foreign keys, and constraints.
- DDL, DML, DQL, DCL, and TCL scripts.
- Joins, subqueries, aggregate functions, and views.
- Transactions with `COMMIT`, `ROLLBACK`, and `SAVEPOINT`.
- `GRANT` and `REVOKE` with least-privilege users.
- Input validation and parameterized queries.

### 2.6 Documentation and submission

- Project report material.
- Setup instructions.
- Test evidence.
- Viva preparation notes.

---

## 3. Out of scope (unless the user explicitly adds it)

- Online payment gateway integration. Fee records are managed inside the system; no real money moves.
- SMS or email notifications.
- Mobile native apps.
- Biometric or hardware attendance devices.
- Multi-college or multi-tenant hosting.
- AI-based performance prediction.
- Real student personal data. All data must be fake sample data.
- Production cloud deployment with public access.
- Single sign-on with a college identity provider.
- Aadhaar-based login unless university policy explicitly approves and supports it.
- Separate student, faculty, and administrator login pages, or any manual role selection.
- Complex timetabling or room allocation.
- Library, hostel, or transport management.

These are reasonable future extensions, but they are **not** part of the baseline and must not be added silently.

---

## 4. Constraints

| Constraint | Detail |
|---|---|
| Database | MySQL 8+ only. No SQLite fallback. |
| Backend | Python Flask only. |
| Connector | MySQL Connector/Python. |
| Frontend | HTML, CSS, JavaScript, Bootstrap 5, Chart.js. |
| Environment | Visual Studio Code with AI Agent Mode. |
| Audience | Beginner developer; explanations must stay understandable. |
| Timeline | College submission deadline set by the student. |
| Data | Fake sample data only. No real personal information. |
| Security | No secrets in source control; parameterized SQL; server-side validation. |

---

## 5. Assumptions

- The student has or can install MySQL 8+ locally.
- The student has Python 3.10+ available.
- The project is assessed on both the working application and the DBMS concepts.
- The final schema will be reviewed before implementation.
- The college accepts a web application as the project format.

If an assumption turns out to be false, record it in `CURRENT_STATUS.md` and ask the user how to proceed.

---

## 6. Scope change process

1. The user requests a change.
2. The agent explains the impact on time, architecture, and submission.
3. If approved, update this file.
4. If the change affects architecture or technology, add an ADR in `docs/decisions/`.
5. Update `TASKS.md`.
6. Do not start work until the change is recorded.

---

## 7. Success criteria for the finished project

- The application runs against a real MySQL 8+ database.
- All core modules work end to end.
- The schema is normalized to 3NF and documented.
- Every required DBMS concept is demonstrated with a runnable script or a visible feature.
- Security rules are followed.
- Tests exist and pass for the core flows.
- Documentation is complete enough for a viva.
- The project can be set up from a clean machine using the README.
