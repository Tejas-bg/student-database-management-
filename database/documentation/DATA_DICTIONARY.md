# GM University Management System — Data Dictionary (Stage 3)

> **Status:** Design complete, corrections applied for review. **Not executed.** MySQL 8.0.16+, InnoDB, utf8mb4.
> PK = Primary Key, FK = Foreign Key, UK = Unique Key, NN = NOT NULL, DFT = Default.
> Cross-table rules not expressible as a single FK are listed in `database/triggers/001_integrity_triggers.sql`.

## roles
| Column | Type | Null | Key | Default | Description |
|---|---|---|---|---|---|
| role_id | TINYINT UNSIGNED | No | PK | AI | Role identifier |
| role_code | VARCHAR(20) | No | UK | — | `student`, `faculty`, `admin` |
| role_name | VARCHAR(50) | No | — | — | Display name |
| description | VARCHAR(255) | Yes | — | NULL | Role description |
| created_at | DATETIME | No | — | CURRENT_TIMESTAMP | Created time |

## users
| Column | Type | Null | Key | Default | Description |
|---|---|---|---|---|---|
| user_id | INT UNSIGNED | No | PK | AI | User account identifier |
| role_id | TINYINT UNSIGNED | No | FK→roles | — | Determines RBAC role (server-resolved) |
| login_identifier | VARCHAR(100) | No | UK | — | USN / employee ID / approved email; never Aadhaar |
| email | VARCHAR(150) | Yes | UK | NULL | Contact/recovery email |
| password_hash | VARCHAR(255) | No | — | — | Hashed password only (bcrypt/argon2 in impl.) |
| account_status | ENUM(...) | No | — | active | `active,inactive,locked,pending_reset` |
| is_active | TINYINT(1) | No | — | 1 | Activation flag |
| must_change_password | TINYINT(1) | No | — | 0 | Force password change |
| failed_login_attempts | TINYINT UNSIGNED | No | — | 0 | Lockout support |
| last_login_at | DATETIME | Yes | — | NULL | Last successful login |
| password_changed_at | DATETIME | Yes | — | NULL | Password change time |
| created_at | DATETIME | No | — | CURRENT_TIMESTAMP | Created |
| updated_at | DATETIME | No | — | CURRENT_TIMESTAMP | Updated |

## password_reset_tokens
| Column | Type | Null | Key | Default | Description |
|---|---|---|---|---|---|
| token_id | BIGINT UNSIGNED | No | PK | AI | Token row id |
| user_id | INT UNSIGNED | No | FK→users | — | Account owner |
| token_hash | CHAR(64) | No | UK | — | SHA-256 hash of token (example) |
| expires_at | DATETIME | No | — | — | Expiry time |
| used_at | DATETIME | Yes | — | NULL | One-time use marker |
| created_at | DATETIME | No | — | CURRENT_TIMESTAMP | Issued time |

## departments
| Column | Type | Null | Key | Default | Description |
|---|---|---|---|---|---|
| department_id | INT UNSIGNED | No | PK | AI | Department id |
| department_code | VARCHAR(20) | No | UK | — | Short code |
| department_name | VARCHAR(120) | No | UK | — | Full name |
| hod_name | VARCHAR(120) | Yes | — | NULL | Head of department |
| office_location | VARCHAR(120) | Yes | — | NULL | Office/room |
| status | ENUM('active','inactive') | No | — | active | Status |
| created_at/updated_at | DATETIME | No | — | timestamps | Audit |

## courses
| Column | Type | Null | Key | Default | Description |
|---|---|---|---|---|---|
| course_id | INT UNSIGNED | No | PK | AI | Course id |
| department_id | INT UNSIGNED | No | FK→departments | — | Owning department |
| course_code | VARCHAR(20) | No | UK | — | Code |
| course_name | VARCHAR(150) | No | — | — | Name |
| level | ENUM('UG','PG','Diploma','PhD') | No | — | — | Level |
| duration_semesters | TINYINT UNSIGNED | No | — | — | Total semesters (1-12) |
| total_credits | SMALLINT UNSIGNED | Yes | — | NULL | Programme credits |
| status | ENUM('active','inactive') | No | — | active | Status |
| created_at/updated_at | DATETIME | No | — | timestamps | Audit |

