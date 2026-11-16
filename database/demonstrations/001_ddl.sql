-- GM University Management System
-- Stage 3: DDL demonstration (DESIGN ONLY - NOT EXECUTED)
-- Demonstrates CREATE/ALTER/TRUNCATE-style DDL concepts. Destructive statements are commented out.

USE gmu_management_system;

-- 1. CREATE TABLE (reference example; the full schema is in ../schema/001_schema.sql)
CREATE TABLE IF NOT EXISTS demo_grade_scales (
  scale_id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  grade_code VARCHAR(5) NOT NULL,
  min_percent DECIMAL(5,2) NOT NULL,
  max_percent DECIMAL(5,2) NOT NULL,
  grade_point DECIMAL(3,2) NOT NULL,
  PRIMARY KEY (scale_id),
  UNIQUE KEY uk_demo_grade (grade_code),
  CONSTRAINT chk_demo_grade_range CHECK (min_percent >= 0 AND max_percent <= 100 AND max_percent >= min_percent),
  CONSTRAINT chk_demo_grade_point CHECK (grade_point BETWEEN 0 AND 10)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 2. ALTER TABLE: add a column and an index
ALTER TABLE demo_grade_scales
  ADD COLUMN description VARCHAR(120) NULL AFTER grade_point;

ALTER TABLE demo_grade_scales
  ADD INDEX idx_demo_grade_range (min_percent, max_percent);

-- 3. CREATE INDEX explicitly
CREATE INDEX idx_demo_grade_point ON demo_grade_scales (grade_point);

-- 4. DROP INDEX and DROP COLUMN (illustrative; safe on the demo table)
DROP INDEX idx_demo_grade_point ON demo_grade_scales;
ALTER TABLE demo_grade_scales DROP COLUMN description;

-- 5. RENAME TABLE (illustrative)
RENAME TABLE demo_grade_scales TO demo_grade_scales_archive;
RENAME TABLE demo_grade_scales_archive TO demo_grade_scales;

-- 6. CREATE VIEW (simple DDL example)
CREATE OR REPLACE VIEW vw_demo_grade_scales AS
SELECT grade_code, min_percent, max_percent, grade_point
FROM demo_grade_scales;

-- 7. DROP a demo object (safe; only affects the demonstration table)
DROP VIEW IF EXISTS vw_demo_grade_scales;
DROP TABLE IF EXISTS demo_grade_scales;

-- 8. Destructive examples are intentionally NOT included as executable statements:
-- DROP DATABASE gmu_management_system;  -- never run against a live database
-- TRUNCATE TABLE students;              -- would erase data
