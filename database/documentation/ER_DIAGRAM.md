# GM University Management System — ER Diagram

> **Status: PLANNING.** This is a proposed model. It has not been reviewed or approved.
> **Do not create tables from this diagram yet.**

---

## 1. How to read this diagram

- `||--o{` means **one to zero-or-many** (one department has many courses).
- `||--||` means **one to exactly one**.
- `}o--o{` means **many to many** (resolved later with a junction table).
- The label on the line is the relationship verb.

This diagram shows entities and relationships. Columns are summarized; the full column list is in `DATA_DICTIONARY.md`.

---

## 2. Entity–relationship diagram

```mermaid
erDiagram
    DEPARTMENTS ||--o{ COURSES : offers
    DEPARTMENTS ||--o{ FACULTY : employs
    DEPARTMENTS ||--o{ STUDENTS : hosts

    COURSES ||--o{ SEMESTERS : runs
    COURSES ||--o{ SUBJECTS : includes
    COURSES ||--o{ STUDENTS : enrols
    COURSES ||--o{ FEE_STRUCTURE : prices

    SEMESTERS ||--o{ FACULTY_SUBJECT_ASSIGNMENTS : schedules
    SEMESTERS ||--o{ ENROLMENTS : runs
    SEMESTERS ||--o{ FEEDBACK : contextualises

    SUBJECTS ||--o{ FACULTY_SUBJECT_ASSIGNMENTS : assigned_to
    SUBJECTS ||--o{ ENROLMENTS : taken_in
    SUBJECTS ||--o{ INTERNAL_ASSESSMENTS : defines
    SUBJECTS ||--o{ SEMESTER_EXAMS : defines
    SUBJECTS ||--o{ FEEDBACK : receives

    FACULTY ||--o{ FACULTY_SUBJECT_ASSIGNMENTS : teaches
    FACULTY ||--o{ FEEDBACK : receives

    STUDENTS ||--o{ ENROLMENTS : registers
    STUDENTS ||--o{ FEE_PAYMENTS : pays
    STUDENTS ||--o{ FEEDBACK : submits

    ENROLMENTS ||--o{ ATTENDANCE : has
    ENROLMENTS ||--o{ INTERNAL_MARKS : earns
    ENROLMENTS ||--o{ SEMESTER_MARKS : earns

    INTERNAL_ASSESSMENTS ||--o{ INTERNAL_MARKS : graded_by
    SEMESTER_EXAMS ||--o{ SEMESTER_MARKS : graded_by

    FEE_STRUCTURE ||--o{ FEE_PAYMENTS : settled_by

    ROLES ||--o{ USERS : grants
    STUDENTS ||--o| USERS : may_have
    FACULTY ||--o| USERS : may_have

    DEPARTMENTS {
        int department_id PK
        varchar department_code UK
        varchar department_name
        varchar hod_name
    }

    COURSES {
        int course_id PK
        varchar course_code UK
        varchar course_name
        int department_id FK
        int duration_years
    }

    SEMESTERS {
        int semester_id PK
        int course_id FK
        int semester_number
        varchar academic_year
        date start_date
        date end_date
    }

    SUBJECTS {
        int subject_id PK
        varchar subject_code
        varchar subject_name
        int course_id FK
        int semester_number
        int credits
    }

    FACULTY {
        int faculty_id PK
        varchar employee_code UK
        varchar full_name
        varchar email UK
        int department_id FK
        varchar designation
    }

    STUDENTS {
        int student_id PK
        varchar admission_no UK
        varchar full_name
        varchar email UK
        int department_id FK
        int course_id FK
        int current_semester
        boolean is_active
    }

    FACULTY_SUBJECT_ASSIGNMENTS {
        int assignment_id PK
        int faculty_id FK
        int subject_id FK
        int semester_id FK
        date assigned_on
    }

    ENROLMENTS {
        int enrolment_id PK
        int student_id FK
        int subject_id FK
        int semester_id FK
        date enrolled_on
    }

    ATTENDANCE {
        int attendance_id PK
        int enrolment_id FK
        date attendance_date
        varchar status
        int recorded_by FK
    }

    INTERNAL_ASSESSMENTS {
        int assessment_id PK
        int subject_id FK
        int semester_id FK
        varchar assessment_name
        decimal max_marks
    }

    INTERNAL_MARKS {
        int internal_mark_id PK
        int enrolment_id FK
        int assessment_id FK
        decimal obtained_marks
    }

    SEMESTER_EXAMS {
        int exam_id PK
        int subject_id FK
        int semester_id FK
        varchar exam_type
        decimal max_marks
    }

    SEMESTER_MARKS {
        int semester_mark_id PK
        int enrolment_id FK
        int exam_id FK
        decimal obtained_marks
    }

    FEE_STRUCTURE {
        int fee_structure_id PK
        int course_id FK
        int semester_number
        varchar fee_type
        decimal amount
        date due_date
    }

    FEE_PAYMENTS {
        int payment_id PK
        int student_id FK
        int fee_structure_id FK
        decimal amount_paid
        date payment_date
        varchar method
        varchar reference_no
        varchar status
    }

    FEEDBACK {
        int feedback_id PK
        int student_id FK
        int subject_id FK
        int faculty_id FK
        int semester_id FK
        int rating
        text comments
        datetime submitted_at
    }

    ROLES {
        int role_id PK
        varchar role_name UK
    }

    USERS {
        int user_id PK
        varchar username UK
        varchar email UK
        varchar password_hash
        int role_id FK
        int student_id FK
        int faculty_id FK
        boolean is_active
    }
```

