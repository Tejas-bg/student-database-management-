# GM University Management System — Database Design (Historical Draft)

> **Status: HISTORICAL / SUPERSEDED.** This was an early planning draft. The final Stage 3 design is in `DATABASE_ARCHITECTURE.md`, `ER_DIAGRAM.md`, `DATA_DICTIONARY.md`, and `TABLE_DESCRIPTIONS_AND_RELATIONSHIPS.md`.
> **No table has been created.** Do not execute anything from this document.

---

## 1. Design goals

- Model the academic domain accurately.
- Normalize to **3NF**.
- Enforce integrity in the database, not only in application code.
- Make reports possible with joins, subqueries, aggregates, and views.
- Support the DBMS concepts required by the project.
- Stay understandable for a beginner and explainable in a viva.

---

## 2. Conventions

| Item | Convention |
|---|---|
| Engine | InnoDB |
| Character set | `utf8mb4` |
| Collation | `utf8mb4_0900_ai_ci` (MySQL 8 default) |
| Table names | `snake_case`, plural |
| Column names | `snake_case`, singular |
| Primary key | `<table_singular>_id` |
| Foreign key | Same name as the referenced primary key |
| Booleans | `TINYINT(1)` with `CHECK (col IN (0,1))` or `BOOLEAN` |
| Money | `DECIMAL(10,2)` |
| Dates | `DATE` |
| Timestamps | `DATETIME` |
| Audit columns | `created_at`, `updated_at` where useful |
| Delete policy | Explicit per foreign key |

---

## 3. Table overview

| # | Table | Purpose | Primary key |
|---|---|---|---|
| 1 | `departments` | Academic departments | `department_id` |
| 2 | `courses` | Programmes offered by departments | `course_id` |
| 3 | `semesters` | Course terms in an academic year | `semester_id` |
| 4 | `subjects` | Units of study | `subject_id` |
| 5 | `faculty` | Teachers | `faculty_id` |
| 6 | `students` | Learners | `student_id` |
| 7 | `faculty_subject_assignments` | Who teaches what, when | `assignment_id` |
| 8 | `enrolments` | Students taking subjects | `enrolment_id` |
| 9 | `attendance` | Presence per enrolment per date | `attendance_id` |
| 10 | `internal_assessments` | Internal assessment definitions | `assessment_id` |
| 11 | `internal_marks` | Internal scores | `internal_mark_id` |
| 12 | `semester_exams` | Exam definitions | `exam_id` |
| 13 | `semester_marks` | Exam scores | `semester_mark_id` |
| 14 | `fee_structure` | Amounts due | `fee_structure_id` |
| 15 | `fee_payments` | Payments received | `payment_id` |
| 16 | `feedback` | Student feedback | `feedback_id` |
| 17 | `roles` | Permission groups | `role_id` |
| 18 | `users` | Login accounts | `user_id` |

The full column list, types, and constraints are in `DATA_DICTIONARY.md`.

---

## 4. Table design notes

### 4.1 `departments`

- `department_code` is unique.
- A department cannot be deleted while courses, faculty, or students reference it.
- `hod_name` is stored as text for simplicity. A later version could reference `faculty_id`.

### 4.2 `courses`

- `course_code` is unique.
- `department_id` references `departments`.
- Delete rule: `RESTRICT` while subjects or students exist.
- `duration_years` is a positive integer.

### 4.3 `semesters`

- Belongs to a course.
- `semester_number` is positive and within the course duration.
- `academic_year` is text such as `2026-27`.
- Unique combination: `(course_id, semester_number, academic_year)`.
- This table anchors subjects, assignments, enrolments, and feedback.

### 4.4 `subjects`

- Belongs to a course.
- `subject_code` is unique within a course.
- `semester_number` is positive.
- `credits` is positive.
- Delete rule: `RESTRICT` while enrolments or assessments exist.

### 4.5 `faculty`

- `employee_code` and `email` are unique.
- Belongs to a department.
- Delete rule: `RESTRICT` while assignments or feedback exist.

### 4.6 `students`

- `admission_no` and `email` are unique.
- Belongs to a department and a course.
- `current_semester` is a positive integer.
- `is_active` supports soft deactivation.
- Delete rule: `RESTRICT` while enrolments or payments exist. Prefer deactivation over deletion.

### 4.7 `faculty_subject_assignments`

- Links faculty, subject, and semester.
- Unique combination: `(faculty_id, subject_id, semester_id)`.
- Delete rule: `RESTRICT` for faculty and subject; `CASCADE` from semester only if the semester is being removed in a controlled reset. Default is `RESTRICT`.

### 4.8 `enrolments`

- Links student, subject, and semester.
- Unique combination: `(student_id, subject_id, semester_id)`.
- This is the anchor for attendance and marks.
- Delete rule: `RESTRICT` while attendance or marks exist.

### 4.9 `attendance`

- Belongs to an enrolment.
- `attendance_date` is a date.
- `status` is one of `present`, `absent`, `late`.
- Unique combination: `(enrolment_id, attendance_date)`.
- `recorded_by` references `faculty`.
- Delete rule: `CASCADE` when an enrolment is deleted only in a controlled reset; default `RESTRICT`.

