# GM University Management System — Current Status

> **This file must reflect verified reality, not intentions.**
> **Last updated:** 2026-11-17 (UI/API polish, account setup/reset tools, and full test suite verified).
> **Update rule:** Change a status only after the work is implemented and verified.

---

## Status at a glance

- **Current Stage:** Stage 4 – Flask Backend and Database Connection
- **Project implementation status:** UI preview, a live MySQL database, and a working authenticated Flask backend serving the login system and the three role dashboards
- **Frontend status:** Stage 2 shared shell and student/faculty/administration pages implemented and verified; Stage 4 login and landing templates added
- **Backend status:** Application factory, blueprints, repositories, sessions, CSRF, RBAC, feedback/search endpoints, error pages, 54 passing tests
- **Database status:** Executed and live — 24 tables, 51 FKs, 8 views, 10 integrity triggers, fictional seed data
- **Testing status:** 54 automated backend tests passing; suite uses MySQL-backed tests and isolated fakes as appropriate

---

## 1. Stage

| Field | Value |
|---|---|
| Current stage | **Stage 4 — Flask Backend and Database Connection** |
| Stage 4 deliverable state | Application factory, config, MySQL connection helpers, repositories, common login with sessions, server-side role checks, CSRF protection, safe error pages, role landing dashboards, and 54 passing tests |
| Next stage | Stage 5 — Functional Module Development (not started) |
| Approval required | No — Stage 4 was approved and has been implemented |

---

## 2. Implementation status

| Area | Status | Notes |
|---|---|---|
| Project implementation | **Working application** | Live Flask backend over a real MySQL database, plus the Stage 2 UI and Stage 3 design. |
| Frontend | **Stage 2 complete** | Stage 1 design system and login preview, plus the shared shell and 34 student/faculty/administration pages. |
| Backend | **Stage 4 complete** | `backend/` runs on http://127.0.0.1:5000 with authentication, sessions, CSRF, RBAC, and error handlers. |
| Database | **Live** | 24 tables, 51 FKs, 32 unique keys, 29 CHECK constraints, 25 secondary indexes, 8 views, and 10 integrity triggers executed in MySQL 8.4.9. |
| Testing | **54 automated tests passing** | `pytest -q` passed on 2026-11-17; database integration tests use MySQL, with isolated route-flow tests using fakes. |
| Documentation | **Current** | Stage 1/2 docs, the Stage 3 database documentation set, the Stage 4 backend README, and this status. |

---

## 3. Database status

| Field | Value |
|---|---|
| Schema state | **Executed** — `database/schema/001_schema.sql` created 24 tables, 51 FKs, 32 unique keys, 29 CHECK constraints, and 25 secondary indexes |
| ER model | Complete Mermaid ER diagram — 24 entities, 51 relationship lines matching the FKs |
| Normalization review | Complete — 1NF/2NF/3NF report with the removed `student_enrolments.academic_year_id` redundancy and documented business exceptions |
| Tables created | **24** — confirmed with `information_schema.tables` in the running MySQL 8.4.9 instance |
| Migrations | None yet (numbered migration execution deferred) |
| Seed data | Loaded — 6 users, 3 students, 6 attendance records, 3 payments, all fictional |
| Views / procedures / triggers | 8 views and 10 triggers executed and compiled; procedures reserved for a later stage |
| Connection from the UI | **Live** — the backend reads the dashboards and role landing pages from MySQL |

The schema is created and live in the local MySQL 8.4.9 instance. Trigger negative tests and numbered migrations remain deferred.

---

## 4. What was created in Stage 1

