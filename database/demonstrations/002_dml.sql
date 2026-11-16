-- GM University Management System
-- Stage 3: DML demonstration (DESIGN ONLY - NOT EXECUTED)
-- INSERT / UPDATE / DELETE examples using clearly fictional data.

USE gmu_management_system;

START TRANSACTION;

-- INSERT: add a fictional department
INSERT INTO departments (department_code, department_name, hod_name, office_location, status)
VALUES ('MECH', 'Mechanical Engineering (Demo)', 'Dr. Fictional HOD', 'Block D, Room 101', 'active');

-- INSERT: add a fictional course under that department
INSERT INTO courses (department_id, course_code, course_name, level, duration_semesters, total_credits, status)
SELECT department_id, 'BTECH-MECH', 'Bachelor of Technology in Mechanical Engineering (Demo)',
       'UG', 8, 160, 'active'
FROM departments
WHERE department_code = 'MECH';

-- INSERT: add a fictional academic year
INSERT INTO academic_years (year_label, start_date, end_date, is_current, status)
VALUES ('2026-27', '2026-08-01', '2027-07-31', 0, 'planned');

-- UPDATE: correct a demo department office location
UPDATE departments
SET office_location = 'Block D, Room 102'
WHERE department_code = 'MECH';

-- UPDATE with a join: mark a demo course inactive
UPDATE courses c
JOIN departments d ON d.department_id = c.department_id
SET c.status = 'inactive'
WHERE d.department_code = 'MECH' AND c.course_code = 'BTECH-MECH';

-- DELETE: remove the demo course and department (only if unused)
DELETE FROM courses
WHERE course_code = 'BTECH-MECH';

DELETE FROM departments
WHERE department_code = 'MECH';

-- DELETE the demo academic year (only if no dependent rows)
DELETE FROM academic_years
WHERE year_label = '2026-27';

COMMIT;

-- Example of a guarded delete using a subquery (no rows affected if dependencies exist)
-- DELETE FROM departments
-- WHERE department_code = 'MECH'
--   AND NOT EXISTS (SELECT 1 FROM courses WHERE courses.department_id = departments.department_id);