### 4.10 `internal_assessments`

- Belongs to a subject and semester.
- `max_marks` is positive.
- Unique combination: `(subject_id, semester_id, assessment_name)`.
- Delete rule: `RESTRICT` while marks exist.

### 4.11 `internal_marks`

- Links an enrolment to an assessment.
- `obtained_marks` is between 0 and the assessment's `max_marks`.
- Unique combination: `(enrolment_id, assessment_id)`.
- The range check may be enforced by a trigger if a `CHECK` cannot reference another table. This is decided in Stage 6.

### 4.12 `semester_exams`

- Belongs to a subject and semester.
- `max_marks` is positive.
- Unique combination: `(subject_id, semester_id, exam_type)`.
- Delete rule: `RESTRICT` while marks exist.

### 4.13 `semester_marks`

- Links an enrolment to an exam.
- `obtained_marks` is between 0 and the exam's `max_marks`.
- Unique combination: `(enrolment_id, exam_id)`.

### 4.14 `fee_structure`

- Belongs to a course.
- `semester_number` is positive.
- `fee_type` is text such as `tuition`, `exam`, `library`.
- `amount` uses `DECIMAL(10,2)`.
- Unique combination: `(course_id, semester_number, fee_type)`.
- Delete rule: `RESTRICT` while payments exist.

### 4.15 `fee_payments`

- Links a student to a fee structure.
- `amount_paid` uses `DECIMAL(10,2)`.
- `method` is text such as `cash`, `card`, `upi`, `bank_transfer`.
- `status` is one of `pending`, `completed`, `failed`, `refunded`.
- `reference_no` is optional but unique when present.
- Payments are written inside a transaction.

### 4.16 `feedback`

- Links a student, subject, faculty, and semester.
- `rating` is an integer from 1 to 5.
- `comments` is optional text.
- `submitted_at` defaults to the current timestamp.
- Unique combination: `(student_id, subject_id, semester_id)`.
- Feedback visibility is controlled by role.

### 4.17 `roles`

- `role_name` is unique.
- Expected rows: `admin`, `faculty`, `student`.

### 4.18 `users`

- `username` and `email` are unique.
- `password_hash` stores a hash, never plaintext.
- `role_id` references `roles`.
- `student_id` and `faculty_id` are optional links to the person.
- `is_active` supports disabling an account.
- A user must link to at most one person. This is enforced in the application and, if possible, with a constraint.

---

## 5. Index plan

Indexes are added for:

- Every foreign key.
- Unique business keys (`admission_no`, `email`, `course_code`, `department_code`, `employee_code`).
- Frequent filters (`attendance_date`, `payment_date`, `academic_year`).
- Report grouping (`subject_id`, `semester_id`, `student_id`).

Exact index names and definitions are added in Stage 3.

---

## 6. Delete policy summary

| Parent | Child | Default rule | Reason |
|---|---|---|---|
| departments | courses | `RESTRICT` | Do not orphan courses. |
| departments | faculty | `RESTRICT` | Do not orphan faculty. |
| departments | students | `RESTRICT` | Do not orphan students. |
| courses | subjects | `RESTRICT` | Do not orphan subjects. |
| courses | students | `RESTRICT` | Do not orphan students. |
| semesters | enrolments | `RESTRICT` | Preserve academic history. |
| subjects | enrolments | `RESTRICT` | Preserve academic history. |
| students | enrolments | `RESTRICT` | Preserve academic history. |
| enrolments | attendance | `RESTRICT` | Preserve attendance. |
| enrolments | internal_marks | `RESTRICT` | Preserve marks. |
| enrolments | semester_marks | `RESTRICT` | Preserve marks. |
| students | fee_payments | `RESTRICT` | Preserve financial history. |
| students | feedback | `RESTRICT` | Preserve feedback. |

`CASCADE` is used only in controlled reset scripts, not in the main schema.

---

## 7. Transaction scenarios

These will be demonstrated in Stage 6:

1. **Fee payment:** insert a payment and update the fee status; `COMMIT` on success, `ROLLBACK` on failure.
2. **Bulk marks entry:** insert several marks; if one fails, roll back to a `SAVEPOINT` and keep the valid ones.
3. **Enrolment:** insert an enrolment and an initial attendance row; both succeed or neither does.

---

## 8. Security design

- `gmu_admin` owns schema changes.
- `gmu_app` has DML and `SELECT` on required tables and views.
- `gmu_report` has `SELECT` on reporting views only.
- Passwords are hashed.
- All application queries are parameterized.
- No real data is stored.

---

## 9. Open questions (must be resolved before approval)

1. Is a semester a global term or per-course?
2. Should `students.current_semester` reference `semesters`?
3. Can a subject belong to more than one course?
4. Should feedback be anonymous?
5. Should `users` use a single person table instead of optional links?
6. What is the exact delete policy for historical records?
7. Is `fee_structure` per course/semester or per student?
8. Are stored procedures and triggers required, or optional demonstrations?

---

## 10. Approval

| Item | Status |
|---|---|
| Draft design | Created |
| Normalization review | Pending |
| User review | Pending |
| Approved for implementation | No |

This historical draft is superseded. The final Stage 3 schema is design-complete for review and still not executed.
