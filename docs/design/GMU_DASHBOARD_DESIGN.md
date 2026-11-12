# GM University Management System — Application Shell and Role Dashboards

> **Stage 2 · Frontend interface preview.** This document describes the shared shell, the student/faculty/administration workspaces, the page contract, and the interaction layer added in Stage 2.
>
> **Reality check:** every page is static HTML with invented sample data. There is no Flask server, MySQL connection, authentication, session, or persistence behind any screen. The existing login page is unchanged and still authenticates nobody.

---

## 1. What Stage 2 adds

Stage 1 produced the design system, the common login preview, and one demonstration dashboard. Stage 2 turns that foundation into a working **interface** for the three roles:

| Role | Workspace | Pages |
|---|---|---|
| Student | `frontend/dashboard/student/` | 10 |
| Faculty | `frontend/dashboard/faculty/` | 10 |
| Administrator | `frontend/dashboard/admin/` | 14 |

Every page shares one shell, one stylesheet set, and one interaction layer. Navigation between all pages works; nothing else is connected to a server.

---

## 2. Page map

### Student

| Page | File | Nav key |
|---|---|---|
| Dashboard overview | `index.html` | `index` |
| My profile | `profile.html` | `profile` |
| My courses | `courses.html` | `courses` |
| Attendance | `attendance.html` | `attendance` |
| Internal assessment marks | `assessments.html` | `assessments` |
| Semester results | `results.html` | `results` |
| Fee details | `fees.html` | `fees` |
| Timetable | `timetable.html` | `timetable` |
| Notifications | `notifications.html` | `notifications` |
| Feedback | `feedback.html` | `feedback` |

### Faculty

| Page | File | Nav key |
|---|---|---|
| Dashboard overview | `index.html` | `index` |
| Faculty profile | `profile.html` | `profile` |
| Assigned subjects | `subjects.html` | `subjects` |
| Student management | `students.html` | `students` |
| Attendance management | `attendance.html` | `attendance` |
| Internal marks entry | `marks-entry.html` | `marks-entry` |
| Semester marks | `semester-marks.html` | `semester-marks` |
| Class performance | `performance.html` | `performance` |
| Reports | `reports.html` | `reports` |
| Notifications | `notifications.html` | `notifications` |

### Administration

| Page | File | Nav key |
|---|---|---|
| Dashboard overview | `index.html` | `index` |
| Student management | `students.html` | `students` |
| Faculty management | `faculty.html` | `faculty` |
| Department management | `departments.html` | `departments` |
| Course management | `courses.html` | `courses` |
| Subject management | `subjects.html` | `subjects` |
| Semester management | `semesters.html` | `semesters` |
| Enrolment management | `enrolments.html` | `enrolments` |
| Attendance management | `attendance.html` | `attendance` |
| Marks management | `marks.html` | `marks` |
| Fee management | `fees.html` | `fees` |
| Feedback management | `feedback.html` | `feedback` |
| Reports and analytics | `reports.html` | `reports` |
| User and role management | `users.html` | `users` |

---

## 3. Page contract

Each dashboard page is a normal standalone HTML document. It supplies metadata on `<body>` and leaves an empty shell mount:

```html
<body data-role="student" data-page="attendance"
      data-title="Attendance" data-subtitle="Semester 5 · Sample data"
      data-breadcrumb="Attendance"
      data-search="Search sample attendance records…">

  <div class="nx-app" data-app-shell>
    <main class="nx-main" id="main-content">
      <div class="nx-page">
        <!-- page content -->
      </div>
    </main>
  </div>

  <div class="nx-toast-region" data-toast-region aria-live="polite" aria-atomic="false"></div>

  <script src="../../static/js/theme.js"></script>
  <script src="../../static/js/app-shell.js"></script>
  <script src="../../static/js/main.js"></script>
  <script src="../../static/js/dashboard.js"></script>
</body>
```

**Rules**

1. `data-role` must match the folder (`student`, `faculty`, `admin`).
2. `data-page` must match the active navigation key; the shell marks exactly one link `aria-current="page"`.
3. `data-title`, `data-subtitle`, `data-breadcrumb`, and `data-search` drive the header, document heading, and search placeholder.
4. `#main-content` is the skip-link target. Do not rename it.
5. Keep the toast region before the scripts.
6. Keep the script order: theme → shell → interactions → dashboard behaviour.
7. Asset paths are relative: CSS `../../static/css/…`, images `../../static/img/branding/gmu-official-logo.jpg`, login `../../login.html`.

