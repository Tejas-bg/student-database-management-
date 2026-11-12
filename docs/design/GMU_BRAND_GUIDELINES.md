# GM University — Brand Guidelines for the Management System

> **Status:** Stage 1 design reference.
> **Scope:** How the GM University identity is used inside this student project.
> **Related:** `VISUAL_IDENTITY.md`, `GMU_LOGIN_DESIGN.md`, `../project-context/DESIGN_PRINCIPLES.md`.

---

## 1. Important note on authority

This document records how a **student project** uses publicly available university branding. It is not an official GM University brand manual, and it does not grant permission to use the university's identity.

- The project must not claim to be an official GM University service.
- The login page and README both state that this is an independent student project.
- For any public or commercial deployment, written permission from GM University is required.
- If the university publishes official brand rules, those rules take priority over this document.

---

## 2. Official identity

| Field | Value |
|---|---|
| Institution | GM University, Davanagere, Karnataka |
| Full application name | GM University Management System |
| Short display name | GMU Management System |
| Tagline | Empowering Education Through Connected Technology |
| Description | A centralized university student and academic management web application |

### Naming rules

- Use **GM University Management System** in formal documentation, page titles, and legal/disclaimer text.
- Use **GMU Management System** only where space is tight, such as a sidebar label, breadcrumb, or tab title.
- Do not invent abbreviations such as “GMUMS” unless the university uses them.
- Do not shorten the institution name to “GM” in user-facing text.

---

## 3. Official logo

### Source and file

| Item | Value |
|---|---|
| Official branding page | `https://www.gmu.ac.in/flag` |
| Official image | `https://www.gmu.ac.in/assets/imgs/logo.jpg` |
| Local path | `frontend/static/img/branding/gmu-official-logo.jpg` |
| Format | JPEG |
| Dimensions | 778 × 778 px |
| Size | 60,862 bytes |
| SHA-256 | `CCEC422F7C519F16228CD527A81C9B54EB376B4620A032A8AB9879A2861B6959` |
| Downloaded | 12 November 2026 |
| Logo background | `#5B1F1F` |

The gold in the artwork is consistent with the university's published gold `#E3B559`. Do not sample, replace, or “correct” colours inside the image file.

### Mandatory rules

1. **Do not redraw the logo.** No SVG trace, no AI recreation, no “cleaned-up” version.
2. **Do not crop.** The full emblem must remain visible.
3. **Do not stretch or squash.** Always preserve the 1:1 aspect ratio.
4. **Do not recolour.** No grayscale, no duotone, no CSS filters, no invert in dark mode.
5. **Do not remove elements.** The ring, crest, and text inside the logo are part of it.
6. **Do not add effects.** No drop shadows, glows, bevels, outlines, or rotation.
7. **Do not place it on a busy photograph or pattern.**
8. **Do not imply endorsement.** Never write “official”, “authorised”, or “powered by GM University” unless the university has approved it.

### Clear space

Keep clear space of at least **10% of the logo width** on all sides. Nothing — text, border, another icon — enters that space.

### Minimum sizes

| Context | Minimum |
|---|---|
| Sidebar / header lockup | 32px |
| Login brand panel | 56px (96px preferred) |
| Documentation and slides | 96px |
| Favicon | The square file is used directly; 16–32px |

### Placement

- Preferred background: the logo's own maroon `#5B1F1F`, or the interface maroon `#5B2020`.
- On the warm ivory panel, place the logo inside a maroon square container. Do not apply a mask, clipping radius, or `overflow: hidden` that trims the image.
- Do not place the logo directly on white and then apply a colour filter to make it “fit”.

### Accessibility

- If a visible text label already names the university, mark the image decorative: `alt=""`.
- Otherwise use `alt="Official GM University logo"`.
- Always provide `width` and `height` attributes to prevent layout shift.

---

## 4. Colour palette

These are **interface** colours derived from the logo. They are not a claim about the university's complete official brand specification.

