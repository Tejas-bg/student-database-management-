# GM University Management System — Data Dictionary

> **Status: PLANNING.** Proposed columns and types. Not approved.
> **Note:** MySQL `CHECK` constraints are enforced from MySQL 8.0.16 onward. Confirm the local version before relying on them.
> **Read with:** `DATABASE_DESIGN.md`, `ER_DIAGRAM.md`, and `TABLE_RELATIONSHIPS.md`.

---

## 1. Conventions

- `PK` = primary key.
- `FK` = foreign key.
- `UK` = unique key.
- `NN` = not null.
- Types are MySQL 8 types.
- `created_at` and `updated_at` are optional audit columns; add them where they help.
- No real data is stored in any table.

---

## 2. `departments`

| Column | Type | Null | Key / Constraint | Default | Description |
|---|---|---|---|---|---|
| `department_id` | `INT UNSIGNED` | No | PK, auto-increment | — | Surrogate identifier. |
| `department_code` | `VARCHAR(10)` | No | UK | — | Short code, e.g. `CSE`. |
| `department_name` | `VARCHAR(100)` | No | — | — | Full name. |
| `hod_name` | `VARCHAR(100)` | Yes | — | `NULL` | Head of department display name. |
| `created_at` | `DATETIME` | No | — | `CURRENT_TIMESTAMP` | Row creation time. |
| `updated_at` | `DATETIME` | Yes | — | `NULL` | Last update time. |

---

## 3. `courses`

| Column | Type | Null | Key / Constraint | Default | Description |
|---|---|---|---|---|---|
| `course_id` | `INT UNSIGNED` | No | PK, auto-increment | — | Surrogate identifier. |
| `course_code` | `VARCHAR(20)` | No | UK | — | Short code, e.g. `BSC-CS`. |
| `course_name` | `VARCHAR(120)` | No | — | — | Full course name. |
| `department_id` | `INT UNSIGNED` | No | FK → `departments.department_id` | — | Owning department. |
| `duration_years` | `TINYINT UNSIGNED` | No | `CHECK (duration_years > 0)` | `3` | Course length in years. |
| `created_at` | `DATETIME` | No | — | `CURRENT_TIMESTAMP` | Row creation time. |
| `updated_at` | `DATETIME` | Yes | — | `NULL` | Last update time. |

---

## 4. `semesters`

| Column | Type | Null | Key / Constraint | Default | Description |
|---|---|---|---|---|---|
| `semester_id` | `INT UNSIGNED` | No | PK, auto-increment | — | Surrogate identifier. |
| `course_id` | `INT UNSIGNED` | No | FK → `courses.course_id` | — | Course this term belongs to. |
| `semester_number` | `TINYINT UNSIGNED` | No | `CHECK (semester_number > 0)` | — | Term number (1–8, etc.). |
| `academic_year` | `VARCHAR(9)` | No | UK with course and number | — | e.g. `2026-27`. |
| `start_date` | `DATE` | Yes | — | `NULL` | Term start. |
| `end_date` | `DATE` | Yes | `CHECK (end_date >= start_date)` | `NULL` | Term end. |

**Unique key:** `(course_id, semester_number, academic_year)`.

---

## 5. `subjects`

| Column | Type | Null | Key / Constraint | Default | Description |
|---|---|---|---|---|---|
| `subject_id` | `INT UNSIGNED` | No | PK, auto-increment | — | Surrogate identifier. |
| `subject_code` | `VARCHAR(20)` | No | UK with course | — | Subject code, e.g. `DBMS`. |
| `subject_name` | `VARCHAR(120)` | No | — | — | Full subject name. |
| `course_id` | `INT UNSIGNED` | No | FK → `courses.course_id` | — | Course this subject belongs to. |
| `semester_number` | `TINYINT UNSIGNED` | No | `CHECK (semester_number > 0)` | — | Typical term. |
| `credits` | `TINYINT UNSIGNED` | No | `CHECK (credits > 0)` | `3` | Credit weight. |
| `created_at` | `DATETIME` | No | — | `CURRENT_TIMESTAMP` | Row creation time. |
| `updated_at` | `DATETIME` | Yes | — | `NULL` | Last update time. |

