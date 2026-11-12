# Stage 1 — UI/UX Design System and Visual Identity

> **Do not run this prompt until the user approves Stage 1.**
> Stage 0 must be verified first.

## Goal

Create the NEXUS design system and visual identity: colour tokens, typography scale, spacing, component specifications, and static design reference pages. Do not build the application modules yet.

## Read first

1. `.github/copilot-instructions.md`
2. `project-context/DESIGN_PRINCIPLES.md`
3. `project-context/PROJECT_SCOPE.md`
4. `project-context/SYSTEM_ARCHITECTURE.md`
5. `project-context/CURRENT_STATUS.md`
6. `project-context/TASKS.md`

## Allowed scope

- `docs/design/`
- `frontend/static/css/` (design tokens and base styles only)
- `frontend/static/js/` (theme toggle only, if needed)
- `docs/decisions/` (new ADRs only)
- `CHANGELOG.md`, `TASKS.md`, `project-context/CURRENT_STATUS.md`

## Out of scope

- Flask routes and backend code.
- MySQL schema or SQL.
- Application features and dashboards.
- Changing the approved palette.

## Deliverables

- Design token file (CSS custom properties).
- Typography and spacing scale.
- Component specifications for buttons, forms, tables, cards, navigation.
- Light and dark theme reference pages.
- Accessibility notes.
- Updated documentation.

## Verification

- Reference pages open in a browser.
- Both themes render correctly.
- Contrast passes WCAG 2.1 AA.
- Keyboard focus is visible.
- No frontend library is added without approval.

## Stop condition

Stop after design deliverables are verified. Wait for approval before Stage 2.
