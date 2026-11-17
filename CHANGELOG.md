# Changelog

All significant changes to the GM University Management System are recorded here, newest first.

The format is simple: date, stage, what changed, and why. It is not a commit log.

---

## 2026-11-17 — GitHub publication safety

### Changed

- Removed the hard-coded shared demo password from the local bulk-reset utility; it now prompts for a strong temporary password and uses the Flask `.env` database configuration.
- Password reset is verified within a transaction before commit, and generated SQL database dumps are ignored.
- Removed password values from the UI polish report.

### Verified

- `pytest -q` — 54 tests passed against the current test configuration.
- `.env` is ignored and not tracked. Generated local SQL dumps are excluded from the pending commit.

---

## 2026-11-16 — Admin and Faculty password reset utility

### Fixed

- `backend/scripts/reset_account_password.py` now resolves the Admin login ID from active database accounts instead of assuming `admin@gmail.com`.
- Password changes are verified before the transaction commits; failed verification rolls back.
- The utility now uses the Flask app's `.env` configuration and no longer creates a full database dump for a password-only update.

### Added

- `tests/unit/test_password_reset.py` — verifies commit-after-success and rollback-on-verification-failure behavior.

---

## 2026-11-16 — Local demo student account setup

### Added

- `backend/scripts/create_sample_student_account.py` — a local-only, confirmed setup utility for the fictional `1GM23CS052` account. It prompts for a password without echoing it, stores a Werkzeug hash, checks for conflicts and required reference rows, and commits the user and student records together.
- `tests/integration/test_sample_account_setup.py` — MySQL integration coverage for password policy, creation, duplicate rejection, and transaction rollback.

### Notes

- The utility has not been used to create the account; the operator must run it and choose a password locally.

### Verified

- `python -m pytest -q` — 39 tests passed against the configured MySQL database.
- The integration test rolled back its sample account; a follow-up query confirmed `1GM23CS052` remains absent until the operator runs the utility.

---

## 2026-11-13 - Stage 4: Flask backend, login system, and role dashboards

### Added

- `backend/config.py` — reads `.env` for the secret key, session flags, and MySQL connection; never hardcodes a secret.
- `backend/app/__init__.py` — `create_app()` with blueprints, CSRF enforcement on every state-changing request, security headers (CSP, `X-Frame-Options`, `nosniff`, `Referrer-Policy`), and template globals.
- `backend/app/db.py` — connection and cursor helpers that always close, plus `ping()` used by `/health`.
- `backend/app/repositories/user_repository.py` — account lookup and login bookkeeping using only `%s` placeholders.
- `backend/app/repositories/dashboard_repository.py` — administrator counts, student profile/overview, and faculty workload queries.
- `backend/app/services/auth_service.py` — Werkzeug hash verification, sentinel rejection, and identical failure handling for unknown users, wrong passwords, and inactive accounts.
- `backend/app/auth/security.py` — per-session CSRF tokens, `login_required`, `roles_required`, open-redirect-safe `next` handling, and session rotation on login.
- `backend/app/routes/auth.py` — common `GET/POST /login` and `POST /logout`.
- `backend/app/routes/dashboard.py` — role-aware landing page populated from MySQL.
- `backend/app/routes/health.py` — `/health` reporting the MySQL version and connected schema.
- `backend/app/routes/prototype.py` — the 34-page Stage 2 interface mounted at `/prototype/` behind authentication, with per-role folder checks.
- `backend/app/errors.py` — safe pages for 400, 401, 403, 404, 405, and 500 that never expose tracebacks, SQL, or paths.
- `frontend/templates/login.html` — the Stage 2 login markup as a Jinja template with a CSRF token and server-rendered error messages.
- `frontend/templates/dashboard.html` — the authenticated landing page for student, faculty, and administrator roles.
- `frontend/templates/errors/error.html` and `prototype_sign_out.html`.
- `frontend/static/css/backend.css` and `frontend/static/js/login-form.js`.
- `tests/conftest.py`, `tests/unit/test_security.py`, `tests/integration/test_auth.py` — 22 tests against MySQL.
- `pytest.ini` — test paths and import paths.

