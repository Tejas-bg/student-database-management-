# GM University Management System — Database Architecture (Stage 3)

> **Status:** Design complete, corrections applied for review. **DATABASE DESIGN ONLY — not connected, not executed.**
> **Stack:** MySQL 8.0.16+ (CHECK constraints), InnoDB, `utf8mb4`, `utf8mb4_0900_ai_ci`.

## 1. Purpose
This document defines the relational database architecture that supports the existing Stage 2 frontend (login preview and student/faculty/admin dashboards) and prepares for future Flask integration. The design is based on inspection of the dashboard pages, forms, tables, filters, and actions.

## 2. Design principles
- **Normalized:** core schema in 3NF to reduce redundancy and anomalies.
- **Integrity in DB:** primary keys, foreign keys, unique constraints, checks, enums, indexes, one composite assignment FK, and documented triggers for cross-table rules.
- **Role from account:** `users.role_id` (and linked student/faculty record) determines role; no role selection at login.
- **Secure auth:** only `password_hash` stored; reset tokens stored as hashes; account activation/status supported.
- **Dashboard-driven:** every page/section in student, faculty, and admin workspaces maps to one or more tables or views.
- **Extensible:** supports future Flask repositories/services, server-side validation, pagination, and reporting.

## 3. Module map

| Module | Tables | Supports |
|---|---|---|
| Authentication & access | `roles`, `users`, `password_reset_tokens` | Common login, RBAC, activation, password reset, audit fields |
| Academic structure | `departments`, `courses`, `academic_years`, `semesters`, `subjects` | Admin department/course/subject/semester pages, filters |
| People | `students`, `faculty` | Profiles, admin/faculty management, student management |
| Teaching & enrolment | `faculty_subject_assignments`, `student_enrolments`, `timetable_entries` | Assigned subjects, course enrolments, timetable, class lists |
| Attendance | `attendance_sessions`, `attendance_records` | Student attendance view, faculty/admin attendance management |
| Assessment & results | `internal_assessments`, `internal_marks`, `semester_exams`, `semester_marks` | Internal marks, semester marks/results, performance reports |
| Fees | `fee_structures`, `fee_payments` | Fee details, fee management, payment history, balances |
| Communication | `notifications`, `notification_reads` | Role/user notifications, read state, header/page lists |
| Feedback | `feedback` | Student feedback submission, faculty/admin feedback views |

## 4. Entity summary (24 tables)
1. `roles` — role definitions (student/faculty/admin)
2. `users` — authentication accounts and status
3. `password_reset_tokens` — reset flow support
4. `departments`
5. `courses`
6. `academic_years`
7. `semesters`
8. `subjects`
9. `students`
10. `faculty`
11. `faculty_subject_assignments`
12. `student_enrolments`
13. `timetable_entries`
14. `attendance_sessions`
15. `attendance_records`
16. `internal_assessments`
17. `internal_marks`
18. `semester_exams`
19. `semester_marks`
20. `fee_structures`
21. `fee_payments`
22. `notifications`
23. `notification_reads`
24. `feedback`

> The 24 tables cover all requested modules plus the dashboard needs for timetables, notifications, read state, and password resets without duplicating entities.

## 5. Authentication and authorization model
- **Login identifier:** `users.login_identifier` (unique). Policy allows USN for students, employee ID for faculty, approved university email for administrators. Aadhaar is **not** used.
- **Role resolution:** server (future Flask) looks up user by identifier, verifies hash, checks `is_active/account_status`, then reads `users.role_id` → `roles.role_code`. Role is never taken from client input.
- **Profile linkage:** `students.user_id` and `faculty.user_id` are nullable unique FKs to `users`. This supports account provisioning independent of profile creation and keeps admin accounts possible without a student/faculty row.
- **Password storage:** `password_hash` only (bcrypt/argon2 expected in implementation). No plaintext.
- **Reset support:** `password_reset_tokens` stores token hash, expiry, usage timestamp; one-time use enforced by application logic + `used_at`.
- **Activation/deactivation:** `account_status` enum + `is_active` flag + lockout counter.

