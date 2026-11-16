-- GM University Management System
-- Stage 3: Reporting views (DESIGN ONLY - NOT EXECUTED)
-- Target: MySQL 8.0+ / InnoDB / utf8mb4

USE gmu_management_system;

CREATE OR REPLACE VIEW vw_student_profile AS
SELECT
  s.student_id,
  s.usn,
  CONCAT(s.first_name, ' ', s.last_name) AS student_name,
  s.email,
  s.phone,
  s.admission_year,
  s.current_semester,
  s.status AS student_status,
  d.department_code,
  d.department_name,
  c.course_code,
  c.course_name,
  u.login_identifier,
  u.account_status
FROM students s
JOIN departments d ON d.department_id = s.department_id
JOIN courses c ON c.course_id = s.course_id
LEFT JOIN users u ON u.user_id = s.user_id;

CREATE OR REPLACE VIEW vw_student_attendance_summary AS
SELECT
  s.student_id,
  s.usn,
  CONCAT(s.first_name, ' ', s.last_name) AS student_name,
  sub.subject_id,
  sub.subject_code,
  sub.subject_name,
  sem.semester_id,
  sem.semester_number,
  ay.year_label AS academic_year,
  se.section,
  COUNT(DISTINCT ats.session_id) AS sessions_held,
  COUNT(DISTINCT ar.session_id) AS sessions_marked,
  COUNT(DISTINCT CASE WHEN ar.status IN ('present','late') THEN ar.session_id END) AS attended_sessions,
  COUNT(DISTINCT ats.session_id) - COUNT(DISTINCT ar.session_id) AS sessions_unmarked,
  ROUND(
    COUNT(DISTINCT CASE WHEN ar.status IN ('present','late') THEN ar.session_id END)
      / NULLIF(COUNT(DISTINCT ats.session_id), 0) * 100,
    2
  ) AS attendance_percentage
FROM students s
JOIN student_enrolments se ON se.student_id = s.student_id
JOIN subjects sub ON sub.subject_id = se.subject_id
JOIN semesters sem ON sem.semester_id = se.semester_id
JOIN academic_years ay ON ay.academic_year_id = sem.academic_year_id
LEFT JOIN faculty_subject_assignments fsa
  ON fsa.subject_id = se.subject_id
 AND fsa.semester_id = se.semester_id
 AND fsa.section = se.section
LEFT JOIN attendance_sessions ats ON ats.assignment_id = fsa.assignment_id
LEFT JOIN attendance_records ar
  ON ar.session_id = ats.session_id
 AND ar.enrolment_id = se.enrolment_id
GROUP BY s.student_id, s.usn, student_name, sub.subject_id, sub.subject_code, sub.subject_name,
         sem.semester_id, sem.semester_number, ay.year_label, se.section;

CREATE OR REPLACE VIEW vw_student_internal_marks AS
SELECT
  s.student_id,
  s.usn,
  CONCAT(s.first_name, ' ', s.last_name) AS student_name,
  sub.subject_code,
  sub.subject_name,
  sem.semester_number,
  ay.year_label AS academic_year,
  ia.assessment_name,
  ia.max_marks,
  im.marks_obtained,
  ROUND((im.marks_obtained / NULLIF(ia.max_marks, 0)) * 100, 2) AS percentage
FROM internal_marks im
JOIN internal_assessments ia ON ia.assessment_id = im.assessment_id
JOIN student_enrolments se ON se.enrolment_id = im.enrolment_id
JOIN students s ON s.student_id = se.student_id
JOIN subjects sub ON sub.subject_id = ia.subject_id
JOIN semesters sem ON sem.semester_id = ia.semester_id
JOIN academic_years ay ON ay.academic_year_id = sem.academic_year_id;

CREATE OR REPLACE VIEW vw_student_semester_results AS
SELECT
  s.student_id,
  s.usn,
  CONCAT(s.first_name, ' ', s.last_name) AS student_name,
  c.course_name,
  sub.subject_code,
  sub.subject_name,
  sub.credits,
  sem.semester_number,
  ay.year_label AS academic_year,
  se_exam.exam_name,
  se_exam.max_marks,
  sm.marks_obtained,
  sm.grade,
  sm.grade_point,
  sm.result_status
FROM semester_marks sm
JOIN semester_exams se_exam ON se_exam.exam_id = sm.exam_id
JOIN student_enrolments se ON se.enrolment_id = sm.enrolment_id
JOIN students s ON s.student_id = se.student_id
JOIN courses c ON c.course_id = s.course_id
JOIN subjects sub ON sub.subject_id = se_exam.subject_id
JOIN semesters sem ON sem.semester_id = se_exam.semester_id
JOIN academic_years ay ON ay.academic_year_id = sem.academic_year_id;

