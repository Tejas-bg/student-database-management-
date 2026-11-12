# GM University Management System — Technology Stack

> **Status:** Approved baseline for the current technology stack.
> **Rule:** Do not add, remove, or replace a technology without user approval and, where relevant, an ADR.

---

## 1. Summary

| Area | Choice | Version target |
|---|---|---|
| Database | MySQL | 8.0+ |
| DB connector | MySQL Connector/Python | Current stable |
| Backend language | Python | 3.10+ |
| Backend framework | Flask | Current stable |
| Frontend markup | HTML5 | — |
| Frontend styling | CSS3 | — |
| Frontend scripting | JavaScript (ES2020+) | — |
| UI framework | Bootstrap 5 | 5.x |
| Charts | Chart.js | Current stable |
| Editor | Visual Studio Code | Current stable |
| AI development | VS Code AI Agent Mode | Current stable |

"Current stable" means the latest stable release available when the stage begins. Pin exact versions in `backend/requirements.txt` when the backend is created.

---

## 2. Database — MySQL 8+

**Why:** It is the required database for the project, it is widely used in education and industry, and it supports the DBMS concepts the project must demonstrate: foreign keys, `CHECK` constraints, views, transactions, stored procedures, triggers, and `GRANT`/`REVOKE`.

**Rules:**

- Use InnoDB.
- Use `utf8mb4`.
- Do not use SQLite, even for tests. Tests must run against MySQL.
- Do not use an ORM unless the user explicitly approves it in an ADR. The project must show real SQL.
- Use parameterized queries through MySQL Connector/Python.

**Planned DB users (least privilege):**

| User | Purpose | Rights |
|---|---|---|
| `gmu_admin` | Schema creation and migrations | DDL + DML on the GM University Management System schema |
| `gmu_app` | Application runtime | DML and `SELECT` on needed tables/views |
| `gmu_report` | Read-only reporting | `SELECT` on views only |

Actual usernames and passwords are created locally and stored in `.env`. They never appear in source control.

---

## 3. Backend — Python + Flask

**Why:** Flask is small, readable, and beginner-friendly. It does not hide the request/response model, which makes it a good teaching framework for a college project.

**Rules:**

- Use an application factory (`create_app()`).
- Organise features with blueprints.
- Separate routes, services, repositories, and validators.
- Configuration comes from environment variables.
- Use `python-dotenv` to load `.env` during local development.
- Use `werkzeug.security` for password hashing unless a stronger approved alternative is chosen.
- Keep the dependency list small.

**Planned dependencies (not installed yet):**

| Package | Purpose |
|---|---|
| `Flask` | Web framework |
| `mysql-connector-python` | MySQL driver |
| `python-dotenv` | Load `.env` locally |
| `pytest` | Testing |
| `pytest-cov` | Coverage reporting |

Additional packages require justification.

---

## 4. Frontend — HTML, CSS, JavaScript, Bootstrap 5, Chart.js

**Why:** These are standard web technologies. Bootstrap 5 speeds up layout and responsive behaviour. Chart.js provides accessible, lightweight charts for analytics.

**Rules:**

- Semantic HTML5.
- CSS custom properties for the GM University Management System design tokens.
- Vanilla JavaScript modules; no jQuery.
- Bootstrap 5 is used where appropriate, not everywhere. Custom design tokens override Bootstrap defaults.
- Chart.js only for data visualisation.
- No frontend build system is assumed in the baseline. If one becomes necessary, record an ADR.
- Load third-party assets from a CDN unless offline use is required; if offline use is required, vendor them under `frontend/static/vendor/` with a licence note.

---

## 5. Development environment — VS Code

**Why:** It is the chosen editor and it supports AI Agent Mode, instruction files, prompt files, and agent skills.

**Relevant conventions:**

- Global instructions: `.github/copilot-instructions.md`.
- Path-specific instructions: `.github/instructions/*.instructions.md` with `applyTo` frontmatter.
- Prompt files: `.github/prompts/*.prompt.md`.
- Agent skills: `.github/skills/<name>/SKILL.md`.

These are documented conventions, not magic. The agent must verify what the installed version supports and say so if something is unavailable.

---

## 6. Rejected or deferred technologies

| Technology | Decision | Reason |
|---|---|---|
| SQLite | Rejected | The project must use MySQL 8+. |
| Django | Rejected | Heavier than needed; Flask keeps the layers visible. |
| SQLAlchemy ORM | Deferred | The project must demonstrate hand-written SQL. |
| React / Vue | Rejected for baseline | Adds build complexity; not needed for the scope. |
| jQuery | Rejected | Modern JavaScript is sufficient. |
| MongoDB | Rejected | The project is relational. |
| Docker | Deferred | Useful later, but not required for the baseline. |
| Cloud hosting | Deferred | Local development is enough for submission. |

---

## 7. Version pinning

- Python dependencies are pinned in `backend/requirements.txt` when created.
- The MySQL version is recorded in `database/documentation/DATABASE_DESIGN.md`.
- If a version changes, record it in `CHANGELOG.md`.