- Primitive tokens (`tokens.css`) and light/dark semantic themes (`themes.css`).
- Reset and accessibility utilities (`reset.css`).
- App shell and layout (`layout.css`): sidebar, header, breadcrumbs, grids, footer.
- Component library (`components.css`): buttons, nav, cards, stat cards, search, forms, badges, menus, notifications, tabs, tables, dialogs, toasts, states, charts.
- Responsive rules and mobile drawer (`responsive.css`).
- Theme bootstrap, theme controller, and interaction layer (`theme-init.js`, `theme.js`, `main.js`).
- Dashboard preview (`frontend/index.html`) with demonstration data.
- Live design-system reference (`frontend/styleguide.html`).
- Common login preview (`frontend/login.html`, `login.css`, `login.js`) for students, faculty, and administrators, with no role selector.
- Official GM University logo at `frontend/static/img/branding/gmu-official-logo.jpg` (unmodified).
- Maroon, gold, and ivory palette applied through the token and theme files.
- `docs/design/VISUAL_IDENTITY.md`, `GMU_BRAND_GUIDELINES.md`, `GMU_LOGIN_DESIGN.md`, `DESIGN_SYSTEM.md`, `UI_COMPONENTS.md`, `ACCESSIBILITY.md`.

### Added in Stage 2

- `frontend/static/js/app-shell.js` — shared role-aware shell, navigation, header, menus, breadcrumbs, demo notice, and footer.
- `frontend/static/js/dashboard.js` — frontend-only table/list filters, pagination, mark-read, inert demo forms, and `/` search shortcut.
- `frontend/static/css/dashboard.css` — dashboard grids, hero, filters, meters, and pagination.
- 10 student pages under `frontend/dashboard/student/`.
- 10 faculty pages under `frontend/dashboard/faculty/`.
- 14 administration pages under `frontend/dashboard/admin/`.
- `docs/design/GMU_DASHBOARD_DESIGN.md` — page map, page contract, shell architecture, interaction hooks, responsive rules, and verification evidence.
- Delegated theme-toggle handling in `theme.js`, so the header control injected by the shell works on every page.

### Added in Stage 3

- `database/schema/001_schema.sql` — complete DDL for 24 InnoDB/utf8mb4 tables with primary keys, 51 foreign keys (including the composite `fk_tt_assignment`), 32 unique keys (including the functional feedback index), 29 CHECK constraints, defaults, and 25 secondary indexes.
- `database/views/001_views.sql` — 8 reporting views for profiles, attendance, internal marks, results, fees, faculty workload, class performance, and feedback.
- `database/triggers/001_integrity_triggers.sql` — 12 BEFORE INSERT/UPDATE triggers for cross-table integrity (attendance vs assignment/enrolment, internal marks vs assessment, semester marks vs exam, fee payment vs course/amount, notification target role).
- `database/seeds/001_sample_data.sql` — clearly fictional sample data for all modules; accounts use the non-authenticating sentinel `!NO_LOGIN_HASH_SET` and `pending_reset` status instead of any usable hash.
- `database/demonstrations/001_ddl.sql` … `006_tcl.sql` — DDL, DML, DQL, DCL, TCL, join, subquery, aggregate, and window-function demonstrations.
- `database/documentation/DATABASE_ARCHITECTURE.md` — module map, auth model, indexing, and Flask-readiness.
- `database/documentation/ER_DIAGRAM.md` — Mermaid ER diagram with cardinalities.
- `database/documentation/DATA_DICTIONARY.md` — column-level reference for all 24 tables.
- `database/documentation/TABLE_DESCRIPTIONS_AND_RELATIONSHIPS.md` — table purposes and FK/cardinality rules.
- `database/documentation/NORMALIZATION.md` — 1NF/2NF/3NF report and anomaly analysis.
- `database/documentation/SECURITY.md` — authentication storage, RBAC, least privilege, and sensitive-data controls.
- `database/documentation/REQUIREMENTS_TO_TABLE_MAPPING.md` — page/form/filter-to-table mapping.
- Updated `database/documentation/SQL_CONCEPT_MAPPING.md` and the database/schema/seed/view/trigger READMEs.
- `database/demonstrations/005_dcl.sql` — least-privilege accounts created with `IDENTIFIED BY RANDOM PASSWORD` (MySQL 8.0.18+); no reusable secret committed.

---

### Added in Stage 4

