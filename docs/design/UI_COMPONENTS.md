# GM University Management System — UI Components

> **Stage 1 component reference.** Every pattern below is implemented in `frontend/static/css/components.css` and demonstrated live in `frontend/styleguide.html`. Classes use the `nx-` prefix to avoid collisions with future libraries.

---

## 1. Naming rules

- Prefix every custom class with `nx-`.
- Use BEM-like blocks and elements: `.nx-card`, `.nx-card__head`, `.nx-stat__value`.
- Use modifiers with a double dash: `.nx-btn--primary`, `.nx-badge--danger`.
- Use `is-*` only for runtime state set by JavaScript: `.is-open`, `.is-active`, `.is-visible`.
- Never style by element alone when a class is available.

---

## 2. Navigation item

```html
<a class="nx-nav-item" href="#" aria-current="page">
  <svg class="nx-icon" aria-hidden="true"><use href="#i-grid"/></svg>
  Dashboard
</a>
```

| State | Visual |
|---|---|
| Default | Muted text, transparent background |
| Hover | Surface hover background, full text colour |
| Active | Gold-tinted background, 3px maroon indicator, current text |
| Focus | Global focus ring + gold halo |

- Set `aria-current="page"` on exactly one item.
- Icons are decorative (`aria-hidden="true"`); the text is the label.
- Optional trailing `.nx-nav-item__badge` for short metadata.

---

## 3. Buttons

```html
<button class="nx-btn nx-btn--primary" type="button">Save</button>
<button class="nx-btn nx-btn--secondary" type="button">Cancel</button>
<button class="nx-btn nx-btn--ghost" type="button">More</button>
<button class="nx-btn nx-btn--danger" type="button">Delete</button>
<button class="nx-btn nx-btn--primary nx-btn--sm" type="button">Small</button>
<button class="nx-btn nx-btn--secondary nx-btn--icon" type="button" aria-label="Download">
  <svg class="nx-icon" aria-hidden="true"><use href="#i-download"/></svg>
</button>
```

| Variant | Use |
|---|---|
| `--primary` | The single main action in a region |
| `--secondary` | Supporting actions |
| `--ghost` | Quiet actions, header icons |
| `--danger` | Destructive actions only |
| `--sm` / `--lg` | Dense toolbars / prominent actions |
| `--icon` | Square icon-only button (always add `aria-label`) |

Sizes set a minimum height of 32px, 40px, or 48px. Disabled buttons set `disabled`; `.is-disabled` exists for links.

---

## 4. Statistic card

```html
<article class="nx-stat">
  <div class="nx-stat__top">
    <span class="nx-stat__label">Total students</span>
    <span class="nx-stat__icon" aria-hidden="true">…</span>
  </div>
  <p class="nx-stat__value">1,248 <small>demo</small></p>
  <p class="nx-stat__foot">
    <span class="nx-delta nx-delta--up">2.4%</span> vs last term
  </p>
</article>
```

- Keep labels short and use the mono label style.
- Always mark demonstration numbers as `demo`.
- Deltas include a direction icon and are not colour-only.
- Hover lifts the card by 2px; reduced-motion users see no movement.

---

## 5. Card and panel

```html
<section class="nx-card">
  <div class="nx-card__head">
    <div><h3>Attendance overview</h3><p>Demo sample</p></div>
    <span class="nx-badge">Preview</span>
  </div>
  <div class="nx-card__body">…</div>
  <div class="nx-card__foot">…</div>
</section>
```

- Use `.nx-card--flush` when a table or image should touch the edges.
- `.nx-card__body` is a vertical flex container with a 12px gap.
- Footnotes are separated by a hairline border, not a shadow.

---

## 6. Search bar

```html
<form role="search" data-demo-search>
  <label class="nx-search">
    <span class="nx-sr-only">Search students</span>
    <svg class="nx-icon" aria-hidden="true"><use href="#i-search"/></svg>
    <input type="search" placeholder="Search students…">
    <kbd aria-hidden="true">⌘K</kbd>
  </label>
</form>
```

- Wrap the field in a `<label>` or connect a visible `<label for>`.
- Use `type="search"`.
- The `kbd` hint is decorative and hidden from assistive technology.
- In Stage 1, submitting shows an honest demo toast; it does not search.

