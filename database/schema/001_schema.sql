-- GM University Management System
-- Stage 3: Database Architecture and ER Design (DESIGN ONLY - NOT EXECUTED)
-- Target: MySQL 8.0+ / InnoDB / utf8mb4
-- All sample data in seed scripts is fictional.

-- The database is created only if it does not exist. No DROP is included.
CREATE DATABASE IF NOT EXISTS gmu_management_system
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE gmu_management_system;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- 1. Roles and authentication
CREATE TABLE roles (
  role_id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  role_code VARCHAR(20) NOT NULL,
  role_name VARCHAR(50) NOT NULL,
  description VARCHAR(255) NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (role_id),
  UNIQUE KEY uk_roles_code (role_code),
  CONSTRAINT chk_roles_code CHECK (role_code IN ('student','faculty','admin'))
) ENGINE=InnoDB;

CREATE TABLE users (
  user_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  role_id TINYINT UNSIGNED NOT NULL,
  login_identifier VARCHAR(100) NOT NULL COMMENT 'USN, employee ID, or approved email; never Aadhaar',
  email VARCHAR(150) NULL,
  password_hash VARCHAR(255) NOT NULL,
  account_status ENUM('active','inactive','locked','pending_reset') NOT NULL DEFAULT 'active',
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  must_change_password TINYINT(1) NOT NULL DEFAULT 0,
  failed_login_attempts TINYINT UNSIGNED NOT NULL DEFAULT 0,
  last_login_at DATETIME NULL,
  password_changed_at DATETIME NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (user_id),
  UNIQUE KEY uk_users_login_identifier (login_identifier),
  UNIQUE KEY uk_users_email (email),
  KEY idx_users_role_status (role_id, account_status),
  CONSTRAINT fk_users_role FOREIGN KEY (role_id) REFERENCES roles(role_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT chk_users_active CHECK (is_active IN (0,1)),
  CONSTRAINT chk_users_must_change CHECK (must_change_password IN (0,1))
) ENGINE=InnoDB;

CREATE TABLE password_reset_tokens (
  token_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id INT UNSIGNED NOT NULL,
  token_hash CHAR(64) NOT NULL,
  expires_at DATETIME NOT NULL,
  used_at DATETIME NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (token_id),
  UNIQUE KEY uk_reset_token_hash (token_hash),
  KEY idx_reset_user_expires (user_id, expires_at),
  CONSTRAINT fk_reset_user FOREIGN KEY (user_id) REFERENCES users(user_id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 2. Academic structure
CREATE TABLE departments (
  department_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  department_code VARCHAR(20) NOT NULL,
  department_name VARCHAR(120) NOT NULL,
  hod_name VARCHAR(120) NULL,
  office_location VARCHAR(120) NULL,
  status ENUM('active','inactive') NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (department_id),
  UNIQUE KEY uk_departments_code (department_code),
  UNIQUE KEY uk_departments_name (department_name)
) ENGINE=InnoDB;

CREATE TABLE courses (
  course_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  department_id INT UNSIGNED NOT NULL,
  course_code VARCHAR(20) NOT NULL,
  course_name VARCHAR(150) NOT NULL,
  level ENUM('UG','PG','Diploma','PhD') NOT NULL,
  duration_semesters TINYINT UNSIGNED NOT NULL,
  total_credits SMALLINT UNSIGNED NULL,
  status ENUM('active','inactive') NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (course_id),
  UNIQUE KEY uk_courses_code (course_code),
  KEY idx_courses_department (department_id),
  CONSTRAINT fk_courses_department FOREIGN KEY (department_id) REFERENCES departments(department_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT chk_courses_duration CHECK (duration_semesters BETWEEN 1 AND 12)
) ENGINE=InnoDB;

CREATE TABLE academic_years (
  academic_year_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  year_label VARCHAR(20) NOT NULL COMMENT 'e.g. 2025-26',
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  is_current TINYINT(1) NOT NULL DEFAULT 0,
  status ENUM('planned','active','closed') NOT NULL DEFAULT 'planned',
  PRIMARY KEY (academic_year_id),
  UNIQUE KEY uk_academic_year_label (year_label),
  CONSTRAINT chk_academic_year_dates CHECK (end_date > start_date),
  CONSTRAINT chk_academic_year_current CHECK (is_current IN (0,1))
) ENGINE=InnoDB;

CREATE TABLE semesters (
  semester_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  course_id INT UNSIGNED NOT NULL,
  academic_year_id INT UNSIGNED NOT NULL,
  semester_number TINYINT UNSIGNED NOT NULL,
  term_label VARCHAR(30) NOT NULL COMMENT 'e.g. Odd, Even',
  start_date DATE NULL,
  end_date DATE NULL,
  status ENUM('planned','active','completed') NOT NULL DEFAULT 'planned',
  PRIMARY KEY (semester_id),
  UNIQUE KEY uk_semester_course_year_number (course_id, academic_year_id, semester_number),
  KEY idx_semesters_academic_year (academic_year_id),
  CONSTRAINT fk_semesters_course FOREIGN KEY (course_id) REFERENCES courses(course_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_semesters_academic_year FOREIGN KEY (academic_year_id) REFERENCES academic_years(academic_year_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT chk_semester_number CHECK (semester_number BETWEEN 1 AND 12),
  CONSTRAINT chk_semester_dates CHECK (end_date IS NULL OR start_date IS NULL OR end_date >= start_date)
) ENGINE=InnoDB;

CREATE TABLE subjects (
  subject_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  course_id INT UNSIGNED NOT NULL,
  department_id INT UNSIGNED NOT NULL COMMENT 'Owning department; may differ from the course department for service/interdisciplinary subjects',
  semester_number TINYINT UNSIGNED NOT NULL COMMENT 'Curriculum semester in the course',
  subject_code VARCHAR(20) NOT NULL,
  subject_name VARCHAR(150) NOT NULL,
  subject_type ENUM('theory','practical','lab','project','elective') NOT NULL DEFAULT 'theory',
  credits TINYINT UNSIGNED NOT NULL,
  status ENUM('active','inactive') NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (subject_id),
  UNIQUE KEY uk_subjects_code (subject_code),
  KEY idx_subjects_course_semester (course_id, semester_number),
  KEY idx_subjects_department (department_id),
  CONSTRAINT fk_subjects_course FOREIGN KEY (course_id) REFERENCES courses(course_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_subjects_department FOREIGN KEY (department_id) REFERENCES departments(department_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT chk_subjects_credits CHECK (credits BETWEEN 0 AND 30),
  CONSTRAINT chk_subjects_semester CHECK (semester_number BETWEEN 1 AND 12)
) ENGINE=InnoDB;

-- 3. People
CREATE TABLE students (
  student_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id INT UNSIGNED NULL,
  department_id INT UNSIGNED NOT NULL COMMENT 'Administrative home department; may differ from the course department',
  course_id INT UNSIGNED NOT NULL,
  usn VARCHAR(20) NOT NULL,
  first_name VARCHAR(60) NOT NULL,
  last_name VARCHAR(60) NOT NULL,
  date_of_birth DATE NULL,
  gender ENUM('male','female','other','prefer_not_to_say') NULL,
  email VARCHAR(150) NULL,
  phone VARCHAR(20) NULL,
  address_line1 VARCHAR(255) NULL,
  city VARCHAR(80) NULL,
  state VARCHAR(80) NULL,
  pincode VARCHAR(10) NULL,
  admission_year YEAR NOT NULL,
  current_semester TINYINT UNSIGNED NOT NULL,
  status ENUM('active','inactive','graduated','withdrawn') NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (student_id),
  UNIQUE KEY uk_students_usn (usn),
  UNIQUE KEY uk_students_user (user_id),
  UNIQUE KEY uk_students_email (email),
  KEY idx_students_department_course (department_id, course_id),
  KEY idx_students_status (status),
  CONSTRAINT fk_students_user FOREIGN KEY (user_id) REFERENCES users(user_id)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT fk_students_department FOREIGN KEY (department_id) REFERENCES departments(department_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_students_course FOREIGN KEY (course_id) REFERENCES courses(course_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT chk_students_semester CHECK (current_semester BETWEEN 1 AND 12)
) ENGINE=InnoDB;

CREATE TABLE faculty (
  faculty_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id INT UNSIGNED NULL,
  department_id INT UNSIGNED NOT NULL,
  employee_id VARCHAR(30) NOT NULL,
  first_name VARCHAR(60) NOT NULL,
  last_name VARCHAR(60) NOT NULL,
  designation VARCHAR(80) NOT NULL,
  qualification VARCHAR(120) NULL,
  email VARCHAR(150) NULL,
  phone VARCHAR(20) NULL,
  date_of_joining DATE NULL,
  status ENUM('active','inactive','on_leave') NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (faculty_id),
  UNIQUE KEY uk_faculty_employee_id (employee_id),
  UNIQUE KEY uk_faculty_user (user_id),
  UNIQUE KEY uk_faculty_email (email),
  KEY idx_faculty_department (department_id),
  CONSTRAINT fk_faculty_user FOREIGN KEY (user_id) REFERENCES users(user_id)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT fk_faculty_department FOREIGN KEY (department_id) REFERENCES departments(department_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 4. Academic operations
CREATE TABLE faculty_subject_assignments (
  assignment_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  faculty_id INT UNSIGNED NOT NULL,
  subject_id INT UNSIGNED NOT NULL,
  semester_id INT UNSIGNED NOT NULL,
  section VARCHAR(10) NOT NULL DEFAULT 'A',
  assigned_on DATE NOT NULL,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (assignment_id),
  UNIQUE KEY uk_assignment (faculty_id, subject_id, semester_id, section),
  KEY idx_assignment_semester_subject (semester_id, subject_id),
  CONSTRAINT fk_assign_faculty FOREIGN KEY (faculty_id) REFERENCES faculty(faculty_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_assign_subject FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_assign_semester FOREIGN KEY (semester_id) REFERENCES semesters(semester_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT chk_assignment_active CHECK (is_active IN (0,1))
) ENGINE=InnoDB;

CREATE TABLE student_enrolments (
  enrolment_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  student_id INT UNSIGNED NOT NULL,
  subject_id INT UNSIGNED NOT NULL,
  semester_id INT UNSIGNED NOT NULL,
  section VARCHAR(10) NOT NULL DEFAULT 'A',
  enrolment_date DATE NOT NULL,
  status ENUM('enrolled','completed','dropped','failed') NOT NULL DEFAULT 'enrolled',
  PRIMARY KEY (enrolment_id),
  UNIQUE KEY uk_enrolment (student_id, subject_id, semester_id),
  KEY idx_enrolment_subject_semester_section (subject_id, semester_id, section),
  KEY idx_enrolment_student_semester (student_id, semester_id),
  CONSTRAINT fk_enrol_student FOREIGN KEY (student_id) REFERENCES students(student_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_enrol_subject FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_enrol_semester FOREIGN KEY (semester_id) REFERENCES semesters(semester_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE timetable_entries (
  timetable_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  subject_id INT UNSIGNED NOT NULL,
  faculty_id INT UNSIGNED NOT NULL,
  semester_id INT UNSIGNED NOT NULL,
  section VARCHAR(10) NOT NULL DEFAULT 'A',
  day_of_week ENUM('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday') NOT NULL,
  start_time TIME NOT NULL,
  end_time TIME NOT NULL,
  room_no VARCHAR(30) NOT NULL,
  class_type ENUM('lecture','lab','tutorial','seminar') NOT NULL DEFAULT 'lecture',
  status ENUM('active','cancelled') NOT NULL DEFAULT 'active',
  PRIMARY KEY (timetable_id),
  UNIQUE KEY uk_timetable_slot (semester_id, section, day_of_week, start_time, room_no),
  UNIQUE KEY uk_timetable_faculty_slot (faculty_id, day_of_week, start_time),
  UNIQUE KEY uk_timetable_room_slot (room_no, day_of_week, start_time),
  KEY idx_timetable_faculty_day (faculty_id, day_of_week, start_time),
  KEY idx_timetable_subject_semester (subject_id, semester_id),
  CONSTRAINT fk_tt_subject FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_tt_faculty FOREIGN KEY (faculty_id) REFERENCES faculty(faculty_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_tt_semester FOREIGN KEY (semester_id) REFERENCES semesters(semester_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_tt_assignment FOREIGN KEY (faculty_id, subject_id, semester_id, section)
    REFERENCES faculty_subject_assignments(faculty_id, subject_id, semester_id, section)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT chk_timetable_time CHECK (end_time > start_time)
) ENGINE=InnoDB;

CREATE TABLE attendance_sessions (
  session_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  assignment_id INT UNSIGNED NOT NULL,
  session_date DATE NOT NULL,
  start_time TIME NOT NULL,
  end_time TIME NULL,
  topic VARCHAR(200) NULL,
  session_type ENUM('lecture','lab','tutorial','other') NOT NULL DEFAULT 'lecture',
  created_by_user_id INT UNSIGNED NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (session_id),
  UNIQUE KEY uk_attendance_session (assignment_id, session_date, start_time),
  CONSTRAINT fk_att_sess_assignment FOREIGN KEY (assignment_id) REFERENCES faculty_subject_assignments(assignment_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_att_sess_user FOREIGN KEY (created_by_user_id) REFERENCES users(user_id)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT chk_att_session_time CHECK (end_time IS NULL OR end_time > start_time)
) ENGINE=InnoDB;

CREATE TABLE attendance_records (
  attendance_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  session_id INT UNSIGNED NOT NULL,
  enrolment_id INT UNSIGNED NOT NULL,
  status ENUM('present','absent','late','excused') NOT NULL,
  remarks VARCHAR(255) NULL,
  marked_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  marked_by_user_id INT UNSIGNED NULL,
  PRIMARY KEY (attendance_id),
  UNIQUE KEY uk_attendance_record (session_id, enrolment_id),
  KEY idx_attendance_enrolment (enrolment_id),
  CONSTRAINT fk_att_rec_session FOREIGN KEY (session_id) REFERENCES attendance_sessions(session_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_att_rec_enrolment FOREIGN KEY (enrolment_id) REFERENCES student_enrolments(enrolment_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_att_rec_user FOREIGN KEY (marked_by_user_id) REFERENCES users(user_id)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 5. Assessments and marks
CREATE TABLE internal_assessments (
  assessment_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  subject_id INT UNSIGNED NOT NULL,
  semester_id INT UNSIGNED NOT NULL,
  assessment_name VARCHAR(80) NOT NULL COMMENT 'e.g. IA-1, IA-2, Assignment',
  max_marks DECIMAL(5,2) NOT NULL,
  weightage_percent DECIMAL(5,2) NULL,
  assessment_date DATE NULL,
  PRIMARY KEY (assessment_id),
  UNIQUE KEY uk_internal_assessment (subject_id, semester_id, assessment_name),
  CONSTRAINT fk_ia_subject FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_ia_semester FOREIGN KEY (semester_id) REFERENCES semesters(semester_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT chk_ia_max_marks CHECK (max_marks > 0),
  CONSTRAINT chk_ia_weightage CHECK (weightage_percent IS NULL OR weightage_percent BETWEEN 0 AND 100)
) ENGINE=InnoDB;

CREATE TABLE internal_marks (
  internal_mark_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  assessment_id INT UNSIGNED NOT NULL,
  enrolment_id INT UNSIGNED NOT NULL,
  marks_obtained DECIMAL(5,2) NOT NULL,
  remarks VARCHAR(255) NULL,
  entered_by_user_id INT UNSIGNED NULL,
  entered_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (internal_mark_id),
  UNIQUE KEY uk_internal_mark (assessment_id, enrolment_id),
  KEY idx_internal_marks_enrolment (enrolment_id),
  CONSTRAINT fk_im_assessment FOREIGN KEY (assessment_id) REFERENCES internal_assessments(assessment_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_im_enrolment FOREIGN KEY (enrolment_id) REFERENCES student_enrolments(enrolment_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_im_user FOREIGN KEY (entered_by_user_id) REFERENCES users(user_id)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT chk_internal_marks_nonneg CHECK (marks_obtained >= 0)
) ENGINE=InnoDB;

CREATE TABLE semester_exams (
  exam_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  subject_id INT UNSIGNED NOT NULL,
  semester_id INT UNSIGNED NOT NULL,
  exam_name VARCHAR(80) NOT NULL DEFAULT 'End Semester Examination',
  exam_date DATE NULL,
  max_marks DECIMAL(5,2) NOT NULL,
  passing_marks DECIMAL(5,2) NOT NULL,
  PRIMARY KEY (exam_id),
  UNIQUE KEY uk_semester_exam (subject_id, semester_id, exam_name),
  CONSTRAINT fk_se_subject FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_se_semester FOREIGN KEY (semester_id) REFERENCES semesters(semester_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT chk_exam_max CHECK (max_marks > 0),
  CONSTRAINT chk_exam_pass CHECK (passing_marks >= 0 AND passing_marks <= max_marks)
) ENGINE=InnoDB;

CREATE TABLE semester_marks (
  semester_mark_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  exam_id INT UNSIGNED NOT NULL,
  enrolment_id INT UNSIGNED NOT NULL,
  marks_obtained DECIMAL(5,2) NOT NULL,
  grade VARCHAR(5) NULL,
  grade_point DECIMAL(3,2) NULL,
  result_status ENUM('pass','fail','absent','withheld') NOT NULL,
  published_at DATETIME NULL,
  entered_by_user_id INT UNSIGNED NULL,
  PRIMARY KEY (semester_mark_id),
  UNIQUE KEY uk_semester_mark (exam_id, enrolment_id),
  KEY idx_semester_marks_enrolment (enrolment_id),
  CONSTRAINT fk_sm_exam FOREIGN KEY (exam_id) REFERENCES semester_exams(exam_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_sm_enrolment FOREIGN KEY (enrolment_id) REFERENCES student_enrolments(enrolment_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_sm_user FOREIGN KEY (entered_by_user_id) REFERENCES users(user_id)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT chk_semester_marks_nonneg CHECK (marks_obtained >= 0),
  CONSTRAINT chk_grade_point CHECK (grade_point IS NULL OR grade_point BETWEEN 0 AND 10)
) ENGINE=InnoDB;

-- 6. Fees
CREATE TABLE fee_structures (
  fee_structure_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  course_id INT UNSIGNED NOT NULL,
  academic_year_id INT UNSIGNED NOT NULL,
  semester_number TINYINT UNSIGNED NOT NULL COMMENT '1-12; split annual fees per semester so uniqueness is reliable',
  fee_head VARCHAR(100) NOT NULL COMMENT 'e.g. Tuition, Exam, Library',
  amount DECIMAL(10,2) NOT NULL,
  due_date DATE NULL,
  is_mandatory TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (fee_structure_id),
  UNIQUE KEY uk_fee_structure (course_id, academic_year_id, semester_number, fee_head),
  KEY idx_fee_structure_year (academic_year_id),
  CONSTRAINT fk_fee_course FOREIGN KEY (course_id) REFERENCES courses(course_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_fee_year FOREIGN KEY (academic_year_id) REFERENCES academic_years(academic_year_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT chk_fee_amount CHECK (amount >= 0),
  CONSTRAINT chk_fee_mandatory CHECK (is_mandatory IN (0,1)),
  CONSTRAINT chk_fee_semester CHECK (semester_number BETWEEN 1 AND 12)
) ENGINE=InnoDB;

CREATE TABLE fee_payments (
  payment_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  student_id INT UNSIGNED NOT NULL,
  fee_structure_id INT UNSIGNED NOT NULL,
  amount_paid DECIMAL(10,2) NOT NULL,
  payment_date DATE NOT NULL,
  payment_mode ENUM('cash','upi','card','net_banking','dd','cheque','other') NOT NULL,
  transaction_ref VARCHAR(80) NULL,
  receipt_no VARCHAR(50) NULL,
  payment_status ENUM('pending','success','failed','refunded') NOT NULL DEFAULT 'success',
  remarks VARCHAR(255) NULL,
  recorded_by_user_id INT UNSIGNED NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (payment_id),
  UNIQUE KEY uk_payment_receipt (receipt_no),
  UNIQUE KEY uk_payment_txn (transaction_ref),
  KEY idx_payment_student (student_id, payment_date),
  KEY idx_payment_fee_structure (fee_structure_id),
  CONSTRAINT fk_pay_student FOREIGN KEY (student_id) REFERENCES students(student_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_pay_fee_structure FOREIGN KEY (fee_structure_id) REFERENCES fee_structures(fee_structure_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_pay_user FOREIGN KEY (recorded_by_user_id) REFERENCES users(user_id)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT chk_payment_amount CHECK (amount_paid > 0)
) ENGINE=InnoDB;

-- 7. Communication and feedback
CREATE TABLE notifications (
  notification_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  sender_user_id INT UNSIGNED NULL,
  target_role ENUM('student','faculty','admin','all') NOT NULL,
  target_user_id INT UNSIGNED NULL,
  title VARCHAR(150) NOT NULL,
  message TEXT NOT NULL,
  category ENUM('general','academic','exam','attendance','fees','system') NOT NULL DEFAULT 'general',
  priority ENUM('low','normal','high') NOT NULL DEFAULT 'normal',
  is_published TINYINT(1) NOT NULL DEFAULT 1,
  published_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  expires_at DATETIME NULL,
  PRIMARY KEY (notification_id),
  KEY idx_notifications_target (target_role, target_user_id, published_at),
  CONSTRAINT fk_notif_sender FOREIGN KEY (sender_user_id) REFERENCES users(user_id)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT fk_notif_target_user FOREIGN KEY (target_user_id) REFERENCES users(user_id)
    ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT chk_notif_published CHECK (is_published IN (0,1)),
  CONSTRAINT chk_notif_target CHECK (target_role <> 'all' OR target_user_id IS NULL)
) ENGINE=InnoDB;

CREATE TABLE notification_reads (
  read_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  notification_id BIGINT UNSIGNED NOT NULL,
  user_id INT UNSIGNED NOT NULL,
  read_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (read_id),
  UNIQUE KEY uk_notification_read (notification_id, user_id),
  KEY idx_notification_reads_user (user_id),
  CONSTRAINT fk_nr_notification FOREIGN KEY (notification_id) REFERENCES notifications(notification_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_nr_user FOREIGN KEY (user_id) REFERENCES users(user_id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE feedback (
  feedback_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  student_id INT UNSIGNED NOT NULL,
  subject_id INT UNSIGNED NULL,
  faculty_id INT UNSIGNED NULL,
  semester_id INT UNSIGNED NULL,
  category ENUM('course','faculty','facility','general') NOT NULL DEFAULT 'general',
  rating TINYINT UNSIGNED NOT NULL,
  comments TEXT NULL,
  is_anonymous TINYINT(1) NOT NULL DEFAULT 0,
  status ENUM('submitted','reviewed','archived') NOT NULL DEFAULT 'submitted',
  submitted_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  reviewed_by_user_id INT UNSIGNED NULL,
  reviewed_at DATETIME NULL,
  PRIMARY KEY (feedback_id),
  -- Functional unique index: NULL subject/semester are coalesced to 0 so
  -- general/facility feedback is also protected from duplicate submissions.
  UNIQUE KEY uk_feedback_once (
    student_id,
    category,
    (COALESCE(subject_id, 0)),
    (COALESCE(semester_id, 0))
  ),
  KEY idx_feedback_subject_semester (subject_id, semester_id),
  KEY idx_feedback_faculty (faculty_id),
  KEY idx_feedback_student (student_id),
  CONSTRAINT fk_fb_student FOREIGN KEY (student_id) REFERENCES students(student_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_fb_subject FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT fk_fb_faculty FOREIGN KEY (faculty_id) REFERENCES faculty(faculty_id)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT fk_fb_semester FOREIGN KEY (semester_id) REFERENCES semesters(semester_id)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT fk_fb_reviewer FOREIGN KEY (reviewed_by_user_id) REFERENCES users(user_id)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT chk_feedback_rating CHECK (rating BETWEEN 1 AND 5),
  CONSTRAINT chk_feedback_anonymous CHECK (is_anonymous IN (0,1))
) ENGINE=InnoDB;

SET FOREIGN_KEY_CHECKS = 1;
