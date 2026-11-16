-- GM University Management System
-- Stage 3: Sample INSERT statements (DESIGN ONLY - NOT EXECUTED)
-- Fictional data only. No real students, faculty, or accounts.

USE gmu_management_system;

START TRANSACTION;

INSERT INTO roles (role_code, role_name, description) VALUES
('student', 'Student', 'Student portal access'),
('faculty', 'Faculty', 'Faculty portal access'),
('admin', 'Administrator', 'Administration portal access');

-- SECURITY: Fictional sample accounts only. No plaintext password is stored here.
-- '!NO_LOGIN_HASH_SET' is a deliberate non-authenticating sentinel, not a real hash.
-- The application must reject it. Run the documented setup process in
-- database/seeds/README.md to set real hashes outside version control.
INSERT INTO users (role_id, login_identifier, email, password_hash, account_status, is_active, must_change_password, last_login_at) VALUES
(3, 'admin@gmu.edu.in', 'admin@gmu.edu.in', '!NO_LOGIN_HASH_SET', 'pending_reset', 1, 1, NULL),
(2, 'FAC-CSE-014', 'anita.rao.faculty@example.edu', '!NO_LOGIN_HASH_SET', 'pending_reset', 1, 1, NULL),
(2, 'FAC-CSE-021', 'rahul.mehta.faculty@example.edu', '!NO_LOGIN_HASH_SET', 'pending_reset', 1, 1, NULL),
(1, '1GM23CS045', 'aarav.sharma.student@example.edu', '!NO_LOGIN_HASH_SET', 'pending_reset', 1, 1, NULL),
(1, '1GM23CS052', 'diya.nair.student@example.edu', '!NO_LOGIN_HASH_SET', 'pending_reset', 1, 1, NULL),
(1, '1GM22EC018', 'kiran.patil.student@example.edu', '!NO_LOGIN_HASH_SET', 'inactive', 0, 1, NULL);

INSERT INTO departments (department_code, department_name, hod_name, office_location, status) VALUES
('CSE', 'Computer Science and Engineering', 'Dr. Sample HOD A', 'Block A, Room 201', 'active'),
('ECE', 'Electronics and Communication Engineering', 'Dr. Sample HOD B', 'Block B, Room 110', 'active'),
('MBA', 'Master of Business Administration', 'Dr. Sample HOD C', 'Block C, Room 305', 'active');

INSERT INTO courses (department_id, course_code, course_name, level, duration_semesters, total_credits, status) VALUES
(1, 'BTECH-CSE', 'Bachelor of Technology in Computer Science', 'UG', 8, 160, 'active'),
(2, 'BTECH-ECE', 'Bachelor of Technology in Electronics and Communication', 'UG', 8, 160, 'active'),
(3, 'MBA-GEN', 'Master of Business Administration', 'PG', 4, 90, 'active');

INSERT INTO academic_years (year_label, start_date, end_date, is_current, status) VALUES
('2024-25', '2024-08-01', '2025-07-31', 0, 'closed'),
('2025-26', '2025-08-01', '2026-07-31', 1, 'active');

INSERT INTO semesters (course_id, academic_year_id, semester_number, term_label, start_date, end_date, status) VALUES
(1, 2, 5, 'Odd', '2025-08-10', '2025-12-20', 'completed'),
(1, 2, 6, 'Even', '2026-01-10', '2026-05-30', 'active'),
(2, 2, 4, 'Even', '2026-01-10', '2026-05-30', 'active'),
(3, 2, 2, 'Even', '2026-01-10', '2026-05-30', 'active');

INSERT INTO subjects (course_id, department_id, semester_number, subject_code, subject_name, subject_type, credits, status) VALUES
(1, 1, 5, 'CS501', 'Database Management Systems', 'theory', 4, 'active'),
(1, 1, 5, 'CS502', 'Operating Systems', 'theory', 4, 'active'),
(1, 1, 5, 'CS503', 'Database Lab', 'lab', 2, 'active'),
(1, 1, 6, 'CS601', 'Computer Networks', 'theory', 4, 'active'),
(1, 1, 6, 'CS602', 'Software Engineering', 'theory', 3, 'active'),
(2, 2, 4, 'EC401', 'Signals and Systems', 'theory', 4, 'active');

