# NEXUS — Design Principles

> **Status:** Design reference for Stage 1. No frontend has been built yet.
> **Purpose:** Define the visual language so every screen feels like part of one product.

---

## 1. Design direction

NEXUS is a hybrid of two inspirations:

**Apple — the calm layer**

- Minimalism.
- Generous whitespace.
- Elegant typography.
- Refined, quiet interactions.
- Clean layouts with clear hierarchy.

**Nothing — the technical layer**

- Monochrome discipline.
- Dot-matrix and grid motifs used sparingly.
- Visible technical detail where it helps understanding.
- Geometric accents.
- An experimental but controlled identity.

The result should feel like a precise academic instrument: calm, legible, and quietly technical. It should not feel like a generic admin template.

---

## 2. Design principles

1. **Clarity over decoration.** Every element earns its place.
2. **Whitespace is structure.** Space groups information; it is not empty space to fill.
3. **Monochrome first, accent second.** Most of the interface is neutral. Signal Lime is a signal, not a theme.
4. **One primary action per view.** The user should never wonder what to do next.
5. **Calm motion.** Animation explains a change; it never delays the user.
6. **Accessible by default.** Contrast, focus, labels, and keyboard paths are part of the design, not an afterthought.
7. **Consistent tokens.** Colours, spacing, radius, and type come from one source.

---

## 3. Colour palette

### 3.1 Core tokens

| Token | Hex | Role |
|---|---|---|
| Obsidian | `#111111` | Primary text, dark surfaces, strong borders |
| Paper | `#F5F5F2` | Light background |
| White | `#FFFFFF` | Cards, elevated surfaces |
| Silver | `#BDBDBD` | Muted text, dividers, disabled states |
| Graphite | `#292929` | Secondary dark surface, dark cards |
| Signal Lime | `#D7FF35` | Accent, focus, active state, key data |

### 3.2 Semantic tokens

| Token | Light theme | Dark theme | Use |
|---|---|---|---|
| `--nx-bg` | Paper `#F5F5F2` | Obsidian `#111111` | Page background |
| `--nx-surface` | White `#FFFFFF` | Graphite `#292929` | Cards, panels |
| `--nx-text` | Obsidian `#111111` | Paper `#F5F5F2` | Primary text |
| `--nx-text-muted` | `#5C5C5C` | Silver `#BDBDBD` | Secondary text |
| `--nx-border` | `#DADADA` | `#3A3A3A` | Dividers, input borders |
| `--nx-accent` | Signal Lime `#D7FF35` | Signal Lime `#D7FF35` | Accent, focus ring |
| `--nx-accent-text` | Obsidian `#111111` | Obsidian `#111111` | Text on accent |
| `--nx-danger` | `#B42318` | `#FF8A80` | Errors, destructive actions |
| `--nx-success` | `#1F7A3D` | `#7EE2A8` | Success states |
| `--nx-warning` | `#8A5A00` | `#FFD27A` | Warnings |

`#5C5C5C` on `#F5F5F2` and `#BDBDBD` on `#111111` are chosen for readable contrast. Verify every pairing with a contrast checker during Stage 1.

### 3.3 Colour rules

- Do not use Signal Lime as a large background. It is for accents, focus rings, active indicators, and small highlights.
- Do not introduce new brand colours without approval.
- Never use colour alone to communicate status. Pair it with text or an icon.
- Error red is for errors, not decoration.

---

## 4. Typography

### 4.1 Families

| Role | Family | Fallback |
|---|---|---|
| Display / headings | A clean geometric or neo-grotesque sans-serif | `system-ui, -apple-system, "Segoe UI", sans-serif` |
| Body | The same family for cohesion | `system-ui, -apple-system, "Segoe UI", sans-serif` |
| Technical / code / data | A monospace family | `"SFMono-Regular", Consolas, "Liberation Mono", monospace` |

Use a maximum of two families: one sans-serif and one monospace. Do not load a font that harms performance or readability. If a specific open-source font is chosen in Stage 1, document it and its licence.