## academic_years
| Column | Type | Null | Key | Default | Description |
|---|---|---|---|---|---|
| academic_year_id | INT UNSIGNED | No | PK | AI | Year id |
| year_label | VARCHAR(20) | No | UK | — | e.g. 2025-26 |
| start_date | DATE | No | — | — | Start |
| end_date | DATE | No | — | — | End (> start) |
| is_current | TINYINT(1) | No | — | 0 | Current flag |
| status | ENUM('planned','active','closed') | No | — | planned | Lifecycle |

## semesters
| Column | Type | Null | Key | Default | Description |
|---|---|---|---|---|---|
| semester_id | INT UNSIGNED | No | PK | AI | Semester id |
| course_id | INT UNSIGNED | No | FK→courses | — | Course |
| academic_year_id | INT UNSIGNED | No | FK→academic_years | — | Academic year |
| semester_number | TINYINT UNSIGNED | No | — | — | 1-12 |
| term_label | VARCHAR(30) | No | — | — | Odd/Even/etc. |
| start_date | DATE | Yes | — | NULL | Term start |
| end_date | DATE | Yes | — | NULL | Term end |
| status | ENUM('planned','active','completed') | No | — | planned | Status |
| UK | (course_id, academic_year_id, semester_number) | — | UK | — | Prevent duplicates |

## subjects
| Column | Type | Null | Key | Default | Description |
|---|---|---|---|---|---|
| subject_id | INT UNSIGNED | No | PK | AI | Subject id |
| course_id | INT UNSIGNED | No | FK→courses | — | Curriculum course |
| department_id | INT UNSIGNED | No | FK→departments | — | Owning department (may differ from course department) |
| semester_number | TINYINT UNSIGNED | No | — | — | Curriculum semester |
| subject_code | VARCHAR(20) | No | UK | — | Subject code |
| subject_name | VARCHAR(150) | No | — | — | Name |
| subject_type | ENUM(...) | No | — | theory | theory/practical/lab/project/elective |
| credits | TINYINT UNSIGNED | No | — | — | 0-30 |
| status | ENUM('active','inactive') | No | — | active | Status |
| created_at/updated_at | DATETIME | No | — | timestamps | Audit |

## students
| Column | Type | Null | Key | Default | Description |
|---|---|---|---|---|---|
| student_id | INT UNSIGNED | No | PK | AI | Student id |
| user_id | INT UNSIGNED | Yes | FK→users, UK | NULL | Linked login (1:1 optional) |
| department_id | INT UNSIGNED | No | FK→departments | — | Administrative home department |
| course_id | INT UNSIGNED | No | FK→courses | — | Course |
| usn | VARCHAR(20) | No | UK | — | University Seat Number |
| first_name | VARCHAR(60) | No | — | — | First name |
| last_name | VARCHAR(60) | No | — | — | Last name |
| date_of_birth | DATE | Yes | — | NULL | DOB |
| gender | ENUM(...) | Yes | — | NULL | Gender option |
| email | VARCHAR(150) | Yes | UK | NULL | Email |
| phone | VARCHAR(20) | Yes | — | NULL | Phone |
| address_line1/city/state/pincode | VARCHAR | Yes | — | NULL | Address fields |
| admission_year | YEAR | No | — | — | Admission year |
| current_semester | TINYINT UNSIGNED | No | — | — | Current semester |
| status | ENUM(...) | No | — | active | active/inactive/graduated/withdrawn |
| created_at/updated_at | DATETIME | No | — | timestamps | Audit |

## faculty
| Column | Type | Null | Key | Default | Description |
|---|---|---|---|---|---|
| faculty_id | INT UNSIGNED | No | PK | AI | Faculty id |
| user_id | INT UNSIGNED | Yes | FK→users, UK | NULL | Linked login (1:1 optional) |
| department_id | INT UNSIGNED | No | FK→departments | — | Department |
| employee_id | VARCHAR(30) | No | UK | — | Employee identifier |
| first_name/last_name | VARCHAR(60) | No | — | — | Name |
| designation | VARCHAR(80) | No | — | — | Designation |
| qualification | VARCHAR(120) | Yes | — | NULL | Qualification |
| email | VARCHAR(150) | Yes | UK | NULL | Email |
| phone | VARCHAR(20) | Yes | — | NULL | Phone |
| date_of_joining | DATE | Yes | — | NULL | Joining date |
| status | ENUM('active','inactive','on_leave') | No | — | active | Status |
| created_at/updated_at | DATETIME | No | — | timestamps | Audit |

