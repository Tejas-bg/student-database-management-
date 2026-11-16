# GM University Management System — ER Diagram (Stage 3)

> **Status:** Design complete, corrections applied for review. **Not executed.** No live database created or connected.
> **Format:** Mermaid ER diagram source. Render in a Mermaid-compatible viewer/editor.
> **Authoritative schema:** `database/schema/001_schema.sql`. This diagram mirrors every foreign key in that file.

## Cardinality legend
- `||--||` one-to-one (mandatory)
- `||--o|` one-to-zero-or-one
- `||--o{` one-to-many
- `}o--o{` many-to-many (resolved by junction tables in the relational schema)

## Mermaid ER diagram

```mermaid
erDiagram
    roles ||--o{ users : "has"
    users ||--o{ password_reset_tokens : "requests"
    users ||--o| students : "account for"
    users ||--o| faculty : "account for"
    users ||--o{ attendance_sessions : "creates"
    users ||--o{ attendance_records : "marks"
    users ||--o{ internal_marks : "enters"
    users ||--o{ semester_marks : "enters"
    users ||--o{ fee_payments : "records"
    users ||--o{ notifications : "sends"
    users ||--o{ notifications : "receives"
    users ||--o{ notification_reads : "reads"
    users ||--o{ feedback : "reviews"

    departments ||--o{ courses : "offers"
    departments ||--o{ subjects : "owns"
    departments ||--o{ students : "enrols"
    departments ||--o{ faculty : "employs"

    courses ||--o{ subjects : "includes"
    courses ||--o{ semesters : "runs"
    courses ||--o{ students : "admits"
    courses ||--o{ fee_structures : "charges"

    academic_years ||--o{ semesters : "contains"
    academic_years ||--o{ fee_structures : "applies to"

    semesters ||--o{ faculty_subject_assignments : "schedules"
    semesters ||--o{ student_enrolments : "registers"
    semesters ||--o{ timetable_entries : "timetables"
    semesters ||--o{ internal_assessments : "assesses"
    semesters ||--o{ semester_exams : "examines"
    semesters ||--o{ feedback : "context"

    subjects ||--o{ faculty_subject_assignments : "assigned as"
    subjects ||--o{ student_enrolments : "taken in"
    subjects ||--o{ timetable_entries : "taught in"
    subjects ||--o{ internal_assessments : "has"
    subjects ||--o{ semester_exams : "has"
    subjects ||--o{ feedback : "receives"

    faculty ||--o{ faculty_subject_assignments : "teaches"
    faculty ||--o{ timetable_entries : "scheduled"
    faculty ||--o{ feedback : "receives"

    students ||--o{ student_enrolments : "enrols"
    students ||--o{ fee_payments : "pays"
    students ||--o{ feedback : "submits"

    faculty_subject_assignments ||--o{ attendance_sessions : "conducts"
    faculty_subject_assignments ||--o{ timetable_entries : "schedules"
    student_enrolments ||--o{ attendance_records : "marked for"

    attendance_sessions ||--o{ attendance_records : "contains"

    internal_assessments ||--o{ internal_marks : "produces"
    student_enrolments ||--o{ internal_marks : "earns"
    semester_exams ||--o{ semester_marks : "produces"
    student_enrolments ||--o{ semester_marks : "earns"

    fee_structures ||--o{ fee_payments : "paid against"
    notifications ||--o{ notification_reads : "read state"

    roles {
      tinyint role_id PK
      varchar role_code UK
      varchar role_name
      varchar description
    }
    users {
      int user_id PK
      tinyint role_id FK
      varchar login_identifier UK
      varchar email UK
      varchar password_hash
      enum account_status
      bool is_active
      bool must_change_password
      tinyint failed_login_attempts
      datetime last_login_at
    }
    password_reset_tokens {
      bigint token_id PK
      int user_id FK
      char token_hash UK
      datetime expires_at
      datetime used_at
    }
    departments {
      int department_id PK
      varchar department_code UK
      varchar department_name UK
      varchar hod_name
      enum status
    }
    courses {
      int course_id PK
      int department_id FK
      varchar course_code UK
      varchar course_name
      enum level
      tinyint duration_semesters
      enum status
    }
    academic_years {
      int academic_year_id PK
      varchar year_label UK
      date start_date
      date end_date
      bool is_current
      enum status
    }
    semesters {
      int semester_id PK
      int course_id FK
      int academic_year_id FK
      tinyint semester_number
      varchar term_label
      enum status
    }
    subjects {
      int subject_id PK
      int course_id FK
      int department_id FK
      tinyint semester_number
      varchar subject_code UK
      varchar subject_name
      enum subject_type
      tinyint credits
      enum status
    }
    students {
      int student_id PK
      int user_id FK_UK
      int department_id FK
      int course_id FK
      varchar usn UK
      varchar first_name
      varchar last_name
      date date_of_birth
      varchar email UK
      year admission_year
      tinyint current_semester
      enum status
    }
    faculty {
      int faculty_id PK
      int user_id FK_UK
      int department_id FK
      varchar employee_id UK
      varchar first_name
      varchar last_name
      varchar designation
      varchar email UK
      enum status
    }
    faculty_subject_assignments {
      int assignment_id PK
      int faculty_id FK
      int subject_id FK
      int semester_id FK
      varchar section
      date assigned_on
      bool is_active
    }
    student_enrolments {
      int enrolment_id PK
      int student_id FK
      int subject_id FK
      int semester_id FK
      varchar section
      date enrolment_date
      enum status
    }
    timetable_entries {
      int timetable_id PK
      int subject_id FK
      int faculty_id FK
      int semester_id FK
      varchar section
      enum day_of_week
      time start_time
      time end_time
      varchar room_no
      enum class_type
      enum status
    }
    attendance_sessions {
      int session_id PK
      int assignment_id FK
      date session_date
      time start_time
      varchar topic
      enum session_type
      int created_by_user_id FK
    }
    attendance_records {
      bigint attendance_id PK
      int session_id FK
      int enrolment_id FK
      enum status
      varchar remarks
      int marked_by_user_id FK
    }
    internal_assessments {
      int assessment_id PK
      int subject_id FK
      int semester_id FK
      varchar assessment_name
      decimal max_marks
      decimal weightage_percent
    }
    internal_marks {
      bigint internal_mark_id PK
      int assessment_id FK
      int enrolment_id FK
      decimal marks_obtained
      int entered_by_user_id FK
    }
    semester_exams {
      int exam_id PK
      int subject_id FK
      int semester_id FK
      varchar exam_name
      date exam_date
      decimal max_marks
      decimal passing_marks
    }
    semester_marks {
      bigint semester_mark_id PK
      int exam_id FK
      int enrolment_id FK
      decimal marks_obtained
      varchar grade
      decimal grade_point
      enum result_status
      int entered_by_user_id FK
    }
    fee_structures {
      int fee_structure_id PK
      int course_id FK
      int academic_year_id FK
      tinyint semester_number
      varchar fee_head
      decimal amount
      date due_date
    }
    fee_payments {
      bigint payment_id PK
      int student_id FK
      int fee_structure_id FK
      decimal amount_paid
      date payment_date
      enum payment_mode
      varchar transaction_ref UK
      varchar receipt_no UK
      enum payment_status
      int recorded_by_user_id FK
    }
    notifications {
      bigint notification_id PK
      int sender_user_id FK
      enum target_role
      int target_user_id FK
      varchar title
      text message
      enum category
      enum priority
      bool is_published
      datetime published_at
    }
    notification_reads {
      bigint read_id PK
      bigint notification_id FK
      int user_id FK
      datetime read_at
    }
    feedback {
      bigint feedback_id PK
      int student_id FK
      int subject_id FK
      int faculty_id FK
      int semester_id FK
      enum category
      tinyint rating
      text comments
      bool is_anonymous
      enum status
      int reviewed_by_user_id FK
    }
```

