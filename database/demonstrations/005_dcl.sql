-- GM University Management System
-- Stage 3: DCL demonstration (DESIGN ONLY - NOT EXECUTED)
-- Illustrates least-privilege MySQL accounts. Review and adapt before any real execution.

-- 1. Create dedicated accounts with generated passwords.
--    MySQL 8.0.18+ prints each generated password once in the result set.
--    Capture it in the deployment secret store; never commit it to this file.
CREATE USER IF NOT EXISTS 'gmu_app'@'localhost' IDENTIFIED BY RANDOM PASSWORD;
CREATE USER IF NOT EXISTS 'gmu_report'@'localhost' IDENTIFIED BY RANDOM PASSWORD;
CREATE USER IF NOT EXISTS 'gmu_admin'@'localhost' IDENTIFIED BY RANDOM PASSWORD;

-- 2. Application account: read/write on application tables, no schema changes
GRANT SELECT, INSERT, UPDATE, DELETE
  ON gmu_management_system.*
  TO 'gmu_app'@'localhost';

-- 3. Reporting account: read-only access to views and reporting tables
GRANT SELECT ON gmu_management_system.vw_student_profile TO 'gmu_report'@'localhost';
GRANT SELECT ON gmu_management_system.vw_student_attendance_summary TO 'gmu_report'@'localhost';
GRANT SELECT ON gmu_management_system.vw_student_internal_marks TO 'gmu_report'@'localhost';
GRANT SELECT ON gmu_management_system.vw_student_semester_results TO 'gmu_report'@'localhost';
GRANT SELECT ON gmu_management_system.vw_student_fee_summary TO 'gmu_report'@'localhost';
GRANT SELECT ON gmu_management_system.vw_faculty_workload TO 'gmu_report'@'localhost';
GRANT SELECT ON gmu_management_system.vw_class_performance TO 'gmu_report'@'localhost';
GRANT SELECT ON gmu_management_system.vw_feedback_summary TO 'gmu_report'@'localhost';

-- 4. Administrator/migration account: full privileges on this schema only
GRANT ALL PRIVILEGES ON gmu_management_system.* TO 'gmu_admin'@'localhost';

-- 5. Apply changes
FLUSH PRIVILEGES;

-- 6. Inspect effective privileges
SHOW GRANTS FOR 'gmu_app'@'localhost';
SHOW GRANTS FOR 'gmu_report'@'localhost';

-- 7. REVOKE examples
-- Remove a privilege that is no longer needed
REVOKE DELETE ON gmu_management_system.* FROM 'gmu_app'@'localhost';

-- Remove reporting access to a specific view
REVOKE SELECT ON gmu_management_system.vw_feedback_summary FROM 'gmu_report'@'localhost';

-- Re-grant if needed after review
-- GRANT SELECT ON gmu_management_system.vw_feedback_summary TO 'gmu_report'@'localhost';

-- 8. Remove demo accounts only after confirming they are not in use
-- DROP USER IF EXISTS 'gmu_app'@'localhost';
-- DROP USER IF EXISTS 'gmu_report'@'localhost';
-- DROP USER IF EXISTS 'gmu_admin'@'localhost';

-- 9. Verify current user and database
SELECT CURRENT_USER() AS current_db_user, DATABASE() AS current_database;
