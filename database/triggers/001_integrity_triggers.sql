-- GM University Management System
-- Stage 3: Cross-table integrity triggers (DESIGN ONLY - NOT EXECUTED)
-- Target: MySQL 8.0.16+ / InnoDB / utf8mb4
--
-- Run order: schema -> views -> triggers -> seeds.
-- These triggers cover business rules that cannot be expressed as a single
-- foreign key because the rule spans two or more parent tables.
-- They are defence in depth; the Flask service must still validate input.

USE gmu_management_system;

DELIMITER $$

-- ---------------------------------------------------------------------------
-- 1. Attendance records must belong to the session's teaching assignment.
--    A session is tied to (subject, semester, section) through its assignment.
--    The enrolment must match all three values.
-- ---------------------------------------------------------------------------
DROP TRIGGER IF EXISTS trg_attendance_records_bi$$
CREATE TRIGGER trg_attendance_records_bi
BEFORE INSERT ON attendance_records
FOR EACH ROW
BEGIN
  DECLARE v_session_subject INT UNSIGNED DEFAULT NULL;
  DECLARE v_session_semester INT UNSIGNED DEFAULT NULL;
  DECLARE v_session_section VARCHAR(10) DEFAULT NULL;
  DECLARE v_enrol_subject INT UNSIGNED DEFAULT NULL;
  DECLARE v_enrol_semester INT UNSIGNED DEFAULT NULL;
  DECLARE v_enrol_section VARCHAR(10) DEFAULT NULL;

  SELECT fsa.subject_id, fsa.semester_id, fsa.section
    INTO v_session_subject, v_session_semester, v_session_section
  FROM attendance_sessions ats
  JOIN faculty_subject_assignments fsa ON fsa.assignment_id = ats.assignment_id
  WHERE ats.session_id = NEW.session_id;

  SELECT se.subject_id, se.semester_id, se.section
    INTO v_enrol_subject, v_enrol_semester, v_enrol_section
  FROM student_enrolments se
  WHERE se.enrolment_id = NEW.enrolment_id;

  IF v_session_subject IS NULL OR v_enrol_subject IS NULL THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Attendance record references an unknown session or enrolment';
  END IF;

  IF v_session_subject <> v_enrol_subject
     OR v_session_semester <> v_enrol_semester
     OR v_session_section <> v_enrol_section THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Attendance session and enrolment subject/semester/section do not match';
  END IF;
END$$

DROP TRIGGER IF EXISTS trg_attendance_records_bu$$
CREATE TRIGGER trg_attendance_records_bu
BEFORE UPDATE ON attendance_records
FOR EACH ROW
BEGIN
  DECLARE v_session_subject INT UNSIGNED DEFAULT NULL;
  DECLARE v_session_semester INT UNSIGNED DEFAULT NULL;
  DECLARE v_session_section VARCHAR(10) DEFAULT NULL;
  DECLARE v_enrol_subject INT UNSIGNED DEFAULT NULL;
  DECLARE v_enrol_semester INT UNSIGNED DEFAULT NULL;
  DECLARE v_enrol_section VARCHAR(10) DEFAULT NULL;

  SELECT fsa.subject_id, fsa.semester_id, fsa.section
    INTO v_session_subject, v_session_semester, v_session_section
  FROM attendance_sessions ats
  JOIN faculty_subject_assignments fsa ON fsa.assignment_id = ats.assignment_id
  WHERE ats.session_id = NEW.session_id;

  SELECT se.subject_id, se.semester_id, se.section
    INTO v_enrol_subject, v_enrol_semester, v_enrol_section
  FROM student_enrolments se
  WHERE se.enrolment_id = NEW.enrolment_id;

  IF v_session_subject IS NULL OR v_enrol_subject IS NULL THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Attendance record references an unknown session or enrolment';
  END IF;

  IF v_session_subject <> v_enrol_subject
     OR v_session_semester <> v_enrol_semester
     OR v_session_section <> v_enrol_section THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Attendance session and enrolment subject/semester/section do not match';
  END IF;
