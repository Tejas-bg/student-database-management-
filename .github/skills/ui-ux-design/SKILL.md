---
name: ui-ux-design
description: Use when designing, reviewing, or documenting NEXUS screens, components, colour, typography, spacing, motion, themes, or accessibility. Do not use it for backend, database, or deployment work.
---

# NEXUS Skill — UI/UX Design

## Purpose

Keep every NEXUS screen inside one coherent visual language: a hybrid of Apple-style minimalism and Nothing-style monochrome technical detail. This skill turns `DESIGN_PRINCIPLES.md` into concrete design decisions and checks.

## When to use

- Designing a new page, component, or state.
- Reviewing a screen for visual consistency.
- Choosing type, spacing, colour, radius, or motion values.
- Checking light and dark theme behaviour.
- Checking WCAG 2.1 AA accessibility.
- Writing design documentation or design tokens.

## Required project context

1. `project-context/DESIGN_PRINCIPLES.md` — the source of truth.
2. `project-context/PROJECT_OVERVIEW.md` — who the users are.
3. `project-context/MODULE_SPECIFICATIONS.md` — what the screen must do.
4. `project-context/CURRENT_STATUS.md` — confirm the design stage is active.
5. `docs/decisions/ADR-004-frontend-design-philosophy.md`.

## Workflow

1. **Identify the user and the task.** Name the role and the one job the screen supports.
2. **Choose the layout.** Pick a grid and a content max width. Decide what is primary, secondary, and tertiary.
3. **Map to tokens.** Use existing colour, type, spacing, radius, and elevation tokens. Do not invent values.
4. **Design the states.** Cover loading, empty, success, error, disabled, and focus states.
5. **Design both themes.** Check light and dark at the same time.
6. **Check accessibility.** Contrast, labels, focus order, keyboard path, screen-reader text, reduced motion.
7. **Check responsiveness.** Mobile, tablet, desktop, wide.
8. **Document the decision.** Add to `docs/design/` if it is reusable.
9. **Review against the checklist.** Fix before handoff.

## Rules and restrictions

- Use only the approved palette. Signal Lime is an accent, not a large background.
- Do not add a new font without approval and a licence note.
- Do not use colour alone to communicate status.
- Do not hide essential navigation on desktop.
- Do not design only one theme and invert it later.
- Do not use decorative animation that blocks reading.
- Do not invent a component that the design system does not define without documenting it.

## Quality checklist

- [ ] The screen has one clear primary action.
- [ ] Colours come from the approved tokens.
- [ ] Signal Lime is used sparingly.
- [ ] Typography follows the scale and line-height rules.
- [ ] Spacing follows the 4px scale.
- [ ] Light and dark themes both work.
- [ ] Text contrast is at least 4.5:1; large text at least 3:1.
- [ ] Every input has a visible label.
- [ ] Focus is visible on every interactive element.
- [ ] The layout works at mobile, tablet, and desktop widths.
- [ ] Tables, charts, and empty states are designed.
- [ ] Motion respects `prefers-reduced-motion`.
- [ ] The design is documented if it introduces a new pattern.

## Expected deliverables

- A screen specification or annotated layout.
- Token usage notes.
- State coverage (loading, empty, error, success, disabled, focus).
- Theme notes.
- Accessibility notes and contrast results.
- Updates to `docs/design/` when a reusable pattern is introduced.

## Common mistakes to avoid

- Treating whitespace as empty space and filling it.
- Using Signal Lime for large surfaces or every button.
- Designing only the happy path.
- Forgetting keyboard focus.
- Using low-contrast grey text because it looks elegant.
- Adding a new font or icon set without approval.
- Copying a generic admin template instead of following the NEXUS language.
- Claiming contrast passes without measuring it.
