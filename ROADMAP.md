# GM University Management System — Roadmap

This is a one-page summary. The detailed version, with tasks, deliverables, dependencies, acceptance criteria, and testing requirements, is in `project-context/DEVELOPMENT_WORKFLOW.md`.

---

## Stages

| Stage | Name | Status |
|---|---|---|
| 0 | Project Workspace and Context Setup | Complete and approved |
| 1 | UI/UX Design System and Visual Identity | Complete and approved |
| 2 | Frontend Development | Implemented and verified; awaiting review |
| 3 | MySQL Database Design and Implementation | Not started |
| 4 | Flask Backend and Database Connection | Not started |
| 5 | Functional Module Development | Not started |
| 6 | SQL and DBMS Concept Demonstration | Not started |
| 7 | Integration and Testing | Not started |
| 8 | Security and Performance Review | Not started |
| 9 | Documentation and College Submission | Not started |
| 10 | Final Demonstration and Viva Preparation | Not started |

---

## Stage gates

Do not start the next stage until:

- [ ] The current stage's acceptance criteria are met.
- [ ] Tests are run and recorded.
- [ ] `TASKS.md`, `CHANGELOG.md`, and `CURRENT_STATUS.md` are updated.
- [ ] Documentation reflects reality.
- [ ] The user has approved the next stage.

---

## Immediate next step

Stage 2 is complete for review. Open `frontend/login.html` and the three workspaces through a local server:

- `frontend/dashboard/student/`
- `frontend/dashboard/faculty/`
- `frontend/dashboard/admin/`

Inspect navigation, filters, dialogs, the profile menu, notifications, sidebar collapse, and both themes. Every page labels its content as sample data.

For example, from the project folder:

```powershell
python -m http.server 8000 --directory frontend
```

Then open `http://127.0.0.1:8000/login.html`.

When you are satisfied, approve Stage 3:

> "Start Stage 3: MySQL Database Design and Implementation."

Until then, do not build the backend or the database.
