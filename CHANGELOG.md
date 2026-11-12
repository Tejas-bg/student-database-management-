# Changelog

All significant changes to NEXUS are recorded here, newest first.

The format is simple: date, stage, what changed, and why. It is not a commit log.

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
- Original brand assets: `frontend/static/img/favicon.svg` and `frontend/static/img/nexus-mark.svg`.
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
- The workspace is not a Git repository, so these changes are filesystem-only and uncommitted.
- Known project-documentation inconsistencies (`.github` prompts referencing a nonexistent `project-context/TASKS.md`; ADR-005 status) were reported, not edited in this stage.
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
