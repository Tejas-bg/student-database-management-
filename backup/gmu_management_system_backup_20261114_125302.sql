-- GM University Management System — Pre-reset backup
-- Created: 2026-11-14T12:53:02.970619
-- Database: gmu_management_system

SET FOREIGN_KEY_CHECKS = 0;

-- Table: academic_years
DROP TABLE IF EXISTS academic_years;
CREATE TABLE `academic_years` (
  `academic_year_id` int unsigned NOT NULL AUTO_INCREMENT,
  `year_label` varchar(20) NOT NULL COMMENT 'e.g. 2025-26',
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `is_current` tinyint(1) NOT NULL DEFAULT '0',
  `status` enum('planned','active','closed') NOT NULL DEFAULT 'planned',
  PRIMARY KEY (`academic_year_id`),
  UNIQUE KEY `uk_academic_year_label` (`year_label`),
  CONSTRAINT `chk_academic_year_current` CHECK ((`is_current` in (0,1))),
  CONSTRAINT `chk_academic_year_dates` CHECK ((`end_date` > `start_date`))
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO academic_years (academic_year_id, year_label, start_date, end_date, is_current, status) VALUES (1, '2024-25', 2024-08-01, 2025-07-31, 0, 'closed');
INSERT INTO academic_years (academic_year_id, year_label, start_date, end_date, is_current, status) VALUES (2, '2025-26', 2025-08-01, 2026-07-31, 1, 'active');

-- Table: attendance_records
DROP TABLE IF EXISTS attendance_records;
CREATE TABLE `attendance_records` (
  `attendance_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `session_id` int unsigned NOT NULL,
  `enrolment_id` int unsigned NOT NULL,
  `status` enum('present','absent','late','excused') NOT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `marked_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `marked_by_user_id` int unsigned DEFAULT NULL,
  PRIMARY KEY (`attendance_id`),
  UNIQUE KEY `uk_attendance_record` (`session_id`,`enrolment_id`),
  KEY `idx_attendance_enrolment` (`enrolment_id`),
  KEY `fk_att_rec_user` (`marked_by_user_id`),
  CONSTRAINT `fk_att_rec_enrolment` FOREIGN KEY (`enrolment_id`) REFERENCES `student_enrolments` (`enrolment_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_att_rec_session` FOREIGN KEY (`session_id`) REFERENCES `attendance_sessions` (`session_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_att_rec_user` FOREIGN KEY (`marked_by_user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO attendance_records (attendance_id, session_id, enrolment_id, status, remarks, marked_at, marked_by_user_id) VALUES (1, 1, 1, 'present', NULL, 2026-11-13 09:12:32, 2);
INSERT INTO attendance_records (attendance_id, session_id, enrolment_id, status, remarks, marked_at, marked_by_user_id) VALUES (2, 1, 5, 'present', NULL, 2026-11-13 09:12:32, 2);
INSERT INTO attendance_records (attendance_id, session_id, enrolment_id, status, remarks, marked_at, marked_by_user_id) VALUES (3, 2, 1, 'late', 'Arrived 10 minutes late', 2026-11-13 09:12:32, 2);
INSERT INTO attendance_records (attendance_id, session_id, enrolment_id, status, remarks, marked_at, marked_by_user_id) VALUES (4, 2, 5, 'absent', NULL, 2026-11-13 09:12:32, 2);
INSERT INTO attendance_records (attendance_id, session_id, enrolment_id, status, remarks, marked_at, marked_by_user_id) VALUES (5, 3, 3, 'present', NULL, 2026-11-13 09:12:32, 2);
INSERT INTO attendance_records (attendance_id, session_id, enrolment_id, status, remarks, marked_at, marked_by_user_id) VALUES (6, 3, 6, 'present', NULL, 2026-11-13 09:12:32, 2);

-- Table: attendance_sessions
DROP TABLE IF EXISTS attendance_sessions;
CREATE TABLE `attendance_sessions` (
  `session_id` int unsigned NOT NULL AUTO_INCREMENT,
  `assignment_id` int unsigned NOT NULL,
  `session_date` date NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time DEFAULT NULL,
  `topic` varchar(200) DEFAULT NULL,
  `session_type` enum('lecture','lab','tutorial','other') NOT NULL DEFAULT 'lecture',
  `created_by_user_id` int unsigned DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`session_id`),
  UNIQUE KEY `uk_attendance_session` (`assignment_id`,`session_date`,`start_time`),
  KEY `fk_att_sess_user` (`created_by_user_id`),
  CONSTRAINT `fk_att_sess_assignment` FOREIGN KEY (`assignment_id`) REFERENCES `faculty_subject_assignments` (`assignment_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_att_sess_user` FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `chk_att_session_time` CHECK (((`end_time` is null) or (`end_time` > `start_time`)))
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO attendance_sessions (session_id, assignment_id, session_date, start_time, end_time, topic, session_type, created_by_user_id, created_at) VALUES (1, 1, 2025-09-01, 10:00:00, 11:00:00, 'ER Modeling', 'lecture', 2, 2026-11-13 09:12:32);
INSERT INTO attendance_sessions (session_id, assignment_id, session_date, start_time, end_time, topic, session_type, created_by_user_id, created_at) VALUES (2, 1, 2025-09-03, 10:00:00, 11:00:00, 'Normalization', 'lecture', 2, 2026-11-13 09:12:32);
INSERT INTO attendance_sessions (session_id, assignment_id, session_date, start_time, end_time, topic, session_type, created_by_user_id, created_at) VALUES (3, 4, 2026-02-10, 9:00:00, 10:00:00, 'OSI Model', 'lecture', 2, 2026-11-13 09:12:32);

-- Table: courses
DROP TABLE IF EXISTS courses;
CREATE TABLE `courses` (
  `course_id` int unsigned NOT NULL AUTO_INCREMENT,
  `department_id` int unsigned NOT NULL,
  `course_code` varchar(20) NOT NULL,
  `course_name` varchar(150) NOT NULL,
  `level` enum('UG','PG','Diploma','PhD') NOT NULL,
  `duration_semesters` tinyint unsigned NOT NULL,
  `total_credits` smallint unsigned DEFAULT NULL,
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`course_id`),
  UNIQUE KEY `uk_courses_code` (`course_code`),
  KEY `idx_courses_department` (`department_id`),
  CONSTRAINT `fk_courses_department` FOREIGN KEY (`department_id`) REFERENCES `departments` (`department_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_courses_duration` CHECK ((`duration_semesters` between 1 and 12))
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO courses (course_id, department_id, course_code, course_name, level, duration_semesters, total_credits, status, created_at, updated_at) VALUES (1, 1, 'BTECH-CSE', 'Bachelor of Technology in Computer Science', 'UG', 8, 160, 'active', 2026-11-13 09:12:32, 2026-11-13 09:12:32);
INSERT INTO courses (course_id, department_id, course_code, course_name, level, duration_semesters, total_credits, status, created_at, updated_at) VALUES (2, 2, 'BTECH-ECE', 'Bachelor of Technology in Electronics and Communication', 'UG', 8, 160, 'active', 2026-11-13 09:12:32, 2026-11-13 09:12:32);
INSERT INTO courses (course_id, department_id, course_code, course_name, level, duration_semesters, total_credits, status, created_at, updated_at) VALUES (3, 3, 'MBA-GEN', 'Master of Business Administration', 'PG', 4, 90, 'active', 2026-11-13 09:12:32, 2026-11-13 09:12:32);

-- Table: departments
DROP TABLE IF EXISTS departments;
CREATE TABLE `departments` (
  `department_id` int unsigned NOT NULL AUTO_INCREMENT,
  `department_code` varchar(20) NOT NULL,
  `department_name` varchar(120) NOT NULL,
  `hod_name` varchar(120) DEFAULT NULL,
  `office_location` varchar(120) DEFAULT NULL,
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`department_id`),
  UNIQUE KEY `uk_departments_code` (`department_code`),
  UNIQUE KEY `uk_departments_name` (`department_name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO departments (department_id, department_code, department_name, hod_name, office_location, status, created_at, updated_at) VALUES (1, 'CSE', 'Computer Science and Engineering', 'Dr. Sample HOD A', 'Block A, Room 201', 'active', 2026-11-13 09:12:32, 2026-11-13 09:12:32);
INSERT INTO departments (department_id, department_code, department_name, hod_name, office_location, status, created_at, updated_at) VALUES (2, 'ECE', 'Electronics and Communication Engineering', 'Dr. Sample HOD B', 'Block B, Room 110', 'active', 2026-11-13 09:12:32, 2026-11-13 09:12:32);
INSERT INTO departments (department_id, department_code, department_name, hod_name, office_location, status, created_at, updated_at) VALUES (3, 'MBA', 'Master of Business Administration', 'Dr. Sample HOD C', 'Block C, Room 305', 'active', 2026-11-13 09:12:32, 2026-11-13 09:12:32);

-- Table: faculty
DROP TABLE IF EXISTS faculty;
CREATE TABLE `faculty` (
  `faculty_id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned DEFAULT NULL,
  `department_id` int unsigned NOT NULL,
  `employee_id` varchar(30) NOT NULL,
  `first_name` varchar(60) NOT NULL,
  `last_name` varchar(60) NOT NULL,
  `designation` varchar(80) NOT NULL,
  `qualification` varchar(120) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `aadhaar` varchar(50) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `date_of_joining` date DEFAULT NULL,
  `status` enum('active','inactive','on_leave') NOT NULL DEFAULT 'active',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`faculty_id`),
  UNIQUE KEY `uk_faculty_employee_id` (`employee_id`),
  UNIQUE KEY `uk_faculty_user` (`user_id`),
  UNIQUE KEY `uk_faculty_email` (`email`),
  UNIQUE KEY `aadhaar` (`aadhaar`),
  KEY `idx_faculty_department` (`department_id`),
  CONSTRAINT `fk_faculty_department` FOREIGN KEY (`department_id`) REFERENCES `departments` (`department_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_faculty_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO faculty (faculty_id, user_id, department_id, employee_id, first_name, last_name, designation, qualification, email, aadhaar, phone, date_of_joining, status, created_at, updated_at) VALUES (1, 2, 1, 'FAC-CSE-014', 'Anita', 'Rao', 'Associate Professor', 'PhD (CSE)', 'anita.rao.faculty@example.edu', NULL, '9100000014', 2018-07-01, 'active', 2026-11-13 09:12:32, 2026-11-13 09:12:32);
INSERT INTO faculty (faculty_id, user_id, department_id, employee_id, first_name, last_name, designation, qualification, email, aadhaar, phone, date_of_joining, status, created_at, updated_at) VALUES (2, 3, 1, 'FAC-CSE-021', 'Rahul', 'Mehta', 'Assistant Professor', 'M.Tech (CSE)', 'rahul.mehta.faculty@example.edu', NULL, '9100000021', 2020-08-15, 'active', 2026-11-13 09:12:32, 2026-11-13 09:12:32);

-- Table: faculty_subject_assignments
DROP TABLE IF EXISTS faculty_subject_assignments;
CREATE TABLE `faculty_subject_assignments` (
  `assignment_id` int unsigned NOT NULL AUTO_INCREMENT,
  `faculty_id` int unsigned NOT NULL,
  `subject_id` int unsigned NOT NULL,
  `semester_id` int unsigned NOT NULL,
  `section` varchar(10) NOT NULL DEFAULT 'A',
  `assigned_on` date NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`assignment_id`),
  UNIQUE KEY `uk_assignment` (`faculty_id`,`subject_id`,`semester_id`,`section`),
  KEY `idx_assignment_semester_subject` (`semester_id`,`subject_id`),
  KEY `fk_assign_subject` (`subject_id`),
  CONSTRAINT `fk_assign_faculty` FOREIGN KEY (`faculty_id`) REFERENCES `faculty` (`faculty_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_assign_semester` FOREIGN KEY (`semester_id`) REFERENCES `semesters` (`semester_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_assign_subject` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`subject_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_assignment_active` CHECK ((`is_active` in (0,1)))
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO faculty_subject_assignments (assignment_id, faculty_id, subject_id, semester_id, section, assigned_on, is_active) VALUES (1, 1, 1, 1, 'A', 2025-08-05, 1);
INSERT INTO faculty_subject_assignments (assignment_id, faculty_id, subject_id, semester_id, section, assigned_on, is_active) VALUES (2, 1, 3, 1, 'A', 2025-08-05, 1);
INSERT INTO faculty_subject_assignments (assignment_id, faculty_id, subject_id, semester_id, section, assigned_on, is_active) VALUES (3, 2, 2, 1, 'A', 2025-08-05, 1);
INSERT INTO faculty_subject_assignments (assignment_id, faculty_id, subject_id, semester_id, section, assigned_on, is_active) VALUES (4, 1, 4, 2, 'A', 2026-01-05, 1);
INSERT INTO faculty_subject_assignments (assignment_id, faculty_id, subject_id, semester_id, section, assigned_on, is_active) VALUES (5, 2, 5, 2, 'A', 2026-01-05, 1);

-- Table: fee_payments
DROP TABLE IF EXISTS fee_payments;
CREATE TABLE `fee_payments` (
  `payment_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `student_id` int unsigned NOT NULL,
  `fee_structure_id` int unsigned NOT NULL,
  `amount_paid` decimal(10,2) NOT NULL,
  `payment_date` date NOT NULL,
  `payment_mode` enum('cash','upi','card','net_banking','dd','cheque','other') NOT NULL,
  `transaction_ref` varchar(80) DEFAULT NULL,
  `receipt_no` varchar(50) DEFAULT NULL,
  `payment_status` enum('pending','success','failed','refunded') NOT NULL DEFAULT 'success',
  `remarks` varchar(255) DEFAULT NULL,
  `recorded_by_user_id` int unsigned DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`payment_id`),
  UNIQUE KEY `uk_payment_receipt` (`receipt_no`),
  UNIQUE KEY `uk_payment_txn` (`transaction_ref`),
  KEY `idx_payment_student` (`student_id`,`payment_date`),
  KEY `idx_payment_fee_structure` (`fee_structure_id`),
  KEY `fk_pay_user` (`recorded_by_user_id`),
  CONSTRAINT `fk_pay_fee_structure` FOREIGN KEY (`fee_structure_id`) REFERENCES `fee_structures` (`fee_structure_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_pay_student` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_pay_user` FOREIGN KEY (`recorded_by_user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `chk_payment_amount` CHECK ((`amount_paid` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO fee_payments (payment_id, student_id, fee_structure_id, amount_paid, payment_date, payment_mode, transaction_ref, receipt_no, payment_status, remarks, recorded_by_user_id, created_at) VALUES (1, 1, 1, 55000.00, 2026-02-10, 'upi', 'TXN-FICTIONAL-1001', 'RCPT-2026-0001', 'success', 'Full tuition paid', 1, 2026-11-13 09:12:32);
INSERT INTO fee_payments (payment_id, student_id, fee_structure_id, amount_paid, payment_date, payment_mode, transaction_ref, receipt_no, payment_status, remarks, recorded_by_user_id, created_at) VALUES (2, 1, 2, 2500.00, 2026-03-01, 'net_banking', 'TXN-FICTIONAL-1002', 'RCPT-2026-0002', 'success', NULL, 1, 2026-11-13 09:12:32);
INSERT INTO fee_payments (payment_id, student_id, fee_structure_id, amount_paid, payment_date, payment_mode, transaction_ref, receipt_no, payment_status, remarks, recorded_by_user_id, created_at) VALUES (3, 2, 1, 25000.00, 2026-02-12, 'card', 'TXN-FICTIONAL-1003', 'RCPT-2026-0003', 'success', 'Partial payment', 1, 2026-11-13 09:12:32);

-- Table: fee_structures
DROP TABLE IF EXISTS fee_structures;
CREATE TABLE `fee_structures` (
  `fee_structure_id` int unsigned NOT NULL AUTO_INCREMENT,
  `course_id` int unsigned NOT NULL,
  `academic_year_id` int unsigned NOT NULL,
  `semester_number` tinyint unsigned NOT NULL COMMENT '1-12; split annual fees per semester so uniqueness is reliable',
  `fee_head` varchar(100) NOT NULL COMMENT 'e.g. Tuition, Exam, Library',
  `amount` decimal(10,2) NOT NULL,
  `due_date` date DEFAULT NULL,
  `is_mandatory` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`fee_structure_id`),
  UNIQUE KEY `uk_fee_structure` (`course_id`,`academic_year_id`,`semester_number`,`fee_head`),
  KEY `idx_fee_structure_year` (`academic_year_id`),
  CONSTRAINT `fk_fee_course` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_fee_year` FOREIGN KEY (`academic_year_id`) REFERENCES `academic_years` (`academic_year_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_fee_amount` CHECK ((`amount` >= 0)),
  CONSTRAINT `chk_fee_mandatory` CHECK ((`is_mandatory` in (0,1))),
  CONSTRAINT `chk_fee_semester` CHECK ((`semester_number` between 1 and 12))
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO fee_structures (fee_structure_id, course_id, academic_year_id, semester_number, fee_head, amount, due_date, is_mandatory) VALUES (1, 1, 2, 6, 'Tuition Fee', 55000.00, 2026-02-15, 1);
INSERT INTO fee_structures (fee_structure_id, course_id, academic_year_id, semester_number, fee_head, amount, due_date, is_mandatory) VALUES (2, 1, 2, 6, 'Examination Fee', 2500.00, 2026-03-15, 1);
INSERT INTO fee_structures (fee_structure_id, course_id, academic_year_id, semester_number, fee_head, amount, due_date, is_mandatory) VALUES (3, 1, 2, 6, 'Library Fee', 1500.00, 2026-02-15, 1);
INSERT INTO fee_structures (fee_structure_id, course_id, academic_year_id, semester_number, fee_head, amount, due_date, is_mandatory) VALUES (4, 2, 2, 4, 'Tuition Fee', 52000.00, 2026-02-15, 1);

-- Table: feedback
DROP TABLE IF EXISTS feedback;
CREATE TABLE `feedback` (
  `feedback_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `student_id` int unsigned NOT NULL,
  `subject_id` int unsigned DEFAULT NULL,
  `faculty_id` int unsigned DEFAULT NULL,
  `semester_id` int unsigned DEFAULT NULL,
  `category` enum('course','faculty','facility','general') NOT NULL DEFAULT 'general',
  `rating` tinyint unsigned NOT NULL,
  `comments` text,
  `is_anonymous` tinyint(1) NOT NULL DEFAULT '0',
  `status` enum('submitted','reviewed','archived') NOT NULL DEFAULT 'submitted',
  `submitted_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `reviewed_by_user_id` int unsigned DEFAULT NULL,
  `reviewed_at` datetime DEFAULT NULL,
  PRIMARY KEY (`feedback_id`),
  UNIQUE KEY `uk_feedback_once` (`student_id`,`category`,(coalesce(`subject_id`,0)),(coalesce(`semester_id`,0))),
  KEY `idx_feedback_subject_semester` (`subject_id`,`semester_id`),
  KEY `idx_feedback_faculty` (`faculty_id`),
  KEY `idx_feedback_student` (`student_id`),
  KEY `fk_fb_semester` (`semester_id`),
  KEY `fk_fb_reviewer` (`reviewed_by_user_id`),
  CONSTRAINT `fk_fb_faculty` FOREIGN KEY (`faculty_id`) REFERENCES `faculty` (`faculty_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_fb_reviewer` FOREIGN KEY (`reviewed_by_user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_fb_semester` FOREIGN KEY (`semester_id`) REFERENCES `semesters` (`semester_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_fb_student` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_fb_subject` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`subject_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `chk_feedback_anonymous` CHECK ((`is_anonymous` in (0,1))),
  CONSTRAINT `chk_feedback_rating` CHECK ((`rating` between 1 and 5))
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO feedback (feedback_id, student_id, subject_id, faculty_id, semester_id, category, rating, comments, is_anonymous, status, submitted_at, reviewed_by_user_id, reviewed_at) VALUES (1, 1, 1, 1, 1, 'course', 5, 'Well-structured DBMS course. (Fictional sample)', 0, 'reviewed', 2025-12-18 14:00:00, 1, 2025-12-19 10:00:00);
INSERT INTO feedback (feedback_id, student_id, subject_id, faculty_id, semester_id, category, rating, comments, is_anonymous, status, submitted_at, reviewed_by_user_id, reviewed_at) VALUES (2, 2, 1, 1, 1, 'faculty', 4, 'Clear explanations and practical examples. (Fictional sample)', 1, 'submitted', 2025-12-18 15:30:00, NULL, NULL);

-- Table: internal_assessments
DROP TABLE IF EXISTS internal_assessments;
CREATE TABLE `internal_assessments` (
  `assessment_id` int unsigned NOT NULL AUTO_INCREMENT,
  `subject_id` int unsigned NOT NULL,
  `semester_id` int unsigned NOT NULL,
  `assessment_name` varchar(80) NOT NULL COMMENT 'e.g. IA-1, IA-2, Assignment',
  `max_marks` decimal(5,2) NOT NULL,
  `weightage_percent` decimal(5,2) DEFAULT NULL,
  `assessment_date` date DEFAULT NULL,
  PRIMARY KEY (`assessment_id`),
  UNIQUE KEY `uk_internal_assessment` (`subject_id`,`semester_id`,`assessment_name`),
  KEY `fk_ia_semester` (`semester_id`),
  CONSTRAINT `fk_ia_semester` FOREIGN KEY (`semester_id`) REFERENCES `semesters` (`semester_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_ia_subject` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`subject_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_ia_max_marks` CHECK ((`max_marks` > 0)),
  CONSTRAINT `chk_ia_weightage` CHECK (((`weightage_percent` is null) or (`weightage_percent` between 0 and 100)))
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO internal_assessments (assessment_id, subject_id, semester_id, assessment_name, max_marks, weightage_percent, assessment_date) VALUES (1, 1, 1, 'IA-1', 25.00, 12.50, 2025-09-20);
INSERT INTO internal_assessments (assessment_id, subject_id, semester_id, assessment_name, max_marks, weightage_percent, assessment_date) VALUES (2, 1, 1, 'IA-2', 25.00, 12.50, 2025-11-05);
INSERT INTO internal_assessments (assessment_id, subject_id, semester_id, assessment_name, max_marks, weightage_percent, assessment_date) VALUES (3, 4, 2, 'IA-1', 25.00, 12.50, 2026-03-10);

-- Table: internal_marks
DROP TABLE IF EXISTS internal_marks;
CREATE TABLE `internal_marks` (
  `internal_mark_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `assessment_id` int unsigned NOT NULL,
  `enrolment_id` int unsigned NOT NULL,
  `marks_obtained` decimal(5,2) NOT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `entered_by_user_id` int unsigned DEFAULT NULL,
  `entered_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`internal_mark_id`),
  UNIQUE KEY `uk_internal_mark` (`assessment_id`,`enrolment_id`),
  KEY `idx_internal_marks_enrolment` (`enrolment_id`),
  KEY `fk_im_user` (`entered_by_user_id`),
  CONSTRAINT `fk_im_assessment` FOREIGN KEY (`assessment_id`) REFERENCES `internal_assessments` (`assessment_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_im_enrolment` FOREIGN KEY (`enrolment_id`) REFERENCES `student_enrolments` (`enrolment_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_im_user` FOREIGN KEY (`entered_by_user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `chk_internal_marks_nonneg` CHECK ((`marks_obtained` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO internal_marks (internal_mark_id, assessment_id, enrolment_id, marks_obtained, remarks, entered_by_user_id, entered_at, updated_at) VALUES (1, 1, 1, 22.00, 'Good performance', 2, 2026-11-13 09:12:32, 2026-11-13 09:12:32);
INSERT INTO internal_marks (internal_mark_id, assessment_id, enrolment_id, marks_obtained, remarks, entered_by_user_id, entered_at, updated_at) VALUES (2, 1, 5, 19.50, NULL, 2, 2026-11-13 09:12:32, 2026-11-13 09:12:32);
INSERT INTO internal_marks (internal_mark_id, assessment_id, enrolment_id, marks_obtained, remarks, entered_by_user_id, entered_at, updated_at) VALUES (3, 2, 1, 23.00, NULL, 2, 2026-11-13 09:12:32, 2026-11-13 09:12:32);
INSERT INTO internal_marks (internal_mark_id, assessment_id, enrolment_id, marks_obtained, remarks, entered_by_user_id, entered_at, updated_at) VALUES (4, 3, 3, 21.00, 'In progress term', 2, 2026-11-13 09:12:32, 2026-11-13 09:12:32);

-- Table: notification_reads
DROP TABLE IF EXISTS notification_reads;
CREATE TABLE `notification_reads` (
  `read_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `notification_id` bigint unsigned NOT NULL,
  `user_id` int unsigned NOT NULL,
  `read_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`read_id`),
  UNIQUE KEY `uk_notification_read` (`notification_id`,`user_id`),
  KEY `idx_notification_reads_user` (`user_id`),
  CONSTRAINT `fk_nr_notification` FOREIGN KEY (`notification_id`) REFERENCES `notifications` (`notification_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_nr_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO notification_reads (read_id, notification_id, user_id, read_at) VALUES (1, 1, 4, 2026-01-07 10:15:00);
INSERT INTO notification_reads (read_id, notification_id, user_id, read_at) VALUES (2, 3, 2, 2026-11-01 09:00:00);

-- Table: notifications
DROP TABLE IF EXISTS notifications;
CREATE TABLE `notifications` (
  `notification_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `sender_user_id` int unsigned DEFAULT NULL,
  `target_role` enum('student','faculty','admin','all') NOT NULL,
  `target_user_id` int unsigned DEFAULT NULL,
  `title` varchar(150) NOT NULL,
  `message` text NOT NULL,
  `category` enum('general','academic','exam','attendance','fees','system') NOT NULL DEFAULT 'general',
  `priority` enum('low','normal','high') NOT NULL DEFAULT 'normal',
  `is_published` tinyint(1) NOT NULL DEFAULT '1',
  `published_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `expires_at` datetime DEFAULT NULL,
  PRIMARY KEY (`notification_id`),
  KEY `idx_notifications_target` (`target_role`,`target_user_id`,`published_at`),
  KEY `fk_notif_sender` (`sender_user_id`),
  KEY `fk_notif_target_user` (`target_user_id`),
  CONSTRAINT `fk_notif_sender` FOREIGN KEY (`sender_user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_notif_target_user` FOREIGN KEY (`target_user_id`) REFERENCES `users` (`user_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `chk_notif_published` CHECK ((`is_published` in (0,1))),
  CONSTRAINT `chk_notif_target` CHECK (((`target_role` <> _utf8mb4'all') or (`target_user_id` is null)))
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO notifications (notification_id, sender_user_id, target_role, target_user_id, title, message, category, priority, is_published, published_at, expires_at) VALUES (1, 1, 'student', NULL, 'Semester 6 timetable published', 'The Semester 6 timetable is now available in the student portal. (Sample)', 'academic', 'normal', 1, 2026-01-07 09:00:00, NULL);
INSERT INTO notifications (notification_id, sender_user_id, target_role, target_user_id, title, message, category, priority, is_published, published_at, expires_at) VALUES (2, 1, 'faculty', 2, 'Internal marks entry window', 'Please submit IA-1 marks by the published deadline. (Sample)', 'exam', 'high', 1, 2026-03-05 10:00:00, NULL);
INSERT INTO notifications (notification_id, sender_user_id, target_role, target_user_id, title, message, category, priority, is_published, published_at, expires_at) VALUES (3, 1, 'all', NULL, 'Portal maintenance notice', 'Scheduled maintenance preview notice for demonstration purposes.', 'system', 'low', 1, 2026-11-01 08:00:00, NULL);

-- Table: password_reset_tokens
DROP TABLE IF EXISTS password_reset_tokens;
CREATE TABLE `password_reset_tokens` (
  `token_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `token_hash` char(64) NOT NULL,
  `expires_at` datetime NOT NULL,
  `used_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`token_id`),
  UNIQUE KEY `uk_reset_token_hash` (`token_hash`),
  KEY `idx_reset_user_expires` (`user_id`,`expires_at`),
  CONSTRAINT `fk_reset_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO password_reset_tokens (token_id, user_id, token_hash, expires_at, used_at, created_at) VALUES (1, 4, '0d6518c8e6e5896399fb4d7f86f5a83ab43b0cbb5dd803c02c721f54ffb43494', 2026-11-12 10:00:00, NULL, 2026-11-13 09:12:32);

-- Table: roles
DROP TABLE IF EXISTS roles;
CREATE TABLE `roles` (
  `role_id` tinyint unsigned NOT NULL AUTO_INCREMENT,
  `role_code` varchar(20) NOT NULL,
  `role_name` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`role_id`),
  UNIQUE KEY `uk_roles_code` (`role_code`),
  CONSTRAINT `chk_roles_code` CHECK ((`role_code` in (_utf8mb4'student',_utf8mb4'faculty',_utf8mb4'admin')))
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO roles (role_id, role_code, role_name, description, created_at) VALUES (1, 'student', 'Student', 'Student portal access', 2026-11-13 09:12:32);
INSERT INTO roles (role_id, role_code, role_name, description, created_at) VALUES (2, 'faculty', 'Faculty', 'Faculty portal access', 2026-11-13 09:12:32);
INSERT INTO roles (role_id, role_code, role_name, description, created_at) VALUES (3, 'admin', 'Administrator', 'Administration portal access', 2026-11-13 09:12:32);

-- Table: semester_exams
DROP TABLE IF EXISTS semester_exams;
CREATE TABLE `semester_exams` (
  `exam_id` int unsigned NOT NULL AUTO_INCREMENT,
  `subject_id` int unsigned NOT NULL,
  `semester_id` int unsigned NOT NULL,
  `exam_name` varchar(80) NOT NULL DEFAULT 'End Semester Examination',
  `exam_date` date DEFAULT NULL,
  `max_marks` decimal(5,2) NOT NULL,
  `passing_marks` decimal(5,2) NOT NULL,
  PRIMARY KEY (`exam_id`),
  UNIQUE KEY `uk_semester_exam` (`subject_id`,`semester_id`,`exam_name`),
  KEY `fk_se_semester` (`semester_id`),
  CONSTRAINT `fk_se_semester` FOREIGN KEY (`semester_id`) REFERENCES `semesters` (`semester_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_se_subject` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`subject_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_exam_max` CHECK ((`max_marks` > 0)),
  CONSTRAINT `chk_exam_pass` CHECK (((`passing_marks` >= 0) and (`passing_marks` <= `max_marks`)))
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO semester_exams (exam_id, subject_id, semester_id, exam_name, exam_date, max_marks, passing_marks) VALUES (1, 1, 1, 'End Semester Examination', 2025-12-10, 100.00, 40.00);
INSERT INTO semester_exams (exam_id, subject_id, semester_id, exam_name, exam_date, max_marks, passing_marks) VALUES (2, 2, 1, 'End Semester Examination', 2025-12-13, 100.00, 40.00);

-- Table: semester_marks
DROP TABLE IF EXISTS semester_marks;
CREATE TABLE `semester_marks` (
  `semester_mark_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `exam_id` int unsigned NOT NULL,
  `enrolment_id` int unsigned NOT NULL,
  `marks_obtained` decimal(5,2) NOT NULL,
  `grade` varchar(5) DEFAULT NULL,
  `grade_point` decimal(3,2) DEFAULT NULL,
  `result_status` enum('pass','fail','absent','withheld') NOT NULL,
  `published_at` datetime DEFAULT NULL,
  `entered_by_user_id` int unsigned DEFAULT NULL,
  PRIMARY KEY (`semester_mark_id`),
  UNIQUE KEY `uk_semester_mark` (`exam_id`,`enrolment_id`),
  KEY `idx_semester_marks_enrolment` (`enrolment_id`),
  KEY `fk_sm_user` (`entered_by_user_id`),
  CONSTRAINT `fk_sm_enrolment` FOREIGN KEY (`enrolment_id`) REFERENCES `student_enrolments` (`enrolment_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_sm_exam` FOREIGN KEY (`exam_id`) REFERENCES `semester_exams` (`exam_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_sm_user` FOREIGN KEY (`entered_by_user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `chk_grade_point` CHECK (((`grade_point` is null) or (`grade_point` between 0 and 10))),
  CONSTRAINT `chk_semester_marks_nonneg` CHECK ((`marks_obtained` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO semester_marks (semester_mark_id, exam_id, enrolment_id, marks_obtained, grade, grade_point, result_status, published_at, entered_by_user_id) VALUES (1, 1, 1, 84.00, 'A', 9.00, 'pass', 2026-01-05 10:00:00, 1);
INSERT INTO semester_marks (semester_mark_id, exam_id, enrolment_id, marks_obtained, grade, grade_point, result_status, published_at, entered_by_user_id) VALUES (2, 1, 5, 76.00, 'B+', 8.00, 'pass', 2026-01-05 10:00:00, 1);
INSERT INTO semester_marks (semester_mark_id, exam_id, enrolment_id, marks_obtained, grade, grade_point, result_status, published_at, entered_by_user_id) VALUES (3, 2, 2, 79.00, 'A', 8.50, 'pass', 2026-01-05 10:00:00, 1);

-- Table: semesters
DROP TABLE IF EXISTS semesters;
CREATE TABLE `semesters` (
  `semester_id` int unsigned NOT NULL AUTO_INCREMENT,
  `course_id` int unsigned NOT NULL,
  `academic_year_id` int unsigned NOT NULL,
  `semester_number` tinyint unsigned NOT NULL,
  `term_label` varchar(30) NOT NULL COMMENT 'e.g. Odd, Even',
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `status` enum('planned','active','completed') NOT NULL DEFAULT 'planned',
  PRIMARY KEY (`semester_id`),
  UNIQUE KEY `uk_semester_course_year_number` (`course_id`,`academic_year_id`,`semester_number`),
  KEY `idx_semesters_academic_year` (`academic_year_id`),
  CONSTRAINT `fk_semesters_academic_year` FOREIGN KEY (`academic_year_id`) REFERENCES `academic_years` (`academic_year_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_semesters_course` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_semester_dates` CHECK (((`end_date` is null) or (`start_date` is null) or (`end_date` >= `start_date`))),
  CONSTRAINT `chk_semester_number` CHECK ((`semester_number` between 1 and 12))
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO semesters (semester_id, course_id, academic_year_id, semester_number, term_label, start_date, end_date, status) VALUES (1, 1, 2, 5, 'Odd', 2025-08-10, 2025-12-20, 'completed');
INSERT INTO semesters (semester_id, course_id, academic_year_id, semester_number, term_label, start_date, end_date, status) VALUES (2, 1, 2, 6, 'Even', 2026-01-10, 2026-05-30, 'active');
INSERT INTO semesters (semester_id, course_id, academic_year_id, semester_number, term_label, start_date, end_date, status) VALUES (3, 2, 2, 4, 'Even', 2026-01-10, 2026-05-30, 'active');
INSERT INTO semesters (semester_id, course_id, academic_year_id, semester_number, term_label, start_date, end_date, status) VALUES (4, 3, 2, 2, 'Even', 2026-01-10, 2026-05-30, 'active');

-- Table: student_enrolments
DROP TABLE IF EXISTS student_enrolments;
CREATE TABLE `student_enrolments` (
  `enrolment_id` int unsigned NOT NULL AUTO_INCREMENT,
  `student_id` int unsigned NOT NULL,
  `subject_id` int unsigned NOT NULL,
  `semester_id` int unsigned NOT NULL,
  `section` varchar(10) NOT NULL DEFAULT 'A',
  `enrolment_date` date NOT NULL,
  `status` enum('enrolled','completed','dropped','failed') NOT NULL DEFAULT 'enrolled',
  PRIMARY KEY (`enrolment_id`),
  UNIQUE KEY `uk_enrolment` (`student_id`,`subject_id`,`semester_id`),
  KEY `idx_enrolment_subject_semester_section` (`subject_id`,`semester_id`,`section`),
  KEY `idx_enrolment_student_semester` (`student_id`,`semester_id`),
  KEY `fk_enrol_semester` (`semester_id`),
  CONSTRAINT `fk_enrol_semester` FOREIGN KEY (`semester_id`) REFERENCES `semesters` (`semester_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_enrol_student` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_enrol_subject` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`subject_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO student_enrolments (enrolment_id, student_id, subject_id, semester_id, section, enrolment_date, status) VALUES (1, 1, 1, 1, 'A', 2025-08-08, 'completed');
INSERT INTO student_enrolments (enrolment_id, student_id, subject_id, semester_id, section, enrolment_date, status) VALUES (2, 1, 2, 1, 'A', 2025-08-08, 'completed');
INSERT INTO student_enrolments (enrolment_id, student_id, subject_id, semester_id, section, enrolment_date, status) VALUES (3, 1, 4, 2, 'A', 2026-01-08, 'enrolled');
INSERT INTO student_enrolments (enrolment_id, student_id, subject_id, semester_id, section, enrolment_date, status) VALUES (4, 1, 5, 2, 'A', 2026-01-08, 'enrolled');
INSERT INTO student_enrolments (enrolment_id, student_id, subject_id, semester_id, section, enrolment_date, status) VALUES (5, 2, 1, 1, 'A', 2025-08-08, 'completed');
INSERT INTO student_enrolments (enrolment_id, student_id, subject_id, semester_id, section, enrolment_date, status) VALUES (6, 2, 4, 2, 'A', 2026-01-08, 'enrolled');

-- Table: students
DROP TABLE IF EXISTS students;
CREATE TABLE `students` (
  `student_id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned DEFAULT NULL,
  `department_id` int unsigned NOT NULL COMMENT 'Administrative home department; may differ from the course department',
  `course_id` int unsigned NOT NULL,
  `usn` varchar(20) NOT NULL,
  `first_name` varchar(60) NOT NULL,
  `last_name` varchar(60) NOT NULL,
  `date_of_birth` date DEFAULT NULL,
  `gender` enum('male','female','other','prefer_not_to_say') DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `aadhaar` varchar(50) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address_line1` varchar(255) DEFAULT NULL,
  `city` varchar(80) DEFAULT NULL,
  `state` varchar(80) DEFAULT NULL,
  `pincode` varchar(10) DEFAULT NULL,
  `admission_year` year NOT NULL,
  `current_semester` tinyint unsigned NOT NULL,
  `status` enum('active','inactive','graduated','withdrawn') NOT NULL DEFAULT 'active',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`student_id`),
  UNIQUE KEY `uk_students_usn` (`usn`),
  UNIQUE KEY `uk_students_user` (`user_id`),
  UNIQUE KEY `uk_students_email` (`email`),
  UNIQUE KEY `aadhaar` (`aadhaar`),
  KEY `idx_students_department_course` (`department_id`,`course_id`),
  KEY `idx_students_status` (`status`),
  KEY `fk_students_course` (`course_id`),
  CONSTRAINT `fk_students_course` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_students_department` FOREIGN KEY (`department_id`) REFERENCES `departments` (`department_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_students_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `chk_students_semester` CHECK ((`current_semester` between 1 and 12))
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO students (student_id, user_id, department_id, course_id, usn, first_name, last_name, date_of_birth, gender, email, aadhaar, phone, address_line1, city, state, pincode, admission_year, current_semester, status, created_at, updated_at) VALUES (1, 4, 1, 1, '1GM23CS045', 'Rahul', 'Sharma', 2005-04-12, 'male', 'aarav.sharma.student@example.edu', NULL, '9000000045', NULL, NULL, NULL, NULL, 2023, 6, 'active', 2026-11-13 09:12:32, 2026-11-14 10:58:09);
INSERT INTO students (student_id, user_id, department_id, course_id, usn, first_name, last_name, date_of_birth, gender, email, aadhaar, phone, address_line1, city, state, pincode, admission_year, current_semester, status, created_at, updated_at) VALUES (2, 5, 1, 1, '1GM23CS052', 'Diya', 'Nair', 2005-09-03, 'female', 'diya.nair.student@example.edu', NULL, '9000000052', NULL, NULL, NULL, NULL, 2023, 6, 'active', 2026-11-13 09:12:32, 2026-11-13 09:12:32);
INSERT INTO students (student_id, user_id, department_id, course_id, usn, first_name, last_name, date_of_birth, gender, email, aadhaar, phone, address_line1, city, state, pincode, admission_year, current_semester, status, created_at, updated_at) VALUES (3, 6, 2, 2, '1GM22EC018', 'Kiran', 'Patil', 2004-12-21, 'male', 'kiran.patil.student@example.edu', NULL, '9000000018', NULL, NULL, NULL, NULL, 2022, 4, 'inactive', 2026-11-13 09:12:32, 2026-11-13 09:12:32);

-- Table: subjects
DROP TABLE IF EXISTS subjects;
CREATE TABLE `subjects` (
  `subject_id` int unsigned NOT NULL AUTO_INCREMENT,
  `course_id` int unsigned NOT NULL,
  `department_id` int unsigned NOT NULL COMMENT 'Owning department; may differ from the course department for service/interdisciplinary subjects',
  `semester_number` tinyint unsigned NOT NULL COMMENT 'Curriculum semester in the course',
  `subject_code` varchar(20) NOT NULL,
  `subject_name` varchar(150) NOT NULL,
  `subject_type` enum('theory','practical','lab','project','elective') NOT NULL DEFAULT 'theory',
  `credits` tinyint unsigned NOT NULL,
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`subject_id`),
  UNIQUE KEY `uk_subjects_code` (`subject_code`),
  KEY `idx_subjects_course_semester` (`course_id`,`semester_number`),
  KEY `idx_subjects_department` (`department_id`),
  CONSTRAINT `fk_subjects_course` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_subjects_department` FOREIGN KEY (`department_id`) REFERENCES `departments` (`department_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_subjects_credits` CHECK ((`credits` between 0 and 30)),
  CONSTRAINT `chk_subjects_semester` CHECK ((`semester_number` between 1 and 12))
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO subjects (subject_id, course_id, department_id, semester_number, subject_code, subject_name, subject_type, credits, status, created_at, updated_at) VALUES (1, 1, 1, 5, 'CS501', 'Database Management Systems', 'theory', 4, 'active', 2026-11-13 09:12:32, 2026-11-13 09:12:32);
INSERT INTO subjects (subject_id, course_id, department_id, semester_number, subject_code, subject_name, subject_type, credits, status, created_at, updated_at) VALUES (2, 1, 1, 5, 'CS502', 'Operating Systems', 'theory', 4, 'active', 2026-11-13 09:12:32, 2026-11-13 09:12:32);
INSERT INTO subjects (subject_id, course_id, department_id, semester_number, subject_code, subject_name, subject_type, credits, status, created_at, updated_at) VALUES (3, 1, 1, 5, 'CS503', 'Database Lab', 'lab', 2, 'active', 2026-11-13 09:12:32, 2026-11-13 09:12:32);
INSERT INTO subjects (subject_id, course_id, department_id, semester_number, subject_code, subject_name, subject_type, credits, status, created_at, updated_at) VALUES (4, 1, 1, 6, 'CS601', 'Computer Networks', 'theory', 4, 'active', 2026-11-13 09:12:32, 2026-11-13 09:12:32);
INSERT INTO subjects (subject_id, course_id, department_id, semester_number, subject_code, subject_name, subject_type, credits, status, created_at, updated_at) VALUES (5, 1, 1, 6, 'CS602', 'Software Engineering', 'theory', 3, 'active', 2026-11-13 09:12:32, 2026-11-13 09:12:32);
INSERT INTO subjects (subject_id, course_id, department_id, semester_number, subject_code, subject_name, subject_type, credits, status, created_at, updated_at) VALUES (6, 2, 2, 4, 'EC401', 'Signals and Systems', 'theory', 4, 'active', 2026-11-13 09:12:32, 2026-11-13 09:12:32);

-- Table: timetable_entries
DROP TABLE IF EXISTS timetable_entries;
CREATE TABLE `timetable_entries` (
  `timetable_id` int unsigned NOT NULL AUTO_INCREMENT,
  `subject_id` int unsigned NOT NULL,
  `faculty_id` int unsigned NOT NULL,
  `semester_id` int unsigned NOT NULL,
  `section` varchar(10) NOT NULL DEFAULT 'A',
  `day_of_week` enum('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday') NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `room_no` varchar(30) NOT NULL,
  `class_type` enum('lecture','lab','tutorial','seminar') NOT NULL DEFAULT 'lecture',
  `status` enum('active','cancelled') NOT NULL DEFAULT 'active',
  PRIMARY KEY (`timetable_id`),
  UNIQUE KEY `uk_timetable_slot` (`semester_id`,`section`,`day_of_week`,`start_time`,`room_no`),
  UNIQUE KEY `uk_timetable_faculty_slot` (`faculty_id`,`day_of_week`,`start_time`),
  UNIQUE KEY `uk_timetable_room_slot` (`room_no`,`day_of_week`,`start_time`),
  KEY `idx_timetable_faculty_day` (`faculty_id`,`day_of_week`,`start_time`),
  KEY `idx_timetable_subject_semester` (`subject_id`,`semester_id`),
  KEY `fk_tt_assignment` (`faculty_id`,`subject_id`,`semester_id`,`section`),
  CONSTRAINT `fk_tt_assignment` FOREIGN KEY (`faculty_id`, `subject_id`, `semester_id`, `section`) REFERENCES `faculty_subject_assignments` (`faculty_id`, `subject_id`, `semester_id`, `section`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_tt_faculty` FOREIGN KEY (`faculty_id`) REFERENCES `faculty` (`faculty_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_tt_semester` FOREIGN KEY (`semester_id`) REFERENCES `semesters` (`semester_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_tt_subject` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`subject_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_timetable_time` CHECK ((`end_time` > `start_time`))
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO timetable_entries (timetable_id, subject_id, faculty_id, semester_id, section, day_of_week, start_time, end_time, room_no, class_type, status) VALUES (1, 4, 1, 2, 'A', 'Monday', 9:00:00, 10:00:00, 'CSE-301', 'lecture', 'active');
INSERT INTO timetable_entries (timetable_id, subject_id, faculty_id, semester_id, section, day_of_week, start_time, end_time, room_no, class_type, status) VALUES (2, 4, 1, 2, 'A', 'Wednesday', 11:00:00, 12:00:00, 'CSE-301', 'lecture', 'active');
INSERT INTO timetable_entries (timetable_id, subject_id, faculty_id, semester_id, section, day_of_week, start_time, end_time, room_no, class_type, status) VALUES (3, 5, 2, 2, 'A', 'Tuesday', 10:00:00, 11:00:00, 'CSE-204', 'lecture', 'active');
INSERT INTO timetable_entries (timetable_id, subject_id, faculty_id, semester_id, section, day_of_week, start_time, end_time, room_no, class_type, status) VALUES (4, 1, 1, 1, 'A', 'Monday', 10:00:00, 11:00:00, 'CSE-201', 'lecture', 'active');

-- Table: users
DROP TABLE IF EXISTS users;
CREATE TABLE `users` (
  `user_id` int unsigned NOT NULL AUTO_INCREMENT,
  `role_id` tinyint unsigned NOT NULL,
  `login_identifier` varchar(100) NOT NULL COMMENT 'USN, employee ID, or approved email; never Aadhaar',
  `email` varchar(150) DEFAULT NULL,
  `password_hash` varchar(255) NOT NULL,
  `account_status` enum('active','inactive','locked','pending_reset') NOT NULL DEFAULT 'active',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `must_change_password` tinyint(1) NOT NULL DEFAULT '0',
  `failed_login_attempts` tinyint unsigned NOT NULL DEFAULT '0',
  `last_login_at` datetime DEFAULT NULL,
  `password_changed_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `uk_users_login_identifier` (`login_identifier`),
  UNIQUE KEY `uk_users_email` (`email`),
  KEY `idx_users_role_status` (`role_id`,`account_status`),
  CONSTRAINT `fk_users_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_users_active` CHECK ((`is_active` in (0,1))),
  CONSTRAINT `chk_users_must_change` CHECK ((`must_change_password` in (0,1)))
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO users (user_id, role_id, login_identifier, email, password_hash, account_status, is_active, must_change_password, failed_login_attempts, last_login_at, password_changed_at, created_at, updated_at) VALUES (1, 3, 'admin@gmail.com', 'admin@gmail.com', 'scrypt:32768:8:1$i7IU8r7Nhze5Peh2$bcb754e11ef03695a3eb09605b6b10275dd9e245db1d750a24924a5bfbe8e58bf7a5504214c2cc2296b906c2e1e72f84a34de4170d1068ae4530a48b22f6035a', 'active', 1, 0, 1, 2026-11-14 12:18:31, NULL, 2026-11-13 09:12:32, 2026-11-14 12:40:05);
INSERT INTO users (user_id, role_id, login_identifier, email, password_hash, account_status, is_active, must_change_password, failed_login_attempts, last_login_at, password_changed_at, created_at, updated_at) VALUES (2, 2, 'FAC-CSE-014', 'anita.rao.faculty@example.edu', 'scrypt:32768:8:1$n6fvF3di1CahxoIO$27fc868fca81b94f901026022f627704815a4e1ae6a5d3163b3f1345a1f2e77a0a4d5926524022c13ab6959ae9080063e02dfeca46607494975d020c5f5b0db4', 'active', 1, 0, 2, 2026-11-13 09:37:40, NULL, 2026-11-13 09:12:32, 2026-11-14 12:40:05);
INSERT INTO users (user_id, role_id, login_identifier, email, password_hash, account_status, is_active, must_change_password, failed_login_attempts, last_login_at, password_changed_at, created_at, updated_at) VALUES (3, 2, 'FAC-CSE-021', 'rahul.mehta.faculty@example.edu', '!NO_LOGIN_HASH_SET', 'pending_reset', 1, 1, 0, NULL, NULL, 2026-11-13 09:12:32, 2026-11-13 09:12:32);
INSERT INTO users (user_id, role_id, login_identifier, email, password_hash, account_status, is_active, must_change_password, failed_login_attempts, last_login_at, password_changed_at, created_at, updated_at) VALUES (4, 1, '1GM23CS045', 'aarav.sharma.student@example.edu', 'scrypt:32768:8:1$bsJZpQ2USE5jP9Ba$c50fd82f39dad648c2eda5c4ef0e299665c0513fb3c20e61f38e8b13305a28d6c2ecbd8fab7cb91daa9cd11159cbc1ae47d97fd05a7a35e73d747649998f3f86', 'active', 1, 0, 2, 2026-11-13 09:37:31, NULL, 2026-11-13 09:12:32, 2026-11-14 12:52:53);
INSERT INTO users (user_id, role_id, login_identifier, email, password_hash, account_status, is_active, must_change_password, failed_login_attempts, last_login_at, password_changed_at, created_at, updated_at) VALUES (5, 1, '1GM23CS052', 'diya.nair.student@example.edu', 'scrypt:32768:8:1$n6fvF3di1CahxoIO$27fc868fca81b94f901026022f627704815a4e1ae6a5d3163b3f1345a1f2e77a0a4d5926524022c13ab6959ae9080063e02dfeca46607494975d020c5f5b0db4', 'active', 1, 0, 0, NULL, NULL, 2026-11-13 09:12:32, 2026-11-13 09:28:31);
INSERT INTO users (user_id, role_id, login_identifier, email, password_hash, account_status, is_active, must_change_password, failed_login_attempts, last_login_at, password_changed_at, created_at, updated_at) VALUES (6, 1, '1GM22EC018', 'kiran.patil.student@example.edu', '!NO_LOGIN_HASH_SET', 'inactive', 0, 1, 0, NULL, NULL, 2026-11-13 09:12:32, 2026-11-13 09:12:32);

SET FOREIGN_KEY_CHECKS = 1;
-- End of backup