| Name | Hex | Token | Primary role |
|---|---|---|---|
| University Maroon | `#5B2020` | `--nx-maroon` | Brand panel, primary button, active marker |
| Deep Maroon | `#421919` | `--nx-maroon-deep` | Hover/pressed, text on gold |
| University Gold | `#E3B559` | `--nx-gold` | Accent, focus halo, dark-theme action |
| Warm Ivory | `#F8F6F0` | `--nx-ivory` | Light page background |
| White | `#FFFFFF` | `--nx-white` | Cards, inputs |
| Graphite | `#242424` | `--nx-graphite` | Primary text, dark surfaces |
| Muted Grey | `#8A8580` | `--nx-muted` | Secondary text, hints |
| Obsidian | `#111111` | `--nx-obsidian` | Dark page background |
| Silver | `#BDBDBD` | `--nx-silver` | Dark-theme borders, muted text |

### Contrast results (WCAG 2.1)

| Pair | Ratio | Verdict |
|---|---|---|
| `#242424` on `#F8F6F0` | 14.36:1 | AAA body text |
| `#5B1F1F` on `#F8F6F0` | 11.70:1 | AAA body text |
| `#FFFFFF` on `#5B1F1F` | 12.65:1 | AAA body text |
| `#421919` on `#E3B559` | 7.96:1 | AAA body text |
| `#E3B559` on `#5B1F1F` | 6.64:1 | AA body text |
| `#E3B559` on `#111111` | 9.91:1 | AAA body text |
| `#8A8580` on `#F8F6F0` | 3.38:1 | Large/decorative only |
| `#8A8580` on `#111111` | 5.17:1 | AA body text |

### Colour rules

- Gold is an accent, never a full-page background or long body text colour on ivory/white.
- Maroon carries institutional weight. Use it for primary actions and active structure.
- Status meaning always has a text label or icon; colour alone is not enough.
- Do not add new brand colours without an explicit decision recorded in docs.

---

## 5. Typography

| Role | Family | Weights | Fallback |
|---|---|---|---|
| Interface | Inter | 400, 500, 600, 700 | `system-ui, -apple-system, "Segoe UI", sans-serif` |
| Technical | JetBrains Mono | 400, 500, 600 | `"SFMono-Regular", Consolas, monospace` |

- Both are open-source fonts loaded from Google Fonts.
- Maximum two families.
- Body text is at least 16px; line height 1.5–1.6.
- Use mono only for IDs, codes, timestamps, and short uppercase labels.
- No all-caps sentences.

---

## 6. Imagery and motifs

- The official logo is the only institutional image. The official flag and mascot are **not** used in Stage 1; the logo alone is clearer and avoids clutter.
- The dot-matrix pattern is a subtle, decorative nod to the technical layer. It is allowed as a low-opacity background texture on maroon panels.
- Decorative patterns must be `aria-hidden="true"`, must not reduce text contrast, and must be removed under `prefers-reduced-motion` if animated.

---

## 7. Interface examples

### Sidebar lockup

A 40px maroon square containing the logo, followed by:

- **GM UNIVERSITY** (semibold, tracked)
- *Management System* (small, muted)

### Login brand panel

Full maroon panel, dotted texture, 96px logo, institution line, welcome heading, tagline, and an independence note. Details in `GMU_LOGIN_DESIGN.md`.

### Browser tab and favicon

- Title pattern: `Page · GMU Management System`.
- Favicon: the square logo file. Its own maroon background makes it legible at small sizes.

---

## 8. What to do if the official asset cannot be used

Do not substitute a fake logo, a different university's logo, or an AI-generated emblem.

Instead:

1. Stop and tell the project owner.
2. Ask them to supply the official image file.
3. Until then, use a plain text wordmark with no emblem.

---

## 9. Pre-publication checklist

- [ ] Logo is the unmodified official file.
- [ ] Aspect ratio is 1:1.
- [ ] Clear space is respected.
- [ ] No CSS filter, crop, or overlay on the logo.
- [ ] Full and short names are used correctly.
- [ ] The independence disclaimer is visible.
- [ ] Gold is used as an accent only.
- [ ] Contrast pairs pass WCAG AA.
- [ ] No “official” or endorsement claim appears anywhere.
