# GM University Management System — Design System

> **Stage 1 foundation, extended in Stage 2.** This document explains how the CSS and JavaScript are organised, what each file does, and how to extend the system without breaking the themes. Stage 2 added the shared application shell and the role dashboards described in `GMU_DASHBOARD_DESIGN.md`.

---

## 1. What “design system” means here

A design system is a small set of shared decisions:

- **Tokens** — named values for colour, type, spacing, radii, shadows, and motion.
- **Themes** — semantic mappings of those values for light and dark mode.
- **Components** — reusable HTML/CSS patterns built only from tokens.
- **Layout** — the app shell and responsive rules.
- **Documentation** — this folder plus the live `frontend/styleguide.html`.

The goal is simple: change a value once, and every screen updates consistently.

---

## 2. File map

```
frontend/
├── login.html                  Common sign-in preview
├── index.html                  Dashboard preview (demo data)
├── styleguide.html             Live component and token reference
├── dashboard/
│   ├── student/                Ten student pages
│   ├── faculty/                Ten faculty pages
│   └── admin/                  Fourteen administration pages
└── static/
    ├── css/
    │   ├── tokens.css          Primitive values: palette, type, space, radii, motion
    │   ├── themes.css          Light/dark semantic tokens
    │   ├── reset.css           Reset, base typography, focus, a11y utilities
    │   ├── layout.css          Shell, sidebar, header, grids, docs layout
    │   ├── components.css      Buttons, cards, forms, tables, dialogs, charts…
    │   ├── dashboard.css       Dashboard grids, hero, filters, pagination
    │   ├── login.css           Split-screen brand panel and sign-in form
    │   └── responsive.css      Breakpoints, mobile drawer, print styles
    ├── js/
    │   ├── theme-init.js       Blocking pre-paint theme selection
    │   ├── theme.js            Theme switch, localStorage, system preference
    │   ├── app-shell.js        Role configs, shared shell, sidebar, header, menus
    │   ├── main.js             Drawer, menus, tabs, dialogs, toasts, filter
    │   ├── dashboard.js        Table/list filters, pagination, mark-read
    │   └── login.js            Password toggle, validation, preview loading state
    └── img/
        └── branding/
            └── gmu-official-logo.jpg   Official GM University logo (unmodified)
```

### Load order (important)

`tokens.css` → `themes.css` → `reset.css` → `layout.css` → `components.css` → `dashboard.css` → `responsive.css`

CSS variables must be declared before the files that use them. Responsive rules load last so they can override layout and component defaults.

Dashboard pages load scripts in this order: `theme.js` → `app-shell.js` → `main.js` → `dashboard.js`. The shell must exist before the interaction layer looks for its menus, tables, and filters.

`login.html` is a standalone page. It loads `tokens.css` → `reset.css` → `login.css` only, so the dashboard shell styles never leak into the sign-in screen.

---

## 3. Token architecture

Tokens live on `:root` in `tokens.css`. They are **primitive** values and should not be used directly in components unless there is a clear reason.

```css
:root {
  --nx-maroon: #5b1f1f;
  --nx-gold: #e3b559;
  --nx-ivory: #f8f6f0;
  --nx-space-4: 16px;
  --nx-radius-lg: 16px;
  --nx-text-sm: 0.875rem;
}
```

`themes.css` maps primitives to **semantic** tokens:

```css
:root,
[data-theme="light"] {
  --nx-bg: var(--nx-ivory);
  --nx-surface: var(--nx-white);
  --nx-text: var(--nx-graphite);
  --nx-border-control: #767676;
}

[data-theme="dark"] {
  --nx-bg: var(--nx-obsidian);
  --nx-surface: var(--nx-neutral-800);
  --nx-text: var(--nx-ivory);
  --nx-border-control: #6a6a6a;
}
```

Components use semantic tokens only:

```css
.nx-card {
  background: var(--nx-surface);
  border: 1px solid var(--nx-border-subtle);
  border-radius: var(--nx-radius-lg);
  color: var(--nx-text);
}
```

### Token groups