CREATE OR REPLACE VIEW vw_student_fee_summary AS
SELECT
  s.student_id,
  s.usn,
  CONCAT(s.first_name, ' ', s.last_name) AS student_name,
  c.course_name,
  ay.year_label AS academic_year,
  sem.semester_number,
  SUM(fs.amount) AS total_demand,
  COALESCE(SUM(paid.total_paid), 0) AS total_paid,
  SUM(fs.amount) - COALESCE(SUM(paid.total_paid), 0) AS balance_amount,
  CASE
    WHEN SUM(fs.amount) - COALESCE(SUM(paid.total_paid), 0) <= 0 THEN 'Paid'
    WHEN COALESCE(SUM(paid.total_paid), 0) = 0 THEN 'Unpaid'
    ELSE 'Partial'
  END AS fee_status
FROM students s
JOIN courses c ON c.course_id = s.course_id
JOIN (
  SELECT DISTINCT se.student_id, se.semester_id
  FROM student_enrolments se
) enrolled ON enrolled.student_id = s.student_id
JOIN semesters sem ON sem.semester_id = enrolled.semester_id
JOIN academic_years ay ON ay.academic_year_id = sem.academic_year_id
JOIN fee_structures fs
  ON fs.course_id = s.course_id
 AND fs.academic_year_id = sem.academic_year_id
 AND fs.semester_number = sem.semester_number
LEFT JOIN (
  SELECT student_id, fee_structure_id, SUM(amount_paid) AS total_paid
  FROM fee_payments
  WHERE payment_status = 'success'
  GROUP BY student_id, fee_structure_id
) paid ON paid.student_id = s.student_id AND paid.fee_structure_id = fs.fee_structure_id
GROUP BY s.student_id, s.usn, student_name, c.course_name, ay.year_label, sem.semester_number;

CREATE OR REPLACE VIEW vw_faculty_workload AS
SELECT
  f.faculty_id,
  f.employee_id,
  CONCAT(f.first_name, ' ', f.last_name) AS faculty_name,
  d.department_name,
  sem.semester_number,
  ay.year_label AS academic_year,
  sub.subject_code,
  sub.subject_name,
  fsa.section,
  fsa.is_active AS assignment_active,
  COUNT(DISTINCT se.student_id) AS enrolled_students
FROM faculty f
JOIN departments d ON d.department_id = f.department_id
JOIN faculty_subject_assignments fsa ON fsa.faculty_id = f.faculty_id
JOIN subjects sub ON sub.subject_id = fsa.subject_id
JOIN semesters sem ON sem.semester_id = fsa.semester_id
JOIN academic_years ay ON ay.academic_year_id = sem.academic_year_id
LEFT JOIN student_enrolments se
  ON se.subject_id = fsa.subject_id
 AND se.semester_id = fsa.semester_id
 AND se.section = fsa.section
GROUP BY f.faculty_id, f.employee_id, faculty_name, d.department_name, sem.semester_number,
         ay.year_label, sub.subject_code, sub.subject_name, fsa.section, fsa.is_active;

CREATE OR REPLACE VIEW vw_class_performance AS
SELECT
  sub.subject_id,
  sub.subject_code,
  sub.subject_name,
  sem.semester_id,
  sem.semester_number,
  ay.year_label AS academic_year,
  COUNT(sm.semester_mark_id) AS students_evaluated,
  ROUND(AVG(sm.marks_obtained), 2) AS average_marks,
  MAX(sm.marks_obtained) AS highest_marks,
  MIN(sm.marks_obtained) AS lowest_marks,
  SUM(CASE WHEN sm.result_status = 'pass' THEN 1 ELSE 0 END) AS pass_count,
  SUM(CASE WHEN sm.result_status = 'fail' THEN 1 ELSE 0 END) AS fail_count
FROM semester_marks sm
JOIN semester_exams se_exam ON se_exam.exam_id = sm.exam_id
JOIN subjects sub ON sub.subject_id = se_exam.subject_id
JOIN semesters sem ON sem.semester_id = se_exam.semester_id
JOIN academic_years ay ON ay.academic_year_id = sem.academic_year_id
GROUP BY sub.subject_id, sub.subject_code, sub.subject_name, sem.semester_id, sem.semester_number, ay.year_label;

CREATE OR REPLACE VIEW vw_feedback_summary AS
SELECT
  COALESCE(sub.subject_name, 'General') AS subject_name,
  COALESCE(CONCAT(f.first_name, ' ', f.last_name), 'Not specified') AS faculty_name,
  sem.semester_number,
  ay.year_label AS academic_year,
  fb.category,
  COUNT(fb.feedback_id) AS feedback_count,
  ROUND(AVG(fb.rating), 2) AS average_rating,
  SUM(CASE WHEN fb.status = 'submitted' THEN 1 ELSE 0 END) AS pending_count
FROM feedback fb
LEFT JOIN subjects sub ON sub.subject_id = fb.subject_id
LEFT JOIN faculty f ON f.faculty_id = fb.faculty_id
LEFT JOIN semesters sem ON sem.semester_id = fb.semester_id
LEFT JOIN academic_years ay ON ay.academic_year_id = sem.academic_year_id
GROUP BY subject_name, faculty_name, sem.semester_number, ay.year_label, fb.category;
