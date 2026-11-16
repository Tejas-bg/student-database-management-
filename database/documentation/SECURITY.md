# GM University Management System — Database Security Considerations (Stage 3)

> **Status:** Design complete, corrections applied for review. **Not executed / not connected.**
> This document covers database-level security design. Application controls (Flask sessions, CSRF, input validation) belong to Stage 4.

## 0. Credential setup rule
- No plaintext password and no reusable secret is committed to this repository.
- The seed script inserts fictional accounts with the non-authenticating sentinel `!NO_LOGIN_HASH_SET` and `account_status = 'pending_reset'`. The application must reject any value that is not a recognised bcrypt/Argon2id hash.
- Real hashes are set **outside version control** by an operator-run setup command that reads the password from stdin or a secret manager, for example:
  ```
  python -c "from werkzeug.security import generate_password_hash; import getpass; print(generate_password_hash(getpass.getpass()))"
  ```
  The resulting hash is written with a parameterized `UPDATE users SET password_hash = ?, account_status = 'active', must_change_password = 1 WHERE login_identifier = ?`.
- The DCL script uses `IDENTIFIED BY RANDOM PASSWORD` (MySQL 8.0.18+). Capture the generated database password from the one-time result set and store it in the deployment secret store; never paste it back into a tracked SQL file.
- `database/seeds/README.md` documents the full setup and rotation procedure.

## 1. Authentication storage
- Only `users.password_hash` is stored. Expected implementation: bcrypt or Argon2id via a maintained library.
- No plaintext, reversible encryption, or MD5/SHA-1 password storage.
- `password_reset_tokens.token_hash` stores a hash (SHA-256 in the design example); raw tokens are emailed/displayed once and never stored.
- `login_identifier` is unique and policy-based: student USN, faculty employee ID, administrator university email. **Aadhaar is not used** without explicit authorization.

## 2. Role and access control
- Role is stored in `users.role_id` and resolved server-side after authentication.
- The login request never supplies a role; no client-controlled role is trusted.
- `roles.role_code` is constrained to `student`, `faculty`, `admin`.
- Future Flask layer must check role on every protected route; the database alone does not enforce HTTP access.
- Optional profile links (`students.user_id`, `faculty.user_id`) allow administrators to exist without a student/faculty row.

## 3. Account lifecycle
- `account_status`: `active`, `inactive`, `locked`, `pending_reset`.
- `is_active` supports quick deactivation without deleting history.
- `failed_login_attempts` + `locked` support lockout policy (application increments/resets).
- `must_change_password` supports first-login and reset flows.
- `last_login_at` and `password_changed_at` support audit and stale-account review.

## 4. Least-privilege database users (to implement in Stage 6)
The DCL demonstration creates roles conceptually; the implementation should use separate accounts:
- `gmu_app` — `SELECT, INSERT, UPDATE, DELETE` on application tables; no `DROP`, `ALTER`, or `GRANT`.
- `gmu_report` — `SELECT` only on views and reporting tables.
- `gmu_admin` — schema owner/migration account, not used by the web app.
- `GRANT`/`REVOKE` examples are in `database/demonstrations/005_dcl.sql`.

## 5. Integrity as a security control
- Foreign keys prevent orphaned marks, payments, attendance, and enrolments.
- Unique keys prevent duplicate accounts, duplicate marks, duplicate payments, duplicate feedback, and duplicate read receipts.
- `CHECK` constraints reject impossible values (negative fees/marks, invalid rating, end time before start time, a broadcast notification with a single target).
- `ENUM`/status columns restrict values to known states.
- `RESTRICT` on historical parents prevents accidental mass deletion.
- Composite FK `fk_tt_assignment` prevents timetable rows without a real teaching assignment.
- Triggers reject attendance/enrolment mismatches, marks for the wrong assessment/exam, marks above the maximum, payments against another course's fee structure, overpayment, and notification targets whose role does not match.

## 6. Sensitive data minimization
- No Aadhaar, government ID, caste, religion, biometric, or medical data is designed.
- Student address/phone are optional and should be access-controlled in the app.
- Feedback supports `is_anonymous`; anonymous feedback should not expose `student_id` through reporting views (implementation must mask it).
- No real student data is included in the repository; all seed rows are fictional and labelled.

## 7. SQL injection and query safety
- All future application SQL must use parameterized queries / prepared statements.
- No dynamic SQL string concatenation with user input.
- Reporting views are read-only and should be exposed to the reporting account only.
- Error messages must not reveal SQL, stack traces, or schema details to end users.

## 8. Transactions and financial integrity
- Fee payment writes should run in a transaction: validate student/fee structure, insert payment, then commit.
- `ROLLBACK` on failure prevents partial financial records.
- `SAVEPOINT` supports partial rollback during bulk marks entry or imports.
- `amount_paid > 0` and `DECIMAL(10,2)` prevent invalid money values.
- Payment `receipt_no` and `transaction_ref` are unique to prevent double-posting.
- `trg_fee_payments_bi/_bu` rejects a fee structure outside the student's course and rejects successful payments above the fee amount.
- The trigger's sum check is not a concurrency lock. The application must lock the fee row (or use a serializable transaction) when two payments can be posted at the same time.

## 9. Auditability
- Actor columns record who entered marks, marked attendance, recorded payments, sent notifications, and reviewed feedback.
- `created_at`/`updated_at` are present on mutable master data.
- `published_at`, `read_at`, `reviewed_at`, `used_at` capture workflow timestamps.
- Application-level audit logging (who viewed/changed sensitive records) is a Stage 4/7 concern.

## 10. Backup, retention, and operations (to plan before production)
- Daily logical backups plus periodic restore tests.
- Point-in-time recovery using binary logs for financial/academic data.
- Retention policy for reset tokens (expire and purge), notifications (archive/expire), and audit logs.
- Database TLS, encrypted backups, and restricted network access are deployment concerns.

## 11. Known limitations of this stage
- No database was created, connected, or tested in MySQL.
- No application authentication code was changed.
- DCL/TCL scripts are illustrative and must be reviewed before execution on a real server.
- The final privilege model and secret management belong to Stage 4/6.
- `IDENTIFIED BY RANDOM PASSWORD` requires MySQL 8.0.18+; confirm the server version before running the DCL script.
- The trigger file has not been compiled or tested; see `database/triggers/README.md` for the runtime test list.