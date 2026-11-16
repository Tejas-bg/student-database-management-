# GM University Management System — Task Board

> **Status:** Stage 3 MySQL database design is complete, corrected, and statically validated. The schema, ER model, views, integrity triggers, seed data, demonstrations, and documentation are prepared but **not executed**; no database is connected. Stage 2 dashboards remain UI-only, and the Stage 1 login preview is unchanged.
> **Rule:** A task is only `Done` when it is implemented and verified. For Stage 3, “Done” means the design artifact is complete and statically validated; SQL execution is a later stage.

---

## 1. Status and priority legend

| Status | Meaning |
|---|---|
| Not Started | No work has begun. |
| In Progress | Work has begun but is not verified. |
| In Review | Work is complete enough for the user to inspect. |
| Done | Implemented and verified. |
| Blocked | Cannot continue without a decision or fix. |

| Priority | Meaning |
|---|---|
| P0 | Critical for the stage. |
| P1 | Important. |
| P2 | Nice to have. |

---

## 2. Stage 0 — Project Workspace and Context Setup

| ID | Task | Stage | Priority | Status | Dependencies | Notes |
|---|---|---|---|---|---|---|
| S0-01 | Inspect the workspace and create the GM University Management System directory structure. | 0 | P0 | Done | — | Directory tree created under `GM University Management System/`. |
| S0-02 | Create global AI instructions. | 0 | P0 | Done | S0-01 | `.github/copilot-instructions.md`. |
| S0-03 | Create path-specific instructions. | 0 | P0 | Done | S0-02 | Backend, frontend, database, documentation. |
| S0-04 | Create prompt templates. | 0 | P1 | Done | S0-02 | `.github/prompts/`. |
| S0-05 | Create the project context documents. | 0 | P0 | Done | S0-01 | Overview, scope, architecture, stack, modules, design, coding, security, workflow, status, glossary, requirements. |
| S0-06 | Create the reusable AI skills. | 0 | P0 | Done | S0-02 | Canonical files in `.github/skills/`; pointers in `skills/`. |
| S0-07 | Create the database planning documents. | 0 | P0 | Done | S0-05 | ER diagram, design, relationships, normalization, concept map, data dictionary. |
| S0-08 | Create the architecture decision records. | 0 | P0 | Done | S0-05 | ADRs 001–005 and a template. |
| S0-09 | Create root project files. | 0 | P0 | Done | S0-01 | README, ROADMAP, CONTRIBUTING, CHANGELOG, TASKS, `.gitignore`, `.env.example`. |
| S0-10 | Create folder READMEs with purpose statements. | 0 | P1 | Done | S0-01 | `frontend/`, `backend/`, `tests/`, `scripts/`, `reports/`, docs, database. |
| S0-11 | Verify the structure and check for contradictions. | 0 | P0 | Done | S0-02–S0-10 | Reviewed; user proceeded to approve Stage 1. Open documentation inconsistencies are reported in the Stage 1 summary, not silently fixed. |
| S0-12 | Get user approval to start Stage 1. | 0 | P0 | Done | S0-11 | Approved via the Stage 1 kickoff prompt. |

---

## 3. Stage 1 — UI/UX Design System and Visual Identity