## faculty_subject_assignments
| Column | Type | Null | Key | Default | Description |
|---|---|---|---|---|---|
| assignment_id | INT UNSIGNED | No | PK | AI | Assignment id |
| faculty_id | INT UNSIGNED | No | FK→faculty | — | Faculty |
| subject_id | INT UNSIGNED | No | FK→subjects | — | Subject |
| semester_id | INT UNSIGNED | No | FK→semesters | — | Term |
| section | VARCHAR(10) | No | — | 'A' | Section/batch |
| assigned_on | DATE | No | — | — | Assignment date |
| is_active | TINYINT(1) | No | — | 1 | Active flag |
| UK | (faculty,subject,semester,section) | — | UK | — | Prevent duplicates |

## student_enrolments
| Column | Type | Null | Key | Default | Description |
|---|---|---|---|---|---|
| enrolment_id | INT UNSIGNED | No | PK | AI | Enrolment id |
| student_id | INT UNSIGNED | No | FK→students | — | Student |
| subject_id | INT UNSIGNED | No | FK→subjects | — | Subject |
| semester_id | INT UNSIGNED | No | FK→semesters | — | Semester (also determines academic year) |
| section | VARCHAR(10) | No | — | 'A' | Section |
| enrolment_date | DATE | No | — | — | Date |
| status | ENUM('enrolled','completed','dropped','failed') | No | — | enrolled | Status |
| UK | (student,subject,semester) | — | UK | — | One enrolment per term |

## timetable_entries
| Column | Type | Null | Key | Default | Description |
|---|---|---|---|---|---|
| timetable_id | INT UNSIGNED | No | PK | AI | Entry id |
| subject_id | INT UNSIGNED | No | FK→subjects | — | Subject |
| faculty_id | INT UNSIGNED | No | FK→faculty | — | Faculty |
| semester_id | INT UNSIGNED | No | FK→semesters | — | Semester |
| section | VARCHAR(10) | No | — | 'A' | Section |
| day_of_week | ENUM(Mon..Sat) | No | — | — | Day |
| start_time/end_time | TIME | No | — | — | Slot (end>start) |
| room_no | VARCHAR(30) | No | — | — | Room/lab |
| class_type | ENUM('lecture','lab','tutorial','seminar') | No | — | lecture | Type |
| status | ENUM('active','cancelled') | No | — | active | Status |
| UK | (faculty_id, day_of_week, start_time); (room_no, day_of_week, start_time) | — | UK | — | Prevent faculty/room double-booking |
| FK | (faculty_id, subject_id, semester_id, section) → faculty_subject_assignments | — | FK | — | Composite FK: a timetable row requires a matching teaching assignment |

## attendance_sessions
| Column | Type | Null | Key | Default | Description |
|---|---|---|---|---|---|
| session_id | INT UNSIGNED | No | PK | AI | Session id |
| assignment_id | INT UNSIGNED | No | FK→assignments | — | Teaching context |
| session_date | DATE | No | — | — | Date |
| start_time | TIME | No | — | — | Start time (required for reliable session uniqueness) |
| end_time | TIME | Yes | — | NULL | End time (must be after start when set) |
| topic | VARCHAR(200) | Yes | — | NULL | Topic |
| session_type | ENUM | No | — | lecture | Type |
| created_by_user_id | INT UNSIGNED | Yes | FK→users | NULL | Creator |
| created_at | DATETIME | No | — | CURRENT_TIMESTAMP | Created |
| UK | (assignment_id,session_date,start_time) | — | UK | — | One session per assignment/date/start |

