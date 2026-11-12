# NEXUS — Global AI Agent Instructions

> **Read this file before doing anything else in this workspace.**
> These instructions apply to every AI agent, every chat session, and every file in the repository.

---

## 1. Project Identity (do not change without approval)

| Field | Value |
|---|---|
| Project name | **NEXUS** |
| Full title | Student Management Database System Using DBMS and SQL |
| Tagline | Education, connected. |
| Type | College DBMS project — web application |
| Architecture | Three-tier web application |
| Database | MySQL 8+ ONLY (never SQLite, never an in-memory substitute) |
| Backend | Python Flask |
| DB connector | MySQL Connector/Python |
| Frontend | HTML5, CSS3, JavaScript, Bootstrap 5 where appropriate, Chart.js |
| IDE | Visual Studio Code with AI Agent Mode |

The project must demonstrate: ER modelling, relational design, primary keys, foreign keys, constraints, 3NF normalisation, DDL, DML, DQL, DCL, TCL, joins, subqueries, aggregate functions, views, transactions (`COMMIT`, `ROLLBACK`, `SAVEPOINT`), `GRANT`, `REVOKE`, and database security.

---

## 2. Mandatory Reading Order

Before modifying code or structure, read these files **in this order**:

1. `project-context/PROJECT_OVERVIEW.md` — what we are building and why.
2. `project-context/PROJECT_SCOPE.md` — what is in and out of scope.
3. `project-context/SYSTEM_ARCHITECTURE.md` — how the three tiers connect.
4. `project-context/TECHNOLOGY_STACK.md` — approved tools and libraries.
5. `project-context/CURRENT_STATUS.md` — the real, verified state of the project.
6. `project-context/TASKS.md` (root `TASKS.md` is the working board) — what is next.
7. `project-context/DESIGN_PRINCIPLES.md` — the visual language.
8. `project-context/CODING_STANDARDS.md` — how code must be written.
9. `project-context/SECURITY_STANDARDS.md` — non-negotiable security rules.
10. `project-context/DEVELOPMENT_WORKFLOW.md` — the staged workflow.

If a required file is missing or contradicts another file, **stop and report the conflict** before changing anything.

---

## 3. Hard Safety Rules (non-negotiable)

1. **Never delete important files** without explicit permission from the user.
2. **Never overwrite existing project work** without inspecting it first.
3. **Never store real secrets** (passwords, API keys, database credentials) in source control.
4. **Never use SQLite** or any other database as a substitute for MySQL 8+.
5. **Never invent test results**, screenshots, database records, or browser output.
6. **Never claim a database connection works** until it has been verified.
7. **Never create unnecessary complexity.** Prefer the simplest correct solution.
8. **Never modify approved architecture silently.** Record a new ADR first.
9. **Never start another development stage** without the user's explicit approval.
10. **Never mark a task complete** until it has actually been implemented and verified.

If an existing file conflicts with these instructions, inspect it, explain the conflict to the user, and wait for a decision before editing.

---

## 4. Security Rules

- Use **parameterized SQL queries**. Never build SQL with string concatenation from user input.
- Validate and sanitize **all** user input on the server side, not only in the browser.
- Escape output in templates (Jinja2 autoescaping is on; do not disable it).
- Store secrets in `.env` (ignored by Git), never in Python, JavaScript, HTML, or SQL files.
- Use `.env.example` as the documented template; it must contain placeholder values only.
- Use the **principle of least privilege** for the MySQL application user.
- Hash passwords with a modern algorithm (e.g., `werkzeug.security` or `bcrypt`). Never store plaintext passwords.
- Use CSRF protection for state-changing forms.
- Set secure session cookie flags.
- Do not expose stack traces or SQL errors to end users. Log them server-side.
- Do not commit `*.sql` files that contain real student data.

---

## 5. Architecture Rules

