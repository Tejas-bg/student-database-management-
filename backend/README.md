# Backend

> **Status: Not Started.** No Flask application exists yet.

This folder will hold the application layer: the Flask app, routes, services, repositories, validation, and authentication.

## Planned structure

```
backend/
├── app/
│   ├── __init__.py          # application factory
│   ├── routes/              # blueprints
│   ├── services/            # business logic
│   ├── repositories/        # parameterized SQL and data access
│   ├── models/              # plain data structures
│   ├── validators/          # input validation
│   └── auth/                # authentication and authorization
├── config.py                # configuration from environment variables
├── requirements.txt         # pinned dependencies
└── wsgi.py                  # entry point (when needed)
```

This is a recommended layout. It is created in Stage 4.

## Rules

- Follow `project-context/CODING_STANDARDS.md`.
- Follow `project-context/SECURITY_STANDARDS.md`.
- Follow `.github/instructions/backend.instructions.md`.
- Use Flask and MySQL Connector/Python only.
- Read configuration from `.env`.
- Use parameterized SQL in repositories.
- Keep routes thin.
- Close connections and cursors.
- Use transactions for multi-step writes.
- Do not expose stack traces to users.

## What belongs here

- Flask application code.
- Database access code.
- Authentication and authorization.
- Server-side validation.
- Backend tests (or tests in `../tests/`).

## What does not belong here

- HTML templates (they belong in `frontend/templates/`).
- Raw database dumps.
- Secrets.
- Real student data.

## Status

Ready for Stage 4. Do not create the app before the schema is approved.
