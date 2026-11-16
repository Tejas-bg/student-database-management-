# Tests

> **Status: Stage 4 suite passing.** 22 automated tests run against the real
> MySQL database, not SQLite.

This folder holds automated tests for the backend, database access, and
integration flows.

## Current structure

```
tests/
├── conftest.py                # shared fixtures (Flask app, disposable MySQL user)
├── unit/
│   ├── __init__.py
│   └── test_security.py       # redirect allow-list, sentinel hash, malformed hash
├── integration/
│   ├── __init__.py
│   └── test_auth.py           # health, CSRF, login, RBAC, logout, 404
├── __init__.py
└── README.md
```

Planned for later stages: `test_students.py`, `test_attendance.py`,
`test_marks.py`, `test_fees.py`, and `test_reports.py`.

## Rules

- Tests run against **MySQL**, not SQLite.
- Use fake data and clean up afterwards.
- Cover success, failure, and permission paths.
- Do not invent results.
- Record real commands and outcomes in `docs/testing/`.
- Do not test only the happy path.

## Running the suite

```powershell
# Activate the virtual environment first
.\.venv\Scripts\Activate.ps1

pytest
pytest -q                 # quiet
pytest tests/integration -k csrf
```

`pytest.ini` adds the repository root and `backend/` to `sys.path`, so the
tests import `app` directly.

## What the suite covers

| Test | Behaviour verified |
|---|---|
| `test_health_reports_live_mysql` | `/health` reports a real MySQL version and the connected schema |
| `test_login_page_renders_with_csrf` | The login page renders and includes a CSRF token |
| `test_protected_dashboard_redirects_anonymous_user` | An unauthenticated dashboard request redirects to login |
| `test_post_without_csrf_is_rejected` | A `POST` without a CSRF token returns `400` |
| `test_empty_fields_are_rejected` | Empty credentials produce field-level messages |
| `test_wrong_password_is_generic` | A wrong password returns one generic message |
| `test_unknown_identifier_uses_the_same_message` | An unknown ID returns the same message, so accounts cannot be enumerated |
| `test_valid_login_starts_session_and_redirects` | A valid login starts a session, redirects to the dashboard, and never stores the password |
| `test_admin_dashboard_uses_database_counts` | The dashboard renders figures read from MySQL |
| `test_role_check_blocks_cross_role_prototype` | A student session is blocked from the admin preview with `403` |
| `test_anonymous_prototype_request_redirects` | Anonymous preview access redirects to login |
| `test_logout_destroys_session` | `POST /logout` clears the session |
| `test_unknown_page_returns_safe_404` | A missing page returns the safe 404 page with no traceback |
| `test_safe_redirect_target` | External and protocol-relative redirect targets are rejected |
| `test_sentinel_hash_never_authenticates` | Seeded `!NO_LOGIN_HASH_SET` accounts cannot sign in |
| `test_malformed_hash_never_raises` | A malformed stored hash is rejected without raising |

## Fixture hygiene

`conftest.py` creates one disposable administrator account
(`TEST-AUTH-9001`) inside a session-scoped fixture and deletes it in teardown.
No real student, faculty, or administrator data is modified, and no password is
hardcoded in a committed file.

## Status

Stage 4 backend tests exist and pass. The wider Stage 7 integration suite
(modules for attendance, marks, fees, and reports) is still to be written.