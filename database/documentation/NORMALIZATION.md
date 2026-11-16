# GM University Management System — Normalization Report (Stage 3)

> **Status:** Design complete, corrections applied for review. **Not executed.**
> **Target:** Third Normal Form (3NF), verified statically against `database/schema/001_schema.sql`.
> **Scope:** 24 base tables. Reporting views are not normalized relations; they are derived read models.

## 1. Why normalize?
Normalization removes duplicated data and prevents insertion, update, and deletion anomalies. The GMU schema targets 3NF because it is explainable in a viva and keeps integrity enforceable in the database. Where a small, controlled redundancy is retained for query clarity, it is listed in section 8 and protected by a foreign key or trigger.

## 2. First Normal Form (1NF)
**Rule:** every column is atomic, rows are unique, and there are no repeating groups.

Applied:
- No comma-separated subject lists. Enrolment is one row per student–subject–semester.
- Marks are rows in `internal_marks` / `semester_marks`, not `mark1`, `mark2`, `mark3`.
- A student's section is a single atomic value on `student_enrolments.section`.
- Phone/address values are atomic columns; additional phone numbers would require a child table later.
- Every table has a primary key.
- The functional unique index on `feedback` does not store a repeating group; it is an index expression, not a column.

**Violation avoided**
```
student(student_id, name, subjects)  -- 'DBMS, OS, CN' violates 1NF
```
Resolved by `student_enrolments(student_id, subject_id, semester_id, section, ...)`.

## 3. Second Normal Form (2NF)
**Rule:** 1NF plus no non-key column depends on only part of a composite key.

Because the schema uses surrogate single-column primary keys, most tables are automatically 2NF. Junction tables were reviewed explicitly.

**Example avoided in `student_enrolments`:**
A naive composite key `(student_id, subject_id)` storing `student_name` and `subject_name` would create partial dependencies. The final table stores only `student_id`, `subject_id`, `semester_id`, `section`, `enrolment_date`, `status`; names live in `students` and `subjects`.

The same rule applies to `faculty_subject_assignments` (no faculty/subject names), `attendance_records` (no student name), and `fee_payments` (no student/course name).

## 4. Third Normal Form (3NF)
**Rule:** 2NF plus no non-key column depends transitively on another non-key column.

**Example avoided in `students`:**
```
students(student_id, name, department_id, department_name, course_id, course_name) -- 3NF violation
```
`department_name` depends on `department_id`, and `course_name` depends on `course_id`. The final `students` table stores only `department_id` and `course_id`; names are in `departments` and `courses`.

Applied:
- Department names only in `departments`.
- Course names only in `courses`.
- Subject names only in `subjects`.
- Faculty names only in `faculty`; student names only in `students`.
- Marks/payments/attendance store keys and measurements, not descriptive names.

### 4.1 Removed redundancy: `student_enrolments.academic_year_id`
The original draft stored `academic_year_id` on `student_enrolments`. That value is functionally determined by `semester_id`:
```
semester_id → semesters.academic_year_id
```
so it was a transitive dependency and a 3NF violation. It was **removed**. The academic year is now obtained by joining `student_enrolments.semester_id` to `semesters.academic_year_id`. The views were updated accordingly, and the old `idx_enrolment_student_year` index was replaced by `idx_enrolment_student_semester`.

### 4.2 Retained business attribute: `subjects.department_id`
`subjects.department_id` is **retained deliberately**. It records the department that *owns* the subject, which may differ from the department that offers the course (for example, a service Mathematics subject inside a CSE programme). Under that business rule, `course_id` does not functionally determine `department_id`, so this is not a transitive dependency. The column is commented in the DDL. If the university later requires every subject to belong to the course's department, this column should be removed and derived through `courses.department_id`.

### 4.3 Retained business attribute: `students.department_id`
`students.department_id` is **retained deliberately** as the student's administrative home department. It may differ from the course's offering department for inter-departmental admission or advising. Under that rule, `course_id` does not functionally determine `department_id`. The column is commented in the DDL. If the university requires them to be identical, remove `students.department_id` and derive it through `courses.department_id`.

### 4.4 Controlled redundancy: timetable assignment columns
`timetable_entries` stores `faculty_id`, `subject_id`, `semester_id`, and `section`, which together identify a `faculty_subject_assignments` row. This is a controlled redundancy kept so timetable queries do not need an extra join. The composite foreign key `fk_tt_assignment` guarantees that the four values always match a real assignment. It is not a transitive dependency because the four columns are the foreign key to the assignment, not a description of it.

### 4.5 No stored derived values
Percentages, balances, averages, and pass counts are not base columns. They are computed in views (section 5). `students.current_semester` remains the one documented convenience field; see section 8.

## 5. Derived values
The following are **computed by views/queries**, not stored as base columns:
- attendance percentage and held/marked/unmarked session counts (`vw_student_attendance_summary`)
- internal percentage (`vw_student_internal_marks`)
- fee demand/paid/balance/status per academic year and semester (`vw_student_fee_summary`)
- class averages/pass counts (`vw_class_performance`)
- feedback averages (`vw_feedback_summary`)

If a cached summary is introduced for performance later, it must be documented, refreshed deterministically, and approved by ADR.

## 6. Anomalies avoided

