# GM University Management System — Current Status

> **This file must reflect verified reality, not intentions.**
> **Last updated:** 2026-11-12 (Stage 2 application shell and 34 role dashboards implemented and browser-verified; awaiting review).
> **Update rule:** Change a status only after the work is implemented and verified.

---

## Status at a glance

- **Current Stage:** Stage 2 – Frontend Development
- **Project implementation status:** UI preview only — no backend or database
- **Frontend status:** Stage 2 shared shell and student/faculty/administration pages implemented and verified
- **Backend status:** Not Started
- **Database status:** Not Started (schema still PLANNING)
- **Testing status:** Scripted browser verification via the Chrome DevTools Protocol; no committed automated suite

---

## 1. Stage

| Field | Value |
|---|---|
| Current stage | **Stage 2 — Frontend Development** |
| Stage 2 deliverable state | Shared application shell and 34 role dashboards implemented and browser-verified; awaiting user review |
| Next stage | Stage 3 — MySQL Database Design and Implementation (not started) |
| Approval required | Yes — do not start Stage 3 without explicit user approval |

---

## 2. Implementation status

| Area | Status | Notes |
|---|---|---|
| Project implementation | **UI preview** | Static HTML/CSS/JS only. No application logic or persistence. |
| Frontend | **Stage 2 complete for review** | Stage 1 design system and login preview, plus the shared shell and 34 student/faculty/administration pages. |
| Backend | **Not Started** | No Flask app, routes, or API. |
| Database | **Not Started** | No MySQL tables created or executed. |
| Testing | **Scripted browser verification** | Chrome DevTools Protocol harness covered all 34 pages, interactions, accessibility, and four viewport widths; the harness is not committed. |
| Documentation | **Stage 2 docs current** | Stage 1 design docs plus `docs/design/GMU_DASHBOARD_DESIGN.md`, changelog, tasks, and this status. |

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
- Common login preview (`frontend/login.html`, `login.css`, `login.js`) for students, faculty, and administrators, with no role selector.
- Official GM University logo at `frontend/static/img/branding/gmu-official-logo.jpg` (unmodified).
- Maroon, gold, and ivory palette applied through the token and theme files.
- `docs/design/VISUAL_IDENTITY.md`, `GMU_BRAND_GUIDELINES.md`, `GMU_LOGIN_DESIGN.md`, `DESIGN_SYSTEM.md`, `UI_COMPONENTS.md`, `ACCESSIBILITY.md`.

### Added in Stage 2

- `frontend/static/js/app-shell.js` — shared role-aware shell, navigation, header, menus, breadcrumbs, demo notice, and footer.
- `frontend/static/js/dashboard.js` — frontend-only table/list filters, pagination, mark-read, inert demo forms, and `/` search shortcut.
- `frontend/static/css/dashboard.css` — dashboard grids, hero, filters, meters, and pagination.
- 10 student pages under `frontend/dashboard/student/`.
- 10 faculty pages under `frontend/dashboard/faculty/`.
- 14 administration pages under `frontend/dashboard/admin/`.
- `docs/design/GMU_DASHBOARD_DESIGN.md` — page map, page contract, shell architecture, interaction hooks, responsive rules, and verification evidence.
- Delegated theme-toggle handling in `theme.js`, so the header control injected by the shell works on every page.

---

## 5. What is not complete

- User review of Stage 2.
- Authentication pages beyond the existing login preview (error pages), and converting the login into a Jinja2 template.
- Flask backend, authentication, sessions, and role checks.
- MySQL schema, migrations, and seed data.
- Real data integration, forms that save, and report generation.
- A committed automated test suite (the browser harness used for Stage 2 lives outside the repository).
- Manual screen-reader pass.
- College report and viva material.

---

## 6. Verified facts

