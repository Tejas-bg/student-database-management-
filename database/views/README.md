# Views

> **Status: PLANNING.** No view has been created.

Views are saved queries used for reporting. They keep complex SQL in one place and make reports easier to explain.

## Planned views

| View | Purpose | Demonstrates |
|---|---|---|
| `vw_student_profile` | Student with department and course names. | Joins |
| `vw_attendance_summary` | Attendance percentage per student per subject. | Aggregates, joins |
| `vw_internal_marks_summary` | Internal totals per student per subject. | Aggregates |
| `vw_semester_results` | Combined internal and semester performance. | Joins, aggregates |
| `vw_fee_status` | Fee due, paid, and outstanding per student. | Aggregates, joins |
| `vw_feedback_summary` | Average rating per subject/faculty. | Aggregates |
| `vw_department_performance` | Department-level performance summary. | Subqueries, aggregates |

## Rules

- Views are read-only by convention.
- Use explicit column lists.
- Name views `vw_<purpose>`.
- Do not embed user input in a view.
- Document each view in `documentation/`.
- Test with representative data.

## Verification

- Create the view on the approved schema.
- Run it and inspect the columns and rows.
- Confirm it matches the documented purpose.