---

## 7. Forms

```html
<div class="nx-field">
  <label class="nx-label" for="name">Student name</label>
  <input class="nx-input" id="name" type="text">
  <span class="nx-hint">Use the name on the enrolment form.</span>
</div>
```

| Class | Notes |
|---|---|
| `.nx-field` | Vertical label + control + hint |
| `.nx-input`, `.nx-select`, `.nx-textarea` | 10px radius, stronger control border |
| `.nx-label` | Above the control, never a placeholder substitute |
| `.nx-hint` | Secondary guidance |
| `.nx-error` | Text + icon; pair with `aria-invalid="true"` and `aria-describedby` |
| `.nx-check` | Checkbox with label |
| `.nx-switch` | Custom switch; the real input remains focusable |
| `.nx-fieldset` | Grouped options with a `<legend>` |

Invalid state example:

```html
<input class="nx-input" id="email" type="email"
       aria-invalid="true" aria-describedby="email-error">
<span class="nx-error" id="email-error">Enter a valid email address.</span>
```

---

## 8. Badges, chips, and status

```html
<span class="nx-badge nx-badge--success">Paid</span>
<span class="nx-badge nx-badge--warning">Pending</span>
<span class="nx-badge nx-badge--danger">Overdue</span>
<span class="nx-badge nx-badge--accent">Accent</span>
<span class="nx-chip is-active">Computer Science</span>
<span class="nx-status nx-status--online">
  <span class="nx-status__dot" aria-hidden="true"></span>Connected
</span>
```

- Badge text is short and uppercase via CSS.
- Never rely on colour alone: include a word and, where useful, an icon.
- `.nx-delta` variants show direction with an arrow and a sign.

---

## 9. Tabs

```html
<div class="nx-tabs" role="tablist" aria-label="Student views" data-tabs="panel-root">
  <button class="nx-tab" role="tab" aria-selected="true"
          aria-controls="panel-a" data-tab="a" tabindex="0">Overview</button>
  <button class="nx-tab" role="tab" aria-selected="false"
          aria-controls="panel-b" data-tab="b" tabindex="-1">Records</button>
</div>
<div id="panel-root">
  <div role="tabpanel" id="panel-a" aria-labelledby="tab-a" data-tab-panel="a">…</div>
  <div role="tabpanel" id="panel-b" aria-labelledby="tab-b" data-tab-panel="b" hidden>…</div>
</div>
```

The JavaScript in `main.js` implements roving `tabindex` and arrow-key navigation. Give each tab an `id` and each panel an `aria-labelledby` that matches it.

---

## 10. Table

```html
<div class="nx-table-wrap">
  <table class="nx-table">
    <caption>Demonstration rows only.</caption>
    <thead>
      <tr><th scope="col">Student</th><th scope="col" class="nx-table__num">Attendance</th></tr>
    </thead>
    <tbody>
      <tr><td><strong>A. Sharma</strong></td><td class="nx-table__num">96%</td></tr>
    </tbody>
  </table>
</div>
```

- Use `scope="col"` or `scope="row"`.
- The wrapper scrolls horizontally on small screens.
- Use `.nx-table__num` for right-aligned numeric columns.
- Always caption the table; use `.nx-sr-only` if the caption should be hidden visually.
- Do not invent real student records. Label demonstration rows clearly.

---

## 11. Dropdown menu

```html
<div class="nx-dropdown">
  <button class="nx-btn nx-btn--secondary" type="button"
          data-menu-toggle aria-controls="menu-1" aria-expanded="false">
    Actions
  </button>
  <div class="nx-menu nx-menu--left" id="menu-1">
    <p class="nx-menu__label">Actions</p>
    <button class="nx-menu__item" type="button">Edit</button>
    <hr class="nx-menu__sep">
    <button class="nx-menu__item nx-menu__item--danger" type="button">Delete</button>
  </div>
</div>
```

- `data-menu-toggle` + `aria-controls` wire the behaviour.
- Arrow/Enter/Space work natively on buttons; Escape closes and returns focus.
- Use `.nx-menu--left` when the trigger is near the left edge.