---

## 4. Shared shell

`frontend/static/js/app-shell.js` runs once per page and injects:

- the inline SVG icon sprite,
- a skip link to `#main-content`,
- the sidebar with role-specific groups and links,
- the sticky header (mobile menu button, page title/subtitle, search, notifications, theme toggle, profile menu),
- breadcrumbs,
- a visible “sample data” notice,
- the footer,
- the mobile navigation overlay.

### Sidebar

| Role | Groups |
|---|---|
| Student | Overview · Academics · Engagement · Account |
| Faculty | Overview · Teaching · Engagement · Account |
| Admin | Overview · People · Academics · Operations · Engagement · Account |

The sidebar collapses on desktop only. The control is `[data-sidebar-collapse]`; the state is the `.is-sidebar-collapsed` class on `.nx-app` and is persisted in `localStorage["gmu-sidebar-collapsed"]` (`"1"` / `"0"`). Below 1025px the collapse control is hidden and the sidebar becomes an off-canvas drawer driven by `main.js`.

### Header and menus

- Search is a labelled form with `[data-dashboard-search]`; it filters the current page's tables.
- Notifications use `[aria-controls="notifications-menu"]` plus `[data-mark-all-read]`.
- The theme toggle uses `[data-theme-toggle]` and is delegated in `theme.js`, so controls injected by the shell still work.
- The profile menu contains a demo profile link, a preview-only preferences item, and **Sign out** — a real link to `../../login.html`.
- Menus close on outside click and Escape, and return focus to their trigger.

### Breadcrumbs, notice, footer

Breadcrumbs are generated from the body metadata. The demo notice states that the workspace is an interface preview with sample data. The footer repeats the project name and the “no backend connected” fact.

---

## 5. Dashboard page patterns

All pages use the existing `nx-` component system and the utilities added in `dashboard.css`.

| Pattern | Markup | Used for |
|---|---|---|
| Hero | `.dashboard-hero` | Page-level greeting and context |
| Stat row | `.dashboard-stat-grid` + `.nx-stat` | Four headline numbers |
| Split | `.dashboard-split`, `.dashboard-split--even` | Chart + side card, 1.35fr / 1fr |
| Thirds | `.dashboard-grid-3` | Report templates and short card rows |
| Form grid | `.dashboard-form-grid` + `.dashboard-span-2` | Dialog and inline forms |
| Filter bar | `.dashboard-filter-bar` | Search, chips, primary action |
| Chips | `.dashboard-chip-row` + `.nx-chip` | Sample table/list filters |
| Pagination | `.dashboard-pagination` | Page info and previous/next |
| Definition list | `.dashboard-def-list` | Key–value detail panels |
| Meter row | `.dashboard-meter-row` | Ranked percentages |
| Static charts | `.nx-bars`, `.nx-donut`, `.nx-meter` | Trends and distributions |
| Lists | `.nx-notification`, `.nx-activity` | Notifications and queues |

Charts remain CSS/SVG. Chart.js is **not loaded**; the CSS charts already meet the sample-data needs and keep the pages dependency-free.

---

## 6. Interaction layer

`frontend/static/js/dashboard.js` is frontend-only. It contains no `fetch`, `XMLHttpRequest`, `WebSocket`, or credential handling.

| Behaviour | Selectors |
|---|---|
| Table search | `[data-table-section]` + `[data-demo-table]` + `[data-table-search]` |
| Chip filters | `[data-filter="<row data key>"]` + `[data-value]` |
| Pagination | `[data-page-size]`, `[data-page-info]`, `[data-page-prev]`, `[data-page-next]` |
| Empty state | `[data-table-empty]`, `[data-list-empty]` |
| Header search sync | `[data-dashboard-search] input` |
| List filters | `[data-filter-list]`, `[data-list-filter]`, `[data-list-item]`, `data-status`, `data-category` |
| Page mark-read | `[data-mark-page-read]`, `[data-unread-dot]`, `[data-unread-summary]` |
| Demo forms | `[data-demo-form]`, `[data-demo-message]` |
| Toasts | `[data-toast]` (handled by `main.js`) |
| Shortcut | `/` focuses the header search when not typing in a field |

**Demo forms** call `preventDefault()` and show a “Preview only — nothing saved” style toast. They never submit, navigate, store, or claim success.

**Filtering is client-side over static rows.** The page-info text (`Showing 1–6 of 10 sample records`) is recalculated from the visible set, including the empty state.