| ID | Task | Stage | Priority | Status | Dependencies | Notes |
|---|---|---|---|---|---|---|
| S1-01 | Create CSS design tokens. | 1 | P0 | Done | S0-12 | `tokens.css` (primitives) + `themes.css` (light/dark semantics). Verified computed colours in browser. |
| S1-02 | Define typography and spacing reference. | 1 | P0 | Done | S1-01 | Inter + JetBrains Mono loaded; 4px spacing scale, radii, shadows documented and rendered in `styleguide.html`. |
| S1-03 | Specify buttons, forms, tables, cards, navigation. | 1 | P0 | Done | S1-01 | All required components implemented in `components.css`, with states and variants. |
| S1-04 | Build light and dark reference pages. | 1 | P0 | Done | S1-01–S1-03 | `index.html` dashboard + `styleguide.html`; theme toggle, `?theme=` preview, persisted preference. |
| S1-05 | Check contrast and keyboard accessibility. | 1 | P0 | Done | S1-04 | Contrast computed; keyboard, focus return, drawer trap, no console errors verified via Chrome DevTools Protocol. See `docs/design/ACCESSIBILITY.md`. |
| S1-06 | Document the design system. | 1 | P1 | Done | S1-04 | Design documents in `docs/design/` plus the live styleguide. |
| S1-07 | Rebrand the interface and documentation to the GM University identity. | 1 | P0 | Done | S1-04 | Maroon/gold/ivory palette, official name, tagline, metadata, and all active docs updated. |
| S1-08 | Integrate the official GM University logo without modification. | 1 | P0 | Done | S1-07 | `frontend/static/img/branding/gmu-official-logo.jpg`; source and checksum recorded in `GMU_BRAND_GUIDELINES.md`. |
| S1-09 | Build the common login page for all roles. | 1 | P0 | Done | S1-07 | `login.html`, `login.css`, `login.js`; no role selector, no real authentication. |
| S1-10 | Document brand usage and the login specification. | 1 | P0 | Done | S1-07 | `GMU_BRAND_GUIDELINES.md` and `GMU_LOGIN_DESIGN.md`. |
| S1-11 | Verify the login preview across widths, keyboard, reduced motion, and console. | 1 | P0 | Done | S1-09 | Verified at 1920/1366/768/375px for scrolling; earlier layout pass covered 1440/1024/390/320px. Validation, password toggle, preview state, dialog focus, reduced motion, and console checked. See `CURRENT_STATUS.md`. |

**Stage 1 status:** Done — retained unchanged as the foundation for Stage 2. Stage 1 is UI-only: no MySQL, Flask, authentication, backend, or real student data.

---

## 4. Stage 2 — Frontend Development

| ID | Task | Stage | Priority | Status | Dependencies | Notes |
|---|---|---|---|---|---|---|
| S2-01 | Create base layout and partials. | 2 | P0 | Done | S1-06 | Shared shell in `app-shell.js` and `dashboard.css`: sidebar, header, breadcrumbs, footer, notice, menus, theme toggle. Verified on all 34 pages. |
| S2-02 | Build remaining authentication pages and convert the login preview into a template. | 2 | P0 | Not Started | S2-01 | Deliberately deferred. Logout links to the existing login preview; no fake authentication or session was added. Template conversion belongs with Flask in Stage 4. |
| S2-03 | Build student and department pages. | 2 | P0 | Done | S2-01 | 10 student pages; department management lives under the administration workspace. Sample data only. |
| S2-04 | Build course, subject, and faculty pages. | 2 | P0 | Done | S2-01 | Course, subject, faculty, and semester management pages plus the faculty workspace. |
| S2-05 | Build attendance and marks pages. | 2 | P0 | Done | S2-01 | Attendance, internal assessment, marks entry, semester marks, and marks management pages with tables and inert forms. |
| S2-06 | Build fee, feedback, and report pages. | 2 | P0 | Done | S2-01 | Fee details/management, feedback workspaces, performance, reports, and analytics. Charts are CSS/SVG. |
| S2-07 | Add responsive and accessibility checks. | 2 | P0 | Done | S2-03–S2-06 | 376 browser assertions passed; zero overflow at 1920/1366/768/375; 34-page accessibility and static audits clean. |
| S2-08 | Build the administration management workspace. | 2 | P0 | Done | S2-01 | 14 pages, including enrolment and user/role management. |
| S2-09 | Document Stage 2 and record verification evidence. | 2 | P1 | In Review | S2-01–S2-08 | `docs/design/GMU_DASHBOARD_DESIGN.md`, changelog, status, and this board updated. Awaiting user review. |