| Anomaly | Example without normalization | How the design prevents it |
|---|---|---|
| Insertion | Cannot add a department until a student exists | `departments` is independent; students reference it |
| Insertion | Cannot record a subject without a student | `subjects` is independent of enrolment |
| Update | Renaming a department requires editing every student row | Name stored once in `departments` |
| Update | Changing a subject title requires editing every mark row | Name stored once in `subjects` |
| Deletion | Deleting a student erases the only copy of a department name | Department lives in its own table; FKs use RESTRICT where history matters |
| Duplicate | Same student enrolled twice in a subject/term | `uk_enrolment (student_id, subject_id, semester_id)` |
| Duplicate | Two marks for one assessment/enrolment | `uk_internal_mark (assessment_id, enrolment_id)` |
| Duplicate | Duplicate payment receipt/reference | `uk_payment_receipt`, `uk_payment_txn` |
| Duplicate | Two read receipts for one user/notification | `uk_notification_read (notification_id, user_id)` |
| Duplicate | Duplicate feedback for the same scope | Functional `uk_feedback_once` with `COALESCE(subject_id,0)` and `COALESCE(semester_id,0)` |
| Duplicate | Duplicate fee head per course/year/semester | `uk_fee_structure` on four NOT NULL columns |
| Duplicate | Duplicate attendance session | `uk_attendance_session` on `(assignment_id, session_date, start_time)`, with `start_time` NOT NULL |

## 7. Table-by-table 3NF review

| Table | 1NF | 2NF | 3NF | Notes |
|---|---|---|---|---|
| roles | Yes | Yes | Yes | Lookup table |
| users | Yes | Yes | Yes | Role/person links only |
| password_reset_tokens | Yes | Yes | Yes | Token-specific attributes |
| departments | Yes | Yes | Yes | No transitive dependency |
| courses | Yes | Yes | Yes | `department_id` only department reference |
| academic_years | Yes | Yes | Yes | Independent year data |
| semesters | Yes | Yes | Yes | Depends on course + year + number |
| subjects | Yes | Yes | Yes | `department_id` is the owning department (section 4.2) |
| students | Yes | Yes | Yes | `department_id` is the administrative home (section 4.3) |
| faculty | Yes | Yes | Yes | `department_id` only |
| faculty_subject_assignments | Yes | Yes | Yes | Junction + section/date/active |
| student_enrolments | Yes | Yes | Yes | Junction + section/status; year derived via `semesters` |
| timetable_entries | Yes | Yes | Yes | Controlled assignment redundancy, FK-enforced (section 4.4) |
| attendance_sessions | Yes | Yes | Yes | Session-specific attributes |
| attendance_records | Yes | Yes | Yes | Status/remarks only |
| internal_assessments | Yes | Yes | Yes | Assessment definition |
| internal_marks | Yes | Yes | Yes | Marks/remarks only |
| semester_exams | Yes | Yes | Yes | Exam definition |
| semester_marks | Yes | Yes | Yes | Result attributes only |
| fee_structures | Yes | Yes | Yes | Fee head/amount/due; semester NOT NULL |
| fee_payments | Yes | Yes | Yes | Payment attributes only |
| notifications | Yes | Yes | Yes | Message attributes; target role checked by trigger |
| notification_reads | Yes | Yes | Yes | Read timestamp only |
| feedback | Yes | Yes | Yes | Rating/comment/workflow; functional unique index |

## 8. Deliberate design notes (not normalization violations)
- `ENUM` columns are used for small, stable code sets; they remain atomic.
- Surrogate integer keys are used for stable references; natural keys are protected by unique constraints.
- Audit/actor columns (`created_by_user_id`, `entered_by_user_id`, `recorded_by_user_id`, `marked_by_user_id`, `reviewed_by_user_id`) are direct attributes of the event and therefore valid in 3NF.
- `students.current_semester` is a denormalized convenience field. It is permitted because it represents the student's current registration state, not a duplicate of immutable history; the authoritative term history remains in `student_enrolments`. It must be updated by the application when a semester is promoted, or recomputed from enrolments.
- `subjects.department_id` and `students.department_id` are business attributes under the assumptions in sections 4.2 and 4.3, not accidental copies.
- `timetable_entries` duplicates the assignment key for query convenience, but `fk_tt_assignment` makes the copy consistent.
- Cross-table integrity rules that cannot be expressed by one foreign key are enforced by triggers (section 9), not by storing more redundant columns.

## 9. Integrity enforcement added by the corrections

| Rule | Mechanism |
|---|---|
| Timetable row must match a real teaching assignment | Composite FK `fk_tt_assignment` |
| Attendance record must match session assignment subject/semester/section | `trg_attendance_records_bi` / `_bu` |
| Internal mark must match assessment subject/semester and max marks | `trg_internal_marks_bi` / `_bu` |
| Semester mark must match exam subject/semester and max marks | `trg_semester_marks_bi` / `_bu` |
| Fee payment must match student course and not exceed fee amount | `trg_fee_payments_bi` / `_bu` |
| Notification target role must match user role | `trg_notifications_bi` / `_bu` |
| Feedback duplicates with NULL scope | Functional unique index `uk_feedback_once` |
| Fee-structure duplicates with NULL semester | `semester_number` NOT NULL + `uk_fee_structure` |
| Attendance-session duplicates with NULL time | `start_time` NOT NULL + `uk_attendance_session` |

## 10. Conclusion
All 24 base tables satisfy 1NF and 2NF. They satisfy 3NF under the documented business assumptions in sections 4.2 and 4.3, with one disclosed convenience field (`students.current_semester`) and one FK-protected controlled redundancy (`timetable_entries`). The previously identified `student_enrolments.academic_year_id` transitive dependency has been removed. Derived academic and financial summaries are computed via views rather than stored redundantly. These results are design-level and have **not** been validated against a running MySQL instance in this stage.