END$$

-- ---------------------------------------------------------------------------
-- 2. Internal marks must match the assessment's subject and semester, and
--    must not exceed the assessment maximum.
-- ---------------------------------------------------------------------------
DROP TRIGGER IF EXISTS trg_internal_marks_bi$$
CREATE TRIGGER trg_internal_marks_bi
BEFORE INSERT ON internal_marks
FOR EACH ROW
BEGIN
  DECLARE v_assess_subject INT UNSIGNED DEFAULT NULL;
  DECLARE v_assess_semester INT UNSIGNED DEFAULT NULL;
  DECLARE v_assess_max DECIMAL(5,2) DEFAULT NULL;
  DECLARE v_enrol_subject INT UNSIGNED DEFAULT NULL;
  DECLARE v_enrol_semester INT UNSIGNED DEFAULT NULL;

  SELECT ia.subject_id, ia.semester_id, ia.max_marks
    INTO v_assess_subject, v_assess_semester, v_assess_max
  FROM internal_assessments ia
  WHERE ia.assessment_id = NEW.assessment_id;

  SELECT se.subject_id, se.semester_id
    INTO v_enrol_subject, v_enrol_semester
  FROM student_enrolments se
  WHERE se.enrolment_id = NEW.enrolment_id;

  IF v_assess_subject IS NULL OR v_enrol_subject IS NULL THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Internal mark references an unknown assessment or enrolment';
  END IF;

  IF v_assess_subject <> v_enrol_subject OR v_assess_semester <> v_enrol_semester THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Assessment and enrolment subject/semester do not match';
  END IF;

  IF NEW.marks_obtained > v_assess_max THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Internal marks exceed the assessment maximum';
  END IF;
END$$

DROP TRIGGER IF EXISTS trg_internal_marks_bu$$
CREATE TRIGGER trg_internal_marks_bu
BEFORE UPDATE ON internal_marks
FOR EACH ROW
BEGIN
  DECLARE v_assess_subject INT UNSIGNED DEFAULT NULL;
  DECLARE v_assess_semester INT UNSIGNED DEFAULT NULL;
  DECLARE v_assess_max DECIMAL(5,2) DEFAULT NULL;
  DECLARE v_enrol_subject INT UNSIGNED DEFAULT NULL;
  DECLARE v_enrol_semester INT UNSIGNED DEFAULT NULL;

  SELECT ia.subject_id, ia.semester_id, ia.max_marks
    INTO v_assess_subject, v_assess_semester, v_assess_max
  FROM internal_assessments ia
  WHERE ia.assessment_id = NEW.assessment_id;

  SELECT se.subject_id, se.semester_id
    INTO v_enrol_subject, v_enrol_semester
  FROM student_enrolments se
  WHERE se.enrolment_id = NEW.enrolment_id;

  IF v_assess_subject IS NULL OR v_enrol_subject IS NULL THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Internal mark references an unknown assessment or enrolment';
  END IF;

  IF v_assess_subject <> v_enrol_subject OR v_assess_semester <> v_enrol_semester THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Assessment and enrolment subject/semester do not match';
  END IF;

  IF NEW.marks_obtained > v_assess_max THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Internal marks exceed the assessment maximum';
  END IF;
END$$

