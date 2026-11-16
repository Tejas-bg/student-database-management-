# Seeds

> **Status: PREPARED — not executed.** No seed data has been loaded into MySQL.

Seed files load fictional sample data for development and demos.

## Files

| File | Purpose |
|---|---|
| `001_sample_data.sql` | Fictional roles, users, departments, courses, academic years, semesters, subjects, students, faculty, assignments, enrolments, timetable, attendance, marks, fees, notifications, reads, feedback, and a reset token. |

## Run order

1. `database/schema/001_schema.sql`
2. `database/views/001_views.sql`
3. `database/triggers/001_integrity_triggers.sql`
4. `database/seeds/001_sample_data.sql`

The seed rows are written to satisfy the integrity triggers. Re-check them whenever seed data changes.

## Account and password setup (no secrets in this repository)

The seed script does **not** contain usable password hashes. Every fictional account is inserted with:

- `password_hash = '!NO_LOGIN_HASH_SET'` — a sentinel that is not a valid bcrypt/Argon2id hash;
- `account_status = 'pending_reset'` (except the deliberately inactive account);
- `must_change_password = 1`.

The application must reject the sentinel. To create a usable development account, run an operator-only command outside version control:

```bash
python -c "from werkzeug.security import generate_password_hash; import getpass; print(generate_password_hash(getpass.getpass('Password: ')))"
```

Then apply the returned hash with a parameterized statement, for example:

```sql
UPDATE users
SET password_hash = ?, account_status = 'active', must_change_password = 1
WHERE login_identifier = ?;
```

Rules:

- Never paste a real password or hash into a tracked SQL file, README, screenshot, or commit.
- Never store plaintext passwords.
- Keep real credentials in the deployment secret store or a local `.env` file that is git-ignored.
- Rotate any development password that was ever shared.
- The DCL script (`database/demonstrations/005_dcl.sql`) uses `IDENTIFIED BY RANDOM PASSWORD`; capture the generated database password from the one-time result set and store it in the secret store.

## Rules

- All data is clearly fictional.
- No real student names, emails, phone numbers, or marks.
- Consistent sample identifiers.
- Seeds run inside a transaction (`START TRANSACTION … COMMIT`).
- No plaintext passwords and no usable password hashes.
- Match the approved schema exactly.
- Do not run against a live database.

## Content

- Roles and accounts for all three roles.
- Departments, courses, academic years, and semesters.
- Subjects and faculty.
- Students and enrolments (with section).
- Teaching assignments and timetable.
- Attendance sessions and records.
- Internal assessments/marks and semester exams/marks.
- Fee structures and payments.
- Notifications and read receipts.
- Feedback and a password-reset token.

## Verification when built

- Load into a clean database after the schema, views, and triggers.
- Check row counts.
- Run the main report views against the seed data.
- Confirm no real data is present.
- Confirm foreign keys, unique constraints, CHECK constraints, and triggers accept the seed rows.
- Confirm the sentinel hash cannot authenticate.
