# NEXUS

**Student Management Database System Using DBMS and SQL**

> Education, connected.

---

## What is this?

NEXUS is a college DBMS project. It is a web application for managing students, departments, courses, subjects, faculty, attendance, marks, fees, feedback, and reports.

It is also a demonstration of database concepts: ER modelling, relational design, keys, constraints, 3NF normalization, SQL DDL/DML/DQL/DCL/TCL, joins, subqueries, aggregates, views, transactions, and access control.

**Current state:** Stage 0 — workspace and context setup. No application, backend, or database has been implemented. See `project-context/CURRENT_STATUS.md`.

---

## Technology

| Layer | Technology |
|---|---|
| Frontend | HTML5, CSS3, JavaScript, Bootstrap 5, Chart.js |
| Backend | Python, Flask, MySQL Connector/Python |
| Database | MySQL 8+ |

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
| `frontend/` | HTML, CSS, and JavaScript (built in later stages). |
| `backend/` | Flask application (built in later stages). |
| `tests/` | Automated tests (built in later stages). |
| `scripts/` | Setup and utility scripts. |
| `reports/` | Generated report assets for the submission. |

---

## Current stage

**Stage 0 — Project Workspace and Context Setup.**

Stage 1 (UI/UX Design System) has **not** started and requires approval.

The full roadmap is in `project-context/DEVELOPMENT_WORKFLOW.md` and summarised in `ROADMAP.md`.

---

## Status at a glance

| Area | Status |
|---|---|
| Project implementation | Not Started |
| Frontend | Not Started |
| Backend | Not Started |
| Database | Not Started (schema is PLANNING) |
| Testing | Not Started |
| Documentation | Stage 0 context created |

---

## Important rules

- This is a MySQL project. Do not use SQLite.
- Do not commit secrets. Use `.env` and `.env.example`.
- Do not claim something works without testing it.
- Do not start a new stage without approval.
- Read the project context before changing code.

---

## Quick start (later stages)

There is nothing to run yet. Setup instructions will be added in Stage 4 and refined in Stage 9. Do not follow a tutorial that assumes the app already exists.
