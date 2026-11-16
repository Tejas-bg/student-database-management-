# GM University Management System — Requirements-to-Table Mapping (Stage 3)

> **Status:** Design mapping complete, corrected, and statically validated. **Not executed.**
> Maps the Stage 2 pages, forms, tables, filters, and planned Stage 4/5 behaviour to the database design.

## 1. Page-to-table mapping

### Student workspace

| Page | Primary tables/views | Notes |
|---|---|---|
| Dashboard overview | `students`, `student_enrolments`, `attendance_records`, `semester_marks`, `fee_payments`, `notifications`, `timetable_entries` | Aggregated cards via views/queries |
| My profile | `students`, `departments`, `courses`, `users` | `vw_student_profile` |
| My courses | `student_enrolments`, `subjects`, `semesters`, `faculty_subject_assignments`, `faculty` | Enrolled subjects + teachers |
| Attendance | `attendance_records`, `attendance_sessions`, `student_enrolments`, `subjects` | `vw_student_attendance_summary` |
| Internal assessment marks | `internal_marks`, `internal_assessments`, `student_enrolments`, `subjects` | `vw_student_internal_marks` |
| Semester results | `semester_marks`, `semester_exams`, `student_enrolments`, `subjects`, `semesters` | `vw_student_semester_results` |
| Fee details | `fee_structures`, `fee_payments`, `students`, `courses`, `academic_years` | `vw_student_fee_summary` |
| Timetable | `timetable_entries`, `subjects`, `faculty`, `semesters` | Weekly slots |
| Notifications | `notifications`, `notification_reads`, `users` | Role/direct targeting + read state |
| Feedback | `feedback`, `subjects`, `faculty`, `semesters`, `students` | Submit + history |

### Faculty workspace

| Page | Primary tables/views | Notes |
|---|---|---|
| Dashboard overview | `faculty_subject_assignments`, `student_enrolments`, `attendance_records`, `internal_marks`, `semester_marks`, `notifications` | Teaching summary |
| Faculty profile | `faculty`, `departments`, `users` | Profile + account link |
| Assigned subjects | `faculty_subject_assignments`, `subjects`, `semesters`, `courses` | Active allocations |
| Student management | `student_enrolments`, `students`, `subjects`, `semesters` | Class lists |
| Attendance management | `attendance_sessions`, `attendance_records`, `faculty_subject_assignments`, `student_enrolments` | Create session + mark |
| Internal marks entry | `internal_assessments`, `internal_marks`, `student_enrolments` | Enter/update IA marks |
| Semester marks | `semester_exams`, `semester_marks`, `student_enrolments` | Enter/publish results |
| Class performance | `vw_class_performance`, `semester_marks`, `subjects`, `semesters` | Averages/pass rates |
| Reports | `vw_class_performance`, `vw_student_attendance_summary`, `vw_student_semester_results`, `vw_feedback_summary` | Filtered reports |
| Notifications | `notifications`, `notification_reads` | Faculty audience/direct |

### Administration workspace

| Page | Primary tables/views | Notes |
|---|---|---|
| Dashboard overview | Cross-module aggregates | Counts/trends |
| Student management | `students`, `departments`, `courses`, `users` | CRUD + activation |
| Faculty management | `faculty`, `departments`, `users` | CRUD + activation |
| Department management | `departments` | CRUD |
| Course management | `courses`, `departments` | CRUD + duration/level |
| Subject management | `subjects`, `courses`, `departments` | CRUD + credits/type |
| Semester management | `semesters`, `academic_years`, `courses` | Terms and status |
| Enrolment management | `student_enrolments`, `students`, `subjects`, `semesters` | Enrol/drop/complete |
| Attendance management | `attendance_sessions`, `attendance_records`, `faculty_subject_assignments` | Oversight/reporting |
| Marks management | `internal_marks`, `semester_marks`, `internal_assessments`, `semester_exams` | Oversight/correction |
| Fee management | `fee_structures`, `fee_payments`, `students`, `courses` | Structures + payments |
| Feedback management | `feedback`, `subjects`, `faculty`, `students` | Review/archive/summaries |
| Reports and analytics | All reporting views | Department/course/semester/subject/date filters |
| User and role management | `users`, `roles`, `students`, `faculty`, `password_reset_tokens` | Accounts/status/role links |