| Fact | How verified |
|---|---|
| Pages render in light and dark themes | Chrome DevTools Protocol; computed `body` colours and theme token values |
| Theme toggle persists the choice | Click test; `localStorage["gmu-theme"]` becomes `"light"`/`"dark"` |
| `?theme=light` / `?theme=dark` previews work | Navigated to both URLs |
| Four stat cards share one row at 1440px | Bounding boxes: identical `top`, four equal widths |
| No horizontal overflow at 320/375/390/768/800/1024/1440px | `documentElement.scrollWidth - clientWidth === 0` |
| Wide tables scroll inside their container | `contain: paint` on `.nx-table-wrap`; document width stayed 390px |
| Mobile drawer opens, locks scroll, traps focus, closes on Escape, returns focus | Scripted interaction checks with `inert`, `overflow`, and `document.activeElement` |
| Menus and dialogs manage focus correctly | Dedicated focus run: focus entered menu/dialog, Escape/close returned it to the trigger |
| Tabs switch panels and support arrow keys | Click and keyboard checks on `styleguide.html` |
| Styleguide filter hides non-matching sections | Filter test returned only the `buttons` block |
| Landmarks and control roles are exposed | Accessibility tree: banner, main, contentinfo, named navigations, search, switch, tablist, tabs, chart images |
| No console errors or uncaught exceptions | Runtime/Log event capture during dashboard, styleguide, and login verification runs |
| Text and control contrast meet targets | WCAG relative-luminance calculations; recorded in `docs/design/ACCESSIBILITY.md` |
| Common login has no role selector or role cards | DOM query returned zero `<select>`, role fields, or role cards on `login.html` |
| Login validates empty fields accessibly | Submit with both fields empty: error summary visible, both inputs `aria-invalid="true"`, focus moved to `#login-id` |
| Show/hide password works | Toggle changed `type` between `password` and `text`, updated `aria-pressed` and its label, and kept focus in the field |
| Login preview never authenticates | Submit showed `aria-busy="true"` and a loading label, then returned to the same page with a preview-only status; no success text and no stored credentials |
| Forgot-password dialog behaves correctly | Native dialog opened by name, closed with its button, and returned focus to the trigger |
| Login is responsive without horizontal overflow | Checked at 1440, 1024, 768, 390, and 320px; `scrollWidth - clientWidth` was 0 at every width |
| Login desktop composition fits a 1440x900 viewport | Shell and both panels measured 900px tall; `scrollHeight === innerHeight` |
| Reduced motion removes entrance animation | Emulated `prefers-reduced-motion: reduce`; brand and panel animation names reported `none` |
| Official logo loads unmodified | Login renders the 778x778 file at 96px (56px mobile), `object-fit: contain`, CSS filter `none`; dashboard and styleguide load the same asset at 40px |
| Rebrand removed old visible branding | Dashboard, styleguide, and login body text contain no `NEXUS` or `lime` strings; titles use the GMU name |
| Desktop login keeps the brand panel stationary | At 1920x1080 and 1366x768, brand `top` stayed 0 while the sign-in panel scrolled; the window did not scroll |
| Sign-in panel scrolls independently | At 1366x768, panel `scrollTop` went 0→121 by wheel, Page Down, and End; Home and Page Up returned it to 0; only one scrollable element existed |
| Login page scrolls naturally on mobile | At 768x1024 and 375x812, the document scrolled by 297px and 556px, panel `scrollTop` stayed 0, and the brand panel moved with the page |
| Login has no horizontal or nested scrollbars | `scrollWidth === clientWidth` at 1920, 1366, 768, and 375px; real-scrollbar run also reported no horizontal overflow |
| No backend, database, or auth is active | No such files or dependencies exist; the UI reports this in the system-status card and login notice |
| All 34 dashboard pages load the shared shell | Scripted run at 1366×768: sidebar, header, footer, breadcrumb, skip link, and demo notice present; exactly one active nav item; role attribute matched its folder; zero console/JS errors |
| Table filters, search, and pagination work on sample rows | Chip filter kept only matching rows; no-match search showed the empty state; pagination showed 6 then 4 rows, disabled Next on the last page, and returned to page 1 |
| Header search filters the current page's tables | Entering a no-match query hid all rows and showed the empty state; clearing it restored the rows |
| Dialogs and demo forms never submit | Dialog opened by trigger, submitted with `requestSubmit()`, showed a preview-only toast, stayed on the page, and closed back to its trigger |
| Profile menu and logout behave correctly | Menu opened, closed on outside click; Sign out points to `../../login.html` |
| Notifications mark read | Header menu opened with 3 unread, mark-all-read cleared them; page-level mark-read removed the page's 3 unread dots, updated its summary to “0 unread”, and showed a toast |
| Sidebar collapse persists | Control visible and functional at 1366px; `.is-sidebar-collapsed` and `localStorage["gmu-sidebar-collapsed"]="1"` survived a reload |
| Theme toggle works on the injected header control | Delegated handler switched `data-theme`, stored `gmu-theme`, and restored the original theme on a second click |
| Tabs switch panels accessibly | Faculty semester-marks tabs hid the inactive panel and set `aria-selected="true"` on the active tab |
| List filters combine and reset | Feedback status and category chips filtered items, produced the empty state for an impossible combination, and restored all items on reset |
| Responsive layouts have no horizontal overflow | 10 representative pages at 1920×1080, 1366×768, 768×1024, and 375×812: zero out-of-viewport elements and zero document overflow |
| Dashboard grids collapse as designed | Stat grids 4-up at 1920, 2-up at 768, 1-up at 375; report template row 3/2/1 at the same widths |
| Mobile navigation works | At 375px the drawer toggle is visible, the collapse control is hidden, the drawer opens with an overlay, and Escape closes it |
| Mobile tables scroll inside their wrapper | Table wrapper scrolled horizontally while the document width stayed at the viewport width |
| Dashboard controls and fields are named | Accessibility audit of 34 pages: no unnamed buttons/links, no unlabelled fields, no image without `alt`, no missing sprite symbol |
| Keyboard entry points work | Skip link is first focusable and targets `#main-content`; `/` focuses header search; sidebar collapse is focusable; notification menu closes on Escape |
| Dashboard pages make no data requests | No `fetch`, `XMLHttpRequest`, `WebSocket`, or form submission exists in the dashboard JavaScript; demo forms call `preventDefault()` |
| Dashboard markup and links are internally consistent | Static validation of 34 pages: balanced tags, no duplicate IDs, page contract present, all local assets and links resolve |

