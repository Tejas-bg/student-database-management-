# Design Documentation

This folder holds the design system artifacts produced in **Stage 1** and refined in **Stage 2**.

## Contents

| Document | Purpose |
|---|---|
| `VISUAL_IDENTITY.md` | Brand idea, official logo usage, palette, typography, voice. |
| `GMU_BRAND_GUIDELINES.md` | Official logo source and rules, colour contrast, naming, checklists. |
| `GMU_LOGIN_DESIGN.md` | Common login layout, states, accessibility, future auth flow. |
| `DESIGN_SYSTEM.md` | Token architecture, theme strategy, file map, layout, extension guide. |
| `UI_COMPONENTS.md` | Component classes, markup examples, states, and usage rules. |
| `ACCESSIBILITY.md` | WCAG target, measured contrast results, keyboard behaviour, limitations. |

## Live reference

The design system is not only documented — it is rendered:

- `frontend/styleguide.html` — every token and component in one scrollable reference.
- `frontend/login.html` — the common sign-in preview.
- `frontend/index.html` — dashboard preview using the same system with demonstration data.

Both pages support light and dark themes. Use the header toggle, or append `?theme=light` / `?theme=dark` to preview without changing the saved preference.

## Canonical source

The design principles live in `project-context/DESIGN_PRINCIPLES.md`. This folder holds the concrete implementation and reference material that follows those principles.

## Status

**Stage 1 — In Review.** The design system, dashboard preview, common login preview, light/dark themes, component library, and documentation are implemented. Stage 1 is UI-only: there is no backend, authentication, or database connection. Awaiting user approval before Stage 2.
