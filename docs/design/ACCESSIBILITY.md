# GM University Management System — Accessibility

> **Stage 1 · WCAG 2.1 AA target.** This document records what was implemented, how it was checked, the measured contrast results, and the limitations that remain.

---

## 1. Target

The GM University Management System aims for **WCAG 2.1 Level AA**:

- **1.4.3 Contrast (Minimum):** body text at least 4.5:1; large text at least 3:1.
- **1.4.11 Non-text Contrast:** UI component boundaries, states, and meaningful graphics at least 3:1.
- **2.1.1 Keyboard:** all interactive controls operable by keyboard.
- **2.4.3 Focus Order:** logical focus order.
- **2.4.7 Focus Visible:** a visible focus indicator.
- **2.5.5 Target Size:** practical target sizes (the design uses 32px minimum buttons, 40px default).
- **2.3.3 Animation from Interactions:** motion can be reduced.
- **1.4.1 Use of Color:** colour is never the only signal.

Stage 1 is a visual preview, so accessibility of *data operations* cannot be tested yet. Accessibility of the shell, components, and theme switching can be tested now.

---

## 2. What is implemented

### Structure and landmarks

- Skip link as the first focusable element.
- `<aside aria-label="Main navigation">`, `<header>`, `<main id="main-content">`, `<footer>`.
- Breadcrumb with `aria-current="page"`.
- One `h1` per page; sections use `h2` and `h3`.
- Inline SVG icons are hidden from assistive technology unless they carry meaning; meaningful charts use `role="img"` and `aria-label`.

### Keyboard support

| Interaction | Behaviour |
|---|---|
| Skip link | Moves focus to main content |
| Mobile drawer | Opens with the menu button; focus enters the drawer; Tab cycles inside; Escape closes; focus returns to the trigger |
| Dropdown menus | Open on click; focus moves to the first item; Escape closes and returns focus |
| Tabs | Left/Right arrows move; Home/End jump; roving `tabindex` |
| Dialogs | Native `<dialog>` focus trapping; Escape closes; backdrop click closes; focus returns to trigger |
| Toasts | Announced through `aria-live="polite"`; dismiss button is keyboard reachable |
| Theme toggle | A real button with `role="switch"` and `aria-checked` updated |

### Focus

- Global `:focus-visible` outline: 2px solid focus colour, 2px offset, plus a 4px halo.
- Light theme focus colour: University Maroon `#5B2020` on Warm Ivory `#F8F6F0` → **11.70:1**.
- Dark theme focus colour: University Gold `#E3B559` on Obsidian `#111111` → **9.91:1**.
- Inputs also change border colour and add a halo on focus.

### Colour independence

- Status badges contain words (`Paid`, `Pending`, `Overdue`).
- Deltas include a direction icon and a sign.
- Connectivity uses a dot **and** text (`Not connected`).
- Charts have visible values, a text summary, and a table alternative for the performance chart.
- Active navigation uses background tint, text colour, and a 3px indicator.

### Motion

- Durations are 120–300ms.
- `prefers-reduced-motion: reduce` shortens animation/transition durations to 0.01ms, stops skeleton shimmer, and disables smooth scrolling.
- Hover lifts are small and non-essential.

### Forms

- Visible labels above fields.
- Hints use helper text, not placeholder-only instructions.
- Error state uses colour + icon + text, `aria-invalid="true"`, and `aria-describedby`.
- Inputs keep a real `<input>` under custom switches.
- Required fields are not simulated in Stage 1; when added, use the `required` attribute and a text indicator.

### Tables

- Captions state that rows are demonstration data.
- Header cells use `scope="col"`.
- Numeric columns are right-aligned and visually distinct.
- The table wrapper scrolls horizontally instead of shrinking text.

---

## 3. Measured contrast

Ratios were computed with the WCAG relative-luminance formula:

```
L = 0.2126 R + 0.7152 G + 0.0722 B
ratio = (Lighter + 0.05) / (Darker + 0.05)
```

These values reflect the GM University palette after the rebrand. Re-run the check if a token changes.

### Light theme

| Pair | Colours | Ratio | Result |
|---|---|---|---|
| Body text on page | `#242424` on `#F8F6F0` | 14.36:1 | Pass AAA |
| Body text on surface | `#242424` on `#FFFFFF` | 15.52:1 | Pass AAA |
| Muted text on page | `#5C5C5C` on `#F8F6F0` | 6.19:1 | Pass AA |
| Muted text on surface | `#5C5C5C` on `#FFFFFF` | 6.69:1 | Pass AA |
| Subtle text on page | `#6E6E6E` on `#F8F6F0` | 4.72:1 | Pass AA |
| Active nav text | `#421919` on `#FBF3E3` | 13.74:1 | Pass AAA |
| Text on University Gold | `#421919` on `#E3B559` | 7.96:1 | Pass AAA |
| Success badge | `#1F7A3D` on `#E8F5EC` | 4.78:1 | Pass AA |
| Danger badge | `#B42318` on `#FDECEA` | 5.75:1 | Pass AA |
| Warning badge | `#8A5A00` on `#FFF4D6` | 5.41:1 | Pass AA |
| Info badge | `#245B8A` on `#EAF2FA` | 6.32:1 | Pass AA |
| Control border | `#767676` on `#FFFFFF` | 4.54:1 | Pass UI (3:1) |
| Focus outline | `#5B2020` on `#F8F6F0` | 11.62:1 | Pass UI |
| Logo panel text | `#F8F6F0` on `#5B1F1F` | 11.70:1 | Pass AAA |
| Logo panel accent | `#E3B559` on `#5B1F1F` | 6.64:1 | Pass AA |

### Dark theme