---

## 3. Entity summary

| Entity | What it represents | Why it exists |
|---|---|---|
| Department | An academic department | Groups courses, faculty, and students. |
| Course | A programme offered by a department | Groups semesters, subjects, and students. |
| Semester | A course term in an academic year | Anchors subjects, enrolments, and assignments. |
| Subject | A unit of study | The thing students are enrolled in and graded on. |
| Faculty | A teacher | Teaches subjects and receives feedback. |
| Student | A learner | The central person in the system. |
| Faculty–Subject Assignment | Who teaches what, when | Connects faculty to subjects and semesters. |
| Enrolment | A student taking a subject | The anchor for attendance and marks. |
| Attendance | Presence for one enrolment on one date | Tracks participation. |
| Internal Assessment | A component of internal marks | Defines the maximum and name. |
| Internal Mark | A student's score on a component | Stores internal performance. |
| Semester Exam | An end-of-term exam definition | Defines the exam and maximum. |
| Semester Mark | A student's exam score | Stores exam performance. |
| Fee Structure | The amount due for a course/semester | Defines what a student owes. |
| Fee Payment | A payment made by a student | Tracks money received. |
| Feedback | A student's rating and comment | Collects qualitative input. |
| Role | A permission group | Supports role-based access. |
| User | A login account | Connects a person to a role. |

---

## 4. Open design questions

These are intentionally unresolved in the planning phase:

1. Is a semester a global term or a per-course term? The diagram assumes per-course.
2. Should `students.current_semester` be a number or a foreign key to `semesters`? The diagram uses a number for simplicity.
3. Can a subject belong to more than one course? The diagram assumes one course.
4. Can a faculty member be assigned to the same subject in multiple semesters? The diagram allows it through `semester_id`.
5. Should feedback be anonymous? The diagram links it to a student.
6. Should users be linked to both students and faculty, or use a single person table? The diagram allows optional links.
7. What is the exact delete policy for historical records? The diagram does not fix it.
8. Is `fee_structure` per course/semester or per student? The diagram assumes per course/semester.

These questions are answered in Stage 3 after user review.

---

## 5. Approval

| Item | Status |
|---|---|
| Draft created | Yes (Stage 0 planning) |
| Reviewed by user | No |
| Approved for implementation | No |

Until approved, the schema remains **PLANNING**.