**Stage 2 status:** Done — all planned role pages are implemented and browser-verified, and the user proceeded to Stage 3. S2-02 (authentication pages and Jinja2 conversion) remains deliberately deferred to Stage 4. The interface is UI-only: no backend, database, authentication, session, or persistence. Every dashboard labels its data as sample/demo.

---

## 5. Stage 3 — MySQL Database Architecture and ER Design

> **Scope:** design only. The schema is not executed, no database is connected, and no frontend files are changed.

| ID | Task | Stage | Priority | Status | Dependencies | Notes |
|---|---|---|---|---|---|---|
| S3-01 | Inspect all Stage 2 pages, forms, tables, filters, and actions. | 3 | P0 | Done | S2-01–S2-08 | Page/data inventory mapped in `REQUIREMENTS_TO_TABLE_MAPPING.md`. |
| S3-02 | Design the ER model with keys and cardinalities. | 3 | P0 | Done | S3-01 | 24 entities, 51 relationships; `ER_DIAGRAM.md`. |
| S3-03 | Finalize the data dictionary for every table. | 3 | P0 | Done | S3-02 | `DATA_DICTIONARY.md`; validated against the schema. |
| S3-04 | Write complete DDL for reference, people, academic, assessment, finance, and feedback tables. | 3 | P0 | Done | S3-03 | `schema/001_schema.sql`; 24 InnoDB/utf8mb4 tables, 51 FKs, 32 unique keys, 29 CHECK constraints. |
| S3-05 | Design authentication and RBAC tables. | 3 | P0 | Done | S3-02 | `roles`, `users`, `password_reset_tokens`; no plaintext passwords. |
| S3-06 | Create reporting views. | 3 | P0 | Done | S3-04 | `views/001_views.sql`; 8 views, including corrected attendance/fee/workload logic. |
| S3-07 | Create fictional seed data. | 3 | P0 | Done | S3-04 | `seeds/001_sample_data.sql`; clearly labelled fictional, no usable password hashes. |
| S3-08 | Prepare DDL/DML/DQL/DCL/TCL and join/subquery/aggregate demonstrations. | 3 | P0 | Done | S3-04 | `demonstrations/001`–`006`; DCL uses `IDENTIFIED BY RANDOM PASSWORD`. |
| S3-09 | Document normalization, relationships, security, and requirements mapping. | 3 | P0 | Done | S3-02–S3-08 | Architecture, normalization, security, mapping, and table docs updated. |
| S3-10 | Statically validate tables, keys, foreign keys, dictionary, and ER entities. | 3 | P0 | Done | S3-04–S3-09 | 24/24 tables have PKs; 0 missing FK targets; dictionary and ER match; 51 FKs / 51 ER lines. |
| S3-13 | Apply the Stage 3 correction review: ER target-user FK, normalization decision, cross-table integrity, nullable unique keys, view logic, credential handling, and documentation consistency. | 3 | P0 | Done | S3-10 | Removed `student_enrolments.academic_year_id`; added `section`; added composite timetable FK; added 10 triggers; fixed 3 views; removed usable seed hashes; updated docs. |
| S3-11 | Execute the schema on a clean MySQL 8 instance and record evidence. | 3/6 | P0 | Not Started | User approval | Deferred: Stage 3 is design-only; no MySQL client is installed. |
| S3-12 | Create numbered migrations and test them on a clean database. | 3/6 | P0 | Not Started | S3-11 | Deferred to the implementation stage. |

**Stage 3 status:** Done - the design is complete, corrected, and statically validated, and the scripts have been executed against MySQL 8.4.9 (24 tables, 8 views, 10 triggers, seed data loaded). Trigger negative tests remain deferred.
**Stage 4 status:** Done - a Flask application is running on http://127.0.0.1:5000, connected to MySQL. The common login, session handling, role-based authorization, CSRF protection, safe error pages, and 22 automated tests all work against the live database.

