---
name: frontend-development
description: Use when building or changing GM University Management System HTML, Jinja2 templates, CSS, JavaScript, Bootstrap 5 layouts, Chart.js charts, forms, tables, navigation, or theme behaviour. Do not use it for Flask business logic or SQL.
---

# GM University Management System Skill — Frontend Development

## Purpose

Build accessible, responsive, maintainable interfaces that follow the GM University Management System design system and talk to Flask over HTTP. The frontend never touches MySQL directly.

## When to use

- Creating or editing pages and partials.
- Styling components with the GM University Management System tokens.
- Adding client-side behaviour or charts.
- Building forms, tables, and navigation.
- Implementing the light/dark theme toggle.
- Fixing responsive or accessibility issues.

## Required project context

1. `project-context/DESIGN_PRINCIPLES.md`.
2. `project-context/SYSTEM_ARCHITECTURE.md` (Presentation Layer).
3. `project-context/CODING_STANDARDS.md` (HTML, CSS, JavaScript sections).
4. `project-context/MODULE_SPECIFICATIONS.md` for the screen's purpose.
5. `.github/instructions/frontend.instructions.md`.

## Workflow

1. **Confirm the stage.** Do not build application pages before Stage 2.
2. **Identify the data contract.** Know exactly what the Flask route will send and receive.
3. **Build semantic HTML first.** Structure before styling.
4. **Apply tokens and layout.** Use the design system, not ad-hoc values.
5. **Add behaviour.** Use vanilla JavaScript modules; handle loading, success, and error.
6. **Add accessibility.** Labels, focus, keyboard path, ARIA only where needed.
7. **Add responsiveness.** Test mobile, tablet, desktop.
8. **Add charts.** Chart.js only, with a text summary.
9. **Test in a browser.** Check console, network, themes, keyboard, zoom.
10. **Update documentation and the task board.**

## Rules and restrictions

- No direct database access from the browser.
- No secrets in HTML, CSS, or JavaScript.
- No jQuery.
- No new library without approval.
- No inline styles for layout.
- Keep Jinja2 autoescaping on.
- Do not use `innerHTML` with untrusted data.
- Do not hardcode URLs; use `url_for()`.
- Do not rely on client-side validation for security.

## Quality checklist

- [ ] Semantic HTML and one `<h1>` per page.
- [ ] Every form field has a label.
- [ ] All interactive elements are keyboard reachable with visible focus.
- [ ] Light and dark themes both work.
- [ ] Responsive at 360px, 768px, 1024px, and 1440px.
- [ ] Tables scroll or adapt on small screens.
- [ ] Charts have a text summary or data table.
- [ ] Loading, empty, error, and success states exist.
- [ ] No console errors.
- [ ] No secrets or database credentials.
- [ ] Only approved dependencies.
- [ ] Browser tested and results recorded.

## Expected deliverables

- Templates in `frontend/templates/`.
- Styles in `frontend/static/css/`.
- Scripts in `frontend/static/js/`.
- Reusable partials.
- Screenshots or a written browser-test record (real, not invented).
- Updated task board and changelog.

## Common mistakes to avoid

- Building a page before the design tokens exist.
- Copying Bootstrap markup without applying the GM University Management System design.
- Using a `<div>` for a button.
- Forgetting mobile layouts.
- Using a chart with no accessible alternative.
- Putting business logic in templates.
- Claiming a page works without opening it in a browser.
- Adding a JavaScript framework silently.