Anything not in this table is unverified.

---

## 7. Known risks and open questions

| Item | Status |
|---|---|
| Final schema and cardinalities | Open — Stage 3 |
| Exact role model | Open — Stage 4 |
| Manual screen-reader review | Open — before submission |
| Automated accessibility testing | Open — the Stage 2 audit was scripted but the harness is not committed |
| Chart library choice for dynamic data | Deferred — Stage 2 uses CSS/SVG charts; Chart.js remains an option for Stage 5 |
| Header unread count vs page notifications | Open — the header menu and page list are separate sample sets; marking page items read does not change the header badge |
| College submission format | Open — confirm with the student |
| Local MySQL version | Open - confirm before Stage 3 |
| ADR-005 database access strategy | Proposed - awaiting approval |
| Manual screen-reader pass for the login page and dashboards | Open - before submission |
| Stage 2 commit | Open — git was unavailable in the working environment; Stage 2 files are not yet committed |

---

## 8. Change log for this file

| Date | Change |
|---|---|
| 2026-11-12 | Initial status after Stage 0 workspace setup. |
| 2026-11-12 | Updated after Stage 1 design-system implementation and browser verification; Stage 1 marked In Review. |
| 2026-11-12 | Rebranded to GM University Management System, added the official logo, common login preview, and login verification evidence. |
| 2026-11-12 | Updated after Stage 2: shared shell, 34 role dashboards, interaction tests, responsive/accessibility audits, and current limitations. |
