# NEXUS — Table Relationships

> **Status: PLANNING.** Proposed relationships. Not approved.
> **Read with:** `ER_DIAGRAM.md` and `DATABASE_DESIGN.md`.

---

## 1. Relationship table

| # | Parent | Child | Foreign key | Cardinality | On delete | On update | Meaning |
|---|---|---|---|---|---|---|---|
| 1 | `departments` | `courses` | `courses.department_id` | 1 : N | `RESTRICT` | `CASCADE` | A department offers many courses. |
| 2 | `departments` | `faculty` | `faculty.department_id` | 1 : N | `RESTRICT` | `CASCADE` | A department employs many faculty. |
| 3 | `departments` | `students` | `students.department_id` | 1 : N | `RESTRICT` | `CASCADE` | A department hosts many students. |
| 4 | `courses` | `semesters` | `semesters.course_id` | 1 : N | `RESTRICT` | `CASCADE` | A course runs many semesters. |
| 5 | `courses` | `subjects` | `subjects.course_id` | 1 : N | `RESTRICT` | `CASCADE` | A course includes many subjects. |
| 6 | `courses` | `students` | `students.course_id` | 1 : N | `RESTRICT` | `CASCADE` | A course enrols many students. |
| 7 | `courses` | `fee_structure` | `fee_structure.course_id` | 1 : N | `RESTRICT` | `CASCADE` | A course has fee items. |
| 8 | `semesters` | `faculty_subject_assignments` | `faculty_subject_assignments.semester_id` | 1 : N | `RESTRICT` | `CASCADE` | A semester schedules many assignments. |
| 9 | `semesters` | `enrolments` | `enrolments.semester_id` | 1 : N | `RESTRICT` | `CASCADE` | A semester has many enrolments. |
| 10 | `semesters` | `feedback` | `feedback.semester_id` | 1 : N | `RESTRICT` | `CASCADE` | Feedback is tied to a semester. |
| 11 | `subjects` | `faculty_subject_assignments` | `faculty_subject_assignments.subject_id` | 1 : N | `RESTRICT` | `CASCADE` | A subject is taught by many assignments. |
| 12 | `subjects` | `enrolments` | `enrolments.subject_id` | 1 : N | `RESTRICT` | `CASCADE` | A subject has many enrolments. |
| 13 | `subjects` | `internal_assessments` | `internal_assessments.subject_id` | 1 : N | `RESTRICT` | `CASCADE` | A subject defines assessments. |
| 14 | `subjects` | `semester_exams` | `semester_exams.subject_id` | 1 : N | `RESTRICT` | `CASCADE` | A subject defines exams. |
| 15 | `subjects` | `feedback` | `feedback.subject_id` | 1 : N | `RESTRICT` | `CASCADE` | Feedback is about a subject. |
| 16 | `faculty` | `faculty_subject_assignments` | `faculty_subject_assignments.faculty_id` | 1 : N | `RESTRICT` | `CASCADE` | A faculty member has many assignments. |
| 17 | `faculty` | `feedback` | `feedback.faculty_id` | 1 : N | `RESTRICT` | `CASCADE` | Feedback can name a faculty member. |
| 18 | `faculty` | `attendance` | `attendance.recorded_by` | 1 : N | `RESTRICT` | `CASCADE` | Faculty records attendance. |
| 19 | `students` | `enrolments` | `enrolments.student_id` | 1 : N | `RESTRICT` | `CASCADE` | A student has many enrolments. |
| 20 | `students` | `fee_payments` | `fee_payments.student_id` | 1 : N | `RESTRICT` | `CASCADE` | A student makes many payments. |
| 21 | `students` | `feedback` | `feedback.student_id` | 1 : N | `RESTRICT` | `CASCADE` | A student submits feedback. |
| 22 | `enrolments` | `attendance` | `attendance.enrolment_id` | 1 : N | `RESTRICT` | `CASCADE` | An enrolment has attendance rows. |
| 23 | `enrolments` | `internal_marks` | `internal_marks.enrolment_id` | 1 : N | `RESTRICT` | `CASCADE` | An enrolment earns internal marks. |
| 24 | `enrolments` | `semester_marks` | `semester_marks.enrolment_id` | 1 : N | `RESTRICT` | `CASCADE` | An enrolment earns exam marks. |
| 25 | `internal_assessments` | `internal_marks` | `internal_marks.assessment_id` | 1 : N | `RESTRICT` | `CASCADE` | An assessment has many marks. |
| 26 | `semester_exams` | `semester_marks` | `semester_marks.exam_id` | 1 : N | `RESTRICT` | `CASCADE` | An exam has many marks. |
| 27 | `fee_structure` | `fee_payments` | `fee_payments.fee_structure_id` | 1 : N | `RESTRICT` | `CASCADE` | A fee item has many payments. |
| 28 | `roles` | `users` | `users.role_id` | 1 : N | `RESTRICT` | `CASCADE` | A role is assigned to many users. |
| 29 | `students` | `users` | `users.student_id` | 1 : 0..1 | `SET NULL` | `CASCADE` | A student may have a login. |
| 30 | `faculty` | `users` | `users.faculty_id` | 1 : 0..1 | `SET NULL` | `CASCADE` | A faculty member may have a login. |

