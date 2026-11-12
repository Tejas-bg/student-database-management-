# NEXUS — Coding Standards

> **Status:** Approved for Stage 0.
> **Rule:** These standards apply to all code written from Stage 1 onward.

---

## 1. General principles

- Prefer readable code over clever code.
- Keep functions small and focused on one job.
- Name things for what they mean, not how they are implemented.
- Avoid duplication; extract shared logic.
- Do not add a dependency without a clear reason.
- Leave the codebase cleaner than you found it.
- Comments explain *why*, not *what*. The code already says what it does.

---

## 2. File and folder naming

| Type | Convention | Example |
|---|---|---|
| Python modules | `snake_case.py` | `student_service.py` |
| Python packages | `snake_case/` with `__init__.py` | `repositories/` |
| Jinja templates | `snake_case.html` | `student_list.html` |
| CSS files | `kebab-case.css` | `tokens.css` |
| JavaScript files | `kebab-case.js` | `theme-toggle.js` |
| SQL files | `NNN_description.sql` | `001_create_departments.sql` |
| Markdown docs | `SCREAMING_SNAKE_CASE.md` in context/docs | `SECURITY_STANDARDS.md` |
| ADRs | `ADR-NNN-short-title.md` | `ADR-001-technology-stack.md` |

---

## 3. Python

### 3.1 Style

- Follow PEP 8.
- 4 spaces per indent. No tabs.
- Maximum line length: 100 characters.
- Two blank lines between top-level definitions.
- Imports grouped: standard library, third-party, local. Alphabetical within groups.
- Use `snake_case` for functions and variables, `PascalCase` for classes, `UPPER_SNAKE_CASE` for constants.

### 3.2 Functions

- One responsibility per function.
- Avoid long parameter lists; group related data into a dataclass or typed structure when it grows.
- Return early instead of nesting deeply.
- Do not mutate arguments unless the function name makes it obvious.

### 3.3 Types and documentation

- Use type hints for public functions where practical.
- Add a docstring to every public module, class, and function.
- Document raised exceptions.
- Keep docstrings short and accurate.

### 3.4 Error handling

- Catch specific exceptions, not bare `except:`.
- Never swallow an exception silently.
- Log the technical detail; return a safe message.
- Use custom exception classes for domain errors when it improves clarity.
- Always close database connections and cursors.

### 3.5 Flask

- Use the application factory.
- Use blueprints for feature groups.
- Keep routes thin.
- Put configuration in `config.py` and read it from environment variables.
- Do not put SQL in routes or templates.
- Use `url_for()` for links.

---

## 4. SQL

- Write keywords in uppercase: `SELECT`, `FROM`, `WHERE`, `JOIN`.
- One major clause per line.
- List columns explicitly. Avoid `SELECT *` in application code.
- Use parameter placeholders (`%s` for MySQL Connector/Python). Never concatenate values.
- Use table aliases that are short but meaningful.
- Qualify columns when more than one table is involved.
- Use `JOIN ... ON` instead of implicit joins in the `WHERE` clause.
- Prefer `EXISTS` or `IN` deliberately; understand the difference.
- Use `DECIMAL` for money.
- Use `LIMIT` for paginated queries.
- Add a comment above complex queries explaining the intent.

Example of the expected style:

```sql
SELECT
    s.student_id,
    s.full_name,
    d.department_name
FROM students AS s
JOIN departments AS d
    ON d.department_id = s.department_id
WHERE s.is_active = TRUE
ORDER BY s.full_name
LIMIT %s OFFSET %s;
```

---

## 5. HTML and Jinja2

- Use semantic elements.
- Use one `<h1>` per page.
- Keep templates free of business logic.
- Use `url_for()` for links and static assets.
- Keep autoescaping enabled.
- Put reusable fragments in `templates/partials/`.
- Indent consistently with 2 spaces.
- Every form includes a CSRF token when CSRF protection is enabled.

---

## 6. CSS

- Use CSS custom properties for colour, spacing, type, and radius.
- Follow the design tokens in `DESIGN_PRINCIPLES.md`.
- Use a mobile-first approach.
- Prefer classes over IDs for styling.
- Avoid `!important` except for documented overrides.
- Keep selectors shallow.
- Group related rules and add a short comment for non-obvious sections.
- Use `rem` for type and spacing, `px` for borders.

---

## 7. JavaScript

- Use `const` by default, `let` when reassignment is needed. No `var`.
- Use modules or IIFEs to avoid globals.
- Use `addEventListener`, not inline `onclick`.
- Use `fetch` for HTTP requests.
- Handle loading, success, and error states.
- Validate on the client for usability only; the server is authoritative.
- Keep DOM queries scoped.
- Do not use `innerHTML` with untrusted data.
- Respect `prefers-reduced-motion`.

---

## 8. Database code

- Every schema change is a numbered migration.
- Never edit an applied migration; add a new one.
- Do not create tables in Stage 0.
- Keep seed data clearly fake.
- Name constraints explicitly.
- Document every table and column in the data dictionary.
- Test migrations on a fresh database before declaring success.

---

## 9. Testing

- Test behaviour, not implementation details.
- One assertion focus per test where practical.
- Name tests so a failure explains itself.
- Use fake sample data.
- Tests must run against MySQL, not SQLite.
- Clean up test data.
- Do not commit tests that depend on a specific local machine state.

---

## 10. Git and commits

- Commit in small, logical units.
- Write commit messages in the imperative mood: `Add student list route`.
- Do not commit secrets, `.env`, virtual environments, or generated files.
- Review the diff before committing.
- Tag or note a checkpoint before risky changes.

---

## 11. Documentation

- Update the relevant context file after a meaningful change.
- Add a `CHANGELOG.md` entry for significant work.
- Keep examples runnable.
- Do not document features that do not exist.
- Use beginner-friendly language.

---

## 12. Definition of done for any code task

1. The code follows these standards.
2. It handles the happy path and realistic errors.
3. It has tests or a documented manual verification.
4. It does not expose secrets.
5. It uses parameterized SQL where relevant.
6. It updates the affected documentation.
7. It is reviewed for unnecessary complexity.
8. It is reported honestly, including what was not verified.
