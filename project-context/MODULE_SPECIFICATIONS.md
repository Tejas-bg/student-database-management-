# GM University Management System — Module Specifications

> **Status:** Planning. These specifications describe intended behaviour. No module is implemented.
> **Rule:** Each module is built only in its roadmap stage and only after user approval.

---

## 1. Module map

| ID | Module | Primary users | Stage |
|---|---|---|---|
| M01 | Authentication and Roles | All | 4 |
| M02 | Students | Admin, Faculty, Student | 5 |
| M03 | Departments | Admin | 5 |
| M04 | Courses | Admin | 5 |
| M05 | Subjects and Semesters | Admin, Faculty | 5 |
| M06 | Faculty | Admin | 5 |
| M07 | Faculty–Subject Assignments | Admin | 5 |
| M08 | Enrolments | Admin, Faculty, Student | 5 |
| M09 | Attendance | Faculty, Student | 5 |
| M10 | Internal Assessment Marks | Faculty, Student | 5 |
| M11 | Semester Examination Marks | Admin, Faculty, Student | 5 |
| M12 | Academic Performance and Analytics | Faculty, Admin, Student | 5–6 |
| M13 | Fees and Payments | Admin, Student | 5 |
| M14 | Feedback | Student, Admin | 5 |
| M15 | Reports | Admin, Faculty, Student | 5–6 |

---

## 2. Module details

### M01 — Authentication and Roles

**Purpose:** Control who can enter the system and what they can do.

**Inputs:** One common sign-in form: University Login ID and password. There is no role selector.

**Outputs:** Authenticated session, role-aware navigation, safe error messages.

**Rules:**

- One login page serves students, faculty, and administrators.
- The backend determines the role from the registered MySQL account, never from the login ID format or frontend JavaScript.
- Passwords are hashed.
- Login errors do not reveal whether an account exists.
- Protected routes check the role on the server.
- Logout clears the session.
- Password reset and "remember me" are not implemented until a secure process exists.
- The Stage 1 login page is a design preview and performs no authentication.

**DB touchpoints:** `users`, `roles` (final names confirmed in Stage 3).

---

### M02 — Students

**Purpose:** Maintain student personal and academic information.

**Inputs:** Name, contact details, date of birth, department, course, semester, admission details.

**Outputs:** Student list, profile page, create/edit forms.

**Rules:**

- Unique admission number and email.
- A student belongs to one department and one course at a time (final cardinality confirmed in Stage 3).
- Deleting a student must respect foreign keys and retention rules.

**DB touchpoints:** `students`, `departments`, `courses`, `semesters`.

---

### M03 — Departments

**Purpose:** Maintain academic departments.

**Inputs:** Department name, code, head of department.

**Outputs:** Department list and detail pages.

**Rules:**

- Department code is unique.
- A department cannot be deleted while courses or faculty reference it.

**DB touchpoints:** `departments`.

---

### M04 — Courses

**Purpose:** Maintain courses offered by departments.

**Inputs:** Course name, code, department, duration.

**Outputs:** Course list and detail pages.

**Rules:**

- Course code is unique.
- A course belongs to a department.
- A course cannot be deleted while subjects or students reference it.

**DB touchpoints:** `courses`, `departments`.

---

### M05 — Subjects and Semesters

**Purpose:** Maintain subjects and the semesters in which they are offered.

**Inputs:** Subject name, code, course, semester number, credits.

**Outputs:** Subject list, semester view.

**Rules:**

- Subject code is unique within a course.
- Semester number is within the valid range for the course.
- A subject cannot be deleted while enrolments or marks reference it.

**DB touchpoints:** `subjects`, `semesters`, `courses`.

---

### M06 — Faculty

**Purpose:** Maintain faculty records.

**Inputs:** Name, contact details, department, designation.

**Outputs:** Faculty list and profile.

**Rules:**

- Email and employee code are unique.
- A faculty member belongs to a department.
- A faculty member cannot be deleted while assignments reference them.

**DB touchpoints:** `faculty`, `departments`.

---

### M07 — Faculty–Subject Assignments

**Purpose:** Record which faculty member teaches which subject in which semester.

**Inputs:** Faculty, subject, academic year/semester.