**Unique key:** `(course_id, subject_code)`.

---

## 6. `faculty`

| Column | Type | Null | Key / Constraint | Default | Description |
|---|---|---|---|---|---|
| `faculty_id` | `INT UNSIGNED` | No | PK, auto-increment | — | Surrogate identifier. |
| `employee_code` | `VARCHAR(20)` | No | UK | — | College employee code. |
| `full_name` | `VARCHAR(120)` | No | — | — | Faculty name. |
| `email` | `VARCHAR(150)` | No | UK | — | Contact email. |
| `phone` | `VARCHAR(20)` | Yes | — | `NULL` | Contact phone. |
| `department_id` | `INT UNSIGNED` | No | FK → `departments.department_id` | — | Owning department. |
| `designation` | `VARCHAR(60)` | Yes | — | `NULL` | e.g. Assistant Professor. |
| `is_active` | `BOOLEAN` | No | `CHECK (is_active IN (0,1))` | `TRUE` | Soft availability. |
| `created_at` | `DATETIME` | No | — | `CURRENT_TIMESTAMP` | Row creation time. |
| `updated_at` | `DATETIME` | Yes | — | `NULL` | Last update time. |

---

## 7. `students`

| Column | Type | Null | Key / Constraint | Default | Description |
|---|---|---|---|---|---|
| `student_id` | `INT UNSIGNED` | No | PK, auto-increment | — | Surrogate identifier. |
| `admission_no` | `VARCHAR(20)` | No | UK | — | College admission number. |
| `full_name` | `VARCHAR(120)` | No | — | — | Student name. |
| `email` | `VARCHAR(150)` | No | UK | — | Contact email. |
| `phone` | `VARCHAR(20)` | Yes | — | `NULL` | Contact phone. |
| `date_of_birth` | `DATE` | Yes | — | `NULL` | Date of birth. |
| `gender` | `ENUM('male','female','other')` | Yes | — | `NULL` | Optional. |
| `department_id` | `INT UNSIGNED` | No | FK → `departments.department_id` | — | Academic department. |
| `course_id` | `INT UNSIGNED` | No | FK → `courses.course_id` | — | Enrolled course. |
| `current_semester` | `TINYINT UNSIGNED` | No | `CHECK (current_semester > 0)` | `1` | Current term number. |
| `admission_date` | `DATE` | Yes | — | `NULL` | Date of admission. |
| `is_active` | `BOOLEAN` | No | `CHECK (is_active IN (0,1))` | `TRUE` | Soft status. |
| `created_at` | `DATETIME` | No | — | `CURRENT_TIMESTAMP` | Row creation time. |
| `updated_at` | `DATETIME` | Yes | — | `NULL` | Last update time. |

---

## 8. `faculty_subject_assignments`

| Column | Type | Null | Key / Constraint | Default | Description |
|---|---|---|---|---|---|
| `assignment_id` | `INT UNSIGNED` | No | PK, auto-increment | — | Surrogate identifier. |
| `faculty_id` | `INT UNSIGNED` | No | FK → `faculty.faculty_id` | — | Assigned faculty. |
| `subject_id` | `INT UNSIGNED` | No | FK → `subjects.subject_id` | — | Assigned subject. |
| `semester_id` | `INT UNSIGNED` | No | FK → `semesters.semester_id` | — | Term of assignment. |
| `assigned_on` | `DATE` | No | — | `(CURRENT_DATE)` | Date of assignment. |

**Unique key:** `(faculty_id, subject_id, semester_id)`.

---

## 9. `enrolments`

| Column | Type | Null | Key / Constraint | Default | Description |
|---|---|---|---|---|---|
| `enrolment_id` | `INT UNSIGNED` | No | PK, auto-increment | — | Surrogate identifier. |
| `student_id` | `INT UNSIGNED` | No | FK → `students.student_id` | — | Enrolled student. |
| `subject_id` | `INT UNSIGNED` | No | FK → `subjects.subject_id` | — | Subject taken. |
| `semester_id` | `INT UNSIGNED` | No | FK → `semesters.semester_id` | — | Term of enrolment. |
| `enrolled_on` | `DATE` | No | — | `(CURRENT_DATE)` | Date of enrolment. |
| `status` | `ENUM('active','completed','dropped')` | No | — | `'active'` | Enrolment state. |

