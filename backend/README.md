# Backend

> **Status: Running (Stage 4).** A Flask application is connected to the MySQL
> `gmu_management_system` schema and serving the live login system and role
> dashboards.

This folder holds the application layer: the Flask app, routes, services,
repositories, validation, and authentication.

## Structure

```
backend/
├── app/
│   ├── __init__.py          # application factory (create_app)
│   ├── db.py                # MySQL connection helpers
│   ├── errors.py            # safe 400/401/403/404/405/500 handlers
│   ├── auth/                # sessions, CSRF, role checks
│   ├── routes/              # blueprints (auth, dashboard, health, prototype)
│   ├── services/            # business logic
│   ├── repositories/        # parameterized SQL and data access
│   ├── models/              # plain data structures
│   └── validators/          # input validation
├── config.py                # configuration from environment variables
├── requirements.txt         # pinned dependencies
└── wsgi.py                  # entry point
```

## Running it

```powershell
# First time only
python -m venv .venv
.\.venv\Scripts\python.exe -m pip install -r backend\requirements.txt

# Copy the environment template and fill in local values
Copy-Item .env.example .env

# Start the server
cd backend
..\.venv\Scripts\python.exe wsgi.py
```

The site is then served at <http://127.0.0.1:5000>.

| Route | Purpose |
|---|---|
| `/` and `/dashboard` | Role dashboard for the signed-in account (live MySQL data) |
| `/login` | Common sign-in page for students, faculty, and administrators |
| `/logout` | Clears the session (`POST` only, CSRF protected) |
| `/health` | Reports the MySQL version and connected schema |
| `/prototype/…` | The original Stage 2 interface preview, mounted behind authentication |

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

## Verified behaviour

| Check | Result |
|---|---|
| MySQL connection from Flask | Connected to MySQL 8.4.9 on the configured port |
| `/health` | `{"status":"ok","database":"connected","version":"8.4.9",...}` |
| Login with a wrong password | `401`, one generic message that does not reveal whether the account exists |
| Login with an unknown identifier | `401`, the same generic message |
| Login with valid credentials | `302` to the role dashboard, session created, password never stored in the cookie |
| Role check on the preview | A student requesting `/prototype/dashboard/admin/` gets `403` |
| Logout | `POST` clears the session and redirects to `/login?signed_out=1` |
| Session cookie flags | `HttpOnly` and `SameSite=Lax`; `Secure` when HTTPS is enabled |
| CSRF on state changes | Every `POST` without a matching token returns `400` |
| Error pages | Consistent safe pages for 400/401/403/404/405/500; no tracebacks shown |
| Redirect safety | Only same-site relative `next` targets are accepted |

## Known limitations

- The running development server is for local demonstration only.
- Password reset is not implemented; the link opens an honest placeholder dialog.
- Sessions are stored server-side in the Flask cookie and expire after 30 idle minutes.
- Least-privilege database users (`gmu_app`, `gmu_admin`, `gmu_report`) exist in
  `database/demonstrations/005_dcl.sql` but the local development instance is
  still using `root`.