INSERT INTO students (user_id, department_id, course_id, usn, first_name, last_name, date_of_birth, gender, email, phone, admission_year, current_semester, status) VALUES
(4, 1, 1, '1GM23CS045', 'Aarav', 'Sharma', '2005-04-12', 'male', 'aarav.sharma.student@example.edu', '9000000045', 2023, 6, 'active'),
(5, 1, 1, '1GM23CS052', 'Diya', 'Nair', '2005-09-03', 'female', 'diya.nair.student@example.edu', '9000000052', 2023, 6, 'active'),
(6, 2, 2, '1GM22EC018', 'Kiran', 'Patil', '2004-12-21', 'male', 'kiran.patil.student@example.edu', '9000000018', 2022, 4, 'inactive');

INSERT INTO faculty (user_id, department_id, employee_id, first_name, last_name, designation, qualification, email, phone, date_of_joining, status) VALUES
(2, 1, 'FAC-CSE-014', 'Anita', 'Rao', 'Associate Professor', 'PhD (CSE)', 'anita.rao.faculty@example.edu', '9100000014', '2018-07-01', 'active'),
(3, 1, 'FAC-CSE-021', 'Rahul', 'Mehta', 'Assistant Professor', 'M.Tech (CSE)', 'rahul.mehta.faculty@example.edu', '9100000021', '2020-08-15', 'active');

INSERT INTO faculty_subject_assignments (faculty_id, subject_id, semester_id, section, assigned_on, is_active) VALUES
(1, 1, 1, 'A', '2025-08-05', 1),
(1, 3, 1, 'A', '2025-08-05', 1),
(2, 2, 1, 'A', '2025-08-05', 1),
(1, 4, 2, 'A', '2026-01-05', 1),
(2, 5, 2, 'A', '2026-01-05', 1);

INSERT INTO student_enrolments (student_id, subject_id, semester_id, section, enrolment_date, status) VALUES
(1, 1, 1, 'A', '2025-08-08', 'completed'),
(1, 2, 1, 'A', '2025-08-08', 'completed'),
(1, 4, 2, 'A', '2026-01-08', 'enrolled'),
(1, 5, 2, 'A', '2026-01-08', 'enrolled'),
(2, 1, 1, 'A', '2025-08-08', 'completed'),
(2, 4, 2, 'A', '2026-01-08', 'enrolled');

INSERT INTO timetable_entries (subject_id, faculty_id, semester_id, section, day_of_week, start_time, end_time, room_no, class_type, status) VALUES
(4, 1, 2, 'A', 'Monday', '09:00:00', '10:00:00', 'CSE-301', 'lecture', 'active'),
(4, 1, 2, 'A', 'Wednesday', '11:00:00', '12:00:00', 'CSE-301', 'lecture', 'active'),
(5, 2, 2, 'A', 'Tuesday', '10:00:00', '11:00:00', 'CSE-204', 'lecture', 'active'),
(1, 1, 1, 'A', 'Monday', '10:00:00', '11:00:00', 'CSE-201', 'lecture', 'active');

INSERT INTO attendance_sessions (assignment_id, session_date, start_time, end_time, topic, session_type, created_by_user_id) VALUES
(1, '2025-09-01', '10:00:00', '11:00:00', 'ER Modeling', 'lecture', 2),
(1, '2025-09-03', '10:00:00', '11:00:00', 'Normalization', 'lecture', 2),
(4, '2026-02-10', '09:00:00', '10:00:00', 'OSI Model', 'lecture', 2);

INSERT INTO attendance_records (session_id, enrolment_id, status, remarks, marked_by_user_id) VALUES
(1, 1, 'present', NULL, 2),
(1, 5, 'present', NULL, 2),
(2, 1, 'late', 'Arrived 10 minutes late', 2),
(2, 5, 'absent', NULL, 2),
(3, 3, 'present', NULL, 2),
(3, 6, 'present', NULL, 2);

INSERT INTO internal_assessments (subject_id, semester_id, assessment_name, max_marks, weightage_percent, assessment_date) VALUES
(1, 1, 'IA-1', 25.00, 12.50, '2025-09-20'),
(1, 1, 'IA-2', 25.00, 12.50, '2025-11-05'),
(4, 2, 'IA-1', 25.00, 12.50, '2026-03-10');