-- ---------------------------------------------------------------------------
-- 3. Semester marks must match the exam's subject and semester, and must not
--    exceed the exam maximum.
-- ---------------------------------------------------------------------------
DROP TRIGGER IF EXISTS trg_semester_marks_bi$$
CREATE TRIGGER trg_semester_marks_bi
BEFORE INSERT ON semester_marks
FOR EACH ROW
BEGIN
  DECLARE v_exam_subject INT UNSIGNED DEFAULT NULL;
  DECLARE v_exam_semester INT UNSIGNED DEFAULT NULL;
  DECLARE v_exam_max DECIMAL(5,2) DEFAULT NULL;
  DECLARE v_enrol_subject INT UNSIGNED DEFAULT NULL;
  DECLARE v_enrol_semester INT UNSIGNED DEFAULT NULL;

  SELECT se_exam.subject_id, se_exam.semester_id, se_exam.max_marks
    INTO v_exam_subject, v_exam_semester, v_exam_max
  FROM semester_exams se_exam
  WHERE se_exam.exam_id = NEW.exam_id;

  SELECT se.subject_id, se.semester_id
    INTO v_enrol_subject, v_enrol_semester
  FROM student_enrolments se
  WHERE se.enrolment_id = NEW.enrolment_id;

  IF v_exam_subject IS NULL OR v_enrol_subject IS NULL THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Semester mark references an unknown exam or enrolment';
  END IF;

  IF v_exam_subject <> v_enrol_subject OR v_exam_semester <> v_enrol_semester THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Exam and enrolment subject/semester do not match';
  END IF;

  IF NEW.marks_obtained > v_exam_max THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Semester marks exceed the exam maximum';
  END IF;
END$$

DROP TRIGGER IF EXISTS trg_semester_marks_bu$$
CREATE TRIGGER trg_semester_marks_bu
BEFORE UPDATE ON semester_marks
FOR EACH ROW
BEGIN
  DECLARE v_exam_subject INT UNSIGNED DEFAULT NULL;
  DECLARE v_exam_semester INT UNSIGNED DEFAULT NULL;
  DECLARE v_exam_max DECIMAL(5,2) DEFAULT NULL;
  DECLARE v_enrol_subject INT UNSIGNED DEFAULT NULL;
  DECLARE v_enrol_semester INT UNSIGNED DEFAULT NULL;

  SELECT se_exam.subject_id, se_exam.semester_id, se_exam.max_marks
    INTO v_exam_subject, v_exam_semester, v_exam_max
  FROM semester_exams se_exam
  WHERE se_exam.exam_id = NEW.exam_id;

  SELECT se.subject_id, se.semester_id
    INTO v_enrol_subject, v_enrol_semester
  FROM student_enrolments se
  WHERE se.enrolment_id = NEW.enrolment_id;

  IF v_exam_subject IS NULL OR v_enrol_subject IS NULL THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Semester mark references an unknown exam or enrolment';
  END IF;

  IF v_exam_subject <> v_enrol_subject OR v_exam_semester <> v_enrol_semester THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Exam and enrolment subject/semester do not match';
  END IF;

  IF NEW.marks_obtained > v_exam_max THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Semester marks exceed the exam maximum';
  END IF;
END$$

-- ---------------------------------------------------------------------------
-- 4. A payment must be against a fee structure for the student's own course,
--    and successful payments must not exceed that fee structure's amount.
-- ---------------------------------------------------------------------------
DROP TRIGGER IF EXISTS trg_fee_payments_bi$$
CREATE TRIGGER trg_fee_payments_bi
BEFORE INSERT ON fee_payments
FOR EACH ROW
BEGIN
  DECLARE v_student_course INT UNSIGNED DEFAULT NULL;
  DECLARE v_fee_course INT UNSIGNED DEFAULT NULL;
  DECLARE v_fee_amount DECIMAL(10,2) DEFAULT NULL;
  DECLARE v_paid DECIMAL(12,2) DEFAULT 0.00;

  SELECT course_id INTO v_student_course
  FROM students WHERE student_id = NEW.student_id;

  SELECT course_id, amount INTO v_fee_course, v_fee_amount
  FROM fee_structures WHERE fee_structure_id = NEW.fee_structure_id;

  IF v_student_course IS NULL OR v_fee_course IS NULL THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Payment references an unknown student or fee structure';
  END IF;

  IF v_student_course <> v_fee_course THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Fee structure does not belong to the student course';
  END IF;

  IF NEW.payment_status = 'success' THEN
    SELECT COALESCE(SUM(amount_paid), 0) INTO v_paid
    FROM fee_payments
    WHERE student_id = NEW.student_id
      AND fee_structure_id = NEW.fee_structure_id
      AND payment_status = 'success';

    IF v_paid + NEW.amount_paid > v_fee_amount THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Successful payments exceed the fee structure amount';
    END IF;
  END IF;
