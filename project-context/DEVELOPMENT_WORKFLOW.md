# GM University Management System — Development Workflow and Roadmap

> **Status:** Stage 0 complete and approved. Stage 1 implemented and awaiting user approval. No later stage has started.
> **Rule:** Do not begin a stage until the user approves it and the previous stage's acceptance criteria are met.

---

## 1. How a stage works

For every stage:

1. Confirm the current stage in `CURRENT_STATUS.md`.
2. Read the stage's objectives, tasks, and acceptance criteria below.
3. Check dependencies and the task board in `TASKS.md`.
4. Work in small steps.
5. Verify each deliverable.
6. Update `TASKS.md`, `CHANGELOG.md`, and `CURRENT_STATUS.md`.
7. Stop and ask for approval before the next stage.

A stage is **not** complete because files exist. It is complete when the acceptance criteria are verified.

---

## 2. Stage 0 — Project Workspace and Context Setup

**Status:** Complete and approved. No application implementation.

**Objectives**

- Create the repository structure.
- Create the project context system.
- Create AI instructions and skills.
- Create the roadmap and task board.
- Do not implement the application.

**Tasks**

- Create directories and READMEs.
- Write project context documents.
- Write AI instructions.
- Write skills.
- Write architecture and ADRs.
- Write database planning documents.
- Write task and status files.

**Deliverables**

- The directory tree in the brief.
- `.github/copilot-instructions.md`.
- `project-context/*`.
- `skills/*` and `.github/skills/*`.
- `docs/*` and ADRs.
- `database/*` planning.
- `README.md`, `CONTRIBUTING.md`, `CHANGELOG.md`, `TASKS.md`, `.gitignore`, `.env.example`.

**Dependencies:** None.

**Acceptance criteria**

- All listed files exist and contain real content.
- No application, backend, or database implementation exists.
- `CURRENT_STATUS.md` reports the true state.
- The user has reviewed the structure.

**Testing requirements**

- File tree inspection.
- Link and contradiction check.
- Confirm no `.sql` table creation was executed.

---

## 3. Stage 1 — UI/UX Design System and Visual Identity

**Status:** Implemented and verified; awaiting user approval. UI only — no backend, database, or authentication.

**Objectives**

- Turn `DESIGN_PRINCIPLES.md` into a working design system.
- Define tokens, typography, spacing, and components.
- Build static reference pages for light and dark themes.

**Tasks**

- Create CSS token files.
- Define the type and spacing scale.
- Specify buttons, forms, tables, cards, and navigation.
- Build static reference pages.
- Check contrast and keyboard focus.
- Document component usage.

**Deliverables**

- `frontend/static/css/tokens.css`
- `frontend/static/css/themes.css` (light + dark semantics)
- `frontend/static/css/reset.css`, `layout.css`, `components.css`, `login.css`, `responsive.css`
- `frontend/static/js/theme-init.js`, `theme.js`, `main.js`, `login.js`
- `frontend/index.html` — dashboard preview with demonstration data
- `frontend/styleguide.html` — live token and component reference
- `frontend/login.html` — common sign-in preview
- `frontend/static/img/branding/gmu-official-logo.jpg` — official, unmodified logo
- `docs/design/VISUAL_IDENTITY.md`, `GMU_BRAND_GUIDELINES.md`, `GMU_LOGIN_DESIGN.md`, `DESIGN_SYSTEM.md`, `UI_COMPONENTS.md`, `ACCESSIBILITY.md`

**Delivered as planned:** tokens, type/spacing scale, component specs, both themes, contrast checks, keyboard checks, documentation, GMU rebrand, and the common login preview.

**Dependencies:** Stage 0 approval. *(Received.)*

**Acceptance criteria**

- Reference pages render in both themes. *(Verified.)*
- The palette is used exactly as approved. *(Verified.)*
- Contrast meets WCAG 2.1 AA. *(Verified for text, status, focus, and control borders; decorative hairlines documented as an exception.)*
- Keyboard focus is visible. *(Verified.)*
- No application logic is added. *(Verified — demo interactions only.)*

