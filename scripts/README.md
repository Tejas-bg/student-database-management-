# Scripts

> **Status: Not Started.** No scripts exist yet.

This folder will hold small, documented utility scripts that support development and demonstrations.

## Planned scripts

| Script | Purpose | Stage |
|---|---|---|
| `setup_database.sql` | Create the database and least-privilege users. | 3 |
| `run_migrations.py` | Apply migrations in order. | 3 |
| `seed_database.py` | Load fake sample data. | 3 |
| `reset_demo.py` | Reset the demo database to a known state. | 9 |
| `check_environment.py` | Check Python, MySQL, and dependency versions. | 4 |

## Rules

- Every script must be documented.
- No secrets in scripts; read from `.env`.
- No real data.
- Destructive scripts must ask for confirmation.
- Test scripts before documenting them as working.
- PowerShell (`.ps1`) or Python is preferred on Windows.

## Status

Ready for Stage 3 onward.
