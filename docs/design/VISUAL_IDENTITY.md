# GM University Management System — Visual Identity

> **Stage 1 · UI/UX design system.** This document explains the visual idea behind the GM University Management System. The working implementation lives in `frontend/`, the live reference is `frontend/styleguide.html`, and the login has its own specification in `GMU_LOGIN_DESIGN.md`.

---

## 1. What the GM University Management System is

The **GM University Management System** is a centralized student and academic management platform for **GM University, Davanagere, Karnataka**.

- **Tagline:** “Empowering Education Through Connected Technology”
- **Short display name:** GMU Management System
- **Personality:** calm, precise, technical, trustworthy, quietly premium.
- **Audience:** university staff (registrar, faculty, administration) and students.
- **Promise:** many academic records — students, faculty, departments, courses, attendance, assessments, fees, feedback, reports — in one coherent workspace.
- **Status:** an independent student project, not an official university service.

The identity is carried by the **official GM University logo**. The interface supplies the calm typography, spacing, and technical detail around it.

---

## 2. Design influences — and what we did not copy

The interface is inspired by two design philosophies, applied to a real institutional identity:

| Influence | What we take | What we avoid |
|---|---|---|
| Apple-inspired product design | Generous whitespace, strong typography, simple navigation, restrained motion, premium surfaces | Apple logos, product layouts, SF fonts, trademarked assets |
| Nothing-inspired technical design | Neutral discipline, dot-matrix motifs, mono labels, visible geometry | Nothing logos, glyphs, packaging layouts, copied assets |
| GM University identity | Official logo, university gold, maroon, and a serious academic tone | Invented logos, recoloured logos, implied official endorsement |

The layout, typography, component styling, and interaction design are original to this project. The university logo is used as supplied.

---

## 3. The official logo

The official GM University logo is the primary identity of the application. It shows the university emblem in gold on a maroon field.

- **Source page:** `https://www.gmu.ac.in/flag`
- **Image URL:** `https://www.gmu.ac.in/assets/imgs/logo.jpg`
- **Local file:** `frontend/static/img/branding/gmu-official-logo.jpg`
- **Format:** JPEG, 778 × 778 px, 60,862 bytes
- **SHA-256:** `CCEC422F7C519F16228CD527A81C9B54EB376B4620A032A8AB9879A2861B6959`
- **Sampled background:** `#5B1F1F`
- **Downloaded:** 12 November 2026

### Files

| File | Purpose |
|---|---|
| `frontend/static/img/branding/gmu-official-logo.jpg` | The only logo file. Used in the sidebar, the login page, the styleguide, and as the favicon. |

There is no derived mark. The old NEXUS SVG assets were removed, and nothing is clipped, rounded, or recoloured around the official logo.

### Usage rules

- Keep the original aspect ratio. The image is square; always set both `width` and `height` (or `aspect-ratio: 1`) and use `object-fit: contain`.
- Do not crop, stretch, rotate, recolour, outline, or redraw the logo.
- Do not place it on a busy photograph.
- Keep clear space equal to at least 10% of the logo width on every side.
- Minimum size: 32px in compact navigation, 56px in headers, 96px on the login page.
- Use `alt="Official GM University logo"` when the logo is meaningful, and `alt=""` when a visible text label already names the institution.
- The maroon panel behind the logo may be `#5B1F1F` (exact logo background) or `#5B2020` (interface maroon). Never place the logo on white and apply a filter.

### Wordmark

The interface wordmark is text, not part of the logo:

1. **GM UNIVERSITY** — Inter, semibold, tracked.
2. **Management System** — small mono or muted sans line underneath.

The full formal name is **GM University Management System**. Compact areas use **GMU Management System**.

---

## 4. Colour

### Core palette

| Token | Name | Hex | Role |
|---|---|---|---|
| `--nx-maroon` | University Maroon | `#5B2020` | Institutional structure, primary button, active marker |
| `--nx-maroon-deep` | Deep Maroon | `#421919` | Hover/pressed states, text on gold |
| `--nx-gold` | University Gold | `#E3B559` | Accent: focus halo, active highlight, dark-theme primary action |
| `--nx-ivory` | Warm Ivory | `#F8F6F0` | Light-theme page background |
| `--nx-white` | White | `#FFFFFF` | Light-theme surfaces and inputs |
| `--nx-graphite` | Graphite | `#242424` | Primary text, dark-theme raised surfaces |
| `--nx-muted` | Muted Grey | `#8A8580` | Secondary text, dividers, disabled states |

Obsidian `#111111`, Paper `#F8F6F0`, Silver `#BDBDBD`, and the neutral ramp remain available for dark-theme structure and secondary borders.

### How University Gold is used

Gold is deliberately rare. It appears as:

- the active navigation tint and indicator accent,
- the dark-theme primary button,
- focus halos,
- small “active/preview” badges,
- the primary chart series in dark theme,
- the accent rule and eyebrow marks on the login page.

It is **not** used for large backgrounds, body text, or every icon. If a screen is mostly gold, the hierarchy is wrong. Gold on ivory/white fails body-text contrast and must never carry essential text alone.

### Semantic colours

| Role | Light | Dark | Use |
|---|---|---|---|
| Success | `#1F7A3D` on `#E8F5EC` | `#7EE2A8` on a 12% tint | Paid, active, present, completed |
| Warning | `#8A5A00` on `#FFF4D6` | `#FFD27A` on a 12% tint | Pending, review, near threshold |
| Danger | `#B42318` on `#FDECEA` | `#FF8A80` on a 12% tint | Overdue, destructive actions, errors |
| Info | `#245B8A` on `#EAF2FA` | `#8FC7F0` on a 12% tint | Neutral guidance, system notes |

Semantic colours are always paired with a word or icon so colour is never the only signal.

### Theme mood

- **Light:** Apple-inspired calm. Warm ivory background, white surfaces, hairline borders, graphite text, maroon structure, gold as a signal.
- **Dark:** technical graphite. Obsidian background, graphite surfaces, silver secondary text, gold as the active signal and chart primary.

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
- Explain limitations honestly: “Database not connected”, “Design preview”, “Not implemented in Stage 1”.
- Never imply that demo data is real.
- Never imply that a preview login authenticated a user.
- Errors say what happened and what to do next.

---

## 8. Identity checklist

- [x] Official GM University logo, unmodified.
- [x] Tagline: “Empowering Education Through Connected Technology”.
- [x] Approved maroon and gold palette only.
- [x] Inter + JetBrains Mono hierarchy.
- [x] Light and dark expression.
- [x] Dot-matrix motif used with restraint.
- [x] No invented university logo and no implied endorsement.