**Testing requirements**

- Browser rendering at mobile, tablet, and desktop widths.
- Contrast checks.
- Keyboard-only navigation.
- No console errors.

---

## 4. Stage 2 — Frontend Development

**Status:** Not started.

**Objectives**

- Build the static page structure for the core modules.
- Implement navigation, layouts, forms, tables, and charts.

**Tasks**

- Create base layout and partials.
- Build pages for students, departments, courses, subjects, faculty, attendance, marks, fees, feedback, and reports.
- Add client-side validation for usability.
- Add Chart.js charts with text summaries.
- Add theme toggle.

**Deliverables**

- Jinja2 templates.
- JavaScript modules.
- Styled pages.
- Static preview data only; no real database connection.

**Dependencies:** Stage 1 design system.

**Acceptance criteria**

- All core pages exist.
- Responsive and accessible.
- No direct database access.
- No secrets.

**Testing requirements**

- Browser checks.
- Keyboard checks.
- Console checks.
- Responsive checks.

---

## 5. Stage 3 — MySQL Database Design and Implementation

**Status:** Not started.

**Objectives**

- Finalize the ER model.
- Normalize to 3NF.
- Create DDL and migrations.
- Create seed data.

**Tasks**

- Review entities and relationships.
- Document the data dictionary.
- Write DDL for all tables.
- Add primary keys, foreign keys, constraints, and indexes.
- Write migrations.
- Write fake seed data.
- Document normalization and relationships.

**Deliverables**

- `database/schema/*.sql`
- `database/migrations/*.sql`
- `database/seeds/*.sql`
- `database/documentation/*`
- ER diagram

**Dependencies:** Stage 0 context; user approval of the schema.

**Acceptance criteria**

- Schema is in 3NF.
- All constraints are present.
- Migrations run on a fresh MySQL 8 database.
- Seed data loads.
- Documentation matches the schema.

**Testing requirements**

- Run migrations on a clean database.
- Verify with `SHOW CREATE TABLE`.
- Run sample queries.
- Confirm foreign key behaviour.

---

## 6. Stage 4 — Flask Backend and Database Connection

**Status:** Not started.

**Objectives**

- Create the Flask application factory.
- Connect to MySQL safely.
- Implement authentication and role checks.

**Tasks**

- Create the app factory and configuration.
- Create the connection helper.
- Create repositories.
- Create authentication.
- Create error handlers.
- Add a health check.

**Deliverables**

- `backend/app/__init__.py`
- `backend/config.py`
- `backend/app/repositories/`
- `backend/app/auth/`
- `backend/requirements.txt`
- Tests for connection and auth

**Dependencies:** Stage 3 schema.

**Acceptance criteria**

- App starts.
- Connection to MySQL is verified.
- Login and logout work.
- Role checks work.
- Errors are handled safely.
- No secrets in code.

**Testing requirements**

- Start the app.
- Test connection success and failure.
- Test login success and failure.
- Test forbidden access.
- Run tests.

---

## 7. Stage 5 — Functional Module Development

**Status:** Not started.

**Objectives**

- Implement the modules in `MODULE_SPECIFICATIONS.md`.

**Tasks**

- Build one module at a time: database → repository → service → route → template.
- Add validation and tests per module.
- Update the task board.

**Deliverables**

- Working modules for students, departments, courses, subjects, faculty, assignments, enrolments, attendance, internal marks, semester marks, performance, fees, feedback, and reports.

**Dependencies:** Stage 4 backend.

**Acceptance criteria**

- Each module works end to end against MySQL.
- Inputs are validated.
- Errors are handled.
- Tests pass.

**Testing requirements**

- Per-module functional tests.
- Manual verification of each flow.
- Permission checks.

---

## 8. Stage 6 — SQL and DBMS Concept Demonstration

**Status:** Not started.

**Objectives**

- Make every required DBMS concept visible and runnable.

**Tasks**

