# GM University Management System — Table Descriptions and Relationships (Stage 3)

> **Status:** Design complete, corrections applied for review. **Not executed.** Relationships are enforced by foreign keys in `database/schema/001_schema.sql`; cross-table rules are enforced by `database/triggers/001_integrity_triggers.sql`.

## 1. Table descriptions

| # | Table | Purpose | Key columns |
|---|---|---|---|
| 1 | roles | RBAC role master | role_id (PK), role_code (UK) |
| 2 | users | Login accounts, status, password hash | user_id (PK), role_id (FK), login_identifier (UK) |
| 3 | password_reset_tokens | Password reset workflow | token_id (PK), user_id (FK), token_hash (UK) |
| 4 | departments | Academic departments | department_id (PK), department_code (UK) |
| 5 | courses | Programmes offered by departments | course_id (PK), department_id (FK), course_code (UK) |
| 6 | academic_years | Academic year windows | academic_year_id (PK), year_label (UK) |
| 7 | semesters | Course-term instances | semester_id (PK), course_id+academic_year_id (FKs) |
| 8 | subjects | Curriculum subjects | subject_id (PK), course_id/department_id (FKs), subject_code (UK) |
| 9 | students | Student personal/academic profile | student_id (PK), user_id (FK,UK), usn (UK) |
| 10 | faculty | Faculty profile | faculty_id (PK), user_id (FK,UK), employee_id (UK) |
| 11 | faculty_subject_assignments | Teaching allocations (M:N) | assignment_id (PK), faculty/subject/semester (FKs) |
| 12 | student_enrolments | Subject registrations (M:N) | enrolment_id (PK), student/subject/semester (FKs), section |
| 13 | timetable_entries | Weekly class schedule | timetable_id (PK), subject/faculty/semester (FKs), composite assignment FK |
| 14 | attendance_sessions | Class session instances | session_id (PK), assignment_id (FK) |
| 15 | attendance_records | Per-student attendance | attendance_id (PK), session_id/enrolment_id (FKs) |
| 16 | internal_assessments | IA definitions | assessment_id (PK), subject_id/semester_id (FKs) |
| 17 | internal_marks | IA marks per enrolment | internal_mark_id (PK), assessment_id/enrolment_id (FKs) |
| 18 | semester_exams | Exam definitions | exam_id (PK), subject_id/semester_id (FKs) |
| 19 | semester_marks | Exam results per enrolment | semester_mark_id (PK), exam_id/enrolment_id (FKs) |
| 20 | fee_structures | Fee demand items | fee_structure_id (PK), course_id/academic_year_id (FKs) |
| 21 | fee_payments | Payment transactions | payment_id (PK), student_id/fee_structure_id (FKs) |
| 22 | notifications | Announcements/messages | notification_id (PK), sender/target user (FKs) |
| 23 | notification_reads | Read receipts per user | read_id (PK), notification_id/user_id (FKs) |
| 24 | feedback | Student feedback | feedback_id (PK), student/subject/faculty/semester (FKs) |

## 2. Relationships and cardinality