## Relationship notes
- **1:1 (optional):** `users` ↔ `students` and `users` ↔ `faculty` via nullable unique `students.user_id` / `faculty.user_id`. A user can be admin-only (no person row), or linked to exactly one student/faculty record.
- **1:N:** Most entities follow strict ownership (department→courses, course→subjects, student→enrolments, etc.).
- **M:N (resolved):** student↔subject via `student_enrolments` (with semester, section, status); faculty↔subject via `faculty_subject_assignments`; student↔notification-read state via `notification_reads`.
- **Two user links to notifications:** `notifications.sender_user_id` is the author and `notifications.target_user_id` is an optional direct recipient. Both are foreign keys to `users.user_id`; the ER shows both lines.
- **Timetable is tied to a teaching assignment:** `timetable_entries(faculty_id, subject_id, semester_id, section)` has a composite foreign key to `faculty_subject_assignments`. A timetable row cannot exist without a matching assignment.
- **Optional FKs:** `notifications.target_user_id`, feedback `subject_id/faculty_id/semester_id`, and user audit references (`created_by_user_id`, `marked_by_user_id`, etc.) are nullable to preserve history and support general/broadcast cases.
- **Cross-table rules enforced by triggers:** attendance vs enrolment, internal marks vs assessment, semester marks vs exam, fee payment vs course, and notification target role vs user role. See `database/triggers/001_integrity_triggers.sql`.
- All enforcing foreign keys use `ON DELETE RESTRICT ON UPDATE CASCADE` except optional/profile links set to `SET NULL` and dependent child records where cascade is appropriate (`password_reset_tokens`, `notification_reads`, `attendance_records` on session delete).

## Relationship count

- **24 entities**
- **51 foreign-key constraints** in `database/schema/001_schema.sql`
- **51 relationship lines** in the Mermaid diagram (one line per FK; the two `users`→`notifications` lines represent the sender and target FKs)
- **8 reporting views** in `database/views/001_views.sql`
- **10 integrity triggers** (5 rules × INSERT/UPDATE) in `database/triggers/001_integrity_triggers.sql`