- `backend/config.py` — environment-driven configuration for the secret key, session flags, and MySQL connection.
- `backend/app/__init__.py` — application factory with blueprints, CSRF enforcement, security headers, and context processors.
- `backend/app/db.py` — MySQL connection and cursor helpers that always close, plus a `ping()` used by `/health`.
- `backend/app/repositories/user_repository.py` and `dashboard_repository.py` — parameterized SQL only (`%s` placeholders).
- `backend/app/services/auth_service.py` — Werkzeug password verification and login bookkeeping.
- `backend/app/auth/security.py` — session rotation, CSRF token handling, `login_required`, and `roles_required`.
- `backend/app/routes/` — `auth.py` (login/logout), `dashboard.py` (role landing pages), `health.py`, and `prototype.py`.
- `backend/scripts/create_sample_student_account.py` — confirmed, transactional local setup for the fictional `1GM23CS052` student; it has not been run, so no password was set and no account was added by this utility.
- `backend/scripts/reset_account_password.py` — local operator utility for resetting active Admin, Student, or Faculty accounts; Admin IDs are listed from MySQL, and password hashes are verified before commit.
- `backend/app/errors.py` — safe 400/401/403/404/405/500 pages that never leak internals.
- `frontend/templates/login.html` — the Stage 2 login markup converted into a Jinja template that posts to the backend.
- `frontend/templates/dashboard.html`, `errors/error.html`, `prototype_sign_out.html` — authenticated landing, error, and sign-out templates.
- `frontend/static/css/backend.css` and `frontend/static/js/login-form.js` — styling and form behaviour for the live pages.
- `tests/conftest.py`, `tests/unit/test_security.py`, and `tests/integration/` — 39 tests running against MySQL.

---

## 5. What is not complete

- Trigger negative tests (valid and invalid rows) against the live database.
- Numbered migration execution and rollback tests.
- Module CRUD: the backend authenticates and reports, but forms do not yet save data.
- Converting the 34 dashboard pages into Jinja2 templates (they are currently mounted behind authentication).
- Report generation and export.
- Integration tests for attendance, marks, fees, and reports.
- Manual screen-reader pass.
- College report and viva material.

---

## 6. Verified facts