---

## 12. Notifications

```html
<div class="nx-menu nx-notifications">
  <div class="nx-notification">
    <span class="nx-notification__icon" aria-hidden="true">…</span>
    <div class="nx-notification__body">
      <strong>Demo: timetable published</strong>
      <p>Sample Semester 5 timetable is ready.</p>
      <span class="nx-notification__time">Demo · 8 min ago</span>
    </div>
    <span class="nx-notification__unread" aria-label="Unread"></span>
  </div>
</div>
```

- Timestamps use mono and always include “Demo” in this stage.
- The bell trigger reports the unread count in its accessible name.
- “Mark all read” removes unread dots and the count badge, then shows a toast.

---

## 13. Dialogs

Native `<dialog>` powers both modal and confirmation patterns.

```html
<dialog class="nx-dialog" id="confirm" aria-labelledby="confirm-title">
  <div class="nx-dialog__head">
    <span class="nx-dialog__icon nx-dialog__icon--danger" aria-hidden="true">…</span>
    <div><h2 id="confirm-title">Delete this record?</h2><p>This cannot be undone.</p></div>
  </div>
  <div class="nx-dialog__body">…</div>
  <div class="nx-dialog__foot">
    <button class="nx-btn nx-btn--secondary" type="button" data-dialog-close>Cancel</button>
    <button class="nx-btn nx-btn--danger" type="button" data-dialog-close>Delete</button>
  </div>
</dialog>

<button class="nx-btn nx-btn--secondary" type="button" data-dialog-open="#confirm">Open</button>
```

- `data-dialog-open="#id"` opens with `showModal()`.
- `data-dialog-close` closes.
- Clicking the backdrop closes.
- Focus returns to the trigger on close.
- Destructive confirmations use the danger icon and danger button.
- A form dialog should use `<form method="dialog">` so submission closes the dialog.

---

## 14. Toasts

```html
<button type="button" data-toast="Title|Message">Show toast</button>
```

Programmatic:

```js
GMU.toast("Saved preview", "Nothing was written to a database.");
```

- The region is `aria-live="polite"`.
- Toasts auto-dismiss after 4.2 seconds and can be closed manually.
- Use for confirmations and demo feedback, not for critical errors that need a decision.

---

## 15. Empty state

```html
<div class="nx-empty">
  <span class="nx-empty__icon" aria-hidden="true">…</span>
  <strong>No students yet</strong>
  <p>Once a student is added, their record will appear here.</p>
  <button class="nx-btn nx-btn--secondary nx-btn--sm" type="button">Add student</button>
</div>
```

Explain what is missing and what the user can do next. Avoid a dead end.

---

## 16. Loading state

```html
<p class="nx-loading-row">
  <span class="nx-spinner" aria-hidden="true"></span>Loading records…
</p>

<div class="nx-skeleton-stack" aria-hidden="true">
  <div class="nx-skeleton nx-skeleton--title"></div>
  <div class="nx-skeleton"></div>
  <div class="nx-skeleton nx-skeleton--short"></div>
</div>
```

- Pair the spinner with text.
- Skeleton blocks are decorative; hide them from assistive technology and announce loading separately.
- Shimmer stops under reduced motion.

---

## 17. Charts

| Pattern | Class | Text alternative |
|---|---|---|
| Donut gauge | `.nx-donut` with `--value` | Numeric label in `.nx-donut__center` |
| Bar chart | `.nx-bars` / `.nx-bar` | `role="img"` + `aria-label`, values above bars |
| Meter | `.nx-meter` | Visible percentage text |
| Sparkline | `.nx-sparkline` | `aria-label` + written summary |

Charts are static in Stage 1. Do not attach fake “live” labels.

---

## 18. Component checklist

Before adding a component:

- [ ] Uses semantic theme tokens only.
- [ ] Has default, hover, focus, and disabled states where relevant.
- [ ] Works in light and dark themes.
- [ ] Works at 375px, 768px, and desktop widths.
- [ ] Has an accessible name and keyboard behaviour.
- [ ] Does not claim backend behaviour that does not exist.
- [ ] Demonstrated in `styleguide.html`.