### Fixed

- `dashboard_repository.student_overview` originally queried `attendance_records.student_id`, which does not exist. Attendance links through `student_enrolments.enrolment_id`; the query now joins that table.
- `db.ping()` returned a `database` key that collided with `jsonify(database="connected")`. It now returns `schema`.

### Why

Stage 4 was approved and required a real connection to MySQL. The backend now
proves the database design works: the login system authenticates against the
`users` table, role checks are enforced on the server, and all three role
dashboards read live figures. The original 34-page interface is preserved and
reached through `/prototype/` rather than being rewritten.

---

## 2026-11-13 — Stage 3: MySQL database architecture and ER design

### Added

- `database/schema/001_schema.sql` — complete MySQL 8 DDL for 24 InnoDB/`utf8mb4` tables covering roles/users, password resets, departments, courses, academic years, semesters, subjects, students, faculty, teaching assignments, enrolments, timetable, attendance, internal assessments/marks, semester exams/marks, fee structures/payments, notifications, read receipts, and feedback. Final counts: 51 FKs, 32 unique keys, 29 CHECK constraints, 25 secondary indexes.
- `database/views/001_views.sql` — eight reporting views: student profile, attendance summary, internal marks, semester results, fee summary, faculty workload, class performance, and feedback summary.
- `database/triggers/001_integrity_triggers.sql` — 10 cross-table integrity triggers (5 rules × INSERT/UPDATE) for attendance vs assignment/enrolment, internal marks vs assessment, semester marks vs exam, fee payments vs course/amount, and notification target role.
- `database/seeds/001_sample_data.sql` — clearly fictional seed data for all modules; accounts use the non-authenticating sentinel `!NO_LOGIN_HASH_SET` and `pending_reset` status (no plaintext and no usable hash).
- `database/demonstrations/001_ddl.sql` — DDL examples on a disposable demo table.
- `database/demonstrations/002_dml.sql` — INSERT/UPDATE/DELETE examples.
- `database/demonstrations/003_dql_joins.sql` — INNER, LEFT, RIGHT, self, and multi-table joins.
- `database/demonstrations/004_dql_subqueries_aggregates.sql` — scalar/IN/EXISTS/derived-table subqueries, aggregates, GROUP BY/HAVING, and a window function.
- `database/demonstrations/005_dcl.sql` — least-privilege accounts created with `IDENTIFIED BY RANDOM PASSWORD` (MySQL 8.0.18+), GRANT, REVOKE, and privilege inspection; no reusable secret committed.
- `database/demonstrations/006_tcl.sql` — COMMIT, ROLLBACK, SAVEPOINT, and transaction outlines.
- `database/documentation/DATABASE_ARCHITECTURE.md` — module map, authentication model, indexing, and Flask-readiness.
- `database/documentation/ER_DIAGRAM.md` — Mermaid ER diagram with 24 entities, 51 relationship lines, keys, cardinalities, and optional/mandatory relationships.
- `database/documentation/DATA_DICTIONARY.md` — column-level reference for every table.
- `database/documentation/TABLE_DESCRIPTIONS_AND_RELATIONSHIPS.md` — table purposes, FK actions, and cardinality explanations.
- `database/documentation/NORMALIZATION.md` — 1NF/2NF/3NF analysis, anomaly examples, and table-by-table review.
- `database/documentation/SECURITY.md` — password storage, RBAC, least privilege, sensitive-data minimization, transactions, and auditability.
- `database/documentation/REQUIREMENTS_TO_TABLE_MAPPING.md` — maps every Stage 2 page, form, filter, and action to tables/columns.
- Updated `database/documentation/SQL_CONCEPT_MAPPING.md` and the database/schema/seed/view/trigger READMEs.

### Fixed (Stage 3 correction review)

