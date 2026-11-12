# GM University Management System — Project Requirements

> **Status:** Baseline requirements. At Stage 1, design and login requirements are In Review; all functional, database, security, testing, and submission requirements remain Not Started.
> **Rule:** Preserve the original college requirements. Add new requirements explicitly; do not silently remove any.

---

## A. Functional requirements

| ID | Requirement | Module | Stage | Verification | Status |
|---|---|---|---|---|---|
| FR-01 | The system shall authenticate users with a username/email and password. | M01 | 4 | Login/logout test | Not Started |
| FR-02 | The system shall enforce role-based access for student, faculty, and administrator roles. | M01 | 4 | Role permission tests | Not Started |
| FR-03 | Administrators shall create, view, update, and deactivate student records. | M02 | 5 | CRUD test | Not Started |
| FR-04 | Students shall view their own profile and academic information. | M02 | 5 | Manual + automated test | Not Started |
| FR-05 | Administrators shall manage departments. | M03 | 5 | CRUD test | Not Started |
| FR-06 | Administrators shall manage courses and associate them with departments. | M04 | 5 | CRUD + relationship test | Not Started |
| FR-07 | Administrators shall manage subjects and semesters. | M05 | 5 | CRUD test | Not Started |
| FR-08 | Administrators shall manage faculty records. | M06 | 5 | CRUD test | Not Started |
| FR-09 | Administrators shall assign faculty to subjects and semesters. | M07 | 5 | Assignment test | Not Started |
| FR-10 | Administrators shall enrol students in subjects. | M08 | 5 | Enrolment test | Not Started |
| FR-11 | Faculty shall record and update attendance for assigned subjects. | M09 | 5 | Attendance test | Not Started |
| FR-12 | Students shall view their attendance percentage per subject. | M09 | 5 | Report query test | Not Started |
| FR-13 | Faculty shall record internal assessment marks. | M10 | 5 | Marks test | Not Started |
| FR-14 | Administrators/faculty shall record semester examination marks. | M11 | 5 | Marks test | Not Started |
| FR-15 | The system shall calculate and display academic performance summaries. | M12 | 5–6 | Calculation test | Not Started |
| FR-16 | Administrators shall manage fee structures and record payments. | M13 | 5 | Fee transaction test | Not Started |
| FR-17 | Students shall view their fee status and payment history. | M13 | 5 | Manual test | Not Started |
| FR-18 | Students shall submit feedback for subjects/faculty. | M14 | 5 | Feedback test | Not Started |
| FR-19 | Administrators shall view feedback summaries. | M14 | 5 | Report test | Not Started |
| FR-20 | The system shall generate reports with filters for department, course, semester, subject, and date range. | M15 | 5–6 | Report tests | Not Started |
| FR-21 | Reports shall support export to CSV. | M15 | 6 | Export test | Not Started |
| FR-22 | The system shall validate all user input on the server. | All | 4–5 | Validation tests | Not Started |
| FR-23 | The system shall show safe, helpful error messages. | All | 4 | Error-path tests | Not Started |
| FR-24 | The system shall log technical errors server-side without exposing them to users. | All | 4 | Log review | Not Started |
| FR-25 | The system shall provide one common login page for students, faculty, and administrators, with no manual role selection. | M01 | 1 (preview), 4 (working) | Login review | In Review |
| FR-26 | The backend shall determine the authenticated role from the registered MySQL account, never from the login ID format or frontend JavaScript. | M01 | 4 | Role detection tests | Not Started |
| FR-27 | The login identifier policy shall be configurable and subject to university approval: student USN, faculty employee ID, administrator email; Aadhaar only if explicitly approved. | M01 | 4 | Policy review | Not Started |
| FR-28 | After successful authentication the system shall redirect by verified role to `/student/dashboard`, `/faculty/dashboard`, or `/admin/dashboard`. | M01 | 4 | Redirect tests | Not Started |

---

## B. Non-functional requirements

| ID | Requirement | Stage | Verification | Status |
|---|---|---|---|---|
| NFR-01 | Pages shall load in under 3 seconds on a local development machine for typical data volumes. | 5–7 | Timing test | Not Started |
| NFR-02 | The application shall run on Python 3.10+ and MySQL 8+. | 4 | Environment check | Not Started |
| NFR-03 | The codebase shall follow `CODING_STANDARDS.md`. | All | Review | Not Started |
| NFR-04 | The system shall be usable on desktop, tablet, and mobile widths. | 2 | Responsive checks | Not Started |
| NFR-05 | The system shall support light and dark themes. | 1–2 | Theme checks | Not Started |
| NFR-06 | The system shall be maintainable through modular routes, services, and repositories. | 4–5 | Code review | Not Started |
| NFR-07 | The system shall not depend on an ORM unless approved by ADR. | 3–5 | Dependency review | Not Started |
| NFR-08 | The system shall run locally without cloud services. | 4 | Setup test | Not Started |
| NFR-09 | Documentation shall stay in sync with the implementation. | All | Doc review | Not Started |
| NFR-10 | The project shall be reproducible from a clean machine using the README. | 9 | Clean setup test | Not Started |

