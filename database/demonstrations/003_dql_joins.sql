-- GM University Management System
-- Stage 3: DQL and JOIN demonstrations (DESIGN ONLY - NOT EXECUTED)

USE gmu_management_system;

-- 1. INNER JOIN: students with their department and course
SELECT s.usn,
       CONCAT(s.first_name, ' ', s.last_name) AS student_name,
       d.department_code,
       c.course_code,
       s.current_semester
FROM students s
INNER JOIN departments d ON d.department_id = s.department_id
INNER JOIN courses c ON c.course_id = s.course_id
ORDER BY s.usn;

-- 2. LEFT JOIN: all students, including those without a linked login
SELECT s.usn,
       CONCAT(s.first_name, ' ', s.last_name) AS student_name,
       u.login_identifier,
       u.account_status
FROM students s
LEFT JOIN users u ON u.user_id = s.user_id
ORDER BY s.usn;

-- 3. RIGHT JOIN: all departments, including those without students
SELECT d.department_code,
       d.department_name,
       s.usn,
       s.first_name,
       s.last_name
FROM students s
RIGHT JOIN departments d ON d.department_id = s.department_id
ORDER BY d.department_code, s.usn;

-- 4. Three-table join: faculty teaching assignments with subject and semester
SELECT f.employee_id,
       CONCAT(f.first_name, ' ', f.last_name) AS faculty_name,
       sub.subject_code,
       sub.subject_name,
       sem.semester_number,
       ay.year_label AS academic_year,
       fsa.section
FROM faculty_subject_assignments fsa
JOIN faculty f ON f.faculty_id = fsa.faculty_id
JOIN subjects sub ON sub.subject_id = fsa.subject_id
JOIN semesters sem ON sem.semester_id = fsa.semester_id
JOIN academic_years ay ON ay.academic_year_id = sem.academic_year_id
WHERE fsa.is_active = 1
ORDER BY faculty_name, sub.subject_code;

-- 5. Self-join example: students in the same course and semester
SELECT a.usn AS student_a, b.usn AS student_b, a.course_id, a.current_semester
FROM students a
JOIN students b
  ON a.course_id = b.course_id
 AND a.current_semester = b.current_semester
 AND a.student_id < b.student_id
ORDER BY a.course_id, a.current_semester, a.usn;

-- 6. LEFT JOIN with aggregation: subjects with no enrolments
SELECT sub.subject_code,
       sub.subject_name,
       COUNT(se.enrolment_id) AS enrolment_count
FROM subjects sub
LEFT JOIN student_enrolments se ON se.subject_id = sub.subject_id
GROUP BY sub.subject_id, sub.subject_code, sub.subject_name
HAVING COUNT(se.enrolment_id) = 0
ORDER BY sub.subject_code;

-- 7. Join + filter: fee payments with student and fee head
SELECT p.receipt_no,
       s.usn,
       CONCAT(s.first_name, ' ', s.last_name) AS student_name,
       fs.fee_head,
       p.amount_paid,
       p.payment_date,
       p.payment_status
FROM fee_payments p
JOIN students s ON s.student_id = p.student_id
JOIN fee_structures fs ON fs.fee_structure_id = p.fee_structure_id
WHERE p.payment_status = 'success'
ORDER BY p.payment_date DESC;

-- 8. Join + date range filter
SELECT a.session_date,
       sub.subject_code,
       CONCAT(f.first_name, ' ', f.last_name) AS faculty_name,
       COUNT(ar.attendance_id) AS students_marked
FROM attendance_sessions a
JOIN faculty_subject_assignments fsa ON fsa.assignment_id = a.assignment_id
JOIN faculty f ON f.faculty_id = fsa.faculty_id
JOIN subjects sub ON sub.subject_id = fsa.subject_id
LEFT JOIN attendance_records ar ON ar.session_id = a.session_id
WHERE a.session_date BETWEEN '2026-01-01' AND '2026-06-30'
GROUP BY a.session_id, a.session_date, sub.subject_code, faculty_name
ORDER BY a.session_date;