| Group | Examples | Notes |
|---|---|---|
| Palette | `--nx-maroon`, `--nx-gold`, `--nx-ivory`, `--nx-obsidian` | Fixed brand values |
| Neutrals | `--nx-neutral-950` … `--nx-neutral-0` | Supporting steps |
| Text | `--nx-text`, `--nx-text-muted`, `--nx-text-subtle` | Three levels only |
| Surfaces | `--nx-bg`, `--nx-surface`, `--nx-surface-sunken`, `--nx-surface-hover` | Theme-aware |
| Borders | `--nx-border-subtle`, `--nx-border`, `--nx-border-strong`, `--nx-border-control` | Control borders meet 3:1 |
| Accent | `--nx-accent`, `--nx-accent-soft`, `--nx-indicator` | Gold and maroon roles |
| Status | `--nx-success`, `--nx-warning`, `--nx-danger`, `--nx-info` + soft variants | Always paired with text |
| Charts | `--nx-chart-primary`, `--nx-chart-secondary`, `--nx-chart-tertiary`, `--nx-chart-grid`, `--nx-chart-fill` | Theme-aware series |
| Focus | `--nx-focus`, `--nx-focus-halo` | Maroon in light, gold in dark |
| Type | `--nx-font-sans`, `--nx-font-mono`, `--nx-text-*`, `--nx-leading-*` | Two families, fixed scale |
| Space | `--nx-space-1` … `--nx-space-10` | 4px base |
| Radius | `--nx-radius-sm` … `--nx-radius-pill` | Consistent shape |
| Layout | `--nx-sidebar-width`, `--nx-header-height`, `--nx-content-max`, `--nx-page-pad` | Shell |
| Motion | `--nx-duration-*`, `--nx-ease-*` | Short and calm |
| Layers | `--nx-z-header` … `--nx-z-toast` | Predictable stacking |

**Rule:** if a value appears more than twice, it belongs in a token. Do not copy hex codes into components.

---

## 4. Themes

### How the theme is chosen

1. `theme-init.js` runs in `<head>` before the page paints.
2. It checks, in order:
   - `?theme=light` or `?theme=dark` in the URL (preview override, not saved),
   - `localStorage["gmu-theme"]`,
   - the operating system preference.
3. It sets `<html data-theme="…">` immediately, preventing a flash of the wrong theme.
4. `theme.js` handles the toggle buttons, saves the choice, updates the browser theme colour, and exposes `GMU.theme`.

### Preview without changing the saved preference

Open either page with:

```
index.html?theme=light
index.html?theme=dark
styleguide.html?theme=light
styleguide.html?theme=dark
```

A normal toggle click **does** save the choice.

### Adding a token

1. Add the primitive to `tokens.css` if it is a new raw value.
2. Add the semantic name to **both** light and dark blocks in `themes.css`.
3. Use the semantic name in the component.
4. Document it here or in `UI_COMPONENTS.md` if it is important.
5. Check contrast in both themes (see `ACCESSIBILITY.md`).

---

## 5. Typography system

- **Inter** for interface text.
- **JetBrains Mono** for IDs, codes, timestamps, technical labels, and chart labels.
- Fonts are loaded from Google Fonts with system fallbacks. If the network is unavailable, the fallbacks keep the layout readable.

Use the utility classes where possible:

| Class | Use |
|---|---|
| `.nx-mono` | Technical label / identifier |
| `.nx-eyebrow` | Small uppercase section marker with a line |
| `.nx-stat__label` | Compact mono label used above values |
| `.nx-hint` | Secondary help text |
| `.nx-text-muted` / `.nx-subtle` | Text levels |
| `.nx-truncate` | Single-line truncation |

Headings use the reset defaults: `h1` 2.75rem, `h2` 1.5rem, `h3` 1.125rem. Hero headings override with `clamp()`.

---

## 6. Spacing, radii, and elevation

- Spacing follows a 4px base: 4, 8, 12, 16, 24, 32, 48, 64, 96, 128.
- Component padding is usually `var(--nx-space-4)`; page gaps are `var(--nx-space-5)`.
- Radii: controls 10px, cards 16px, large surfaces 24px, badges pill.
- Elevation is intentionally limited:
  - `--nx-shadow-sm`: tiny control lift,
  - `--nx-shadow-md`: menus and toasts,
  - `--nx-shadow-lg`: dialogs and the mobile drawer.

Do not add decorative shadows to ordinary cards. Thin borders and spacing carry the hierarchy.

---

## 7. Layout system

### App shell

```
.nx-app
├── .nx-sidebar          fixed left navigation
├── .nx-overlay          mobile dim layer
└── .nx-shell
    ├── .nx-header       sticky top bar
    ├── .nx-main
    │   └── .nx-page     max-width content column
    └── .nx-footer
```

### Grid helpers

| Class | Desktop behaviour |
|---|---|
| `.nx-grid--stats` | 4 equal columns |
| `.nx-grid--split` | 1.35fr / 1fr |
| `.nx-grid--halves` | 2 equal columns |
| `.nx-grid--thirds` | 3 equal columns |
| `.dashboard-stat-grid` | 4 / 2 / 1 responsive statistic cards |
| `.dashboard-split` | 1.35fr / 1fr, stacks at 1120px |
| `.dashboard-grid-3` | 3 / 2 / 1 responsive card row |
| `.dashboard-filter-bar` | Search, chip filters, and action |
| `.nx-stack` | Vertical flex with 16px gap |
| `.nx-cluster` | Wrapping horizontal flex |

