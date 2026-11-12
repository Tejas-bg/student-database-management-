# Frontend

> **Status: Stage 1 complete for review (UI only).** The design system and preview pages exist. No backend, authentication, database connection, or real student data is present.

This folder holds the presentation layer: the Stage 1 design system, the dashboard preview, and the component reference. In Stage 2 the same static shell will become Jinja2 templates served by Flask.

## Current structure

```
frontend/
├── index.html                 Dashboard preview (Stage 1)
├── styleguide.html            Live design-system and component reference
├── README.md                  This file
└── static/
    ├── css/
    │   ├── tokens.css         Primitive tokens: palette, type, space, radius, motion
    │   ├── themes.css         Light and dark semantic tokens
    │   ├── reset.css          Reset, base type, focus, a11y utilities
    │   ├── layout.css         App shell, sidebar, header, grids, docs layout
    │   ├── components.css     Buttons, cards, forms, tables, dialogs, charts
    │   └── responsive.css     Breakpoints, mobile drawer, print
    ├── js/
    │   ├── theme-init.js      Blocking pre-paint theme selection
    │   ├── theme.js           Theme toggle, persistence, system preference
    │   └── main.js            Drawer, menus, tabs, dialogs, toasts, doc filter
    ├── img/
    │   ├── favicon.svg        Browser icon
    │   └── nexus-mark.svg     Standalone brand mark
    └── vendor/                (empty — no third-party assets in Stage 1)
```

Jinja2 `templates/` do not exist yet. They are part of Stage 2.

## Preview locally

No build step, package manager, or Node.js is required. Any static file server works:

```powershell
cd C:\Users\tejas\Documents\NEXUS\frontend
python -m http.server 8000
```

Then open:

- `http://localhost:8000/index.html` — dashboard
- `http://localhost:8000/styleguide.html` — component reference

Theme preview without changing the saved preference:

- `http://localhost:8000/index.html?theme=light`
- `http://localhost:8000/index.html?theme=dark`

The normal toggle button **does** save the choice in `localStorage`.

Opening `index.html` directly from the filesystem also works in most browsers, but a local server gives a more realistic result and avoids some file:// restrictions.

## Rules

- Follow `project-context/DESIGN_PRINCIPLES.md` and `docs/design/`.
- Follow `.github/instructions/frontend.instructions.md`.
- Never connect directly to MySQL.
- Never store secrets.
- Use semantic HTML, accessible forms, and keyboard-friendly navigation.
- Support light and dark themes through semantic tokens, not hardcoded colours.
- Bootstrap 5 and Chart.js are allowed in later stages only when they solve a concrete problem. Neither is used in Stage 1.

## What belongs here

- Jinja2 templates and partials (Stage 2).
- CSS design tokens and component styles.
- Vanilla JavaScript modules.
- Static chart markup (inline SVG/CSS) and later Chart.js configuration.
- Icons and images.

## What does not belong here

- Flask routes or business logic.
- SQL.
- Database credentials.
- Real student data.

## Stage 1 limitations

- All figures, names, and activity entries are demonstration data.
- Charts are static SVG/CSS, not data-driven.
- Forms, search, and destructive actions show a demo toast or dialog; they do not persist anything.
- No authentication, session, or role handling exists.
- “System status” explicitly reports that MySQL, Flask, and authentication are not connected.
- Automated axe/visual-regression tests are not configured yet.

## Next step

Stage 1 is awaiting user approval. After approval, Stage 2 converts this static shell into Flask/Jinja templates and builds the individual module pages.