## attendance_records
| Column | Type | Null | Key | Default | Description |
|---|---|---|---|---|---|
| attendance_id | BIGINT UNSIGNED | No | PK | AI | Record id |
| session_id | INT UNSIGNED | No | FK→attendance_sessions | — | Session |
| enrolment_id | INT UNSIGNED | No | FK→student_enrolments | — | Student enrolment |
| status | ENUM('present','absent','late','excused') | No | — | — | Attendance |
| remarks | VARCHAR(255) | Yes | — | NULL | Remarks |
| marked_at | DATETIME | No | — | CURRENT_TIMESTAMP | Marked time |
| marked_by_user_id | INT UNSIGNED | Yes | FK→users | NULL | Marker |
| UK | (session_id,enrolment_id) | — | UK | — | One mark per student/session |

## internal_assessments
| Column | Type | Null | Key | Default | Description |
|---|---|---|---|---|---|
| assessment_id | INT UNSIGNED | No | PK | AI | Assessment id |
| subject_id | INT UNSIGNED | No | FK→subjects | — | Subject |
| semester_id | INT UNSIGNED | No | FK→semesters | — | Semester |
| assessment_name | VARCHAR(80) | No | — | — | IA-1, Assignment, etc. |
| max_marks | DECIMAL(5,2) | No | — | — | > 0 |
| weightage_percent | DECIMAL(5,2) | Yes | — | NULL | 0-100 |
| assessment_date | DATE | Yes | — | NULL | Date |

## internal_marks
| Column | Type | Null | Key | Default | Description |
|---|---|---|---|---|---|
| internal_mark_id | BIGINT UNSIGNED | No | PK | AI | Mark id |
| assessment_id | INT UNSIGNED | No | FK→internal_assessments | — | Assessment |
| enrolment_id | INT UNSIGNED | No | FK→student_enrolments | — | Student enrolment |
| marks_obtained | DECIMAL(5,2) | No | — | — | >= 0 |
| remarks | VARCHAR(255) | Yes | — | NULL | Remarks |
| entered_by_user_id | INT UNSIGNED | Yes | FK→users | NULL | Entered by |
| entered_at/updated_at | DATETIME | No | — | timestamps | Audit |

## semester_exams
| Column | Type | Null | Key | Default | Description |
|---|---|---|---|---|---|
| exam_id | INT UNSIGNED | No | PK | AI | Exam id |
| subject_id | INT UNSIGNED | No | FK→subjects | — | Subject |
| semester_id | INT UNSIGNED | No | FK→semesters | — | Semester |
| exam_name | VARCHAR(80) | No | — | End Semester Examination | Name |
| exam_date | DATE | Yes | — | NULL | Date |
| max_marks | DECIMAL(5,2) | No | — | — | > 0 |
| passing_marks | DECIMAL(5,2) | No | — | — | 0..max |

## semester_marks
| Column | Type | Null | Key | Default | Description |
|---|---|---|---|---|---|
| semester_mark_id | BIGINT UNSIGNED | No | PK | AI | Result row id |
| exam_id | INT UNSIGNED | No | FK→semester_exams | — | Exam |
| enrolment_id | INT UNSIGNED | No | FK→student_enrolments | — | Student enrolment |
| marks_obtained | DECIMAL(5,2) | No | — | — | >= 0 |
| grade | VARCHAR(5) | Yes | — | NULL | Grade |
| grade_point | DECIMAL(3,2) | Yes | — | NULL | 0-10 |
| result_status | ENUM('pass','fail','absent','withheld') | No | — | — | Result |
| published_at | DATETIME | Yes | — | NULL | Publish time |
| entered_by_user_id | INT UNSIGNED | Yes | FK→users | NULL | Entered by |

## fee_structures
| Column | Type | Null | Key | Default | Description |
|---|---|---|---|---|---|
| fee_structure_id | INT UNSIGNED | No | PK | AI | Structure id |
| course_id | INT UNSIGNED | No | FK→courses | — | Course |
| academic_year_id | INT UNSIGNED | No | FK→academic_years | — | Year |
| semester_number | TINYINT UNSIGNED | No | — | — | Semester 1-12; annual fees are split per semester |
| fee_head | VARCHAR(100) | No | — | — | Tuition/Exam/etc. |
| amount | DECIMAL(10,2) | No | — | — | >= 0 |
| due_date | DATE | Yes | — | NULL | Due date |
| is_mandatory | TINYINT(1) | No | — | 1 | Mandatory flag |
| UK | (course_id,academic_year_id,semester_number,fee_head) | — | UK | — | One fee head per course/year/semester |