## 6. Key relationships
- Department 1:N Courses, Students, Faculty, Subjects.
- Course 1:N Semesters, Subjects, Fee structures, Students.
- Academic year 1:N Semesters, Fee structures.
- Student M:N Subject resolved by `student_enrolments` (scoped to semester and section; academic year derived through `semesters`).
- Faculty M:N Subject resolved by `faculty_subject_assignments`.
- Timetable entries reference a matching faculty/subject/semester/section assignment through a composite FK.
- Attendance: assignment/session → records per enrolment; a trigger rejects a record whose enrolment does not match the session's subject/semester/section.
- Marks: assessment/exam definitions + marks per enrolment; triggers reject subject/semester mismatches and marks above the maximum.
- Fees: structures define demand; payments record transactions; a trigger rejects a fee structure outside the student's course and overpayment.
- Notifications: broadcast by role and/or direct to user; a trigger rejects a target user whose role differs from `target_role`; read state per user in `notification_reads`.

## 7. Performance and indexing strategy
- Primary keys on all tables (surrogate integer/bigint).
- Unique keys on natural identifiers: role code, login identifier, email, department/course/subject codes, USN, employee ID, receipt/transaction refs, composite business keys.
- Foreign key indexes on all join/filter columns.
- Composite indexes for common dashboard queries: `(role_id, account_status)`, `(department_id, course_id)`, `(subject_id, semester_id, section)`, `(student_id, semester_id)`, `(target_role, target_user_id, published_at)`.
- Views provided for frequent read patterns (profiles, attendance %, marks, results, fees, workload, performance, feedback summary).
- Cross-table integrity triggers provided for attendance, marks, fees, and notification targeting.

## 8. Data types and conventions
- Money: `DECIMAL(10,2)` for fees/payments.
- Marks: `DECIMAL(5,2)` with range checks.
- Dates/times: `DATE`, `TIME`, `DATETIME`, `YEAR` as appropriate.
- Booleans: `TINYINT(1)` with `CHECK (... IN (0,1))`.
- Controlled values: `ENUM` for statuses/types where sets are stable and small.
- Engine: InnoDB; charset/collation `utf8mb4` / `utf8mb4_0900_ai_ci`.

## 9. Flask integration readiness
- Tables map cleanly to repositories/services and Jinja views.
- No frontend assumptions embedded; server will supply role, identity, and filtered data.
- Schema supports parameterized CRUD, joins for dashboards, transactions for payments/marks entry, and paginated queries via indexed keys.
- `created_at/updated_at` and actor columns included where useful for auditing.
- The Flask service must still validate input and handle concurrency; triggers are defence in depth, not a substitute for application checks.

## 10. Integrity enforcement summary
- **Declarative:** 24 primary keys, 51 foreign keys, 32 unique keys, 29 CHECK constraints, 25 secondary indexes.
- **Composite FK:** `timetable_entries(faculty_id, subject_id, semester_id, section)` → `faculty_subject_assignments`, so a timetable row requires a real teaching assignment.
- **Functional unique index:** `feedback(student_id, category, COALESCE(subject_id,0), COALESCE(semester_id,0))` prevents duplicate feedback even when the scope is NULL.
- **Triggers:** `database/triggers/001_integrity_triggers.sql` contains 10 triggers (5 rules × INSERT/UPDATE) for attendance, internal marks, semester marks, fee payments, and notification targets.
- **Run order:** schema → views → triggers → seeds.

## 11. Out of scope / not claimed
- No database has been created or populated in MySQL.
- No Flask routes, models, or connections implemented.
- No real university data included.
- No changes to login page, dashboards, or existing frontend files.
- No trigger has been compiled or tested against a running MySQL server.
- No concurrency/race test has been run for fee payments or marks entry.