## 2. Form-field-to-column mapping

| Form / action | Fields | Target columns |
|---|---|---|
| Login (future) | login identifier, password | `users.login_identifier`, `users.password_hash`, `role_id`, `is_active` |
| Add/edit student | name, USN, email, department, course, admission year, semester | `students.*`, `departments.department_id`, `courses.course_id` |
| Add/edit faculty | name, employee ID, department, designation, email | `faculty.*`, `departments.department_id` |
| Add/edit department | name, code, HOD | `departments.department_name/code/hod_name` |
| Add/edit course | name, code, department, level, duration | `courses.*` |
| Add/edit subject | name, code, course, department, semester, type, credits | `subjects.*` |
| Add/edit semester | course, academic year, number, term, dates | `semesters.*`, `academic_years.*` |
| Enrolment | student, subject, semester, section, date | `student_enrolments.*` |
| Attendance session | assignment, date, time, topic, type | `attendance_sessions.*` |
| Attendance mark | enrolment, status, remarks | `attendance_records.*` |
| Internal assessment | subject, semester, name, max marks, weightage, date | `internal_assessments.*` |
| Internal marks | assessment, enrolment, marks, remarks | `internal_marks.*` |
| Semester exam | subject, semester, name, date, max/passing marks | `semester_exams.*` |
| Semester marks | exam, enrolment, marks, grade, grade point, result | `semester_marks.*` |
| Fee structure | course, year, semester, head, amount, due date | `fee_structures.*` |
| Fee payment | student, fee structure, amount, date, mode, reference, receipt | `fee_payments.*` |
| Notification | sender, audience role/user, title, message, category, priority, publish/expiry | `notifications.*` |
| Notification read | notification, user | `notification_reads.*` |
| Feedback | student, subject/faculty/semester, category, rating, comments, anonymity | `feedback.*` |
| User/role | login ID, email, role, status, activation, reset | `users.*`, `roles.*`, `password_reset_tokens.*` |

## 3. Search, filter, and pagination mapping

| UI filter | Column(s) / index |
|---|---|
| Student search (USN/name) | `students.usn`, `students.first_name/last_name`, `idx_students_status` |
| Faculty search (employee ID/name) | `faculty.employee_id`, names, `idx_faculty_department` |
| Department/course/subject search | codes/names with unique indexes |
| Attendance filter by date/department/subject | `attendance_sessions.session_date`, joins + `idx_attendance_enrolment` |
| Marks filter by subject/semester | `internal_assessments.subject_id/semester_id`, `semester_exams.*` |
| Fee filter by student/status | `fee_payments.student_id/payment_status`, `idx_payment_student` |
| Feedback filter by category/status | `feedback.category/status`, `idx_feedback_subject_semester` |
| Notification filter by category/read | `notifications.category`, `notification_reads.user_id` |
| Pagination | `LIMIT/OFFSET` on indexed sort keys (`published_at`, `payment_date`, names) |

## 4. Role-specific data isolation
- Student queries scope by authenticated `students.student_id`.
- Faculty queries scope by `faculty_subject_assignments.faculty_id`.
- Admin queries operate across the institution but remain auditable.
- Role is resolved from `users.role_id`; it is never accepted from the browser.

## 5. Unmapped / future items
- CSV export (Stage 6) reads the same views; no new tables required.
- Audit trail of views/changes (Stage 7) may add an `audit_log` table later.
- File uploads (documents/photos) are not part of Stage 2 UI and are not modelled yet.
- Hostel/library/transport modules are out of scope and intentionally not added.