**Outputs:** Assignment list, faculty workload view.

**Rules:**

- The same faculty–subject–semester combination is not duplicated.
- Only assigned faculty may record attendance or marks for that subject (final rule confirmed in Stage 5).

**DB touchpoints:** `faculty_subject_assignments`, `faculty`, `subjects`, `semesters`.

---

### M08 — Enrolments

**Purpose:** Record which students are enrolled in which subjects.

**Inputs:** Student, subject, academic year/semester.

**Outputs:** Enrolment list, class roster.

**Rules:**

- A student cannot be enrolled twice in the same subject and term.
- A student must exist and the subject must exist.
- Enrolment is the anchor for attendance and marks.

**DB touchpoints:** `enrolments`, `students`, `subjects`, `semesters`.

---

### M09 — Attendance

**Purpose:** Record and view attendance.

**Inputs:** Enrolment, date, status (present/absent/late).

**Outputs:** Attendance register, student attendance percentage.

**Rules:**

- One attendance record per enrolment per date.
- Attendance cannot be recorded for a future date without an explicit allowance.
- Percentage is computed with aggregate SQL.

**DB touchpoints:** `attendance`, `enrolments`.

---

### M10 — Internal Assessment Marks

**Purpose:** Record internal assessment components and marks.

**Inputs:** Enrolment, assessment type, maximum marks, obtained marks.

**Outputs:** Internal marks sheet, student internal total.

**Rules:**

- Obtained marks cannot exceed maximum marks.
- Marks cannot be negative.
- Only assigned faculty can enter marks.

**DB touchpoints:** `internal_assessments`, `internal_marks`, `enrolments`.

---

### M11 — Semester Examination Marks

**Purpose:** Record end-of-semester examination marks.

**Inputs:** Enrolment, exam, maximum marks, obtained marks.

**Outputs:** Semester marks sheet, result view.

**Rules:**

- Obtained marks are within the allowed range.
- Duplicate exam records for the same enrolment are rejected.
- Changes are auditable in a later enhancement.

**DB touchpoints:** `semester_exams`, `semester_marks`, `enrolments`.

---

### M12 — Academic Performance and Analytics

**Purpose:** Combine attendance, internal marks, and semester marks into performance views.

**Inputs:** Existing records.

**Outputs:** Subject-wise performance, semester GPA/percentage, charts.

**Rules:**

- Calculations are defined once and reused.
- Views and aggregate queries are used to demonstrate SQL concepts.
- Charts are accessible and have text summaries.

**DB touchpoints:** reporting views over `attendance`, `internal_marks`, `semester_marks`, `enrolments`.

---

### M13 — Fees and Payments

**Purpose:** Record fee obligations and payments.

**Inputs:** Student, fee type, amount, due date, payment date, method, reference.

**Outputs:** Fee status, payment history, outstanding balance.

**Rules:**

- Money uses `DECIMAL`.
- A payment is recorded inside a transaction.
- `ROLLBACK` and `SAVEPOINT` are demonstrated in a controlled scenario.
- No real payment gateway is integrated.

**DB touchpoints:** `fee_structure`, `fee_payments`, `students`.

---

### M14 — Feedback

**Purpose:** Collect student feedback on subjects and faculty.

**Inputs:** Student, subject, rating, comments.

**Outputs:** Feedback summary and reports.

**Rules:**

- A student submits feedback once per subject per term (final rule confirmed in Stage 5).
- Comments are escaped on output.
- Feedback visibility is limited by role.

**DB touchpoints:** `feedback`, `students`, `subjects`, `faculty`.

---

### M15 — Reports

**Purpose:** Provide operational and analytical reports.

**Inputs:** Filters (department, course, semester, subject, date range).

**Outputs:** Tables, CSV exports, charts.

**Rules:**

- Reports use joins, subqueries, aggregates, and views.
- Reports are read-only.
- Report queries are parameterized.
- Large reports are paginated.

**DB touchpoints:** views and read-only queries.

---

## 3. Module development rules

- Build one module at a time.
- Finish the database part before the route part before the page part.
- Write tests as you go.
- Update this file if behaviour changes.
- Do not mark a module complete until it is tested end to end.