| Fact | How verified |
|---|---|
| The MySQL schema executed successfully | `source database/schema/001_schema.sql`; `information_schema.tables` returned 24 base tables |
| Views, triggers, and seed data executed | View count 8, trigger count 10, and seed counts 6 users / 3 students / 6 attendance / 3 payments |
| A MySQL 8.4 CHECK/FK conflict was found and fixed | Runtime `ERROR 3823` on `fk_notif_target_user`; changed to `ON DELETE RESTRICT ON UPDATE RESTRICT` and re-ran the schema cleanly |
| Flask connects to MySQL | `GET /health` returned `{"status":"ok","database":"connected","version":"8.4.9","schema":"gmu_management_system"}` |
| Login rejects a wrong password | Live request returned `401` with the generic "did not match an active account" message |
| Login rejects an unknown identifier with the same message | Live request returned `401` with identical text, so accounts cannot be enumerated |
| A valid student login creates a session and redirects | Live request returned `302` to `/dashboard`, then the dashboard rendered USN `1GM23CS045` |
| Faculty and admin logins reach their own dashboards | Live requests with `FAC-CSE-014` and `admin@gmu.edu.in` rendered the faculty and administrator landing pages from MySQL |
| Role checks block cross-role access | A student session requesting the admin preview returned `403`; an admin session requesting the student and faculty previews returned `403` |
| The original 34-page interface preview is still reachable | `GET /prototype/dashboard/student/index.html` returned `200` with 17,885 bytes behind authentication |
| Sessions are destroyed on logout | `POST /logout` redirected to `/login?signed_out=1` and the dashboard then redirected back to login |
| State-changing requests require a CSRF token | `POST /login` without a token returned `400`; every form embeds `csrf_token()` |
| Redirect targets are restricted to the site | `safe_redirect_target` rejects `//evil.example`, absolute URLs, and `javascript:` payloads |
| Seeded sentinel hashes cannot authenticate | `verify_password('!NO_LOGIN_HASH_SET', ...)` returns `False`; malformed hashes are also rejected without raising |
| No internals are exposed in error pages | 404/500 responses contain no traceback, SQL, or file paths |
| The automated suite passes against MySQL | `pytest` reported `22 passed`; every test uses the real database, not SQLite |
| No usable credential is committed | `.env` is ignored by Git; the demo password lives only in a temp script outside the repository |
| Pages render in light and dark themes | Chrome DevTools Protocol; computed `body` colours and theme token values |
| Theme toggle persists the choice | Click test; `localStorage["gmu-theme"]` becomes `"light"`/`"dark"` |
| `?theme=light` / `?theme=dark` previews work | Navigated to both URLs |
| Four stat cards share one row at 1440px | Bounding boxes: identical `top`, four equal widths |
| No horizontal overflow at 320/375/390/768/800/1024/1440px | `documentElement.scrollWidth - clientWidth === 0` |
| Wide tables scroll inside their container | `contain: paint` on `.nx-table-wrap`; document width stayed 390px |
| Mobile drawer opens, locks scroll, traps focus, closes on Escape, returns focus | Scripted interaction checks with `inert`, `overflow`, and `document.activeElement` |
| Menus and dialogs manage focus correctly | Dedicated focus run: focus entered menu/dialog, Escape/close returned it to the trigger |
| Tabs switch panels and support arrow keys | Click and keyboard checks on `styleguide.html` |
| Styleguide filter hides non-matching sections | Filter test returned only the `buttons` block |
| Landmarks and control roles are exposed | Accessibility tree: banner, main, contentinfo, named navigations, search, switch, tablist, tabs, chart images |
| No console errors or uncaught exceptions | Runtime/Log event capture during dashboard, styleguide, and login verification runs |
| Text and control contrast meet targets | WCAG relative-luminance calculations; recorded in `docs/design/ACCESSIBILITY.md` |
| Common login has no role selector or role cards | DOM query returned zero `<select>`, role fields, or role cards on `login.html` |
| Login validates empty fields accessibly | Submit with both fields empty: error summary visible, both inputs `aria-invalid="true"`, focus moved to `#login-id` |
| Show/hide password works | Toggle changed `type` between `password` and `text`, updated `aria-pressed` and its label, and kept focus in the field |
| Login preview never authenticates | Submit showed `aria-busy="true"` and a loading label, then returned to the same page with a preview-only status; no success text and no stored credentials |
| Forgot-password dialog behaves correctly | Native dialog opened by name, closed with its button, and returned focus to the trigger |
| Login is responsive without horizontal overflow | Checked at 1440, 1024, 768, 390, and 320px; `scrollWidth - clientWidth` was 0 at every width |
| Login desktop composition fits a 1440x900 viewport | Shell and both panels measured 900px tall; `scrollHeight === innerHeight` |
| Reduced motion removes entrance animation | Emulated `prefers-reduced-motion: reduce`; brand and panel animation names reported `none` |
| Official logo loads unmodified | Login renders the 778x778 file at 96px (56px mobile), `object-fit: contain`, CSS filter `none`; dashboard and styleguide load the same asset at 40px |
| Rebrand removed old visible branding | Dashboard, styleguide, and login body text contain no `NEXUS` or `lime` strings; titles use the GMU name |
| Desktop login keeps the brand panel stationary | At 1920x1080 and 1366x768, brand `top` stayed 0 while the sign-in panel scrolled; the window did not scroll |
| Sign-in panel scrolls independently | At 1366x768, panel `scrollTop` went 0→121 by wheel, Page Down, and End; Home and Page Up returned it to 0; only one scrollable element existed |
| Login page scrolls naturally on mobile | At 768x1024 and 375x812, the document scrolled by 297px and 556px, panel `scrollTop` stayed 0, and the brand panel moved with the page |
| Login has no horizontal or nested scrollbars | `scrollWidth === clientWidth` at 1920, 1366, 768, and 375px; real-scrollbar run also reported no horizontal overflow |
| No backend, database, or auth is active | No such files or dependencies exist; the UI reports this in the system-status card and login notice |
| All 34 dashboard pages load the shared shell | Scripted run at 1366×768: sidebar, header, footer, breadcrumb, skip link, and demo notice present; exactly one active nav item; role attribute matched its folder; zero console/JS errors |
| Table filters, search, and pagination work on sample rows | Chip filter kept only matching rows; no-match search showed the empty state; pagination showed 6 then 4 rows, disabled Next on the last page, and returned to page 1 |
| Header search filters the current page's tables | Entering a no-match query hid all rows and showed the empty state; clearing it restored the rows |
| Dialogs and demo forms never submit | Dialog opened by trigger, submitted with `requestSubmit()`, showed a preview-only toast, stayed on the page, and closed back to its trigger |
| Profile menu and logout behave correctly | Menu opened, closed on outside click; Sign out points to `../../login.html` |
| Notifications mark read | Header menu opened with 3 unread, mark-all-read cleared them; page-level mark-read removed the page's 3 unread dots, updated its summary to “0 unread”, and showed a toast |
| Sidebar collapse persists | Control visible and functional at 1366px; `.is-sidebar-collapsed` and `localStorage["gmu-sidebar-collapsed"]="1"` survived a reload |
| Theme toggle works on the injected header control | Delegated handler switched `data-theme`, stored `gmu-theme`, and restored the original theme on a second click |
| Tabs switch panels accessibly | Faculty semester-marks tabs hid the inactive panel and set `aria-selected="true"` on the active tab |
| List filters combine and reset | Feedback status and category chips filtered items, produced the empty state for an impossible combination, and restored all items on reset |
| Responsive layouts have no horizontal overflow | 10 representative pages at 1920×1080, 1366×768, 768×1024, and 375×812: zero out-of-viewport elements and zero document overflow |
| Dashboard grids collapse as designed | Stat grids 4-up at 1920, 2-up at 768, 1-up at 375; report template row 3/2/1 at the same widths |
| Mobile navigation works | At 375px the drawer toggle is visible, the collapse control is hidden, the drawer opens with an overlay, and Escape closes it |
| Mobile tables scroll inside their wrapper | Table wrapper scrolled horizontally while the document width stayed at the viewport width |
| Dashboard controls and fields are named | Accessibility audit of 34 pages: no unnamed buttons/links, no unlabelled fields, no image without `alt`, no missing sprite symbol |
| Keyboard entry points work | Skip link is first focusable and targets `#main-content`; `/` focuses header search; sidebar collapse is focusable; notification menu closes on Escape |
| Dashboard pages make no data requests | No `fetch`, `XMLHttpRequest`, `WebSocket`, or form submission exists in the dashboard JavaScript; demo forms call `preventDefault()` |
| Dashboard markup and links are internally consistent | Static validation of 34 pages: balanced tags, no duplicate IDs, page contract present, all local assets and links resolve |
| Every designed table has a primary key | Static schema validation: 24/24 tables contain a `PRIMARY KEY` |
| Every foreign key references an existing table | Static validation: 51/51 FK targets exist; 0 missing targets |
| Data dictionary matches the schema | Script compared 24 tables and their columns; 0 missing/extra columns after grouped-column normalization |
| ER diagram matches the schema | Script compared 24 ER entities and 51 relationship lines against the 51 FKs; 0 unknown entities or missing tables |
| Schema counts are internally consistent | Static count: 24 tables, 24 PKs, 51 FKs, 32 unique keys, 29 CHECK constraints, 25 secondary indexes |
| Integrity triggers are structurally valid | Static review: 10 triggers (5 rules × INSERT/UPDATE), paired `DROP TRIGGER IF EXISTS` + `CREATE TRIGGER`, balanced `BEGIN`/`END`, `DELIMITER` restored to `;` |
| Seed data contains no usable credentials | Every seeded account uses `!NO_LOGIN_HASH_SET` with `pending_reset`; no bcrypt/Argon2 hash or plaintext password is present |
| No destructive SQL is included as executable | Schema has no `DROP DATABASE`; DDL demo drops only its disposable table; destructive examples are commented out |
| No database is connected or operational | No MySQL client installed; no application code opens a connection; no SQL executed |

