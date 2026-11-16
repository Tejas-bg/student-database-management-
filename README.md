# GM University Management System

**A centralized university student and academic management web application**

> Empowering Education Through Connected Technology

---

## What is this?

The **GM University Management System** is a college DBMS project for **GM University, Davanagere, Karnataka**. It is a web application for managing students, departments, courses, subjects, faculty, attendance, marks, fees, feedback, and reports.

It is also a demonstration of database concepts: ER modelling, relational design, keys, constraints, 3NF normalization, SQL DDL/DML/DQL/DCL/TCL, joins, subqueries, aggregates, views, transactions, and access control.

One common sign-in page serves students, faculty, and administrators. The user role will be detected by the backend from the registered MySQL account, never chosen in the browser.

> **Independent student project.** This is not an official GM University service and does not claim university endorsement. The official university logo is used to identify the institution the project is built for.

**Current state:** Stage 3 — frontend interface preview plus a complete MySQL database design for student, faculty, and administration workspaces. No backend, authentication, or live database connection exists yet. See `project-context/CURRENT_STATUS.md`.

---

## Technology

| Layer | Technology |
|---|---|
| Frontend | HTML5, CSS3, JavaScript (Bootstrap 5 and Chart.js approved for later stages, not yet loaded) |
| Backend | Python, Flask, MySQL Connector/Python |
| Database | MySQL 8+ |

---

## Preview the design

The interface is static. From the `frontend/` folder, run a local file server:

```powershell
cd frontend
python -m http.server 8000
```

Then open:

| Page | URL | What it shows |
|---|---|---|
| Common sign-in | `http://localhost:8000/login.html` | Branded login preview with validation and password toggle |
| Student workspace | `http://localhost:8000/dashboard/student/` | Student overview, courses, attendance, marks, fees, timetable, notifications, feedback |
| Faculty workspace | `http://localhost:8000/dashboard/faculty/` | Teaching overview, subjects, students, attendance, marks entry, performance, reports |
| Administration workspace | `http://localhost:8000/dashboard/admin/` | Institution management across people, academics, operations, and reports |
| Design reference | `http://localhost:8000/styleguide.html` | Colours, type, components, and accessibility patterns |

The login form does not authenticate anyone. It deliberately shows a preview message instead of a fake success. Every dashboard uses invented sample data and says so on the page. Bootstrap 5 and Chart.js are part of the approved stack but are not loaded yet; the current interface and charts use the project's own CSS and SVG components.

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

**Stage 3 — MySQL Database Architecture and ER Design.**

Stage 3 is complete, corrected, and statically validated. It defines a 24-table MySQL 8 schema with 51 foreign keys, 8 reporting views, 10 cross-table integrity triggers, fictional seed data, SQL demonstrations, an ER diagram, a data dictionary, a normalization report, security guidance, and a page-to-table mapping. The schema has **not** been executed and no database is connected.

Stage 2 remains the current interface: a shared shell and 34 student, faculty, and administration pages on top of the Stage 1 design system and login preview. The interface is UI-only.

Start with `database/documentation/README.md`. The full roadmap is in `project-context/DEVELOPMENT_WORKFLOW.md` and summarised in `ROADMAP.md`.

---

## Status at a glance

| Area | Status |
|---|---|
| Project implementation | UI preview + database design |
| Frontend | Stage 2 shell and 34 role pages implemented and browser-verified |
| Backend | Not Started |
| Database | Stage 3 design complete, corrected, and statically validated — 24 tables, 51 FKs, 8 views, 10 triggers, scripts and docs; not executed |
| Testing | Stage 2 scripted browser verification + Stage 3 static SQL/document validation; no committed automated suite |
| Documentation | Stage 3 database docs current |

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