---

## 2. Why these relationships exist

### 2.1 Department → Course

A department is the academic home of a course. A course belongs to exactly one department. This is a classic one-to-many relationship.

### 2.2 Course → Semester → Subject

A course runs over several semesters. Subjects are defined within a course and offered in a semester. `semesters` exists so that enrolments, assignments, and feedback can refer to a specific term in a specific academic year.

### 2.3 Student → Enrolment → Subject

A student enrols in subjects. The `enrolments` table is the junction that resolves the many-to-many relationship between students and subjects. It also carries the semester, which is why it is not just a simple two-column junction.

### 2.4 Enrolment → Attendance / Marks

Attendance and marks belong to an enrolment, not directly to a student or a subject. This ensures that a mark is always tied to a valid student–subject–semester combination.

### 2.5 Faculty → Assignment → Subject

A faculty member can teach several subjects, and a subject can be taught by several faculty members over time. `faculty_subject_assignments` records who teaches what, in which semester.

### 2.6 Student → Fee Payment → Fee Structure

A payment is made by a student against a fee item. This lets the system calculate outstanding amounts and keep a payment history.

### 2.7 Student → Feedback → Subject / Faculty

Feedback is submitted by a student about a subject and optionally a faculty member in a semester. The unique key prevents duplicate feedback for the same subject in the same term.

### 2.8 Role → User → Person

A user account has one role. It may be linked to a student or a faculty record. Administrators may not need a person link.

---

## 3. Many-to-many relationships

| Relationship | Junction table | Extra attributes |
|---|---|---|
| Student ↔ Subject | `enrolments` | `semester_id`, `enrolled_on` |
| Faculty ↔ Subject | `faculty_subject_assignments` | `semester_id`, `assigned_on` |
| Student ↔ Fee Structure | `fee_payments` | `amount_paid`, `payment_date`, `method`, `reference_no`, `status` |

These are not simple junctions; they carry data of their own, which is why they have surrogate primary keys.

---

## 4. Referential integrity rules

- A child row cannot reference a missing parent.
- Deleting a parent is blocked while children exist, unless the relationship is explicitly `SET NULL` (only for the optional user links).
- Updating a primary key cascades to children. In practice, surrogate keys rarely change.
- Historical records (marks, payments, attendance, feedback) are protected by `RESTRICT`.

---

## 5. Open questions

1. Should `attendance.recorded_by` reference `faculty` or `users`? The diagram uses `faculty`.
2. Should `feedback.faculty_id` be required or optional? The diagram allows it to be required.
3. Should `users` have a single `person_id` instead of two optional links?
4. Should soft deletes be used for students and faculty instead of hard deletes?
5. Should fee payments support partial payments against one fee item? The diagram allows many payments per fee item.

These are resolved in Stage 3.