**Unique key:** `(student_id, subject_id, semester_id)`.

---

## 10. `attendance`

| Column | Type | Null | Key / Constraint | Default | Description |
|---|---|---|---|---|---|
| `attendance_id` | `BIGINT UNSIGNED` | No | PK, auto-increment | — | Surrogate identifier. |
| `enrolment_id` | `INT UNSIGNED` | No | FK → `enrolments.enrolment_id` | — | Enrolment the record belongs to. |
| `attendance_date` | `DATE` | No | UK with enrolment | — | Date of class. |
| `status` | `ENUM('present','absent','late')` | No | — | — | Attendance state. |
| `recorded_by` | `INT UNSIGNED` | No | FK → `faculty.faculty_id` | — | Faculty who recorded it. |
| `created_at` | `DATETIME` | No | — | `CURRENT_TIMESTAMP` | Row creation time. |

**Unique key:** `(enrolment_id, attendance_date)`.

---

## 11. `internal_assessments`

| Column | Type | Null | Key / Constraint | Default | Description |
|---|---|---|---|---|---|
| `assessment_id` | `INT UNSIGNED` | No | PK, auto-increment | — | Surrogate identifier. |
| `subject_id` | `INT UNSIGNED` | No | FK → `subjects.subject_id` | — | Subject assessed. |
| `semester_id` | `INT UNSIGNED` | No | FK → `semesters.semester_id` | — | Term of assessment. |
| `assessment_name` | `VARCHAR(80)` | No | UK with subject and semester | — | e.g. `Quiz 1`, `Assignment`. |
| `max_marks` | `DECIMAL(6,2)` | No | `CHECK (max_marks > 0)` | — | Maximum possible marks. |
| `weightage` | `DECIMAL(5,2)` | Yes | `CHECK (weightage BETWEEN 0 AND 100)` | `NULL` | Contribution to internal total. |
| `assessment_date` | `DATE` | Yes | — | `NULL` | Date of assessment. |

**Unique key:** `(subject_id, semester_id, assessment_name)`.

---

## 12. `internal_marks`

| Column | Type | Null | Key / Constraint | Default | Description |
|---|---|---|---|---|---|
| `internal_mark_id` | `BIGINT UNSIGNED` | No | PK, auto-increment | — | Surrogate identifier. |
| `enrolment_id` | `INT UNSIGNED` | No | FK → `enrolments.enrolment_id` | — | Student's enrolment. |
| `assessment_id` | `INT UNSIGNED` | No | FK → `internal_assessments.assessment_id` | — | Assessment. |
| `obtained_marks` | `DECIMAL(6,2)` | No | `CHECK (obtained_marks >= 0)` | — | Score obtained. |
| `entered_by` | `INT UNSIGNED` | Yes | FK → `faculty.faculty_id` | `NULL` | Faculty who entered it. |
| `entered_at` | `DATETIME` | No | — | `CURRENT_TIMESTAMP` | Entry time. |

**Unique key:** `(enrolment_id, assessment_id)`.

**Note:** The upper bound (`obtained_marks <= max_marks`) references another table, so it may need a trigger or application validation. It cannot be a simple `CHECK` in MySQL. This is decided in Stage 6.

---

## 13. `semester_exams`

| Column | Type | Null | Key / Constraint | Default | Description |
|---|---|---|---|---|---|
| `exam_id` | `INT UNSIGNED` | No | PK, auto-increment | — | Surrogate identifier. |
| `subject_id` | `INT UNSIGNED` | No | FK → `subjects.subject_id` | — | Subject examined. |
| `semester_id` | `INT UNSIGNED` | No | FK → `semesters.semester_id` | — | Term of exam. |
| `exam_type` | `ENUM('theory','practical','project','viva')` | No | UK with subject and semester | — | Type of exam. |
| `max_marks` | `DECIMAL(6,2)` | No | `CHECK (max_marks > 0)` | — | Maximum possible marks. |
| `exam_date` | `DATE` | Yes | — | `NULL` | Date of exam. |