- Write DDL, DML, DQL, DCL, and TCL demonstration scripts.
- Create views.
- Create stored procedures and triggers if used.
- Create transaction scenarios with `COMMIT`, `ROLLBACK`, and `SAVEPOINT`.
- Create `GRANT` and `REVOKE` scripts.
- Map each concept to a file and a feature.

**Deliverables**

- `database/documentation/SQL_CONCEPT_MAPPING.md` filled in.
- Runnable SQL scripts.
- Demo notes for the viva.

**Dependencies:** Stage 3 schema and Stage 5 modules.

**Acceptance criteria**

- Every concept in the brief is demonstrated.
- Scripts run successfully on MySQL 8.
- The mapping document is accurate.

**Testing requirements**

- Run every script.
- Confirm results.
- Confirm transaction behaviour.

---

## 9. Stage 7 — Integration and Testing

**Status:** Not started.

**Objectives**

- Verify the whole system works together.
- Build an automated test suite.

**Tasks**

- Write integration tests.
- Test cross-module flows.
- Test error paths.
- Test security controls.
- Fix defects.
- Record evidence.

**Deliverables**

- `tests/` suite.
- Test report in `docs/testing/`.
- Defect log.

**Dependencies:** Stages 5 and 6.

**Acceptance criteria**

- Core flows pass.
- Security checks pass.
- Test evidence is real and stored.
- Known issues are documented.

**Testing requirements**

- Automated tests.
- Manual regression pass.
- Browser and API checks.

---

## 10. Stage 8 — Security and Performance Review

**Status:** Not started.

**Objectives**

- Review the system against `SECURITY_STANDARDS.md`.
- Identify and fix performance problems.

**Tasks**

- Audit secrets and SQL.
- Audit authentication and authorization.
- Audit CSRF and XSS.
- Review database indexes and slow queries.
- Review error handling.
- Document findings and fixes.

**Deliverables**

- Security review in `docs/testing/`.
- Performance notes.
- Fixed issues.

**Dependencies:** Stage 7.

**Acceptance criteria**

- No secrets in Git.
- All queries parameterized.
- All protected routes check roles.
- Slow queries are addressed or documented.

**Testing requirements**

- Security checklist.
- Query plan review for key reports.
- Permission tests.

---

## 11. Stage 9 — Documentation and College Submission

**Status:** Not started.

**Objectives**

- Produce the final report and submission package.

**Tasks**

- Complete the project report.
- Finalize diagrams and screenshots.
- Write the user guide.
- Write setup instructions.
- Prepare the demo database.
- Package the submission.

**Deliverables**

- Final report.
- User guide.
- Setup guide.
- Screenshots and diagrams.
- Submission archive.

**Dependencies:** Stage 8.

**Acceptance criteria**

- Documentation matches the final system.
- All screenshots are real.
- Setup works from a clean machine.
- The submission meets college requirements.

**Testing requirements**

- Clean setup test.
- Documentation link check.
- Screenshot accuracy check.

---

## 12. Stage 10 — Final Demonstration and Viva Preparation

**Status:** Not started.

**Objectives**

- Prepare and rehearse the final demonstration.

**Tasks**

- Prepare a demo script.
- Prepare viva questions and answers.
- Rehearse the flow.
- Prepare a backup plan for demo failures.

**Deliverables**

- Demo script.
- Viva notes.
- Backup plan.

**Dependencies:** Stage 9.

**Acceptance criteria**

- The demo runs end to end.
- Every DBMS concept can be shown on request.
- The student can explain the architecture and schema.

**Testing requirements**

- Full rehearsal.
- Backup database and screenshots ready.

---

## 13. Stage gate checklist

Before moving from one stage to the next:

- [ ] Acceptance criteria met and verified.
- [ ] Tests run and recorded.
- [ ] `TASKS.md` updated.
- [ ] `CHANGELOG.md` updated.
- [ ] `CURRENT_STATUS.md` updated truthfully.
- [ ] Documentation updated.
- [ ] User approval received.

If any item is unchecked, the next stage does not start.