Anything not in this table is unverified.

---

## 7. Known risks and open questions

| Item | Status |
|---|---|
| Final schema and cardinalities | Resolved — schema executed, 24 tables confirmed |
| Exact role model | Implemented — `users.role_id` drives `roles_required` on every protected route |
| Manual screen-reader review | Open — before submission |
| Automated accessibility testing | Open — the Stage 2 audit was scripted but the harness is not committed |
| Chart library choice for dynamic data | Deferred — Stage 2 uses CSS/SVG charts; Chart.js remains an option for Stage 5 |
| Header unread count vs page notifications | Open — the header menu and page list are separate sample sets; marking page items read does not change the header badge |
| College submission format | Open — confirm with the student |
| Local MySQL version | Resolved — MySQL 8.4.9 confirmed by `SELECT VERSION()` |
| ADR-005 database access strategy | Implemented — repository layer with parameterized SQL is in use |
| Manual screen-reader pass for the login page and dashboards | Open — before submission |
| Stage 2 commit | Resolved — committed and pushed (`2112cd8`, `96d77f2`) |
| Stage 3 SQL execution | Resolved — schema, views, triggers, and seed data executed in MySQL 8.4.9 |
| Stage 3/4 commits | Open — work is uncommitted on purpose; the user has not asked for a commit |
| Least-privilege database users | Open — `gmu_app`/`gmu_admin`/`gmu_report` exist only in `005_dcl.sql`; the local dev instance still uses `root` |
| Trigger negative tests | Open — the 10 triggers compile, but invalid-row tests are not written yet |
| Sessions in production | Open — Flask's signed-cookie session is fine for a college demo; a server-side session store is the upgrade path |