### 4.2 Scale

| Token | Size | Line height | Use |
|---|---|---|---|
| `--nx-text-xs` | 0.75rem / 12px | 1.4 | Labels, captions |
| `--nx-text-sm` | 0.875rem / 14px | 1.5 | Secondary text, table cells |
| `--nx-text-base` | 1rem / 16px | 1.6 | Body |
| `--nx-text-lg` | 1.125rem / 18px | 1.5 | Lead paragraphs |
| `--nx-text-xl` | 1.5rem / 24px | 1.3 | Section headings |
| `--nx-text-2xl` | 2rem / 32px | 1.2 | Page headings |
| `--nx-text-3xl` | 2.75rem / 44px | 1.1 | Hero / dashboard totals |

### 4.3 Type rules

- Body text is at least 16px.
- Line length is 60–75 characters for reading text.
- Headings use tighter line height than body text.
- Numbers in tables are tabular where the font supports it.
- Do not use all-caps for long text. Short labels may use uppercase with letter-spacing.
- Do not justify text.

---

## 5. Spacing and layout

### 5.1 Spacing scale

Use a 4px base unit:

| Token | Value |
|---|---|
| `--nx-space-1` | 4px |
| `--nx-space-2` | 8px |
| `--nx-space-3` | 12px |
| `--nx-space-4` | 16px |
| `--nx-space-5` | 24px |
| `--nx-space-6` | 32px |
| `--nx-space-7` | 48px |
| `--nx-space-8` | 64px |
| `--nx-space-9` | 96px |

### 5.2 Layout rules

- Page padding: 24px on mobile, 32–48px on desktop.
- Content max width: 1200–1280px for dashboards; 720px for reading text.
- Use a 12-column grid on desktop, collapsing to a single column on mobile.
- Group related items with spacing before adding borders.
- Cards use 16–24px internal padding.

### 5.3 Radius and elevation

| Token | Value | Use |
|---|---|---|
| `--nx-radius-sm` | 6px | Inputs, small buttons |
| `--nx-radius-md` | 10px | Cards, panels |
| `--nx-radius-lg` | 16px | Large surfaces |
| `--nx-radius-pill` | 999px | Pills, tags |

Shadows are subtle and sparse. Prefer a 1px border over a heavy shadow. Dark theme uses lighter borders instead of stronger shadows.

---

## 6. Icons

- Use one icon family consistently. Prefer a simple line set.
- Icons are 16px, 20px, or 24px. Do not mix sizes within a row.
- Every icon-only button needs an accessible name (`aria-label`).
- Do not use an icon when a short text label is clearer.
- Dot-matrix motifs may appear as decorative background texture, never as the only carrier of meaning.

---

## 7. Buttons

### 7.1 Variants

| Variant | Light theme | Dark theme | Use |
|---|---|---|---|
| Primary | Obsidian background, Paper text | Signal Lime background, Obsidian text | The one main action |
| Secondary | Transparent, 1px Obsidian border | Transparent, 1px Silver border | Supporting actions |
| Ghost | No border, text only | No border, text only | Low-emphasis actions |
| Danger | Error red background, White text | Error red background, White text | Destructive actions |

### 7.2 Rules

- One primary button per view.
- Button height: 40px default, 48px for primary form actions.
- Padding: 16–24px horizontal.
- Focus ring: 2px Signal Lime offset by 2px.
- Disabled buttons reduce opacity and block pointer events.
- Loading state shows a spinner and keeps the button width stable.
- Destructive actions require confirmation.

---

## 8. Forms

- Every input has a visible `<label>`.
- Placeholder text is a hint, not a label.
- Required fields are marked in text, not only with colour.
- Validation messages appear next to the field and are announced to screen readers.
- Error state: red border plus message; do not rely on colour alone.
- Inputs are at least 40px tall.
- Group related fields with a fieldset and legend.
- Use the correct input type (`email`, `date`, `number`, `password`).
- Never prefill sensitive values.
- Show password requirements before submission, not only after failure.