---

## 6. Stage 4 — Flask Backend and Database Connection

| ID | Task | Stage | Priority | Status | Dependencies | Notes |
|---|---|---|---|---|---|---|
| S4-01 | Create the Flask application factory and config. | 4 | P0 | Done | S3-06 | `create_app()`, blueprints, `.env` loading, pinned dependencies; app boots. |
| S4-02 | Create the MySQL connection helper. | 4 | P0 | Done | S4-01 | `db.py` opens and closes connections; `/health` reports MySQL 8.4.9. |
| S4-03 | Create repositories for core tables. | 4 | P0 | Done | S4-02 | `user_repository` and `dashboard_repository` use `%s` placeholders only. |
| S4-04 | Implement authentication and sessions. | 4 | P0 | Done | S4-01 | Werkzeug hashes, generic failure message, session rotation, `POST` logout. |
| S4-05 | Implement role-based authorization. | 4 | P0 | Done | S4-04 | `login_required` and `roles_required`; cross-role preview returns 403. |
| S4-06 | Add error handlers. | 4 | P0 | Done | S4-01 | Safe pages for 400/401/403/404/405/500; no internals leaked. |
| S4-07 | Add backend tests. | 4 | P0 | Done | S4-02-S4-06 | 22 tests pass against MySQL (auth, CSRF, RBAC, logout, error pages). |

---

## 7. Stage 5 — Functional Module Development

| ID | Task | Stage | Priority | Status | Dependencies | Notes |
|---|---|---|---|---|---|---|
| S5-01 | Implement Students module. | 5 | P0 | Not Started | S4-07 | DB → repository → service → route → template. |
| S5-02 | Implement Departments and Courses modules. | 5 | P0 | Not Started | S5-01 | Relationships. |
| S5-03 | Implement Subjects, Semesters, and Faculty modules. | 5 | P0 | Not Started | S5-02 | |
| S5-04 | Implement Assignments and Enrolments modules. | 5 | P0 | Not Started | S5-03 | |
| S5-05 | Implement Attendance module. | 5 | P0 | Not Started | S5-04 | Percentage reports. |
| S5-06 | Implement Internal and Semester Marks modules. | 5 | P0 | Not Started | S5-04 | Range validation. |
| S5-07 | Implement Fees and Payments module. | 5 | P0 | Not Started | S5-01 | Transactions. |
| S5-08 | Implement Feedback module. | 5 | P0 | Not Started | S5-01 | One per subject per term. |
| S5-09 | Implement Performance and Reports modules. | 5 | P0 | Not Started | S5-05–S5-07 | Joins, aggregates, charts. |

---

## 8. Stage 6 — SQL and DBMS Concept Demonstration

| ID | Task | Stage | Priority | Status | Dependencies | Notes |
|---|---|---|---|---|---|---|
| S6-01 | Write DDL, DML, and DQL demonstration scripts. | 6 | P0 | Not Started | S5-09 | Map to `SQL_CONCEPT_MAPPING.md`. |
| S6-02 | Create reporting views. | 6 | P0 | Not Started | S5-09 | Joins, aggregates. |
| S6-03 | Create subquery demonstrations. | 6 | P0 | Not Started | S6-02 | Correlated and non-correlated. |
| S6-04 | Create the transaction demo. | 6 | P0 | Not Started | S5-07 | `COMMIT`, `ROLLBACK`, `SAVEPOINT`. |
| S6-05 | Create the DCL demo. | 6 | P0 | Not Started | S4-02 | `GRANT`, `REVOKE`. |
| S6-06 | Create procedures/triggers where justified. | 6 | P1 | Not Started | S6-02 | Optional. |
| S6-07 | Complete the concept mapping and viva notes. | 6 | P0 | Not Started | S6-01–S6-06 | Every concept demonstrated. |

---

## 9. Stage 7 — Integration and Testing

