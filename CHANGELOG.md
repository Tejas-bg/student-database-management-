# Changelog

All significant changes to the GM University Management System are recorded here, newest first.

The format is simple: date, stage, what changed, and why. It is not a commit log.

---

## 2026-11-12 — Stage 1: GM University rebrand and common login preview

### Added

- `frontend/login.html` — one common sign-in page for students, faculty, and administrators, with no role selector or role cards.
- `frontend/static/css/login.css` — split-screen brand panel, sign-in panel, validation, loading, and responsive rules.
- `frontend/static/js/login.js` — show/hide password, empty-field validation, honest preview loading state, and forgot-password dialog behaviour.
- `frontend/static/img/branding/gmu-official-logo.jpg` — the unmodified official GM University logo (778x778 JPEG, SHA-256 `CCEC422F...B6959`).
- `docs/design/GMU_BRAND_GUIDELINES.md` — logo source, usage rules, naming, palette, contrast, and checklists.
- `docs/design/GMU_LOGIN_DESIGN.md` — login layout, states, accessibility, responsive checks, and the future server-side authentication flow.
- Requirement entries FR-25 to FR-28 and UX-11 to UX-12.
- `login.html` links from the dashboard and styleguide.

### Changed

- Project name to **GM University Management System** (short form **GMU Management System**) and tagline to **Empowering Education Through Connected Technology**.
- Palette to University Maroon `#5B2020`, Deep Maroon `#421919`, University Gold `#E3B559`, Warm Ivory `#F8F6F0`, White, Graphite `#242424`, and Muted Grey `#8A8580`.
- Dashboard, styleguide, tokens, themes, components, and responsive rules now use the maroon and gold identity.
- JavaScript globals and events renamed from `NEXUS` to `GMU`; theme storage key is `gmu-theme`.
- Database identifiers in examples renamed to `gmu_management`, `gmu_app`, `gmu_admin`, and `gmu_report`.
- All active documentation, AI instructions, skills, prompts, requirements, scope, security, and architecture records rebranded.
- `docs/design/ACCESSIBILITY.md` contrast tables recomputed for the new palette.
- Old placeholder SVGs `favicon.svg` and `nexus-mark.svg` removed; the official logo is the favicon.

### Verified

- Login validated at 1440x900, 1024x768, 768x1024, 390x844, and 320x640 with zero horizontal overflow; the 1440x900 composition fits without page scroll.
- Empty-field validation shows an error summary, marks both fields invalid, and moves focus to the first field.
- Password toggle switches input type and `aria-pressed`, updates its label, and keeps focus.
- Preview submit shows a loading state, never navigates, never displays success, and stores no credentials.
- Forgot-password dialog opens, closes, and returns focus to its trigger.
- Reduced motion removes the entrance animations.
- Official logo loads at 96px (56px mobile), with `object-fit: contain`, no CSS filter, and the original 778x778 dimensions.
- Dashboard, styleguide, and login contain no visible `NEXUS` or `lime` strings.
- No console errors or failed resource loads in the verification run.

### Notes

- The login is a **design preview**. It does not authenticate, query MySQL, store passwords, create accounts, or reset passwords.
- Role detection is planned for the backend in Stage 4: the server looks up the registered account and reads its stored role.
- "Remember me" is intentionally omitted until secure, revocable token handling exists.
- Stage 1 remains **In Review** and awaits user approval.

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
- Initial placeholder brand assets: `frontend/static/img/favicon.svg` and `frontend/static/img/nexus-mark.svg` (later removed in the GMU rebrand).
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
- The work was committed to the `main` branch in the private project repository.
- Known project-documentation inconsistencies (`.github` prompts referencing a nonexistent `project-context/TASKS.md`; ADR-005 status) were later corrected during the rebrand cleanup, except ADR-005 itself, which remains Proposed pending approval.
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