INSERT INTO internal_marks (assessment_id, enrolment_id, marks_obtained, remarks, entered_by_user_id) VALUES
(1, 1, 22.00, 'Good performance', 2),
(1, 5, 19.50, NULL, 2),
(2, 1, 23.00, NULL, 2),
(3, 3, 21.00, 'In progress term', 2);

INSERT INTO semester_exams (subject_id, semester_id, exam_name, exam_date, max_marks, passing_marks) VALUES
(1, 1, 'End Semester Examination', '2025-12-10', 100.00, 40.00),
(2, 1, 'End Semester Examination', '2025-12-13', 100.00, 40.00);

INSERT INTO semester_marks (exam_id, enrolment_id, marks_obtained, grade, grade_point, result_status, published_at, entered_by_user_id) VALUES
(1, 1, 84.00, 'A', 9.00, 'pass', '2026-01-05 10:00:00', 1),
(1, 5, 76.00, 'B+', 8.00, 'pass', '2026-01-05 10:00:00', 1),
(2, 2, 79.00, 'A', 8.50, 'pass', '2026-01-05 10:00:00', 1);

INSERT INTO fee_structures (course_id, academic_year_id, semester_number, fee_head, amount, due_date, is_mandatory) VALUES
(1, 2, 6, 'Tuition Fee', 55000.00, '2026-02-15', 1),
(1, 2, 6, 'Examination Fee', 2500.00, '2026-03-15', 1),
(1, 2, 6, 'Library Fee', 1500.00, '2026-02-15', 1),
(2, 2, 4, 'Tuition Fee', 52000.00, '2026-02-15', 1);

INSERT INTO fee_payments (student_id, fee_structure_id, amount_paid, payment_date, payment_mode, transaction_ref, receipt_no, payment_status, remarks, recorded_by_user_id) VALUES
(1, 1, 55000.00, '2026-02-10', 'upi', 'TXN-FICTIONAL-1001', 'RCPT-2026-0001', 'success', 'Full tuition paid', 1),
(1, 2, 2500.00, '2026-03-01', 'net_banking', 'TXN-FICTIONAL-1002', 'RCPT-2026-0002', 'success', NULL, 1),
(2, 1, 25000.00, '2026-02-12', 'card', 'TXN-FICTIONAL-1003', 'RCPT-2026-0003', 'success', 'Partial payment', 1);

INSERT INTO notifications (sender_user_id, target_role, target_user_id, title, message, category, priority, is_published, published_at) VALUES
(1, 'student', NULL, 'Semester 6 timetable published', 'The Semester 6 timetable is now available in the student portal. (Sample)', 'academic', 'normal', 1, '2026-01-07 09:00:00'),
(1, 'faculty', 2, 'Internal marks entry window', 'Please submit IA-1 marks by the published deadline. (Sample)', 'exam', 'high', 1, '2026-03-05 10:00:00'),
(1, 'all', NULL, 'Portal maintenance notice', 'Scheduled maintenance preview notice for demonstration purposes.', 'system', 'low', 1, '2026-11-01 08:00:00');

INSERT INTO notification_reads (notification_id, user_id, read_at) VALUES
(1, 4, '2026-01-07 10:15:00'),
(3, 2, '2026-11-01 09:00:00');

INSERT INTO feedback (student_id, subject_id, faculty_id, semester_id, category, rating, comments, is_anonymous, status, submitted_at, reviewed_by_user_id, reviewed_at) VALUES
(1, 1, 1, 1, 'course', 5, 'Well-structured DBMS course. (Fictional sample)', 0, 'reviewed', '2025-12-18 14:00:00', 1, '2025-12-19 10:00:00'),
(2, 1, 1, 1, 'faculty', 4, 'Clear explanations and practical examples. (Fictional sample)', 1, 'submitted', '2025-12-18 15:30:00', NULL, NULL);

INSERT INTO password_reset_tokens (user_id, token_hash, expires_at, used_at) VALUES
(4, SHA2('fictional-reset-token-aarav-sample', 256), '2026-11-12 10:00:00', NULL);

COMMIT;