| Parent | Child | Type | FK | Mandatory/Optional | On delete/update | Notes |
|---|---|---|---|---|---|---|
| roles | users | 1:N | users.role_id | Mandatory | RESTRICT/CASCADE | Role determines access |
| users | password_reset_tokens | 1:N | token.user_id | Mandatory | CASCADE/CASCADE | Tokens removed with user |
| users | students | 1:0..1 | students.user_id (UK) | Optional | SET NULL/CASCADE | Student may have account |
| users | faculty | 1:0..1 | faculty.user_id (UK) | Optional | SET NULL/CASCADE | Faculty may have account |
| departments | courses | 1:N | courses.department_id | Mandatory | RESTRICT/CASCADE | Course belongs to dept |
| departments | subjects | 1:N | subjects.department_id | Mandatory | RESTRICT/CASCADE | Subject ownership |
| departments | students | 1:N | students.department_id | Mandatory | RESTRICT/CASCADE | Student home dept |
| departments | faculty | 1:N | faculty.department_id | Mandatory | RESTRICT/CASCADE | Faculty home dept |
| courses | students | 1:N | students.course_id | Mandatory | RESTRICT/CASCADE | Admission/programme |
| courses | subjects | 1:N | subjects.course_id | Mandatory | RESTRICT/CASCADE | Curriculum |
| courses | semesters | 1:N | semesters.course_id | Mandatory | RESTRICT/CASCADE | Term instances |
| courses | fee_structures | 1:N | fee_structures.course_id | Mandatory | RESTRICT/CASCADE | Fee heads |
| academic_years | semesters | 1:N | semesters.academic_year_id | Mandatory | RESTRICT/CASCADE | Year scope |
| academic_years | fee_structures | 1:N | fee_structures.academic_year_id | Mandatory | RESTRICT/CASCADE | Year scope |
| semesters | faculty_subject_assignments | 1:N | assignment.semester_id | Mandatory | RESTRICT/CASCADE | Teaching term |
| semesters | student_enrolments | 1:N | enrolment.semester_id | Mandatory | RESTRICT/CASCADE | Registration term |
| semesters | timetable_entries | 1:N | timetable.semester_id | Mandatory | RESTRICT/CASCADE | Schedule term |
| semesters | internal_assessments | 1:N | assessment.semester_id | Mandatory | RESTRICT/CASCADE | IA term |
| semesters | semester_exams | 1:N | exam.semester_id | Mandatory | RESTRICT/CASCADE | Exam term |
| subjects | faculty_subject_assignments | 1:N | assignment.subject_id | Mandatory | RESTRICT/CASCADE | Taught subject |
| subjects | student_enrolments | 1:N | enrolment.subject_id | Mandatory | RESTRICT/CASCADE | Enrolled subject |
| subjects | timetable_entries | 1:N | timetable.subject_id | Mandatory | RESTRICT/CASCADE | Scheduled subject |
| subjects | internal_assessments | 1:N | ia.subject_id | Mandatory | RESTRICT/CASCADE | IA definitions |
| subjects | semester_exams | 1:N | exam.subject_id | Mandatory | RESTRICT/CASCADE | Exam definitions |
| faculty | faculty_subject_assignments | 1:N | assignment.faculty_id | Mandatory | RESTRICT/CASCADE | Teacher |
| faculty | timetable_entries | 1:N | timetable.faculty_id | Mandatory | RESTRICT/CASCADE | Scheduled teacher |
| students | student_enrolments | 1:N | enrolment.student_id | Mandatory | RESTRICT/CASCADE | Learner |
| students | fee_payments | 1:N | payment.student_id | Mandatory | RESTRICT/CASCADE | Payer |
| students | feedback | 1:N | feedback.student_id | Mandatory | RESTRICT/CASCADE | Submitter |
| faculty_subject_assignments | attendance_sessions | 1:N | session.assignment_id | Mandatory | RESTRICT/CASCADE | Session context |
| faculty_subject_assignments | timetable_entries | 1:N | timetable(faculty_id,subject_id,semester_id,section) | Mandatory | RESTRICT/CASCADE | Composite FK: timetable requires an assignment |
| attendance_sessions | attendance_records | 1:N | record.session_id | Mandatory | CASCADE/CASCADE | Session detail rows |
| student_enrolments | attendance_records | 1:N | record.enrolment_id | Mandatory | RESTRICT/CASCADE | Enrolled student only |
| internal_assessments | internal_marks | 1:N | mark.assessment_id | Mandatory | RESTRICT/CASCADE | IA mark |
| student_enrolments | internal_marks | 1:N | mark.enrolment_id | Mandatory | RESTRICT/CASCADE | Earned by enrolment |
| semester_exams | semester_marks | 1:N | mark.exam_id | Mandatory | RESTRICT/CASCADE | Exam result |
| student_enrolments | semester_marks | 1:N | mark.enrolment_id | Mandatory | RESTRICT/CASCADE | Earned by enrolment |
| fee_structures | fee_payments | 1:N | payment.fee_structure_id | Mandatory | RESTRICT/CASCADE | Payment against demand |
| notifications | notification_reads | 1:N | read.notification_id | Mandatory | CASCADE/CASCADE | Read state |
| users | notification_reads | 1:N | read.user_id | Mandatory | CASCADE/CASCADE | Reader |
| users | notifications (sender) | 1:N | notif.sender_user_id | Optional | SET NULL/CASCADE | Preserve notice |
| users | notifications (target) | 1:N | notif.target_user_id | Optional | CASCADE/CASCADE | Direct message cleanup |
| users | attendance_sessions/records/marks/payments/feedback review | 1:N | various *_user_id | Optional | SET NULL/CASCADE | Audit actor preserved |
| subjects | feedback | 1:N | feedback.subject_id | Optional | SET NULL/CASCADE | Subject context |
| faculty | feedback | 1:N | feedback.faculty_id | Optional | SET NULL/CASCADE | Faculty context |
| semesters | feedback | 1:N | feedback.semester_id | Optional | SET NULL/CASCADE | Term context |

## 3. Resolved many-to-many relationships
- **Student ↔ Subject (per term):** `student_enrolments` with `section`, `enrolment_date`, `status`; the academic year is derived through `semesters`.
- **Faculty ↔ Subject (per term):** `faculty_subject_assignments` with `section`, `assigned_on`, `is_active`.
- **User ↔ Notification:** broadcast/target in `notifications` + per-user state in `notification_reads`.

## 4. Integrity rationale
- `RESTRICT` on academic/financial history prevents accidental loss of marks, attendance, payments, and enrolments.
- `SET NULL` used only for optional actor/profile links where history should remain.
- `CASCADE` used for dependent artifacts (reset tokens, read receipts, session-level attendance rows).
- Composite unique keys enforce business rules: no duplicate enrolment, no duplicate mark per assessment/exam, no duplicate feedback per student/scope/category, and no faculty or room double-booking in the timetable.
- `fk_tt_assignment` is a composite foreign key from `timetable_entries` to `faculty_subject_assignments`, so a timetable row cannot exist without a matching teaching assignment.
- Cross-table rules that cannot be expressed by one FK are enforced by the 10 triggers in `database/triggers/001_integrity_triggers.sql`: attendance vs assignment/enrolment, internal marks vs assessment, semester marks vs exam, fee payment vs student course, and notification target role vs user role.

## 5. Counts

- **24 tables**
- **51 foreign-key constraints**
- **32 unique keys**
- **29 CHECK constraints**
- **25 secondary indexes**
- **10 integrity triggers** (5 rules × INSERT/UPDATE)
- **8 views**