---

## 9. Tables

- Tables are for tabular data, not layout.
- Left-align text, right-align numbers, align dates consistently.
- Header row is sticky on long tables.
- Use zebra striping only if it improves readability; prefer spacing and dividers.
- Include a caption or heading that describes the table.
- Provide empty states ("No students found") and loading states.
- On small screens, allow horizontal scroll rather than squeezing columns.
- Row actions are clear text buttons or an accessible menu.
- Pagination controls show the current range and total.

---

## 10. Dashboard cards

- A card contains one idea: a metric, a chart, or a short list.
- Card anatomy: label, value, optional trend, optional action.
- Use large tabular numbers for the primary value.
- Use Signal Lime sparingly for the most important metric or an active state.
- Cards have a 1px border, a subtle radius, and generous padding.
- Do not nest cards inside cards.
- Charts sit inside a card with a title and a text summary.

---

## 11. Navigation

### 11.1 Structure

- Top bar for identity, global search, theme toggle, and account menu.
- Sidebar for primary sections on desktop.
- Bottom or collapsible navigation on mobile.
- Breadcrumbs for deep pages.

### 11.2 Rules

- The active section is clearly indicated with text weight and a Signal Lime marker.
- Navigation labels are plain nouns ("Students", "Attendance").
- Do not hide essential navigation behind a hamburger on desktop.
- Keyboard users can reach every link.
- The current page is announced with `aria-current="page"`.

---

## 12. Light and dark themes

- Both themes are first-class. Do not design only one and invert it later.
- Theme choice is stored in `localStorage` and respects `prefers-color-scheme` on first visit.
- Theme toggle has an accessible label and shows the current state.
- Images and charts must remain legible in both themes.
- Signal Lime stays the same in both themes; surrounding neutrals change.
- Avoid pure black `#000000` and pure white `#FFFFFF` for large reading surfaces in dark mode. Use Obsidian and Graphite.

---

## 13. Responsive layouts

| Breakpoint | Width | Behaviour |
|---|---|---|
| Mobile | < 640px | Single column, stacked cards, collapsible nav |
| Tablet | 640–1023px | Two columns where useful, sidebar collapses |
| Desktop | 1024–1439px | Sidebar visible, multi-column dashboards |
| Wide | ≥ 1440px | Max-width container, more whitespace |

- Design mobile-first, then enhance.
- Touch targets are at least 44×44px.
- Never rely on hover for essential information.
- Tables and charts must remain usable on small screens.

---

## 14. Accessibility

Target: **WCAG 2.1 AA**.

- Text contrast at least 4.5:1; large text at least 3:1.
- Every interactive element is keyboard reachable.
- Focus is always visible.
- Form fields have labels and error associations.
- Images have meaningful alt text or are marked decorative.
- Charts have a text summary or data table alternative.
- Motion respects `prefers-reduced-motion`.
- Page language is set in the HTML.
- Headings are in logical order.
- Error messages are announced to assistive technology.

---

## 15. Motion and animation

- Duration: 120–200ms for micro-interactions, up to 300ms for larger transitions.
- Easing: ease-out for entering, ease-in for leaving.
- Animate opacity and transform, not layout properties.
- Never animate essential content in a way that blocks reading.
- Respect `prefers-reduced-motion`.
- Loading indicators appear only after a short delay to avoid flicker.
- Dot-matrix or scanline effects are decorative, subtle, and optional.

---

## 16. Content and tone

- Use plain, direct language.
- Labels are short nouns or verbs.
- Error messages say what happened and what to do next.
- Empty states explain how to add the first record.
- Avoid jargon in the interface; keep technical vocabulary for documentation.
- Dates use a consistent format across the product.

---

## 17. Design deliverables for Stage 1

Stage 1 will produce:

- A token file with CSS custom properties.
- A type and spacing reference.
- Component specifications for buttons, forms, tables, cards, and navigation.
- Light and dark reference pages.
- Accessibility notes and contrast results.

No application pages are built in Stage 0.
