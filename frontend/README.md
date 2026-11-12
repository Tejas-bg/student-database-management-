# Frontend

> **Status: Stage 2 complete for review (UI only).** The design system, login preview, shared shell, and 34 student/faculty/administration pages exist. No backend, authentication, database connection, or real student data is present.

This folder holds the presentation layer: the design system, the common login page, the component reference, and the Stage 2 role workspaces. Every dashboard page is static HTML with sample data. Jinja2 conversion is planned for Stage 4, when Flask serves the pages.

## Current structure

```
frontend/
├── login.html                 Common sign-in preview (students, faculty, admin)
├── index.html                 Stage 1 dashboard preview
├── styleguide.html            Live design-system and component reference
├── dashboard/
│   ├── student/               10 student pages
│   ├── faculty/               10 faculty pages
│   └── admin/                 14 administration pages
├── README.md                  This file
└── static/
    ├── css/
    │   ├── tokens.css         Primitive tokens: palette, type, space, radius, motion
    │   ├── themes.css         Light and dark semantic tokens
    │   ├── reset.css          Reset, base type, focus, a11y utilities
    │   ├── layout.css         App shell, sidebar, header, grids, docs layout
    │   ├── components.css     Buttons, cards, forms, tables, dialogs, charts
    │   ├── dashboard.css      Dashboard grids, hero, filters, pagination
    │   ├── login.css          Split-screen login layout and form states
    │   └── responsive.css     Breakpoints, mobile drawer, print
    ├── js/
    │   ├── theme-init.js      Blocking pre-paint theme selection
    │   ├── theme.js           Theme toggle, persistence, system preference
    │   ├── app-shell.js       Role configs, shared shell, sidebar, header, menus
    │   ├── main.js            Drawer, menus, tabs, dialogs, toasts, doc filter
    │   ├── dashboard.js       Table/list filters, pagination, mark-read
    │   └── login.js           Password toggle, validation, demo loading state
    ├── img/
    │   └── branding/
    │       └── gmu-official-logo.jpg   Official GM University logo (unmodified)
    └── vendor/                (empty — no third-party assets in Stages 1–2)
```

Jinja2 `templates/` do not exist yet. They are planned for Stage 4.

## Preview locally

No build step, package manager, or Node.js is required. Any static file server works:

```powershell
cd frontend
python -m http.server 8000
```

Then open:

- `http://localhost:8000/login.html` — common sign-in preview
- `http://localhost:8000/dashboard/student/` — student workspace
- `http://localhost:8000/dashboard/faculty/` — faculty workspace
- `http://localhost:8000/dashboard/admin/` — administration workspace
- `http://localhost:8000/index.html` — Stage 1 dashboard
- `http://localhost:8000/styleguide.html` — component reference

Theme preview without changing the saved preference:

- `http://localhost:8000/index.html?theme=light`
- `http://localhost:8000/index.html?theme=dark`

The normal toggle button **does** save the choice in `localStorage`.

Opening `index.html` directly from the filesystem also works in most browsers, but a local server gives a more realistic result and avoids some file:// restrictions.

## Login page behaviour

`login.html` and `login.js` demonstrate the planned experience only:

- One form for every role — no role selector.
- Empty-field validation with inline messages and an error summary.
- Show/hide password control with `aria-pressed`.
- A short loading animation, then a clear "preview only" message.
- A "forgot password" dialog that explains recovery is a future feature.

The page **never** sends, checks, or stores credentials, and never shows a successful sign-in it did not perform.

## Rules

- Follow `project-context/DESIGN_PRINCIPLES.md` and `docs/design/`.
- Follow `.github/instructions/frontend.instructions.md`.
- Never connect directly to MySQL.
- Never store secrets.
- Use semantic HTML, accessible forms, and keyboard-friendly navigation.
- Support light and dark themes through semantic tokens, not hardcoded colours.
- Use the official logo exactly as supplied: no crop, stretch, recolour, or redraw.
- Bootstrap 5 and Chart.js are allowed in later stages only when they solve a concrete problem. Neither is loaded in Stages 1–2.

## What belongs here

- Jinja2 templates and partials (Stage 4).
- CSS design tokens and component styles.
- Vanilla JavaScript modules.
- Static chart markup (inline SVG/CSS) and later Chart.js configuration.
- Icons and images.

## What does not belong here

- Flask routes or business logic.
- SQL.
- Database credentials.
- Real student data.
- Role selection or client-side authorization.

## Stage 1–2 limitations

- All figures, names, and activity entries are sample data.
- Charts are static SVG/CSS, not data-driven.
- Filters, pagination, and mark-read operate on the static markup and reset on reload.
- Forms show a preview toast; they do not submit or persist anything.
- No authentication, session, or role handling exists.
- The login page is a visual and interaction preview, not a working sign-in.
- "System status" explicitly reports that MySQL, Flask, and authentication are not connected.
- Automated axe/visual-regression tests are not configured yet.

## Next step

Stage 2 is awaiting user review. After approval, Stage 3 designs and implements the MySQL schema; Stage 4 converts the static shell into Flask/Jinja templates and connects it to the database.