END$$

DROP TRIGGER IF EXISTS trg_fee_payments_bu$$
CREATE TRIGGER trg_fee_payments_bu
BEFORE UPDATE ON fee_payments
FOR EACH ROW
BEGIN
  DECLARE v_student_course INT UNSIGNED DEFAULT NULL;
  DECLARE v_fee_course INT UNSIGNED DEFAULT NULL;
  DECLARE v_fee_amount DECIMAL(10,2) DEFAULT NULL;
  DECLARE v_paid DECIMAL(12,2) DEFAULT 0.00;

  SELECT course_id INTO v_student_course
  FROM students WHERE student_id = NEW.student_id;

  SELECT course_id, amount INTO v_fee_course, v_fee_amount
  FROM fee_structures WHERE fee_structure_id = NEW.fee_structure_id;

  IF v_student_course IS NULL OR v_fee_course IS NULL THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Payment references an unknown student or fee structure';
  END IF;

  IF v_student_course <> v_fee_course THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Fee structure does not belong to the student course';
  END IF;

  IF NEW.payment_status = 'success' THEN
    SELECT COALESCE(SUM(amount_paid), 0) INTO v_paid
    FROM fee_payments
    WHERE student_id = NEW.student_id
      AND fee_structure_id = NEW.fee_structure_id
      AND payment_status = 'success'
      AND payment_id <> NEW.payment_id;

    IF v_paid + NEW.amount_paid > v_fee_amount THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Successful payments exceed the fee structure amount';
    END IF;
  END IF;
END$$

-- ---------------------------------------------------------------------------
-- 5. A direct notification target must match the declared target role.
--    'all' broadcasts must not carry a target user (also enforced by CHECK).
-- ---------------------------------------------------------------------------
DROP TRIGGER IF EXISTS trg_notifications_bi$$
CREATE TRIGGER trg_notifications_bi
BEFORE INSERT ON notifications
FOR EACH ROW
BEGIN
  DECLARE v_target_role_code VARCHAR(20) DEFAULT NULL;

  IF NEW.target_role = 'all' AND NEW.target_user_id IS NOT NULL THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'A broadcast notification cannot target a single user';
  END IF;

  IF NEW.target_user_id IS NOT NULL THEN
    SELECT r.role_code INTO v_target_role_code
    FROM users u
    JOIN roles r ON r.role_id = u.role_id
    WHERE u.user_id = NEW.target_user_id;

    IF v_target_role_code IS NULL THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Notification target user does not exist';
    END IF;

    IF NEW.target_role <> v_target_role_code THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Notification target role does not match the user role';
    END IF;
  END IF;
END$$

DROP TRIGGER IF EXISTS trg_notifications_bu$$
CREATE TRIGGER trg_notifications_bu
BEFORE UPDATE ON notifications
FOR EACH ROW
BEGIN
  DECLARE v_target_role_code VARCHAR(20) DEFAULT NULL;

  IF NEW.target_role = 'all' AND NEW.target_user_id IS NOT NULL THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'A broadcast notification cannot target a single user';
  END IF;

  IF NEW.target_user_id IS NOT NULL THEN
    SELECT r.role_code INTO v_target_role_code
    FROM users u
    JOIN roles r ON r.role_id = u.role_id
    WHERE u.user_id = NEW.target_user_id;

    IF v_target_role_code IS NULL THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Notification target user does not exist';
    END IF;

    IF NEW.target_role <> v_target_role_code THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Notification target role does not match the user role';
    END IF;
  END IF;
END$$

DELIMITER ;

-- End of integrity triggers.