## fee_payments
| Column | Type | Null | Key | Default | Description |
|---|---|---|---|---|---|
| payment_id | BIGINT UNSIGNED | No | PK | AI | Payment id |
| student_id | INT UNSIGNED | No | FK→students | — | Student |
| fee_structure_id | INT UNSIGNED | No | FK→fee_structures | — | Fee head |
| amount_paid | DECIMAL(10,2) | No | — | — | > 0 |
| payment_date | DATE | No | — | — | Date |
| payment_mode | ENUM(...) | No | — | — | cash/upi/card/net_banking/dd/cheque/other |
| transaction_ref | VARCHAR(80) | Yes | UK | NULL | Gateway/bank ref |
| receipt_no | VARCHAR(50) | Yes | UK | NULL | Receipt |
| payment_status | ENUM('pending','success','failed','refunded') | No | — | success | Status |
| remarks | VARCHAR(255) | Yes | — | NULL | Notes |
| recorded_by_user_id | INT UNSIGNED | Yes | FK→users | NULL | Recorder |
| created_at | DATETIME | No | — | CURRENT_TIMESTAMP | Created |

## notifications
| Column | Type | Null | Key | Default | Description |
|---|---|---|---|---|---|
| notification_id | BIGINT UNSIGNED | No | PK | AI | Notification id |
| sender_user_id | INT UNSIGNED | Yes | FK→users | NULL | Sender |
| target_role | ENUM('student','faculty','admin','all') | No | — | — | Audience role |
| target_user_id | INT UNSIGNED | Yes | FK→users | NULL | Direct target |
| title | VARCHAR(150) | No | — | — | Title |
| message | TEXT | No | — | — | Body |
| category | ENUM(...) | No | — | general | Category |
| priority | ENUM('low','normal','high') | No | — | normal | Priority |
| is_published | TINYINT(1) | No | — | 1 | Published flag |
| published_at | DATETIME | No | — | CURRENT_TIMESTAMP | Publish time |
| expires_at | DATETIME | Yes | — | NULL | Expiry |
| CHECK | target_role = 'all' → target_user_id IS NULL | — | CHECK | — | A broadcast cannot target one user |

## notification_reads
| Column | Type | Null | Key | Default | Description |
|---|---|---|---|---|---|
| read_id | BIGINT UNSIGNED | No | PK | AI | Read record id |
| notification_id | BIGINT UNSIGNED | No | FK→notifications | — | Notification |
| user_id | INT UNSIGNED | No | FK→users | — | Reader |
| read_at | DATETIME | No | — | CURRENT_TIMESTAMP | Read time |
| UK | (notification_id,user_id) | — | UK | — | One read state |

## feedback
| Column | Type | Null | Key | Default | Description |
|---|---|---|---|---|---|
| feedback_id | BIGINT UNSIGNED | No | PK | AI | Feedback id |
| student_id | INT UNSIGNED | No | FK→students | — | Submitter |
| UK | functional (student_id, category, COALESCE(subject_id,0), COALESCE(semester_id,0)) | — | UK | — | One feedback per student/scope/category, including NULL scope |
| subject_id | INT UNSIGNED | Yes | FK→subjects | NULL | Subject context |
| faculty_id | INT UNSIGNED | Yes | FK→faculty | NULL | Faculty context |
| semester_id | INT UNSIGNED | Yes | FK→semesters | NULL | Term context |
| category | ENUM('course','faculty','facility','general') | No | — | general | Category |
| rating | TINYINT UNSIGNED | No | — | — | 1-5 |
| comments | TEXT | Yes | — | NULL | Comments |
| is_anonymous | TINYINT(1) | No | — | 0 | Anonymous flag |
| status | ENUM('submitted','reviewed','archived') | No | — | submitted | Workflow |
| submitted_at | DATETIME | No | — | CURRENT_TIMESTAMP | Submitted |
| reviewed_by_user_id | INT UNSIGNED | Yes | FK→users | NULL | Reviewer |
| reviewed_at | DATETIME | Yes | — | NULL | Review time |