| ID | Task | Stage | Priority | Status | Dependencies | Notes |
|---|---|---|---|---|---|---|
| S7-01 | Write integration tests for core flows. | 7 | P0 | Not Started | S6-07 | Against MySQL. |
| S7-02 | Test security controls. | 7 | P0 | Not Started | S7-01 | Injection, CSRF, XSS, roles. |
| S7-03 | Test error paths. | 7 | P0 | Not Started | S7-01 | 400/401/403/404/500. |
| S7-04 | Run a manual regression pass. | 7 | P0 | Not Started | S7-01 | Record evidence. |
| S7-05 | Write the test report. | 7 | P0 | Not Started | S7-04 | `docs/testing/`. |

---

## 10. Stage 8 — Security and Performance Review

| ID | Task | Stage | Priority | Status | Dependencies | Notes |
|---|---|---|---|---|---|---|
| S8-01 | Run the security checklist. | 8 | P0 | Not Started | S7-05 | `SECURITY_STANDARDS.md`. |
| S8-02 | Review SQL injection and input validation. | 8 | P0 | Not Started | S8-01 | All routes. |
| S8-03 | Review authentication and authorization. | 8 | P0 | Not Started | S8-01 | Every protected route. |
| S8-04 | Review database privileges. | 8 | P0 | Not Started | S8-01 | Least privilege. |
| S8-05 | Review query performance. | 8 | P1 | Not Started | S8-01 | `EXPLAIN` key queries. |
| S8-06 | Fix and document findings. | 8 | P0 | Not Started | S8-01–S8-05 | Honest report. |

---

## 11. Stage 9 — Documentation and College Submission

| ID | Task | Stage | Priority | Status | Dependencies | Notes |
|---|---|---|---|---|---|---|
| S9-01 | Write the project report. | 9 | P0 | Not Started | S8-06 | Use real results. |
| S9-02 | Finalize diagrams. | 9 | P0 | Not Started | S9-01 | ER, architecture, flows. |
| S9-03 | Capture real screenshots. | 9 | P0 | Not Started | S9-01 | No fabricated images. |
| S9-04 | Write the user guide. | 9 | P0 | Not Started | S9-01 | `docs/user-guide/`. |
| S9-05 | Write setup instructions. | 9 | P0 | Not Started | S9-01 | Clean-machine test. |
| S9-06 | Prepare the demo database. | 9 | P0 | Not Started | S9-01 | Fake data only. |
| S9-07 | Package the submission. | 9 | P0 | Not Started | S9-01–S9-06 | Follow college format. |

---

## 12. Stage 10 — Final Demonstration and Viva Preparation

| ID | Task | Stage | Priority | Status | Dependencies | Notes |
|---|---|---|---|---|---|---|
| S10-01 | Write the demo script. | 10 | P0 | Not Started | S9-07 | End-to-end flow. |
| S10-02 | Prepare viva questions and answers. | 10 | P0 | Not Started | S9-07 | Architecture, schema, SQL. |
| S10-03 | Rehearse the demonstration. | 10 | P0 | Not Started | S10-01 | Timed run. |
| S10-04 | Prepare a backup plan. | 10 | P0 | Not Started | S10-03 | Screenshots, seed reset. |

---

## 13. Current focus

Stage 2 is **In Review**. The shared shell and all 34 student, faculty, and administration pages are implemented and verified. The login page remains unchanged.

Next gates:

1. User review of the Stage 2 interface.
2. Approval before Stage 3 (MySQL schema and implementation) begins.

Stage 2 remains UI-only. Do not add fake authentication, mock success messages, or claims of database storage.

---

## 14. Verification references

- `docs/design/GMU_DASHBOARD_DESIGN.md` — Stage 2 page map, contract, behaviour, responsive rules, and evidence.
- `project-context/CURRENT_STATUS.md` — verified facts and current limitations.
- `CHANGELOG.md` — dated record of the Stage 2 work.
