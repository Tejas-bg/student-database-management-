---
name: flask-backend
description: Use when building or changing the NEXUS Flask application, routes, services, repositories, validation, authentication, authorization, configuration, error handling, or MySQL connection code. Do not use it for pure UI design or standalone SQL scripts.
---

# NEXUS Skill — Flask Backend

## Purpose

Build a small, readable, layered Flask application that connects safely to MySQL 8+ and enforces the project's security rules.

## When to use

- Creating the application factory or configuration.
- Adding routes, blueprints, services, or repositories.
- Implementing login, logout, sessions, or roles.
- Connecting to MySQL with MySQL Connector/Python.
- Handling transactions and errors.
- Writing backend tests.

## Required project context

1. `project-context/SYSTEM_ARCHITECTURE.md`.
2. `project-context/SECURITY_STANDARDS.md`.
3. `project-context/CODING_STANDARDS.md` (Python and SQL sections).
4. `project-context/TECHNOLOGY_STACK.md`.
5. `.github/instructions/backend.instructions.md`.

## Workflow

1. **Confirm the stage.** Backend work starts in Stage 4.
2. **Define the layer.** Decide whether the change belongs in a route, service, repository, or validator.
3. **Define the contract.** Inputs, outputs, status codes, and error cases.
4. **Validate input server-side.** Reject unexpected or unsafe values.
5. **Write the data access.** Parameterized SQL only, with connection cleanup.
6. **Write the business logic.** Keep it independent of HTTP where possible.
7. **Write the route.** Thin: parse → validate → call service → respond.
8. **Handle errors.** Safe messages for users, technical detail in logs.
9. **Test.** Happy path, validation errors, authorization, database failure.
10. **Verify against MySQL.** Do not claim a connection works until it does.
11. **Update documentation and the task board.**

## Rules and restrictions

- Flask and MySQL Connector/Python only.
- No secrets in code; configuration comes from `.env`.
- No raw SQL in routes or templates.
- No string-built SQL.
- No bare `except:`.
- Always close connections and cursors.
- Use transactions for multi-step writes.
- Do not expose stack traces or SQL errors.
- Do not swap the framework, driver, or database.
- Do not add a dependency without approval.

## Quality checklist

- [ ] Application factory and blueprints used.
- [ ] Configuration read from environment variables.
- [ ] Routes are thin and services hold business rules.
- [ ] All SQL is parameterized and lives in repositories.
- [ ] Connections and cursors are closed on every path.
- [ ] Multi-step writes use `COMMIT`/`ROLLBACK`.
- [ ] Input is validated server-side.
- [ ] Errors are safe for users and logged for developers.
- [ ] Authentication and role checks are enforced server-side.
- [ ] Tests cover success, failure, and permission paths.
- [ ] The app was actually started and the route was hit.
- [ ] Results are reported honestly.

## Expected deliverables

- `backend/app/__init__.py` (application factory).
- `backend/config.py`.
- Routes, services, repositories, and validators.
- Authentication and authorization code.
- Tests.
- Updated documentation and changelog.

## Common mistakes to avoid

- Putting SQL in a route.
- Building SQL with f-strings.
- Hardcoding a database password.
- Forgetting to close a cursor.
- Catching every exception and hiding it.
- Returning a `500` for a validation error.
- Trusting a hidden form field.
- Claiming the database works without running the app.
- Adding an ORM because it feels faster.
