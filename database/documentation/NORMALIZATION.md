# GM University Management System — Normalization

> **Status: PLANNING.** Proposed normalization analysis. Not reviewed.
> **Target:** Third Normal Form (3NF).

---

## 1. Why normalize?

Normalization removes duplication and update anomalies. If a department name is stored in every student row, renaming the department requires many updates and one missed row creates inconsistent data.

The project targets **3NF** because it is the standard expectation for a college DBMS project and it keeps the schema explainable.

---

## 2. First Normal Form (1NF)

**Rule:** Each column holds a single atomic value, and each row is unique.

### Applied to the GM University Management System

- No column stores a comma-separated list. For example, a student does not have a `subjects` column; enrolments are rows in `enrolments`.
- No repeating groups. A student's marks are rows in `internal_marks` and `semester_marks`, not columns `mark1`, `mark2`, `mark3`.
- Every table has a primary key.
- Phone numbers are stored as one value per row. If multiple phone numbers are needed later, a separate `student_phones` table would be added.

### Example of a 1NF violation (avoided)

| student_id | name | subjects |
|---|---|---|
| 1 | Asha | DBMS, OS, Maths |

This violates 1NF because `subjects` holds multiple values. The normalized form uses `enrolments`.

---

## 3. Second Normal Form (2NF)

**Rule:** The table is in 1NF, and every non-key column depends on the **whole** primary key, not part of it.

2NF only matters when a table has a composite primary key. GM University Management System mostly uses surrogate single-column keys, so most tables are automatically in 2NF. The junction tables are the places to check.

### Example: `enrolments`

Suppose the primary key were `(student_id, subject_id)` and the table stored `student_name` and `subject_name`.

| student_id | subject_id | student_name | subject_name | semester_id |
|---|---|---|---|---|
| 1 | 101 | Asha | DBMS | 3 |

- `student_name` depends only on `student_id` → partial dependency.
- `subject_name` depends only on `subject_id` → partial dependency.

This violates 2NF. The fix is to keep names in `students` and `subjects`, and store only keys and enrolment-specific data in `enrolments`.

### Applied to the GM University Management System

- `students` stores student attributes.
- `subjects` stores subject attributes.
- `enrolments` stores only the relationship and its own attributes (`semester_id`, `enrolled_on`).
- The same pattern applies to `faculty_subject_assignments` and `fee_payments`.

---

## 4. Third Normal Form (3NF)

**Rule:** The table is in 2NF, and no non-key column depends on another non-key column (no transitive dependency).

### Example: `students`

A naive design might store:

| student_id | name | department_id | department_name | course_id | course_name |
|---|---|---|---|---|---|
| 1 | Asha | 10 | Computer Science | 20 | BSc CS |

- `department_name` depends on `department_id`, not directly on `student_id`.
- `course_name` depends on `course_id`, not directly on `student_id`.

This violates 3NF. The fix is to store only `department_id` and `course_id` in `students`, and keep names in `departments` and `courses`.

### Applied to the GM University Management System

- Department names live only in `departments`.
- Course names live only in `courses`.
- Subject names live only in `subjects`.
- Faculty names live only in `faculty`.
- Student names live only in `students`.
- Marks tables store only the obtained marks and keys, not the student name or subject name.
- Fee payments store the amount and keys, not the student name or course name.

### Derived values

Some values are derived but may be stored for reporting convenience:

- Attendance percentage.
- Internal totals.
- Outstanding fee balance.

The baseline prefers computing these with views and aggregate queries rather than storing them. If a stored summary is added for performance, it must be documented and kept consistent; otherwise it reintroduces an update anomaly.

---

## 5. Table-by-table 3NF review

| Table | 1NF | 2NF | 3NF | Notes |
|---|---|---|---|---|
| `departments` | Yes | Yes | Yes | No transitive dependency. |
| `courses` | Yes | Yes | Yes | `department_id` is the only department reference. |
| `semesters` | Yes | Yes | Yes | Depends on course and term. |
| `subjects` | Yes | Yes | Yes | `course_id` and `semester_number` are direct attributes. |
| `faculty` | Yes | Yes | Yes | `department_id` only. |
| `students` | Yes | Yes | Yes | `department_id` and `course_id` only. |
| `faculty_subject_assignments` | Yes | Yes | Yes | Junction with its own attributes. |
| `enrolments` | Yes | Yes | Yes | Junction with `semester_id`. |
| `attendance` | Yes | Yes | Yes | Depends on enrolment and date. |
| `internal_assessments` | Yes | Yes | Yes | Depends on subject and semester. |
| `internal_marks` | Yes | Yes | Yes | Depends on enrolment and assessment. |
| `semester_exams` | Yes | Yes | Yes | Depends on subject and semester. |
| `semester_marks` | Yes | Yes | Yes | Depends on enrolment and exam. |
| `fee_structure` | Yes | Yes | Yes | Depends on course, semester, type. |
| `fee_payments` | Yes | Yes | Yes | Depends on student and fee item. |
| `feedback` | Yes | Yes | Yes | Depends on student, subject, semester. |
| `roles` | Yes | Yes | Yes | Simple lookup. |
| `users` | Yes | Yes | Yes | Role and person links only. |

This is a **proposed** review. It becomes valid only after the final columns are confirmed.

---

## 6. Deliberate exceptions

None at baseline. If a derived column is added later, record:

- what it stores,
- why it is stored,
- how it is kept consistent,
- the ADR that approved it.

---

## 7. What to verify before approval

- [ ] Every table has a primary key.
- [ ] No repeating groups.
- [ ] No partial dependencies in junction tables.
- [ ] No transitive dependencies.
- [ ] Names are stored once.
- [ ] Derived values are computed or explicitly justified.
- [ ] The ER diagram matches the tables.
- [ ] The data dictionary matches the columns.

Until all boxes are checked and the user approves, the schema stays **PLANNING**.
