# GM University Management System

**A centralized university student and academic management web application**

> Empowering Education Through Connected Technology

---

## What is this?

The **GM University Management System** is a college DBMS project for **GM University, Davanagere, Karnataka**. It is a web application for managing students, departments, courses, subjects, faculty, attendance, marks, fees, feedback, and reports.

It is also a demonstration of database concepts: ER modelling, relational design, keys, constraints, 3NF normalization, SQL DDL/DML/DQL/DCL/TCL, joins, subqueries, aggregates, views, transactions, and access control.

One common sign-in page serves students, faculty, and administrators. The user role will be detected by the backend from the registered MySQL account, never chosen in the browser.

> **Independent student project.** This is not an official GM University service and does not claim university endorsement. The official university logo is used to identify the institution the project is built for.

**Current state:** Stage 1 — UI/UX design system and login preview. No backend, authentication, or database connection exists yet. See `project-context/CURRENT_STATUS.md`.

---

## Technology

| Layer | Technology |
|---|---|
| Frontend | HTML5, CSS3, JavaScript, Bootstrap 5, Chart.js |
| Backend | Python, Flask, MySQL Connector/Python |
| Database | MySQL 8+ |

---

## Preview the design

The Stage 1 interface is static. From the `frontend/` folder, run a local file server:

```powershell
cd frontend
python -m http.server 8000
```

Then open:

| Page | URL | What it shows |
|---|---|---|
| Common sign-in | `http://localhost:8000/login.html` | Branded login preview with validation and password toggle |
| Dashboard | `http://localhost:8000/index.html` | Demonstration dashboard shell |
| Design reference | `http://localhost:8000/styleguide.html` | Colours, type, components, and accessibility patterns |

The login form does not authenticate anyone. It deliberately shows a preview message instead of a fake success.

---

## Official branding

- **Logo:** `frontend/static/img/branding/gmu-official-logo.jpg`
- **Source:** `https://www.gmu.ac.in/assets/imgs/logo.jpg` (official GM University website)
- **Status:** Downloaded unmodified on 12 November 2026; 778×778 JPEG.
- **Palette:** University Maroon `#5B2020`, Deep Maroon `#421919`, University Gold `#E3B559`, Warm Ivory `#F8F6F0`, White `#FFFFFF`, Graphite `#242424`, Muted Grey `#8A8580`.

Read `docs/design/GMU_BRAND_GUIDELINES.md` before using the logo anywhere, and `docs/design/GMU_LOGIN_DESIGN.md` for the login specification.

---

## Read these first

If you are new to the project, read in this order:

1. `project-context/PROJECT_OVERVIEW.md` — what we are building.
2. `project-context/PROJECT_SCOPE.md` — what is in and out of scope.
3. `project-context/SYSTEM_ARCHITECTURE.md` — how the three tiers connect.
4. `project-context/CURRENT_STATUS.md` — the real state.
5. `TASKS.md` — what is next.
6. `CONTRIBUTING.md` — how to work on the project with VS Code and AI Agent Mode.
7. `project-context/GLOSSARY.md` — technical terms explained simply.

---

## Repository map

| Path | Purpose |
|---|---|
| `.github/` | AI instructions, prompts, and skills. |
| `.vscode/` | Recommended extensions and basic workspace settings. |
| `project-context/` | The single source of truth for project knowledge. |
| `skills/` | Human index of AI skills; the loadable files are in `.github/skills/`. |
| `docs/` | Architecture, design, API, testing, user guide, and ADRs. |
| `database/` | Schema, migrations, seeds, views, procedures, triggers, and database docs. |
| `frontend/` | HTML, CSS, JavaScript, and static design assets. |
| `backend/` | Flask application (built in later stages). |
| `tests/` | Automated tests (built in later stages). |
| `scripts/` | Setup and utility scripts. |
| `reports/` | Generated report assets for the submission. |

---

## Current stage

**Stage 1 — UI/UX Design System and Visual Identity.**

Stage 1 is implemented and awaiting user approval. The rebrand and login-page preview are part of that review. Stage 2 (Frontend Development) has not started.

The full roadmap is in `project-context/DEVELOPMENT_WORKFLOW.md` and summarised in `ROADMAP.md`.

---

## Status at a glance

| Area | Status |
|---|---|
| Project implementation | UI preview only |
| Frontend | Stage 1 design system and login preview implemented |
| Backend | Not Started |
| Database | Not Started (schema is PLANNING) |
| Testing | Manual browser verification only |
| Documentation | Rebranded and current |

---

## Important rules

- This is a MySQL project. Do not use SQLite.
- Do not commit secrets. Use `.env` and `.env.example`.
- Do not claim something works without testing it.
- Do not start a new stage without approval.
- Read the project context before changing code.
- Never implement role selection in the browser. The backend decides the role.
- Never alter, crop, or recolour the official university logo.

---

## Setup (later stages)

The static preview needs only Python's built-in file server. Flask, MySQL, and the virtual environment are set up in Stage 4. Do not follow a tutorial that assumes the app already exists.
