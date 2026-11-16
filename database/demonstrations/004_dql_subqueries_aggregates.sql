-- GM University Management System
-- Stage 3: Subqueries, aggregates, GROUP BY / HAVING (DESIGN ONLY - NOT EXECUTED)

USE gmu_management_system;

-- 1. Scalar subquery: students whose fee demand is above the average
SELECT s.usn,
       CONCAT(s.first_name, ' ', s.last_name) AS student_name,
       (SELECT SUM(fs.amount)
        FROM fee_structures fs
        WHERE fs.course_id = s.course_id AND fs.is_mandatory = 1) AS total_demand
FROM students s
WHERE (SELECT SUM(fs.amount)
       FROM fee_structures fs
       WHERE fs.course_id = s.course_id AND fs.is_mandatory = 1)
      > (SELECT AVG(course_total)
         FROM (
           SELECT SUM(amount) AS course_total
           FROM fee_structures
           WHERE is_mandatory = 1
           GROUP BY course_id
         ) AS course_totals);

-- 2. IN subquery: students enrolled in a specific subject code
SELECT s.usn, CONCAT(s.first_name, ' ', s.last_name) AS student_name
FROM students s
WHERE s.student_id IN (
  SELECT se.student_id
  FROM student_enrolments se
  JOIN subjects sub ON sub.subject_id = se.subject_id
  WHERE sub.subject_code = 'CS501'
)
ORDER BY s.usn;

-- 3. EXISTS correlated subquery: subjects that have at least one assessment
SELECT sub.subject_code, sub.subject_name
FROM subjects sub
WHERE EXISTS (
  SELECT 1
  FROM internal_assessments ia
  WHERE ia.subject_id = sub.subject_id
)
ORDER BY sub.subject_code;

-- 4. NOT EXISTS: students with no fee payments
SELECT s.usn, CONCAT(s.first_name, ' ', s.last_name) AS student_name
FROM students s
WHERE NOT EXISTS (
  SELECT 1 FROM fee_payments p WHERE p.student_id = s.student_id
)
ORDER BY s.usn;

-- 5. Derived table: subject-wise attendance percentage
SELECT sub.subject_code,
       sub.subject_name,
       stats.total_marked,
       stats.attended,
       ROUND((stats.attended / NULLIF(stats.total_marked, 0)) * 100, 2) AS attendance_percentage
FROM subjects sub
JOIN (
  SELECT se.subject_id,
         COUNT(ar.attendance_id) AS total_marked,
         SUM(CASE WHEN ar.status IN ('present','late') THEN 1 ELSE 0 END) AS attended
  FROM student_enrolments se
  JOIN attendance_records ar ON ar.enrolment_id = se.enrolment_id
  GROUP BY se.subject_id
) AS stats ON stats.subject_id = sub.subject_id
ORDER BY attendance_percentage DESC;

-- 6. Aggregate functions: overall fee collection summary
SELECT COUNT(*) AS payment_count,
       SUM(amount_paid) AS total_collected,
       AVG(amount_paid) AS average_payment,
       MIN(amount_paid) AS smallest_payment,
       MAX(amount_paid) AS largest_payment
FROM fee_payments
WHERE payment_status = 'success';

-- 7. GROUP BY: enrolments per course
SELECT c.course_code,
       c.course_name,
       COUNT(se.enrolment_id) AS enrolment_count
FROM courses c
LEFT JOIN subjects sub ON sub.course_id = c.course_id
LEFT JOIN student_enrolments se ON se.subject_id = sub.subject_id
GROUP BY c.course_id, c.course_code, c.course_name
ORDER BY enrolment_count DESC;

-- 8. GROUP BY + HAVING: subjects with average exam marks above 70
SELECT sub.subject_code,
       sub.subject_name,
       COUNT(sm.semester_mark_id) AS results_count,
       ROUND(AVG(sm.marks_obtained), 2) AS average_marks
FROM semester_marks sm
JOIN semester_exams se_exam ON se_exam.exam_id = sm.exam_id
JOIN subjects sub ON sub.subject_id = se_exam.subject_id
GROUP BY sub.subject_id, sub.subject_code, sub.subject_name
HAVING AVG(sm.marks_obtained) > 70
ORDER BY average_marks DESC;

-- 9. GROUP BY + HAVING with multiple conditions: departments with many students and high attendance
SELECT d.department_code,
       d.department_name,
       COUNT(DISTINCT s.student_id) AS student_count,
       ROUND(AVG(CASE WHEN ar.status IN ('present','late') THEN 1 ELSE 0 END) * 100, 2) AS attendance_percentage
FROM departments d
JOIN students s ON s.department_id = d.department_id
JOIN student_enrolments se ON se.student_id = s.student_id
LEFT JOIN attendance_records ar ON ar.enrolment_id = se.enrolment_id
GROUP BY d.department_id, d.department_code, d.department_name
HAVING COUNT(DISTINCT s.student_id) >= 1
   AND AVG(CASE WHEN ar.status IN ('present','late') THEN 1 ELSE 0 END) >= 0.75
ORDER BY attendance_percentage DESC;

-- 10. Window function example (MySQL 8): rank students by semester marks within an exam
SELECT se_exam.exam_name,
       s.usn,
       sm.marks_obtained,
       RANK() OVER (PARTITION BY sm.exam_id ORDER BY sm.marks_obtained DESC) AS mark_rank
FROM semester_marks sm
JOIN semester_exams se_exam ON se_exam.exam_id = sm.exam_id
JOIN student_enrolments se ON se.enrolment_id = sm.enrolment_id
JOIN students s ON s.student_id = se.student_id
ORDER BY se_exam.exam_name, mark_rank;
