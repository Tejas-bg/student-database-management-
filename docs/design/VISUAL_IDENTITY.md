# NEXUS — Visual Identity

> **Stage 1 · UI/UX design system.** This document explains the visual idea behind NEXUS. The working implementation lives in `frontend/` and the live reference is `frontend/styleguide.html`.

---

## 1. What NEXUS is

**NEXUS** is a student information and academic management platform for a college.

- **Tagline:** “Education, connected.”
- **Personality:** calm, precise, technical, trustworthy, quietly premium.
- **Audience:** college staff (registrar, faculty, administration) and students.
- **Promise:** many academic records — students, faculty, departments, courses, attendance, assessments, fees, feedback, reports — in one coherent workspace.

The name suggests a connection point. The mark turns that idea into geometry: two dot-matrix columns connected by a diagonal bridge, like records linked across a system.

---

## 2. Design influences — and what we did not copy

NEXUS is inspired by two design philosophies:

| Influence | What we take | What we avoid |
|---|---|---|
| Apple-inspired product design | Generous whitespace, strong typography, simple navigation, restrained motion, premium surfaces | Apple logos, product layouts, SF fonts, trademarked assets |
| Nothing-inspired technical design | Monochrome discipline, dot-matrix motifs, mono labels, visible geometry, lime signal colour | Nothing logos, glyphs, packaging layouts, copied assets |

Everything in this identity — the mark, wordmark, palette usage, layout, and component styling — is original to this project.

---

## 3. The mark

The NEXUS mark is a geometric “N” built from dots.

- Two vertical columns of five dots form the sides of the letter.
- A descending diagonal of four dots bridges the columns.
- The dot grid reads as nodes in a network and as a dot-matrix display.
- The mark works at 16px (favicon) and at 128px (documentation).
- The default presentation is Signal Lime on Obsidian with a rounded square container.

### Files

| File | Purpose |
|---|---|
| `frontend/static/img/favicon.svg` | Browser favicon and small mark. |
| `frontend/static/img/nexus-mark.svg` | Larger standalone mark for documentation, slides, or reports. |
| Inline symbol in `index.html` / `styleguide.html` | The same geometry, drawn with `currentColor` so it inherits theme colours. |

### Clear space and minimum size

- Keep clear space equal to at least the width of one dot on every side.
- Do not place the mark on a busy photograph or pattern.
- Minimum size: 16px for the favicon, 24px for the inline mark.
- Do not rotate, outline, stretch, or recolour the mark outside the approved palette.

### Wordmark

The wordmark is **NEXUS**, set in Inter Semibold with wide tracking (`0.16em`). The tagline is set in JetBrains Mono, lowercase: `education, connected.`

### Lockup

The standard lockup is:

1. Rounded square mark.
2. Wordmark.
3. Tagline underneath in mono.

The stacked mark-only lockup is used where horizontal space is limited.

---

## 4. Colour

### Core palette

| Token | Name | Hex | Role |
|---|---|---|---|
| `--nx-obsidian` | Obsidian | `#111111` | Primary ink, light-theme primary button, dark-theme page background |
| `--nx-paper` | Paper | `#F5F5F2` | Light-theme page background, dark-theme primary text |
| `--nx-white` | White | `#FFFFFF` | Light-theme surfaces |
| `--nx-silver` | Silver | `#BDBDBD` | Strong decorative borders, secondary chart series |
| `--nx-graphite` | Graphite | `#292929` | Dark-theme raised surfaces, primary button hover |
| `--nx-lime` | Signal Lime | `#D7FF35` | Accent: active navigation, focus halo, key indicators, dark-theme primary action |

### How Signal Lime is used

Signal Lime is deliberately rare. It appears as:

- the active navigation tint and indicator line,
- the dark-theme primary button,
- focus halos,
- small “active/preview” badges,
- the primary chart series in dark theme.

It is **not** used for large backgrounds, body text, or every icon. If a screen is mostly lime, the hierarchy is wrong.

### Semantic colours

| Role | Light | Dark | Use |
|---|---|---|---|
| Success | `#1F7A3D` on `#E8F5EC` | `#7EE2A8` on a 12% tint | Paid, active, present, completed |
| Warning | `#8A5A00` on `#FFF4D6` | `#FFD27A` on a 12% tint | Pending, review, near threshold |
| Danger | `#B42318` on `#FDECEA` | `#FF8A80` on a 12% tint | Overdue, destructive actions, errors |
| Info | `#245B8A` on `#EAF2FA` | `#8FC7F0` on a 12% tint | Neutral guidance, system notes |

Semantic colours are always paired with a word or icon so colour is never the only signal.

### Theme mood

- **Light:** Apple-inspired calm. Paper background, white surfaces, hairline borders, Obsidian text, lime only as a signal.
- **Dark:** Nothing-inspired technical. Obsidian background, Graphite surfaces, Silver secondary text, lime as the active signal and chart primary.

---

## 5. Typography

| Role | Font | Notes |
|---|---|---|
| Interface | **Inter** | 400, 500, 600, 700. Loaded from Google Fonts with system fallbacks. |
| Technical labels, IDs, codes, timestamps | **JetBrains Mono** | 400, 500, 600. Used at small sizes with tracking. |

### Hierarchy

| Level | Size | Weight | Use |
|---|---|---|---|
| Display | `clamp(2.25rem, 5vw, 3.5rem)` | 600 | Hero statements only |
| Page heading | `2.75rem` | 600 | One per page |
| Section heading | `1.5rem` | 600 | Major regions |
| Card heading | `0.875rem` | 600 | Cards and panels |
| Body | `1rem` / 1.6 | 400 | Reading text |
| Small body | `0.875rem` / 1.5 | 400 | Dense UI |
| Technical label | `0.625rem–0.6875rem` mono | 500 | Uppercase with tracking; short only |

### Rules

- Sentence case everywhere except short technical labels.
- Avoid all-uppercase sentences and excessive bold.
- Keep body text at a comfortable measure (roughly 60–72 characters).
- Use mono for identifiers such as `STU-2025-0412`, academic years, and status metadata.
- Numeric tables use tabular figures where possible.

---

## 6. Layout and shape

- **Sidebar:** 272px on desktop, grouped navigation (Overview, Academic, Records, Insights, System).
- **Header:** 72px, sticky, translucent with blur.
- **Content:** maximum 1280px, generous page padding (`clamp(20px, 3vw, 48px)`).
- **Grid:** 4-up stat cards, 1.35/1 split for primary content, 2-up halves, 3-up thirds.
- **Radii:** 6px small, 10px controls, 16px cards, 24px large surfaces, pill for badges.
- **Borders:** 1px hairlines; shadows only for menus, dialogs, and toasts.
- **Motion:** 120–300ms, standard easing; all motion reduced under `prefers-reduced-motion`.

---

## 7. Voice and microcopy

- Calm, direct, and specific.
- Prefer “Add student” over “Submit”.
- Explain limitations honestly: “Database not connected”, “Demo data”, “Not implemented in Stage 1”.
- Never imply that demo data is real.
- Errors say what happened and what to do next.

---

## 8. Identity checklist

- [x] Original mark and wordmark.
- [x] Tagline: “Education, connected.”
- [x] Approved palette only.
- [x] Inter + JetBrains Mono hierarchy.
- [x] Light and dark expression.
- [x] Dot-matrix motif used with restraint.
- [x] No copied logos, trademarks, or proprietary assets.