---

## C. Database requirements

| ID | Requirement | Stage | Verification | Status |
|---|---|---|---|---|
| DB-01 | The database shall be MySQL 8+ using InnoDB and `utf8mb4`. | 3 | `SHOW VARIABLES` / table check | Not Started |
| DB-02 | Every table shall have a primary key. | 3 | Schema review | Not Started |
| DB-03 | Relationships shall be enforced with foreign keys and explicit `ON DELETE`/`ON UPDATE` actions. | 3 | Schema review | Not Started |
| DB-04 | The schema shall be normalized to 3NF. | 3 | Normalization review | Not Started |
| DB-05 | The schema shall include `NOT NULL`, `UNIQUE`, `CHECK`, and `DEFAULT` constraints where appropriate. | 3 | Schema review | Not Started |
| DB-06 | Money shall use `DECIMAL`, not `FLOAT` or `DOUBLE`. | 3 | Schema review | Not Started |
| DB-07 | The schema shall include an ER diagram and data dictionary. | 3 | Document review | Not Started |
| DB-08 | The project shall include DDL, DML, DQL, DCL, and TCL scripts. | 3, 6 | Script execution | Not Started |
| DB-09 | The project shall demonstrate joins, subqueries, and aggregate functions. | 5–6 | Query review | Not Started |
| DB-10 | The project shall include reporting views. | 6 | View execution | Not Started |
| DB-11 | The project shall demonstrate transactions with `COMMIT`, `ROLLBACK`, and `SAVEPOINT`. | 6 | Transaction demo | Not Started |
| DB-12 | The project shall demonstrate `GRANT` and `REVOKE`. | 6 | DCL script execution | Not Started |
| DB-13 | Schema changes shall be delivered as numbered migrations. | 3 | Migration review | Not Started |
| DB-14 | Seed data shall be fake and clearly labelled. | 3 | Data review | Not Started |
| DB-15 | The final schema shall be reviewed and approved before implementation. | 3 | User approval | Not Started |

---

## D. Security requirements

| ID | Requirement | Stage | Verification | Status |
|---|---|---|---|---|
| SEC-01 | All SQL shall use parameterized queries. | 4–5 | Code review + injection test | Not Started |
| SEC-02 | All user input shall be validated server-side. | 4–5 | Validation tests | Not Started |
| SEC-03 | Passwords shall be stored as strong hashes, never plaintext. | 4 | Code review | Not Started |
| SEC-04 | Secrets shall live in `.env`, never in source control. | 0–4 | Git history check | Not Started |
| SEC-05 | The application shall use least-privilege MySQL users. | 3–6 | `SHOW GRANTS` | Not Started |
| SEC-06 | State-changing forms shall be protected against CSRF. | 4–5 | CSRF test | Not Started |
| SEC-07 | Output shall be escaped to prevent XSS. | 2–5 | XSS test | Not Started |
| SEC-08 | Session cookies shall use secure flags. | 4 | Config review | Not Started |
| SEC-09 | Protected routes shall check roles on the server. | 4–5 | Permission tests | Not Started |
| SEC-10 | Errors shall not expose stack traces or SQL to users. | 4 | Error-path tests | Not Started |
| SEC-11 | Sample data shall be fake; no real student data shall be committed. | 3–9 | Data review | Not Started |
| SEC-12 | Dependencies shall be minimal and pinned. | 4 | `requirements.txt` review | Not Started |

---

## E. UI/UX requirements