- ER/FK mismatch: added the missing `users` → `notifications.target_user_id` relationship line, so the diagram now mirrors all 51 FKs.
- Normalization: removed the transitive `student_enrolments.academic_year_id`; the academic year is derived through `semesters`. Retained `subjects.department_id` and `students.department_id` as documented business attributes.
- Attendance/workload matching: added `student_enrolments.section` and a composite FK `fk_tt_assignment` from `timetable_entries` to `faculty_subject_assignments`.
- Cross-table integrity: added 10 triggers for rules a single FK cannot express.
- Nullable composite unique keys: replaced the nullable feedback key with a functional unique index using `COALESCE`, made `fee_structures.semester_number` NOT NULL, and made `attendance_sessions.start_time` NOT NULL.
- Reporting views: corrected the attendance denominator to count held sessions, scoped fee demand by academic year and semester, and matched faculty workload by section.
- Credentials: replaced placeholder hashes with the non-authenticating `!NO_LOGIN_HASH_SET` sentinel and `pending_reset`, and switched DCL to `IDENTIFIED BY RANDOM PASSWORD`.
- Documentation: reconciled table counts, FK counts, run order, and the `database/seeds/` path across all Stage 3 documents.

### Changed

- `database/documentation/DATABASE_DESIGN.md` and `TABLE_RELATIONSHIPS.md` are retained as historical drafts and marked superseded by the final Stage 3 documents.
- `ROADMAP.md`, `TASKS.md`, and `project-context/CURRENT_STATUS.md` now record Stage 3 design completion and the Stage 4 gate.

### Verified

- Static schema validation: 24/24 tables have primary keys; all 51 foreign-key targets exist; no duplicate table definitions.
- Count consistency: 24 tables, 24 PKs, 51 FKs, 32 unique keys, 29 CHECK constraints, 25 secondary indexes.
- Data dictionary/schema comparison: 24 tables and all columns match (after normalizing grouped audit columns).
- ER/schema comparison: 24 entities and 51 relationship lines match the 51 FKs; no unknown entities.
- Views: every referenced table and column exists in the schema; attendance, fee, and workload logic reviewed against the seed data.
- Triggers: 10 structurally valid triggers (5 rules × INSERT/UPDATE) with balanced blocks and the delimiter restored.
- Seeds: every INSERT targets an existing table; no usable password hash is present.
- No executable `DROP DATABASE` is present; destructive examples are commented out.
- No MySQL client is installed, no SQL was executed, and no database connection exists.

### Notes

- Stage 3 is **design only**. The schema, views, triggers, seed data, and demonstrations are prepared for review and have **not** been run against MySQL.
- The login page, dashboards, and all frontend files are unchanged.
- Role is determined from `users.role_id`; no client-selected role is trusted. Password storage is hash-only; Aadhaar is not used.
- Stage 3 is **Done** and awaits explicit approval before Stage 4. SQL execution and trigger testing are deferred to the implementation stage.

---

## 2026-11-12 — Stage 2: Application shell and role dashboards

### Added

- `frontend/static/js/app-shell.js` — role configuration for student, faculty, and administration; inline SVG sprite; skip link; collapsible sidebar; sticky header with search, notifications, theme toggle, and profile menu; breadcrumbs; sample-data notice; footer.
- `frontend/static/js/dashboard.js` — client-side table search, chip filters, pagination, empty states, header-search synchronisation, list filters, page-level mark-read, inert demo forms, and a `/` search shortcut.
- `frontend/static/css/dashboard.css` — dashboard hero, statistic and split grids, three-column responsive card grid, filter bar, meter rows, and pagination.
- **34 dashboard pages:**
  - 10 student pages: overview, profile, courses, attendance, internal assessment marks, semester results, fee details, timetable, notifications, feedback.
  - 10 faculty pages: overview, profile, assigned subjects, student management, attendance management, internal marks entry, semester marks, class performance, reports, notifications.
  - 14 administration pages: overview, student management, faculty management, department management, course management, subject management, semester management, enrolment management, attendance management, marks management, fee management, feedback management, reports and analytics, user and role management.
