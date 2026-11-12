# NEXUS — Current Status

> **This file must reflect verified reality, not intentions.**
> **Last updated:** 2026-11-12 (Stage 1 design system implemented and verified; awaiting approval).
> **Update rule:** Change a status only after the work is implemented and verified.

---

## Status at a glance

- **Current Stage:** Stage 1 – UI/UX Design System and Visual Identity
- **Project implementation status:** UI preview only — no backend or database
- **Frontend status:** Stage 1 design system implemented; awaiting approval
- **Backend status:** Not Started
- **Database status:** Not Started (schema still PLANNING)
- **Testing status:** Manual browser verification done; no automated suite

---

## 1. Stage

| Field | Value |
|---|---|
| Current stage | **Stage 1 — UI/UX Design System and Visual Identity** |
| Stage 1 deliverable state | Design system, dashboard preview, themes, components, and documentation implemented and verified; awaiting user approval |
| Next stage | Stage 2 — Frontend Development (not started) |
| Approval required | Yes — do not start Stage 2 without explicit user approval |

---

## 2. Implementation status

| Area | Status | Notes |
|---|---|---|
| Project implementation | **UI preview** | Stage 1 static HTML/CSS/JS exists. No application logic or persistence. |
| Frontend | **Stage 1 complete for review** | `frontend/index.html`, `frontend/styleguide.html`, six CSS files, three JS files, two SVG assets. |
| Backend | **Not Started** | No Flask app, routes, or API. |
| Database | **Not Started** | No MySQL tables created or executed. |
| Testing | **Manual verification only** | Chrome DevTools Protocol checks; no automated test suite yet. |
| Documentation | **Stage 1 docs created** | Context docs plus `docs/design/` (visual identity, design system, components, accessibility). |

---

## 3. Database status

| Field | Value |
|---|---|
| Schema state | **PLANNING** |
| ER model | Draft outline only |
| Normalization review | Not performed |
| Tables created | None |
| Migrations | None |
| Seed data | None |
| Views / procedures / triggers | None |
| Connection from the UI | **None** — the dashboard states this explicitly |

The schema has not been reviewed or approved. Do not create tables yet.

---

## 4. What was created in Stage 1

- Primitive tokens (`tokens.css`) and light/dark semantic themes (`themes.css`).
- Reset and accessibility utilities (`reset.css`).
- App shell and layout (`layout.css`): sidebar, header, breadcrumbs, grids, footer.
- Component library (`components.css`): buttons, nav, cards, stat cards, search, forms, badges, menus, notifications, tabs, tables, dialogs, toasts, states, charts.
- Responsive rules and mobile drawer (`responsive.css`).
- Theme bootstrap, theme controller, and interaction layer (`theme-init.js`, `theme.js`, `main.js`).
- Dashboard preview (`frontend/index.html`) with demonstration data.
- Live design-system reference (`frontend/styleguide.html`).
- Original mark and favicon.
- `docs/design/VISUAL_IDENTITY.md`, `DESIGN_SYSTEM.md`, `UI_COMPONENTS.md`, `ACCESSIBILITY.md`.

---

## 5. What is not complete

- User approval of Stage 1.
- Stage 2 module pages and Jinja2 templates.
- Flask backend, authentication, sessions, and role checks.
- MySQL schema, migrations, and seed data.
- Real data integration, forms that save, and report generation.
- Automated tests (unit, integration, accessibility, visual regression).
- Manual screen-reader pass.
- College report and viva material.

---

## 6. Verified facts

| Fact | How verified |
|---|---|
| Pages render in light and dark themes | Chrome DevTools Protocol; computed `body` colours and theme token values |
| Theme toggle persists the choice | Click test; `localStorage["nexus-theme"]` becomes `"light"`/`"dark"` |
| `?theme=light` / `?theme=dark` previews work | Navigated to both URLs |
| Four stat cards share one row at 1440px | Bounding boxes: identical `top`, four equal widths |
| No horizontal overflow at 320/375/390/768/800/1024/1440px | `documentElement.scrollWidth - clientWidth === 0` |
| Wide tables scroll inside their container | `contain: paint` on `.nx-table-wrap`; document width stayed 390px |
| Mobile drawer opens, locks scroll, traps focus, closes on Escape, returns focus | Scripted interaction checks with `inert`, `overflow`, and `document.activeElement` |
| Menus and dialogs manage focus correctly | Dedicated focus run: focus entered menu/dialog, Escape/close returned it to the trigger |
| Tabs switch panels and support arrow keys | Click and keyboard checks on `styleguide.html` |
| Styleguide filter hides non-matching sections | Filter test returned only the `buttons` block |
| Landmarks and control roles are exposed | Accessibility tree: banner, main, contentinfo, named navigations, search, switch, tablist, tabs, chart images |
| No console errors or uncaught exceptions | Runtime/Log event capture during the verification run |
| Text and control contrast meet targets | WCAG relative-luminance calculations; recorded in `docs/design/ACCESSIBILITY.md` |
| No backend, database, or auth is active | No such files or dependencies exist; the UI reports this in the system-status card |

Anything not in this table is unverified.

---

## 7. Known risks and open questions

| Item | Status |
|---|---|
| Final schema and cardinalities | Open — Stage 3 |
| Exact role model | Open — Stage 4 |
| Manual screen-reader review | Open — before submission |
| Automated accessibility testing | Open — add in Stage 2 or 7 |
| Chart library choice for dynamic data | Open — Chart.js can be added in Stage 2 if needed |
| College submission format | Open — confirm with the student |
| Local MySQL version | Open — confirm before Stage 3 |
| Documentation inconsistencies (`.github` prompt paths, ADR-005 status) | Known — reported, not yet fixed |

---

## 8. Change log for this file

| Date | Change |
|---|---|
| 2026-11-12 | Initial status after Stage 0 workspace setup. |
| 2026-11-12 | Updated after Stage 1 design-system implementation and browser verification; Stage 1 marked In Review. |