---

## 8. Change log for this file

| Date | Change |
|---|---|
| 2026-11-12 | Initial status after Stage 0 workspace setup. |
| 2026-11-12 | Updated after Stage 1 design-system implementation and browser verification; Stage 1 marked In Review. |
| 2026-11-12 | Rebranded to GM University Management System, added the official logo, common login preview, and login verification evidence. |
| 2026-11-12 | Updated after Stage 2: shared shell, 34 role dashboards, interaction tests, responsive/accessibility audits, and current limitations. |
| 2026-11-13 | Updated after Stage 3: 24-table schema, 8 views, fictional seed data, SQL demonstrations, ER/data dictionary/normalization/security/mapping docs, and static validation. No database executed or connected. |
| 2026-11-13 | Applied the Stage 3 correction review: removed `student_enrolments.academic_year_id`, added `section`, added the composite timetable FK, added 10 integrity triggers, fixed the attendance/fee/workload views, removed usable seed hashes, and reconciled all documentation. Stage 3 marked Done; execution and trigger testing remain deferred. |
| 2026-11-13 | Executed the Stage 3 schema, views, triggers, and seed data against MySQL 8.4.9; found and fixed `ERROR 3823` on `fk_notif_target_user`; confirmed 24 tables, 8 views, 10 triggers, and seed counts. |
| 2026-11-13 | Stage 4: built the Flask backend, authenticated login, sessions, CSRF, RBAC, error pages, and role dashboards. 22 automated tests pass against MySQL; the app is running on http://127.0.0.1:5000. |
| 2026-11-16 | Added and tested a transactional local setup utility for the fictional `1GM23CS052` student. The account itself remains absent until the operator runs the script and sets a password locally; the full MySQL suite reports 39 passing tests. |