- `docs/design/GMU_DASHBOARD_DESIGN.md` — page map, page contract, shell architecture, interaction hooks, responsive rules, accessibility, limitations, and verification evidence.

### Changed

- `theme.js` now uses delegated click handling and re-syncs controls after the document parses, so the theme button injected by `app-shell.js` works on every dashboard page.
- `docs/design/DESIGN_SYSTEM.md` and `docs/design/README.md` document the dashboard file map, load order, grid helpers, and Stage 2 status.

### Fixed

- Header theme toggle had no click handler because it was injected after `theme.js` initialised. Delegation plus a `DOMContentLoaded` sync fixes it without touching the login page.
- Removed an unused `mb-0` class from `frontend/dashboard/admin/marks.html`.

### Verified

- 34 dashboard pages loaded at 1366×768 with shell, header, sidebar, footer, breadcrumb, skip link, demo notice, one active nav item, and zero console/JS errors.
- 376 automated assertions passed with 0 failures, covering navigation, table filters, search, empty states, pagination, header-search sync, dialogs, demo forms, profile/logout, notifications, sidebar collapse and persistence, theme toggle and persistence, tabs, list filters, page mark-read, and responsive layouts.
- Zero horizontal overflow at 1920×1080, 1366×768, 768×1024, and 375×812 on every tested page; mobile tables scroll inside their wrapper.
- Accessibility audit across 34 pages found no unnamed controls, unlabelled fields, images without `alt`, or missing sprite symbols.
- Static validation across 34 pages found no tag-balance errors, duplicate IDs, page-contract violations, or broken local links/assets.
- No `fetch`, `XMLHttpRequest`, `WebSocket`, or form submission exists in the dashboard JavaScript.

### Notes

- Stage 2 is **UI only**. Sample tables, charts, statistics, and forms are static; nothing is saved, sent, or stored.
- Logout is a real link back to `frontend/login.html`; the login page and its authentication preview were not modified.
- Chart.js and Bootstrap 5 remain part of the approved stack but are not loaded. Charts use the existing CSS/SVG components.
- Stage 2 is **In Review** and awaits user approval.

---

## 2026-11-12 — Stage 1: Login scrolling behaviour

### Changed

- Desktop login now uses a viewport-height shell: the maroon brand panel stays stationary while only the ivory sign-in panel scrolls (`overflow-y: auto`).
- The sign-in panel is focusable (`tabindex="0"`), so Page Up, Page Down, Home, and End scroll it in addition to the mouse wheel and touchpad.
- The page itself no longer scrolls on desktop, preventing nested scrollbars and horizontal overflow.
- Mobile (≤ 860px) keeps the stacked layout and natural whole-page scrolling; the sign-in panel uses `overflow: visible` and the brand panel is not fixed.

### Verified

- 1920×1080: page height equalled the viewport; content fit without a scrollbar.
- 1366×768: brand panel stayed at top 0 while the sign-in panel scrolled 0→121px; wheel, End, and Page Down reached the bottom; Home and Page Up returned to 0; window scroll stayed 0.
- 768×1024 and 375×812: the whole page scrolled (297px and 556px) with panel scroll at 0 and the brand panel moving with the page; no horizontal overflow.
- Footer, password field, and Sign In button were reachable at the bottom; the skip link and validation focus still scrolled the panel correctly.
- No console errors or failed resources in the final warm run.

---

## 2026-11-12 — Stage 1: GM University rebrand and common login preview

### Added