**Unique key:** `(subject_id, semester_id, exam_type)`.

---

## 14. `semester_marks`

| Column | Type | Null | Key / Constraint | Default | Description |
|---|---|---|---|---|---|
| `semester_mark_id` | `BIGINT UNSIGNED` | No | PK, auto-increment | — | Surrogate identifier. |
| `enrolment_id` | `INT UNSIGNED` | No | FK → `enrolments.enrolment_id` | — | Student's enrolment. |
| `exam_id` | `INT UNSIGNED` | No | FK → `semester_exams.exam_id` | — | Exam. |
| `obtained_marks` | `DECIMAL(6,2)` | No | `CHECK (obtained_marks >= 0)` | — | Score obtained. |
| `entered_by` | `INT UNSIGNED` | Yes | FK → `faculty.faculty_id` | `NULL` | Faculty who entered it. |
| `entered_at` | `DATETIME` | No | — | `CURRENT_TIMESTAMP` | Entry time. |

**Unique key:** `(enrolment_id, exam_id)`.

**Note:** The upper bound references `semester_exams.max_marks`, so it is enforced by a trigger or application validation.

---

## 15. `fee_structure`

| Column | Type | Null | Key / Constraint | Default | Description |
|---|---|---|---|---|---|
| `fee_structure_id` | `INT UNSIGNED` | No | PK, auto-increment | — | Surrogate identifier. |
| `course_id` | `INT UNSIGNED` | No | FK → `courses.course_id` | — | Course the fee applies to. |
| `semester_number` | `TINYINT UNSIGNED` | No | `CHECK (semester_number > 0)` | — | Term number. |
| `fee_type` | `ENUM('tuition','exam','library','lab','other')` | No | UK with course, term, year | — | Category. |
| `amount` | `DECIMAL(10,2)` | No | `CHECK (amount >= 0)` | — | Amount due. |
| `due_date` | `DATE` | Yes | — | `NULL` | Payment deadline. |
| `academic_year` | `VARCHAR(9)` | No | UK with course, term, type | — | e.g. `2026-27`. |

**Unique key:** `(course_id, semester_number, fee_type, academic_year)`.

---

## 16. `fee_payments`

| Column | Type | Null | Key / Constraint | Default | Description |
|---|---|---|---|---|---|
| `payment_id` | `BIGINT UNSIGNED` | No | PK, auto-increment | — | Surrogate identifier. |
| `student_id` | `INT UNSIGNED` | No | FK → `students.student_id` | — | Paying student. |
| `fee_structure_id` | `INT UNSIGNED` | No | FK → `fee_structure.fee_structure_id` | — | Fee item paid. |
| `amount_paid` | `DECIMAL(10,2)` | No | `CHECK (amount_paid > 0)` | — | Amount paid. |
| `payment_date` | `DATE` | No | — | — | Date of payment. |
| `method` | `ENUM('cash','card','upi','bank_transfer','other')` | No | — | — | Payment method. |
| `reference_no` | `VARCHAR(50)` | Yes | UK | `NULL` | Receipt or transaction reference. |
| `status` | `ENUM('pending','completed','failed','refunded')` | No | — | `'completed'` | Payment state. |
| `notes` | `TEXT` | Yes | — | `NULL` | Optional note. |
| `created_at` | `DATETIME` | No | — | `CURRENT_TIMESTAMP` | Row creation time. |

**Note:** A payment is recorded inside a transaction. `status` supports refunds and failed attempts.

---

## 17. `feedback`

| Column | Type | Null | Key / Constraint | Default | Description |
|---|---|---|---|---|---|
| `feedback_id` | `BIGINT UNSIGNED` | No | PK, auto-increment | — | Surrogate identifier. |
| `student_id` | `INT UNSIGNED` | No | FK → `students.student_id` | — | Student submitting. |
| `subject_id` | `INT UNSIGNED` | No | FK → `subjects.subject_id` | — | Subject reviewed. |
| `faculty_id` | `INT UNSIGNED` | No | FK → `faculty.faculty_id` | — | Faculty reviewed. |
| `semester_id` | `INT UNSIGNED` | No | FK → `semesters.semester_id` | — | Term of feedback. |
| `rating` | `TINYINT UNSIGNED` | No | `CHECK (rating BETWEEN 1 AND 5)` | — | 1–5 score. |
| `comments` | `TEXT` | Yes | — | `NULL` | Optional comment. |
| `submitted_at` | `DATETIME` | No | — | `CURRENT_TIMESTAMP` | Submission time. |