| Pair | Colours | Ratio | Result |
|---|---|---|---|
| Body text on page | `#F8F6F0` on `#111111` | 17.47:1 | Pass AAA |
| Muted text on page | `#BDBDBD` on `#111111` | 10.05:1 | Pass AA |
| Muted text on raised surface | `#BDBDBD` on `#1C1C1C` | 9.07:1 | Pass AA |
| Subtle text on page | `#9A9A9A` on `#111111` | 6.71:1 | Pass AA |
| Subtle text on raised surface | `#9A9A9A` on `#1C1C1C` | 6.06:1 | Pass AA |
| University Gold on page | `#E3B559` on `#111111` | 9.91:1 | Pass AAA |
| Text on University Gold | `#421919` on `#E3B559` | 7.96:1 | Pass AAA |
| Success badge | `#7EE2A8` on 12% tint over `#1C1C1C` | 8.23:1 | Pass AA |
| Danger badge | `#FF8A80` on 12% tint over `#1C1C1C` | 6.09:1 | Pass AA |
| Warning badge | `#FFD27A` on 12% tint over `#1C1C1C` | 8.95:1 | Pass AA |
| Info badge | `#8FC7F0` on 12% tint over `#1C1C1C` | 7.30:1 | Pass AA |
| Control border | `#6A6A6A` on `#1C1C1C` | 3.15:1 | Pass UI (3:1) |
| Focus outline | `#E3B559` on `#111111` | 9.91:1 | Pass UI |

### Deliberate exception

Decorative card and table hairlines (`--nx-border-subtle`, `--nx-border`) are below 3:1. They are not the only way to identify a control or state:

- Cards are also distinguished by spacing and surface colour.
- Tables use header background, weight, and alignment.
- Form controls use the stronger `--nx-border-control` token, which passes 3:1.
- Active states use text, background tint, and an indicator.

If a future component relies on a hairline border to identify a control, it must switch to `--nx-border-control` or another 3:1 boundary.

---

## 4. How to verify manually

### Keyboard

1. Open `frontend/index.html`.
2. Press `Tab` once: the skip link should appear.
3. Press `Enter`: focus moves to main content.
4. Tab through the header: search, notifications, theme toggle, profile.
5. Press `Enter` on the notification button: the menu opens and focus moves inside.
6. Press `Escape`: the menu closes and focus returns to the bell.
7. Open the page at 375px width, click the menu button, then use Tab and Escape.
8. Focus the theme toggle and press `Space`: the theme changes and the switch state updates.

### Login page keyboard

1. Open `frontend/login.html`.
2. Press `Tab` once: the skip link should appear; `Enter` moves focus to the sign-in form.
3. Submit with both fields empty: the error summary appears and focus moves to the first invalid field.
4. Tab to the show/hide password button and press `Enter`: the input type changes and `aria-pressed` updates.
5. Activate “Forgot password?”: the dialog opens, `Escape` closes it, and focus returns to the link.
6. Tab through the form in visual order with no keyboard trap.

### Theme and contrast

1. Add `?theme=dark` to the URL and reload.
2. Confirm text, borders, badges, charts, and focus rings remain readable.
3. Repeat with `?theme=light`.
4. Use browser DevTools → Elements → Computed to inspect token values.

### Reduced motion

1. Enable “Reduce motion” in the operating system.
2. Reload the page.
3. Hover cards and open a dialog: transitions should be effectively instant.
4. Skeleton shimmer should not animate.

### Screen reader smoke test (manual)

Not yet performed. Recommended next checks with NVDA (Windows) or VoiceOver:

- Landmarks are announced.
- The drawer is announced as navigation and focus stays inside.
- Tabs announce “tab, selected”.
- Dialogs announce their accessible name.
- Chart labels are read once, not as dozens of fragments.

---

## 5. Automated and browser checks

| Check | Status |
|---|---|
| Contrast calculations | Done (WCAG formula, values above) |
| Login layout, validation, password toggle, dialog focus, reduced motion, console | Done (Chrome DevTools Protocol; see `project-context/CURRENT_STATUS.md`) |
| CSS token audit for raw hex in components | Done (`components.css` uses semantic tokens) |
| Browser console errors | Checked during Stage 1 verification (see `project-context/CURRENT_STATUS.md`) |
| Responsive layout screenshots | Checked at desktop, tablet, and mobile widths |
| Automated axe scan | Not configured yet |
| Visual regression tests | Not configured yet |
| Screen reader pass | Not performed yet |

---

## 6. Known limitations

1. **No backend or auth**, so signed-in states, permissions, and error flows cannot be accessibility-tested yet.
2. **Fonts come from Google Fonts.** Offline use falls back to system fonts; metrics may shift slightly.
3. **Native `<dialog>` support** is assumed (current Chrome, Edge, Firefox, Safari). Very old browsers will not open dialogs.
4. **Charts are static.** Their text alternatives describe the visual, but future dynamic charts need a generated data table or accessible description.
5. **No automated accessibility test** is part of the workflow yet. Add axe or Playwright checks in Stage 2.
6. **The styleguide filter** hides blocks visually but does not announce a result count. It is a documentation convenience, not product UI.
7. **Decorative hairlines** intentionally sit below 3:1; see the exception note above.

---

## 7. Accessibility checklist

- [x] Skip link.
- [x] Landmarks and heading order.
- [x] Visible focus styles in both themes.
- [x] Keyboard-operable drawer, menus, tabs, dialogs, and toasts.
- [x] Focus return after menus and dialogs.
- [x] Text alternatives for charts.
- [x] Status conveyed with text, not colour alone.
- [x] Form labels, hints, and error text.
- [x] Reduced-motion support.
- [x] Contrast measured and recorded.
- [ ] Automated axe run.
- [ ] Manual screen-reader pass.
- [ ] Real data and permission flows tested.