| ID | Requirement | Stage | Verification | Status |
|---|---|---|---|---|
| UX-01 | The interface shall follow `DESIGN_PRINCIPLES.md`. | 1–2 | Design review | In Review |
| UX-02 | The palette shall use University Maroon, Deep Maroon, University Gold, Warm Ivory, White, Graphite, and Muted Grey as specified. | 1 | Token review | In Review |
| UX-03 | University Gold shall be used as an accent, never as body text on light surfaces or a large background. | 1–2 | Visual review | In Review |
| UX-04 | The interface shall support light and dark themes. | 1–2 | Theme toggle test | In Review |
| UX-05 | The interface shall be responsive across mobile, tablet, and desktop. | 2 | Responsive checks | Not Started |
| UX-06 | The interface shall meet WCAG 2.1 AA contrast and keyboard access. | 1–2 | Contrast + keyboard tests | In Review |
| UX-07 | Every form input shall have a visible label. | 2 | Form review | Not Started |
| UX-08 | Tables shall be readable and support small screens. | 2 | Responsive table test | Not Started |
| UX-09 | Charts shall include a text summary or data alternative. | 2 | Accessibility review | Not Started |
| UX-10 | Motion shall respect `prefers-reduced-motion`. | 1–2 | CSS review | In Review |
| UX-11 | The official GM University logo shall be used unmodified, with its original aspect ratio. | 1–2 | Brand review | In Review |
| UX-12 | The login page shall include a logo, welcome copy, login ID, password, show/hide control, forgot-password placeholder, error area, loading state, and responsive layout. | 1 | Login review | In Review |

---

## F. Testing requirements

| ID | Requirement | Stage | Verification | Status |
|---|---|---|---|---|
| TEST-01 | Core routes and services shall have automated tests. | 4–7 | Test suite run | Not Started |
| TEST-02 | Tests shall run against MySQL, not SQLite. | 7 | Test config review | Not Started |
| TEST-03 | Security controls shall be tested. | 7–8 | Security tests | Not Started |
| TEST-04 | Database migrations shall be tested on a clean database. | 3 | Migration test | Not Started |
| TEST-05 | Every report query shall be tested with representative data. | 6–7 | Query tests | Not Started |
| TEST-06 | Test results shall be recorded honestly in `docs/testing/`. | 7–9 | Report review | Not Started |
| TEST-07 | Known defects shall be documented, not hidden. | 7–8 | Defect log review | Not Started |
| TEST-08 | The final system shall be tested end to end before submission. | 7–9 | Regression pass | Not Started |

---

## G. College submission requirements

| ID | Requirement | Stage | Verification | Status |
|---|---|---|---|---|
| SUB-01 | The project shall include a complete project report. | 9 | Report review | Not Started |
| SUB-02 | The report shall explain the problem, scope, architecture, ER model, normalization, and implementation. | 9 | Report review | Not Started |
| SUB-03 | The project shall include an ER diagram and relational schema diagram. | 3, 9 | Diagram review | Not Started |
| SUB-04 | The project shall include real screenshots of the working system. | 9 | Screenshot review | Not Started |
| SUB-05 | The project shall include runnable SQL scripts for every required DBMS concept. | 6 | Script execution | Not Started |
| SUB-06 | The project shall include setup instructions that work from a clean machine. | 9 | Clean setup test | Not Started |
| SUB-07 | The project shall be demonstrable in a viva. | 10 | Rehearsal | Not Started |
| SUB-08 | The submission shall follow the college's required format and deadline. | 9 | Checklist | Not Started |

---

## H. Requirements traceability summary

> Statuses at Stage 1: **design and login requirements are In Review; all remaining functional, database, security, testing, and submission requirements remain Not Started.** Workspace documentation is not the same as requirement implementation.

| Requirement group | Total | Not Started | In Progress | In Review | Implemented | Tested | Blocked |
|---|---|---|---|---|---|---|---|
| Functional | 28 | 27 | 0 | 1 | 0 | 0 | 0 |
| Non-functional | 10 | 10 | 0 | 0 | 0 | 0 | 0 |
| Database | 15 | 15 | 0 | 0 | 0 | 0 | 0 |
| Security | 12 | 12 | 0 | 0 | 0 | 0 | 0 |
| UI/UX | 12 | 4 | 0 | 8 | 0 | 0 | 0 |
| Testing | 8 | 8 | 0 | 0 | 0 | 0 | 0 |
| Submission | 8 | 8 | 0 | 0 | 0 | 0 | 0 |
| **Total** | **93** | **84** | **0** | **9** | **0** | **0** | **0** |

---

## I. Status definitions

| Status | Meaning |
|---|---|
| Not Started | No work has begun. |
| In Progress | Work has begun but is not verified. |
| In Review | Work is complete enough for the user to inspect and approve. |
| Implemented | The feature exists but is not fully tested. |
| Tested | The feature is implemented and has passing verification evidence. |
| Blocked | Work cannot continue without a decision, dependency, or fix. |

A requirement moves to **Tested** only when there is real evidence. Documentation alone never moves a requirement forward.

---

## J. Change control

- New requirements are added with a new ID.
- Removed requirements are marked **Dropped** with a reason; they are not deleted silently.
- Changes that affect architecture require an ADR.
- Update this file and `TASKS.md` together.
