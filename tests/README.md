# Tests

> **Status: Not Started.** No tests exist yet.

This folder will hold automated tests for the backend, database access, and integration flows.

## Planned structure

```
tests/
├── conftest.py              # shared fixtures
├── unit/
│   ├── test_validators.py
│   └── test_services.py
├── integration/
│   ├── test_auth.py
│   ├── test_students.py
│   ├── test_attendance.py
│   ├── test_marks.py
│   ├── test_fees.py
│   └── test_reports.py
└── README.md
```

## Rules

- Tests run against **MySQL**, not SQLite.
- Use fake data and clean up afterwards.
- Cover success, failure, and permission paths.
- Do not invent results.
- Record real commands and outcomes in `docs/testing/`.
- Do not test only the happy path.

## Running tests (later)

```powershell
pytest
pytest --cov=backend
```

These commands are planned. They will not work until the backend and test dependencies exist.

## Status

Ready for Stage 4 (backend tests) and Stage 7 (integration tests).