- Respect the three-tier architecture: Presentation → Application → Data.
- Frontend code must not connect directly to MySQL.
- Backend routes must not contain raw SQL. Use a repository / data-access layer.
- Business rules belong in services, not in templates or route handlers.
- Database changes must be delivered as migrations, not ad-hoc edits to a live database.
- Any architectural change requires a new ADR in `docs/decisions/` and user approval.

See `project-context/SYSTEM_ARCHITECTURE.md` for the full design.

---

## 6. Coding Standards (summary)

- Python: PEP 8, 4-space indentation, meaningful names, type hints where practical, docstrings for public functions.
- JavaScript: `const`/`let`, no global variables, modular functions, no jQuery.
- HTML: semantic elements, accessible labels, no inline styles for layout.
- CSS: use design tokens from `DESIGN_PRINCIPLES.md`; avoid magic numbers.
- SQL: uppercase keywords, one clause per line, explicit column lists, parameterized values.
- Keep functions small and single-purpose. Do not copy-paste logic.
- Add comments only where the reason is not obvious.
- Do not add a dependency unless it is in `TECHNOLOGY_STACK.md` or the user approves it.

Full rules: `project-context/CODING_STANDARDS.md`.

---

## 7. Design System Rules

The UI follows the NEXUS hybrid design language:

- Apple-inspired minimalism, whitespace, elegant typography, refined interactions.
- Nothing-inspired monochrome discipline, dot-matrix accents, technical detail.
- Palette: Obsidian `#111111`, Paper `#F5F5F2`, White `#FFFFFF`, Silver `#BDBDBD`, Graphite `#292929`, Signal Lime `#D7FF35`.
- Signal Lime is an accent, not a background for large areas.
- Every new screen must support light and dark themes.
- Every new component must meet WCAG 2.1 AA contrast and keyboard accessibility.

Full rules: `project-context/DESIGN_PRINCIPLES.md`.

---

## 8. Verification Rules

Before saying a task is done:

1. Run the relevant tests (or explain why they cannot run).
2. Check the actual output, not just the code.
3. Confirm the database change applied to MySQL, not a mock.
4. Confirm the page renders in a browser if the task is visual.
5. Update `CHANGELOG.md` if the change is significant.
6. Update `TASKS.md` and `project-context/CURRENT_STATUS.md`.
7. Report exactly what was verified and what was not.

If you cannot verify something, say so plainly. Do not fill the gap with assumptions.

---

## 9. Documentation Rules

After a meaningful change:

- Update the relevant file in `project-context/`.
- Update `docs/` if the change affects architecture, API, database, or design.
- Add an entry to `CHANGELOG.md`.
- Update `TASKS.md` status.
- Update `project-context/CURRENT_STATUS.md` only after verification.
- If a decision was made, add an ADR in `docs/decisions/`.

Documentation must describe reality, not intentions.

---

## 10. Skills

Reusable skill instructions live in `.github/skills/<skill-name>/SKILL.md` (VS Code Agent Skills convention). A human-readable index lives in the root `skills/` folder.

When a task matches a skill:

1. Load or read the relevant `SKILL.md`.
2. Follow its workflow and checklist.
3. If the skill cannot be loaded, say so and follow the closest documented alternative.

Do not pretend a skill was loaded. Do not invent tool or configuration names.

---

## 11. Current Stage

The project is at **Stage 0 — Project Workspace and Context Setup**.

Do **not** start Stage 1 (UI/UX Design System) or any later stage until the user explicitly approves it.

See `project-context/DEVELOPMENT_WORKFLOW.md` for the full roadmap.

---

## 12. Communication Style

- Explain technical decisions in beginner-friendly English.
- Define jargon the first time it is used.
- Prefer short paragraphs and tables over long walls of text.
- When giving instructions, say exactly which file to open and which command to run.
- Be honest about uncertainty. "I have not verified this" is an acceptable answer.

---

## 13. Unknowns and Limitations

If you do not have access to a required tool, skill, database, or file:

- Say so explicitly.
- Document the limitation in the relevant file.
- Offer the safest compatible alternative.
- Do not fabricate access or results.