- `frontend/login.html` — one common sign-in page for students, faculty, and administrators, with no role selector or role cards.
- `frontend/static/css/login.css` — split-screen brand panel, sign-in panel, validation, loading, and responsive rules.
- `frontend/static/js/login.js` — show/hide password, empty-field validation, honest preview loading state, and forgot-password dialog behaviour.
- `frontend/static/img/branding/gmu-official-logo.jpg` — the unmodified official GM University logo (778x778 JPEG, SHA-256 `CCEC422F...B6959`).
- `docs/design/GMU_BRAND_GUIDELINES.md` — logo source, usage rules, naming, palette, contrast, and checklists.
- `docs/design/GMU_LOGIN_DESIGN.md` — login layout, states, accessibility, responsive checks, and the future server-side authentication flow.
- Requirement entries FR-25 to FR-28 and UX-11 to UX-12.
- `login.html` links from the dashboard and styleguide.

### Changed

- Project name to **GM University Management System** (short form **GMU Management System**) and tagline to **Empowering Education Through Connected Technology**.
- Palette to University Maroon `#5B2020`, Deep Maroon `#421919`, University Gold `#E3B559`, Warm Ivory `#F8F6F0`, White, Graphite `#242424`, and Muted Grey `#8A8580`.
- Dashboard, styleguide, tokens, themes, components, and responsive rules now use the maroon and gold identity.
- JavaScript globals and events renamed from `NEXUS` to `GMU`; theme storage key is `gmu-theme`.
- Database identifiers in examples renamed to `gmu_management`, `gmu_app`, `gmu_admin`, and `gmu_report`.
- All active documentation, AI instructions, skills, prompts, requirements, scope, security, and architecture records rebranded.
- `docs/design/ACCESSIBILITY.md` contrast tables recomputed for the new palette.
- Old placeholder SVGs `favicon.svg` and `nexus-mark.svg` removed; the official logo is the favicon.

### Verified

- Login validated at 1440x900, 1024x768, 768x1024, 390x844, and 320x640 with zero horizontal overflow; the 1440x900 composition fits without page scroll.
- Empty-field validation shows an error summary, marks both fields invalid, and moves focus to the first field.
- Password toggle switches input type and `aria-pressed`, updates its label, and keeps focus.
- Preview submit shows a loading state, never navigates, never displays success, and stores no credentials.
- Forgot-password dialog opens, closes, and returns focus to its trigger.
- Reduced motion removes the entrance animations.
- Official logo loads at 96px (56px mobile), with `object-fit: contain`, no CSS filter, and the original 778x778 dimensions.
- Dashboard, styleguide, and login contain no visible `NEXUS` or `lime` strings.
- No console errors or failed resource loads in the verification run.

### Notes

- The login is a **design preview**. It does not authenticate, query MySQL, store passwords, create accounts, or reset passwords.
- Role detection is planned for the backend in Stage 4: the server looks up the registered account and reads its stored role.
- "Remember me" is intentionally omitted until secure, revocable token handling exists.
- Stage 1 remains **In Review** and awaits user approval.

---

## 2026-11-12 — Stage 1: UI/UX Design System and Visual Identity

### Added

- Design tokens in `frontend/static/css/tokens.css` (palette, typography, spacing, radii, shadows, motion, layers).
- Light and dark semantic themes in `frontend/static/css/themes.css`, including a dedicated `--nx-border-control` token for 3:1 control contrast.
- Base reset and accessibility utilities in `frontend/static/css/reset.css`.
- Application shell in `frontend/static/css/layout.css`: fixed sidebar, sticky header, breadcrumbs, content grid, footer, overlays.
- Reusable components in `frontend/static/css/components.css`: buttons, nav items, cards, stat cards, search, forms, selects, textareas, checkboxes, switches, badges, chips, avatars, dropdown menus, notifications, tabs, tables, dialogs, toasts, empty/loading/skeleton states, and static charts.
- Responsive behaviour in `frontend/static/css/responsive.css`: desktop → tablet → off-canvas mobile drawer, plus print rules.
- Theme bootstrap `theme-init.js` (runs before paint), theme controller `theme.js` (`localStorage`, system preference, toggle state), and interaction layer `main.js` (drawer, menus, tabs, dialogs, toasts, documentation filter).
- Dashboard preview at `frontend/index.html`: welcome panel, academic year/semester, four statistics, attendance overview, academic performance chart with table alternative, recent activity, quick actions, and a clearly labelled database-status placeholder.
- Live design-system reference at `frontend/styleguide.html` with 14 documentation sections and a section filter.
- Initial placeholder brand assets: `frontend/static/img/favicon.svg` and `frontend/static/img/nexus-mark.svg` (later removed in the GMU rebrand).
- Design documentation: `docs/design/VISUAL_IDENTITY.md`, `DESIGN_SYSTEM.md`, `UI_COMPONENTS.md`, and `ACCESSIBILITY.md`.

