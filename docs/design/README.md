# Design Documentation

This folder holds the design system artifacts produced in **Stage 1** and refined in **Stage 2**.

## Contents

| Document | Purpose |
|---|---|
| `VISUAL_IDENTITY.md` | Brand idea, official logo usage, palette, typography, voice. |
| `GMU_BRAND_GUIDELINES.md` | Official logo source and rules, colour contrast, naming, checklists. |
| `GMU_LOGIN_DESIGN.md` | Common login layout, states, accessibility, future auth flow. |
| `GMU_DASHBOARD_DESIGN.md` | Stage 2 application shell, role page map, page contract, interactions, responsive and verification notes. |
| `DESIGN_SYSTEM.md` | Token architecture, theme strategy, file map, layout, extension guide. |
| `UI_COMPONENTS.md` | Component classes, markup examples, states, and usage rules. |
| `ACCESSIBILITY.md` | WCAG target, measured contrast results, keyboard behaviour, limitations. |

## Live reference

The design system is not only documented — it is rendered:

- `frontend/styleguide.html` — every token and component in one scrollable reference.
- `frontend/login.html` — the common sign-in preview.
- `frontend/dashboard/student/`, `frontend/dashboard/faculty/`, `frontend/dashboard/admin/` — the Stage 2 role workspaces, built on the shared shell.

All pages support light and dark themes. Use the header toggle, or append `?theme=light` / `?theme=dark` to preview without changing the saved preference.

## Canonical source

The design principles live in `project-context/DESIGN_PRINCIPLES.md`. This folder holds the concrete implementation and reference material that follows those principles.

## Status

**Stage 2 — In Review.** The Stage 1 design system and login preview remain, and the shared application shell plus all 34 student, faculty, and administration pages are implemented and browser-verified. The interface is still UI-only: there is no backend, authentication, session, or database connection. Every dashboard uses clearly labelled sample data. Awaiting user approval.
