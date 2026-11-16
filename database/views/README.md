# Views

> **Status: PREPARED — not executed.** No view has been created in MySQL.

Views are saved queries used for reporting. They keep complex SQL in one place and make reports easier to explain.

## Files

| File | Purpose |
|---|---|
| `001_views.sql` | Eight reporting views for profiles, attendance, internal marks, results, fees, faculty workload, class performance, and feedback. |

## Views

| View | Purpose | Demonstrates |
|---|---|---|
| `vw_student_profile` | Student with department, course, and account status. | Joins |
| `vw_student_attendance_summary` | Attendance percentage per student per subject, with held/marked/unmarked session counts. | Aggregates, joins, NULL-safe denominator |
| `vw_student_internal_marks` | Internal assessment marks per student. | Joins, percentage calculation |
| `vw_student_semester_results` | Semester exam results per student. | Joins, grade data |
| `vw_student_fee_summary` | Fee demand, paid, balance, and status per student/academic year/semester. | Aggregates, derived table |
| `vw_faculty_workload` | Faculty assignments with enrolled student counts, matched by section. | Joins, aggregation |
| `vw_class_performance` | Subject-level averages, pass/fail counts. | Aggregates |
| `vw_feedback_summary` | Feedback counts and average ratings by subject/faculty. | Aggregates, LEFT JOINs |

## Calculation rules

- **Attendance:** denominator is the number of `attendance_sessions` held for the student's subject/semester/section assignment, not the number of marked rows. An unmarked held session counts as not attended; `sessions_unmarked` exposes the gap. If no session was held, `attendance_percentage` is NULL.
- **Fees:** demand is the sum of fee structures for the student's course, the semester's academic year, and the semester number. It is not summed across different semesters in the same academic year. Paid is the sum of successful payments against those fee structures.
- **Faculty workload:** enrolments are matched to the assignment by subject, semester, **and section**; the view also exposes `assignment_active` so current workload can be filtered.

## Rules

- Views are read-only by convention.
- Use explicit column lists.
- Name views `vw_<purpose>`.
- Do not embed user input in a view.
- Document each view in `../documentation/`.
- Test with representative data.

## Verification when built

- Create the views on the approved schema.
- Run each view and inspect columns and rows.
- Confirm it matches the documented purpose.
- Record results in `docs/testing/`.
