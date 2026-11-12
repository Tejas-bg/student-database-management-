---
applyTo: "frontend/**"
---

# NEXUS Frontend Instructions

These rules apply to every file under `frontend/`.

## Before writing frontend code

1. Read `project-context/DESIGN_PRINCIPLES.md`.
2. Read `project-context/SYSTEM_ARCHITECTURE.md` (Presentation Layer).
3. Check `project-context/CURRENT_STATUS.md` to confirm the frontend stage is active.

## Non-negotiable rules

- Use semantic HTML5 elements (`header`, `nav`, `main`, `section`, `table`, `form`, `label`).
- Every form input must have an associated `<label>`.
- Use the NEXUS design tokens. Do not invent new colours or fonts.
- Support light and dark themes.
- Meet WCAG 2.1 AA: contrast, focus states, keyboard access, alt text.
- Do not connect directly to MySQL or hold database credentials.
- Do not use jQuery.
- Do not add a JavaScript or CSS library without approval; Bootstrap 5 and Chart.js are approved.
- Do not use inline styles for layout. Use the stylesheet and utility classes.
- Validate forms on the client for usability, but never rely on it for security.
- Chart.js charts must have an accessible text summary.

## File organisation

- `frontend/templates/` — Jinja2 templates served by Flask.
- `frontend/static/css/` — stylesheets.
- `frontend/static/js/` — JavaScript modules.
- `frontend/static/img/` — images and icons.
- `frontend/static/vendor/` — only if a dependency cannot be loaded from a CDN and the user approves.

## Verification

- Open the page in a browser.
- Test at mobile, tablet, and desktop widths.
- Test keyboard navigation.
- Test both themes.
- Check the browser console for errors.
- Report exactly what was tested.
