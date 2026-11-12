---
applyTo: "backend/**"
---

# NEXUS Backend Instructions

These rules apply to every file under `backend/`.

## Before writing backend code

1. Read `project-context/SYSTEM_ARCHITECTURE.md`.
2. Read `project-context/SECURITY_STANDARDS.md`.
3. Read `project-context/CODING_STANDARDS.md`.
4. Confirm the current stage in `project-context/CURRENT_STATUS.md`.

## Non-negotiable rules

- Use Flask and MySQL Connector/Python only. Do not swap frameworks or drivers.
- Configuration comes from environment variables via `.env`. Never hardcode secrets.
- Use an application factory (`create_app()`) and blueprints.
- Keep routes thin: parse → validate → call service → return response.
- Put SQL in a repository/data-access layer, not in routes or templates.
- Use parameterized queries (`%s` placeholders with MySQL Connector/Python).
- Use context managers or `try/finally` to close connections and cursors.
- Use transactions for multi-step writes; `COMMIT` on success, `ROLLBACK` on failure.
- Validate every input server-side. Return clear, safe error messages.
- Do not expose stack traces or raw SQL errors to users.
- Return the correct HTTP status codes.
- Log server-side errors without logging secrets.
- Write tests for new routes and services.

## Verification

- Start the app and hit the route.
- Confirm the response and status code.
- Confirm the database state changed as expected.
- Run the test suite.
- Report what was verified.