---

## 7. Responsive behaviour

| Width | Layout |
|---|---|
| > 1280px | 4-up stats, 3-up thirds, full sidebar |
| ≤ 1280px | Stats 2-up, thirds 2-up |
| ≤ 1120px | Split grids stack to one column |
| ≤ 1024px | Sidebar becomes an off-canvas drawer; collapse control hidden |
| ≤ 860px | Header title hides; thirds 1-up |
| ≤ 640px | Phone spacing; dialogs use full-width buttons |
| ≤ 420px | Stats 1-up; header search hides |

Tables never widen the page. `.nx-table-wrap` scrolls horizontally inside its card while the document width stays at the viewport width.

---

## 8. Accessibility

- Skip link is the first focusable element and targets `#main-content`.
- Every icon-only control has an accessible name (`aria-label` or visible text).
- Form fields have associated labels; dialogs are native `<dialog>` elements opened by name and closed with focus return.
- Tabs use `role="tablist"`, `aria-selected`, and arrow/Home/End handling in `main.js`.
- The active navigation item uses `aria-current="page"`.
- The mobile drawer traps focus and closes on Escape.
- Charts expose text alternatives through `aria-label` or adjacent sample data.
- Status is always conveyed with text, not colour alone.
- Both themes use the semantic tokens from Stage 1; contrast is recorded in `docs/design/ACCESSIBILITY.md`.

---

## 9. Honest limitations

- Every number, name, date, and status is invented sample content. Pages say so in the demo notice, section subtitles, and callouts.
- No form saves anything, no filter queries a database, and no report is generated.
- Logout only returns to the existing login preview.
- The notification badge in the header and the notification list on a page are separate sample sets; marking page notifications read does not change the header count.
- There is no role enforcement in the browser. Directly opening a URL is always possible; enforcement belongs to the Flask backend in Stage 4.
- No automated test suite is committed. Verification used the Chrome DevTools Protocol harness described below.

---

## 10. Future Flask/MySQL mapping

The static pages are structured so Stage 4/5 can replace sample content without re-layout:

1. Flask renders the same shell and page markup through Jinja2 templates.
2. `data-*` hooks stay; table rows, list items, and statistics come from queries.
3. The backend supplies the role and removes the sample-data notice.
4. Forms post to routes with CSRF protection and server-side validation.
5. The browser never selects a role; the server reads it from the authenticated account.
6. Pagination and filters become server-side queries when data volume justifies it.

---

## 11. Verification evidence

Verified with headless Chrome over the DevTools Protocol on 12 November 2026:

- **34 dashboard pages** loaded with shell, header, sidebar, footer, breadcrumb, skip link, demo notice, one active nav item, and no console/JS errors.
- **376 assertions passed, 0 failed**, covering:
  - table chip filter, search, empty state, and pagination;
  - header search synchronisation;
  - dialog open/close and inert demo form toasts;
  - profile menu, outside-click close, and logout target;
  - notification menu and mark-all-read;
  - sidebar collapse, persistence, and reload;
  - theme toggle and stored preference;
  - tabs and keyboard behaviour;
  - list filters, combined filters, and empty state;
  - page-level mark-read;
  - responsive overflow checks at 1920×1080, 1366×768, 768×1024, and 375×812.
- **Accessibility audit:** 34 pages checked for unnamed controls, unlabelled fields, images without `alt`, and missing sprite symbols — zero problems.
- **Layout audit:** 10 representative pages × 4 widths — zero out-of-viewport elements and zero horizontal overflow.
- **Static validation:** 34 pages checked for tag balance, duplicate IDs, page contract, and local asset/link resolution — zero problems.

---

## 12. Files introduced in Stage 2

| File | Purpose |
|---|---|
| `frontend/static/js/app-shell.js` | Role configs, sprite, sidebar, header, menus, breadcrumbs, notice, footer |
| `frontend/static/js/dashboard.js` | Table/list filtering, pagination, mark-read, demo forms, `/` shortcut |
| `frontend/static/css/dashboard.css` | Dashboard grids, hero, filters, pagination, responsive thirds |
| `frontend/dashboard/student/*.html` | 10 student pages |
| `frontend/dashboard/faculty/*.html` | 10 faculty pages |
| `frontend/dashboard/admin/*.html` | 14 administration pages |

The login page, its CSS, and its JavaScript were **not** modified in Stage 2.