### Verified

- Rendered in Chrome via the DevTools Protocol at 320, 375, 390, 768, 1024, 1440, and 800px widths.
- Light and dark themes switch correctly; `?theme=light` / `?theme=dark` previews work; toggle choice persists.
- Four stat cards share one row at 1440px; grids collapse as designed on smaller widths.
- Zero horizontal document overflow at every tested width, including the wide table on the styleguide at 390px.
- Mobile drawer opens, locks the page, makes the rest of the shell inert, traps Tab, closes on Escape, and returns focus.
- Menus and dialogs move focus correctly and return it to their trigger; tabs respond to arrows/Home/End.
- Accessibility tree exposes landmarks, named search, switch, tablist/tabs, and descriptive chart image labels.
- No console errors or uncaught exceptions.
- WCAG contrast ratios computed for text, status badges, focus rings, and control borders in both themes; results recorded in `docs/design/ACCESSIBILITY.md`.

### Notes

- Stage 1 is **UI only**. MySQL, Flask, authentication, sessions, roles, and real student data are **not** connected; demo data is labelled as such throughout.
- Charts are static inline SVG/CSS. No Bootstrap or Chart.js is included.
- The work was committed to the `main` branch in the private project repository.
- Known project-documentation inconsistencies (`.github` prompts referencing a nonexistent `project-context/TASKS.md`; ADR-005 status) were later corrected during the rebrand cleanup, except ADR-005 itself, which remains Proposed pending approval.
- Stage 1 is awaiting user approval before Stage 2 begins.

---

## 2026-11-12 — Stage 0: Project Workspace and Context Setup

### Added

- Repository directory structure for `.github/`, `project-context/`, `skills/`, `docs/`, `database/`, `frontend/`, `backend/`, `tests/`, `scripts/`, and `reports/`.
- Global AI instructions in `.github/copilot-instructions.md`.
- Path-specific instructions for backend, frontend, database, and documentation.
- Prompt template and Stage 1 kickoff prompt.
- Eleven AI skills in `.github/skills/`, with human-readable pointers in `skills/`.
- Project context documents:
  - `PROJECT_OVERVIEW.md`
  - `PROJECT_REQUIREMENTS.md`
  - `PROJECT_SCOPE.md`
  - `SYSTEM_ARCHITECTURE.md`
  - `TECHNOLOGY_STACK.md`
  - `MODULE_SPECIFICATIONS.md`
  - `DESIGN_PRINCIPLES.md`
  - `CODING_STANDARDS.md`
  - `SECURITY_STANDARDS.md`
  - `DEVELOPMENT_WORKFLOW.md`
  - `CURRENT_STATUS.md`
  - `GLOSSARY.md`
- Architecture decision records 001–005 and a template.
- Database planning documents: ER diagram, database design, relationships, normalization, SQL concept mapping, and data dictionary.
- Root `README.md`, `ROADMAP.md`, `TASKS.md`, `CONTRIBUTING.md`, `.gitignore`, and `.env.example`.
- `.vscode/extensions.json` and `.vscode/settings.json` with recommended extensions and basic workspace settings. This is an addition beyond the requested structure, documented here and in the README.

### Notes

- No application, backend, or database implementation was started.
- The database schema is marked **PLANNING** and has not been executed.
- Stage 1 has not started and requires user approval.