### Breakpoints

| Width | Change |
|---|---|
| ≤ 1280px | Stats become 2-up; thirds become 2-up |
| ≤ 1120px | Split and halves stack to one column |
| ≤ 1024px | Sidebar becomes an off-canvas drawer |
| ≤ 860px | Header title hides; thirds become 1-up; footer stacks |
| ≤ 640px | Phone spacing; quick actions 1-up; dialogs full-width buttons |
| ≤ 420px | Stats 1-up; header search hides |
| Print | Chrome/navigation hidden; cards avoid page breaks |

The layout is desktop-first with `max-width` queries. Mobile navigation is fully keyboard operable.

---

## 8. JavaScript responsibilities

| File | Responsibility | Must not do |
|---|---|---|
| `theme-init.js` | Choose and apply the initial theme before paint | Contain UI logic |
| `theme.js` | Toggle theme, persist choice, update labels and meta | Fetch data |
| `app-shell.js` | Inject the shared shell, role navigation, header, menus, breadcrumbs, notice, footer | Authenticate, fetch, or decide a real role |
| `main.js` | Drawer, menus, tabs, dialogs, toasts, doc filter | Pretend to save data |
| `dashboard.js` | Filter, search, paginate, mark read, inert demo forms | Fetch, store, or submit data |
| `login.js` | Password toggle, empty-field validation, preview loading state, reset dialog | Send, store, or authenticate credentials |

No framework, build step, or package manager is required. This is deliberate: it keeps the foundation readable for a beginner and avoids a toolchain before the backend exists.

### Public API

```js
GMU.theme.get();      // "light" | "dark"
GMU.theme.set("dark");
GMU.theme.toggle();
GMU.toast("Title", "Message", { duration: 4200 });
```

Custom event: `gmu:themechange` fires on `document` with `{ detail: { theme } }`.

---

## 9. Charts in Stages 1–2

Charts are hand-built with CSS and inline SVG:

- donut gauge using `conic-gradient`,
- bar charts using flex heights,
- meters using width percentages,
- sparkline using an SVG path.

No chart library is loaded in either stage. Every chart has a text summary, an `aria-label`, or a data-table alternative. Chart.js remains available for Stage 5 if live analytics need interaction; the layout tokens would not change.

---

## 10. How to add a component

1. Check whether the component already exists in `components.css`.
2. Use existing tokens; do not introduce raw colours.
3. Add a documented example to `styleguide.html`.
4. Add a short entry to `UI_COMPONENTS.md`.
5. Test:
   - keyboard focus and Escape behaviour,
   - light and dark themes,
   - desktop and 375px widths,
   - browser console for errors.

---

## 11. How to add a dashboard page (Stage 2)

1. Create the file under `frontend/dashboard/<role>/` and add its key to the role config in `app-shell.js` if it is a new destination.
2. Copy the page contract from an existing page: body `data-*` attributes, `[data-app-shell]`, `#main-content`, toast region, and script order.
3. Use `.nx-page`, `.nx-section`, and the dashboard grid helpers.
4. For a table, add `[data-table-section]`, `[data-demo-table]`, `[data-table-search]`, chips, pagination, and empty state.
5. For a list, add `[data-filter-list]` with `[data-list-item]` and matching chips.
6. Label every figure as sample or illustrative.
7. Verify: one active nav item, both themes, `/` search focus, filters, pagination, dialogs, console, and no horizontal overflow at 375px.

---

## 12. Dependencies

Stage 1–2 intentionally use only:

- HTML, CSS, and vanilla JavaScript,
- Google Fonts for Inter and JetBrains Mono,
- inline SVG icons.

Bootstrap 5 and Chart.js are part of the approved long-term stack but are **not loaded** yet. The custom token system already covers layout and components, and the CSS/SVG charts meet the sample-data needs. Add either library only when a concrete Stage 5 need appears, and record the decision.

---

## 13. Known limitations

- The font CDN requires a network connection; fallbacks are defined but visually different.
- Charts are static illustrations, not data-driven.
- The styleguide filter is a small convenience, not a search engine.
- Dashboard filters operate on static rows and reset on reload.
- No automated visual regression or axe run is configured yet.
- Borders on decorative cards are intentionally subtle; control borders use a stronger token to meet the 3:1 UI target.