**Unique key:** `(student_id, subject_id, semester_id)`.

---

## 18. `roles`

| Column | Type | Null | Key / Constraint | Default | Description |
|---|---|---|---|---|---|
| `role_id` | `TINYINT UNSIGNED` | No | PK, auto-increment | — | Surrogate identifier. |
| `role_name` | `VARCHAR(30)` | No | UK | — | `admin`, `faculty`, `student`. |
| `description` | `VARCHAR(150)` | Yes | — | `NULL` | Human-readable description. |

---

## 19. `users`

| Column | Type | Null | Key / Constraint | Default | Description |
|---|---|---|---|---|---|
| `user_id` | `INT UNSIGNED` | No | PK, auto-increment | — | Surrogate identifier. |
| `username` | `VARCHAR(50)` | No | UK | — | Login name. |
| `email` | `VARCHAR(150)` | No | UK | — | Login email. |
| `password_hash` | `VARCHAR(255)` | No | — | — | Hashed password, never plaintext. |
| `role_id` | `TINYINT UNSIGNED` | No | FK → `roles.role_id` | — | Permission role. |
| `student_id` | `INT UNSIGNED` | Yes | FK → `students.student_id`, UK | `NULL` | Optional student link. |
| `faculty_id` | `INT UNSIGNED` | Yes | FK → `faculty.faculty_id`, UK | `NULL` | Optional faculty link. |
| `is_active` | `BOOLEAN` | No | `CHECK (is_active IN (0,1))` | `TRUE` | Account status. |
| `last_login_at` | `DATETIME` | Yes | — | `NULL` | Last successful login. |
| `created_at` | `DATETIME` | No | — | `CURRENT_TIMESTAMP` | Account creation time. |

**Constraint:** `CHECK (student_id IS NULL OR faculty_id IS NULL)` — a user links to at most one person.

---

## 20. Summary of keys

| Table | Primary key | Unique keys |
|---|---|---|
| `departments` | `department_id` | `department_code` |
| `courses` | `course_id` | `course_code` |
| `semesters` | `semester_id` | `(course_id, semester_number, academic_year)` |
| `subjects` | `subject_id` | `(course_id, subject_code)` |
| `faculty` | `faculty_id` | `employee_code`, `email` |
| `students` | `student_id` | `admission_no`, `email` |
| `faculty_subject_assignments` | `assignment_id` | `(faculty_id, subject_id, semester_id)` |
| `enrolments` | `enrolment_id` | `(student_id, subject_id, semester_id)` |
| `attendance` | `attendance_id` | `(enrolment_id, attendance_date)` |
| `internal_assessments` | `assessment_id` | `(subject_id, semester_id, assessment_name)` |
| `internal_marks` | `internal_mark_id` | `(enrolment_id, assessment_id)` |
| `semester_exams` | `exam_id` | `(subject_id, semester_id, exam_type)` |
| `semester_marks` | `semester_mark_id` | `(enrolment_id, exam_id)` |
| `fee_structure` | `fee_structure_id` | `(course_id, semester_number, fee_type, academic_year)` |
| `fee_payments` | `payment_id` | `reference_no` (when present) |
| `feedback` | `feedback_id` | `(student_id, subject_id, semester_id)` |
| `roles` | `role_id` | `role_name` |
| `users` | `user_id` | `username`, `email`, `student_id`, `faculty_id` |

---

## 21. Change rule

If a column, type, or key changes during Stage 3:

1. Update this file.
2. Update `DATABASE_DESIGN.md` and `ER_DIAGRAM.md`.
3. Add a new migration; never edit an applied one.
4. Record the change in `CHANGELOG.md`.
