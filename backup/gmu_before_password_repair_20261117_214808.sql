-- MySQL dump 10.13  Distrib 8.4.9, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: gmu_management_system
-- ------------------------------------------------------
-- Server version	8.4.9

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `academic_years`
--

DROP TABLE IF EXISTS `academic_years`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `academic_years`
--

LOCK TABLES `academic_years` WRITE;
/*!40000 ALTER TABLE `academic_years` DISABLE KEYS */;
INSERT INTO `academic_years` VALUES (1,'2024-25','2024-08-01','2025-07-31',0,'closed'),(2,'2025-26','2025-08-01','2026-07-31',1,'active');
/*!40000 ALTER TABLE `academic_years` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `attendance_records`
--

DROP TABLE IF EXISTS `attendance_records`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attendance_records`
--

LOCK TABLES `attendance_records` WRITE;
/*!40000 ALTER TABLE `attendance_records` DISABLE KEYS */;
INSERT INTO `attendance_records` VALUES (1,1,1,'present',NULL,'2026-11-17 07:19:04',2),(2,1,5,'present',NULL,'2026-11-17 07:19:04',2),(3,2,1,'late','Arrived 10 minutes late','2026-11-17 07:19:04',2),(4,2,5,'absent',NULL,'2026-11-17 07:19:04',2),(5,3,3,'present',NULL,'2026-11-17 07:19:04',2),(6,3,6,'present',NULL,'2026-11-17 07:19:04',2);
/*!40000 ALTER TABLE `attendance_records` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `attendance_sessions`
--

DROP TABLE IF EXISTS `attendance_sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attendance_sessions`
--

LOCK TABLES `attendance_sessions` WRITE;
/*!40000 ALTER TABLE `attendance_sessions` DISABLE KEYS */;
INSERT INTO `attendance_sessions` VALUES (1,1,'2025-09-01','10:00:00','11:00:00','ER Modeling','lecture',2,'2026-11-17 07:19:04'),(2,1,'2025-09-03','10:00:00','11:00:00','Normalization','lecture',2,'2026-11-17 07:19:04'),(3,4,'2026-02-10','09:00:00','10:00:00','OSI Model','lecture',2,'2026-11-17 07:19:04');
/*!40000 ALTER TABLE `attendance_sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `courses`
--

DROP TABLE IF EXISTS `courses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `courses`
--

LOCK TABLES `courses` WRITE;
/*!40000 ALTER TABLE `courses` DISABLE KEYS */;
INSERT INTO `courses` VALUES (1,1,'BTECH-CSE','Bachelor of Technology in Computer Science','UG',8,160,'active','2026-11-17 07:19:04','2026-11-17 07:19:04'),(2,2,'BTECH-ECE','Bachelor of Technology in Electronics and Communication','UG',8,160,'active','2026-11-17 07:19:04','2026-11-17 07:19:04'),(3,3,'MBA-GEN','Master of Business Administration','PG',4,90,'active','2026-11-17 07:19:04','2026-11-17 07:19:04');
/*!40000 ALTER TABLE `courses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `departments`
--

DROP TABLE IF EXISTS `departments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `departments`
--

LOCK TABLES `departments` WRITE;
/*!40000 ALTER TABLE `departments` DISABLE KEYS */;
INSERT INTO `departments` VALUES (1,'CSE','Computer Science and Engineering','Dr. Sample HOD A','Block A, Room 201','active','2026-11-17 07:19:04','2026-11-17 07:19:04'),(2,'ECE','Electronics and Communication Engineering','Dr. Sample HOD B','Block B, Room 110','active','2026-11-17 07:19:04','2026-11-17 07:19:04'),(3,'MBA','Master of Business Administration','Dr. Sample HOD C','Block C, Room 305','active','2026-11-17 07:19:04','2026-11-17 07:19:04');
/*!40000 ALTER TABLE `departments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `faculty`
--

DROP TABLE IF EXISTS `faculty`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
  `phone` varchar(20) DEFAULT NULL,
  `date_of_joining` date DEFAULT NULL,
  `status` enum('active','inactive','on_leave') NOT NULL DEFAULT 'active',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`faculty_id`),
  UNIQUE KEY `uk_faculty_employee_id` (`employee_id`),
  UNIQUE KEY `uk_faculty_user` (`user_id`),
  UNIQUE KEY `uk_faculty_email` (`email`),
  KEY `idx_faculty_department` (`department_id`),
  CONSTRAINT `fk_faculty_department` FOREIGN KEY (`department_id`) REFERENCES `departments` (`department_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_faculty_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `faculty`
--

LOCK TABLES `faculty` WRITE;
/*!40000 ALTER TABLE `faculty` DISABLE KEYS */;
INSERT INTO `faculty` VALUES (1,2,1,'FAC-CSE-014','Anita','Rao','Associate Professor','PhD (CSE)','anita.rao.faculty@example.edu','9100000014','2018-07-01','active','2026-11-17 07:19:04','2026-11-17 07:19:04'),(2,3,1,'FAC-CSE-021','Rahul','Mehta','Assistant Professor','M.Tech (CSE)','rahul.mehta.faculty@example.edu','9100000021','2020-08-15','active','2026-11-17 07:19:04','2026-11-17 07:19:04');
/*!40000 ALTER TABLE `faculty` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `faculty_subject_assignments`
--

DROP TABLE IF EXISTS `faculty_subject_assignments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `faculty_subject_assignments`
--

LOCK TABLES `faculty_subject_assignments` WRITE;
/*!40000 ALTER TABLE `faculty_subject_assignments` DISABLE KEYS */;
INSERT INTO `faculty_subject_assignments` VALUES (1,1,1,1,'A','2025-08-05',1),(2,1,3,1,'A','2025-08-05',1),(3,2,2,1,'A','2025-08-05',1),(4,1,4,2,'A','2026-01-05',1),(5,2,5,2,'A','2026-01-05',1);
/*!40000 ALTER TABLE `faculty_subject_assignments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fee_payments`
--

DROP TABLE IF EXISTS `fee_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fee_payments`
--

LOCK TABLES `fee_payments` WRITE;
/*!40000 ALTER TABLE `fee_payments` DISABLE KEYS */;
INSERT INTO `fee_payments` VALUES (1,1,1,55000.00,'2026-02-10','upi','TXN-FICTIONAL-1001','RCPT-2026-0001','success','Full tuition paid',1,'2026-11-17 07:19:04'),(2,1,2,2500.00,'2026-03-01','net_banking','TXN-FICTIONAL-1002','RCPT-2026-0002','success',NULL,1,'2026-11-17 07:19:04'),(3,2,1,25000.00,'2026-02-12','card','TXN-FICTIONAL-1003','RCPT-2026-0003','success','Partial payment',1,'2026-11-17 07:19:04');
/*!40000 ALTER TABLE `fee_payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fee_structures`
--

DROP TABLE IF EXISTS `fee_structures`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fee_structures`
--

LOCK TABLES `fee_structures` WRITE;
/*!40000 ALTER TABLE `fee_structures` DISABLE KEYS */;
INSERT INTO `fee_structures` VALUES (1,1,2,6,'Tuition Fee',55000.00,'2026-02-15',1),(2,1,2,6,'Examination Fee',2500.00,'2026-03-15',1),(3,1,2,6,'Library Fee',1500.00,'2026-02-15',1),(4,2,2,4,'Tuition Fee',52000.00,'2026-02-15',1);
/*!40000 ALTER TABLE `fee_structures` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `feedback`
--

DROP TABLE IF EXISTS `feedback`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `feedback`
--

LOCK TABLES `feedback` WRITE;
/*!40000 ALTER TABLE `feedback` DISABLE KEYS */;
INSERT INTO `feedback` VALUES (1,1,1,1,1,'course',5,'Well-structured DBMS course. (Fictional sample)',0,'reviewed','2025-12-18 14:00:00',1,'2025-12-19 10:00:00'),(2,2,1,1,1,'faculty',4,'Clear explanations and practical examples. (Fictional sample)',1,'submitted','2025-12-18 15:30:00',NULL,NULL);
/*!40000 ALTER TABLE `feedback` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `internal_assessments`
--

DROP TABLE IF EXISTS `internal_assessments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `internal_assessments`
--

LOCK TABLES `internal_assessments` WRITE;
/*!40000 ALTER TABLE `internal_assessments` DISABLE KEYS */;
INSERT INTO `internal_assessments` VALUES (1,1,1,'IA-1',25.00,12.50,'2025-09-20'),(2,1,1,'IA-2',25.00,12.50,'2025-11-05'),(3,4,2,'IA-1',25.00,12.50,'2026-03-10');
/*!40000 ALTER TABLE `internal_assessments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `internal_marks`
--

DROP TABLE IF EXISTS `internal_marks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `internal_marks`
--

LOCK TABLES `internal_marks` WRITE;
/*!40000 ALTER TABLE `internal_marks` DISABLE KEYS */;
INSERT INTO `internal_marks` VALUES (1,1,1,22.00,'Good performance',2,'2026-11-17 07:19:04','2026-11-17 07:19:04'),(2,1,5,19.50,NULL,2,'2026-11-17 07:19:04','2026-11-17 07:19:04'),(3,2,1,23.00,NULL,2,'2026-11-17 07:19:04','2026-11-17 07:19:04'),(4,3,3,21.00,'In progress term',2,'2026-11-17 07:19:04','2026-11-17 07:19:04');
/*!40000 ALTER TABLE `internal_marks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification_reads`
--

DROP TABLE IF EXISTS `notification_reads`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification_reads`
--

LOCK TABLES `notification_reads` WRITE;
/*!40000 ALTER TABLE `notification_reads` DISABLE KEYS */;
INSERT INTO `notification_reads` VALUES (1,1,4,'2026-01-07 10:15:00'),(2,3,2,'2026-11-01 09:00:00');
/*!40000 ALTER TABLE `notification_reads` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
INSERT INTO `notifications` VALUES (1,1,'student',NULL,'Semester 6 timetable published','The Semester 6 timetable is now available in the student portal. (Sample)','academic','normal',1,'2026-01-07 09:00:00',NULL),(2,1,'faculty',2,'Internal marks entry window','Please submit IA-1 marks by the published deadline. (Sample)','exam','high',1,'2026-03-05 10:00:00',NULL),(3,1,'all',NULL,'Portal maintenance notice','Scheduled maintenance preview notice for demonstration purposes.','system','low',1,'2026-11-01 08:00:00',NULL);
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_reset_tokens`
--

DROP TABLE IF EXISTS `password_reset_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_reset_tokens`
--

LOCK TABLES `password_reset_tokens` WRITE;
/*!40000 ALTER TABLE `password_reset_tokens` DISABLE KEYS */;
INSERT INTO `password_reset_tokens` VALUES (1,4,'0d6518c8e6e5896399fb4d7f86f5a83ab43b0cbb5dd803c02c721f54ffb43494','2026-11-12 10:00:00',NULL,'2026-11-17 07:19:04');
/*!40000 ALTER TABLE `password_reset_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'student','Student','Student portal access','2026-11-17 07:19:04'),(2,'faculty','Faculty','Faculty portal access','2026-11-17 07:19:04'),(3,'admin','Administrator','Administration portal access','2026-11-17 07:19:04');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `semester_exams`
--

DROP TABLE IF EXISTS `semester_exams`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `semester_exams`
--

LOCK TABLES `semester_exams` WRITE;
/*!40000 ALTER TABLE `semester_exams` DISABLE KEYS */;
INSERT INTO `semester_exams` VALUES (1,1,1,'End Semester Examination','2025-12-10',100.00,40.00),(2,2,1,'End Semester Examination','2025-12-13',100.00,40.00);
/*!40000 ALTER TABLE `semester_exams` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `semester_marks`
--

DROP TABLE IF EXISTS `semester_marks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `semester_marks`
--

LOCK TABLES `semester_marks` WRITE;
/*!40000 ALTER TABLE `semester_marks` DISABLE KEYS */;
INSERT INTO `semester_marks` VALUES (1,1,1,84.00,'A',9.00,'pass','2026-01-05 10:00:00',1),(2,1,5,76.00,'B+',8.00,'pass','2026-01-05 10:00:00',1),(3,2,2,79.00,'A',8.50,'pass','2026-01-05 10:00:00',1);
/*!40000 ALTER TABLE `semester_marks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `semesters`
--

DROP TABLE IF EXISTS `semesters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `semesters`
--

LOCK TABLES `semesters` WRITE;
/*!40000 ALTER TABLE `semesters` DISABLE KEYS */;
INSERT INTO `semesters` VALUES (1,1,2,5,'Odd','2025-08-10','2025-12-20','completed'),(2,1,2,6,'Even','2026-01-10','2026-05-30','active'),(3,2,2,4,'Even','2026-01-10','2026-05-30','active'),(4,3,2,2,'Even','2026-01-10','2026-05-30','active');
/*!40000 ALTER TABLE `semesters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_enrolments`
--

DROP TABLE IF EXISTS `student_enrolments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_enrolments`
--

LOCK TABLES `student_enrolments` WRITE;
/*!40000 ALTER TABLE `student_enrolments` DISABLE KEYS */;
INSERT INTO `student_enrolments` VALUES (1,1,1,1,'A','2025-08-08','completed'),(2,1,2,1,'A','2025-08-08','completed'),(3,1,4,2,'A','2026-01-08','enrolled'),(4,1,5,2,'A','2026-01-08','enrolled'),(5,2,1,1,'A','2025-08-08','completed'),(6,2,4,2,'A','2026-01-08','enrolled');
/*!40000 ALTER TABLE `student_enrolments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `students`
--

DROP TABLE IF EXISTS `students`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
  KEY `idx_students_department_course` (`department_id`,`course_id`),
  KEY `idx_students_status` (`status`),
  KEY `fk_students_course` (`course_id`),
  CONSTRAINT `fk_students_course` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_students_department` FOREIGN KEY (`department_id`) REFERENCES `departments` (`department_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_students_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `chk_students_semester` CHECK ((`current_semester` between 1 and 12))
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `students`
--

LOCK TABLES `students` WRITE;
/*!40000 ALTER TABLE `students` DISABLE KEYS */;
INSERT INTO `students` VALUES (1,4,1,1,'1GM23CS045','Aarav','Sharma','2005-04-12','male','aarav.sharma.student@example.edu','9000000045',NULL,NULL,NULL,NULL,2023,6,'active','2026-11-17 07:19:04','2026-11-17 07:19:04'),(2,5,1,1,'1GM23CS052','Diya','Nair','2005-09-03','female','diya.nair.student@example.edu','9000000052',NULL,NULL,NULL,NULL,2023,6,'active','2026-11-17 07:19:04','2026-11-17 07:19:04'),(3,6,2,2,'1GM22EC018','Kiran','Patil','2004-12-21','male','kiran.patil.student@example.edu','9000000018',NULL,NULL,NULL,NULL,2022,4,'inactive','2026-11-17 07:19:04','2026-11-17 07:19:04');
/*!40000 ALTER TABLE `students` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subjects`
--

DROP TABLE IF EXISTS `subjects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subjects`
--

LOCK TABLES `subjects` WRITE;
/*!40000 ALTER TABLE `subjects` DISABLE KEYS */;
INSERT INTO `subjects` VALUES (1,1,1,5,'CS501','Database Management Systems','theory',4,'active','2026-11-17 07:19:04','2026-11-17 07:19:04'),(2,1,1,5,'CS502','Operating Systems','theory',4,'active','2026-11-17 07:19:04','2026-11-17 07:19:04'),(3,1,1,5,'CS503','Database Lab','lab',2,'active','2026-11-17 07:19:04','2026-11-17 07:19:04'),(4,1,1,6,'CS601','Computer Networks','theory',4,'active','2026-11-17 07:19:04','2026-11-17 07:19:04'),(5,1,1,6,'CS602','Software Engineering','theory',3,'active','2026-11-17 07:19:04','2026-11-17 07:19:04'),(6,2,2,4,'EC401','Signals and Systems','theory',4,'active','2026-11-17 07:19:04','2026-11-17 07:19:04');
/*!40000 ALTER TABLE `subjects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `timetable_entries`
--

DROP TABLE IF EXISTS `timetable_entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `timetable_entries`
--

LOCK TABLES `timetable_entries` WRITE;
/*!40000 ALTER TABLE `timetable_entries` DISABLE KEYS */;
INSERT INTO `timetable_entries` VALUES (1,4,1,2,'A','Monday','09:00:00','10:00:00','CSE-301','lecture','active'),(2,4,1,2,'A','Wednesday','11:00:00','12:00:00','CSE-301','lecture','active'),(3,5,2,2,'A','Tuesday','10:00:00','11:00:00','CSE-204','lecture','active'),(4,1,1,1,'A','Monday','10:00:00','11:00:00','CSE-201','lecture','active');
/*!40000 ALTER TABLE `timetable_entries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,3,'admin@gmu.edu.in','admin@gmu.edu.in','scrypt:32768:8:1$S2weNI0clM72aieL$1128cd56ce84014260f99e2055b49fa2a3781aa4e0529250fe2ad3e575c1e74622ea6850e64ee21a1c2e1e2a486889e3da8ea2a8232d7dc0c04f65c5f78a77f8','active',1,0,7,NULL,NULL,'2026-11-17 07:19:04','2026-11-17 21:31:08'),(2,2,'FAC-CSE-014','anita.rao.faculty@example.edu','scrypt:32768:8:1$S2weNI0clM72aieL$1128cd56ce84014260f99e2055b49fa2a3781aa4e0529250fe2ad3e575c1e74622ea6850e64ee21a1c2e1e2a486889e3da8ea2a8232d7dc0c04f65c5f78a77f8','pending_reset',1,1,0,'2026-11-17 21:23:52',NULL,'2026-11-17 07:19:04','2026-11-17 21:23:52'),(3,2,'FAC-CSE-021','rahul.mehta.faculty@example.edu','scrypt:32768:8:1$S2weNI0clM72aieL$1128cd56ce84014260f99e2055b49fa2a3781aa4e0529250fe2ad3e575c1e74622ea6850e64ee21a1c2e1e2a486889e3da8ea2a8232d7dc0c04f65c5f78a77f8','pending_reset',1,1,0,NULL,NULL,'2026-11-17 07:19:04','2026-11-17 21:19:40'),(4,1,'1GM23CS045','aarav.sharma.student@example.edu','scrypt:32768:8:1$S2weNI0clM72aieL$1128cd56ce84014260f99e2055b49fa2a3781aa4e0529250fe2ad3e575c1e74622ea6850e64ee21a1c2e1e2a486889e3da8ea2a8232d7dc0c04f65c5f78a77f8','pending_reset',1,1,1,'2026-11-17 21:21:00',NULL,'2026-11-17 07:19:04','2026-11-17 21:45:44'),(5,1,'1GM23CS052','diya.nair.student@example.edu','scrypt:32768:8:1$S2weNI0clM72aieL$1128cd56ce84014260f99e2055b49fa2a3781aa4e0529250fe2ad3e575c1e74622ea6850e64ee21a1c2e1e2a486889e3da8ea2a8232d7dc0c04f65c5f78a77f8','pending_reset',1,1,0,'2026-11-17 21:22:13',NULL,'2026-11-17 07:19:04','2026-11-17 21:22:13'),(6,1,'1GM22EC018','kiran.patil.student@example.edu','!NO_LOGIN_HASH_SET','inactive',0,1,0,NULL,NULL,'2026-11-17 07:19:04','2026-11-17 07:19:04');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `vw_faculty_workload`
--

DROP TABLE IF EXISTS `vw_faculty_workload`;
/*!50001 DROP VIEW IF EXISTS `vw_faculty_workload`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_faculty_workload` AS SELECT 
 1 AS `faculty_id`,
 1 AS `employee_id`,
 1 AS `faculty_name`,
 1 AS `department_name`,
 1 AS `semester_number`,
 1 AS `academic_year`,
 1 AS `subject_code`,
 1 AS `subject_name`,
 1 AS `section`,
 1 AS `assignment_active`,
 1 AS `enrolled_students`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_student_profile`
--

DROP TABLE IF EXISTS `vw_student_profile`;
/*!50001 DROP VIEW IF EXISTS `vw_student_profile`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_student_profile` AS SELECT 
 1 AS `student_id`,
 1 AS `usn`,
 1 AS `student_name`,
 1 AS `email`,
 1 AS `phone`,
 1 AS `admission_year`,
 1 AS `current_semester`,
 1 AS `student_status`,
 1 AS `department_code`,
 1 AS `department_name`,
 1 AS `course_code`,
 1 AS `course_name`,
 1 AS `login_identifier`,
 1 AS `account_status`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping events for database 'gmu_management_system'
--

--
-- Dumping routines for database 'gmu_management_system'
--

--
-- Final view structure for view `vw_faculty_workload`
--

/*!50001 DROP VIEW IF EXISTS `vw_faculty_workload`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_faculty_workload` AS select `f`.`faculty_id` AS `faculty_id`,`f`.`employee_id` AS `employee_id`,concat(`f`.`first_name`,' ',`f`.`last_name`) AS `faculty_name`,`d`.`department_name` AS `department_name`,`sem`.`semester_number` AS `semester_number`,`ay`.`year_label` AS `academic_year`,`sub`.`subject_code` AS `subject_code`,`sub`.`subject_name` AS `subject_name`,`fsa`.`section` AS `section`,`fsa`.`is_active` AS `assignment_active`,count(distinct `se`.`student_id`) AS `enrolled_students` from ((((((`faculty` `f` join `departments` `d` on((`d`.`department_id` = `f`.`department_id`))) join `faculty_subject_assignments` `fsa` on((`fsa`.`faculty_id` = `f`.`faculty_id`))) join `subjects` `sub` on((`sub`.`subject_id` = `fsa`.`subject_id`))) join `semesters` `sem` on((`sem`.`semester_id` = `fsa`.`semester_id`))) join `academic_years` `ay` on((`ay`.`academic_year_id` = `sem`.`academic_year_id`))) left join `student_enrolments` `se` on(((`se`.`subject_id` = `fsa`.`subject_id`) and (`se`.`semester_id` = `fsa`.`semester_id`) and (`se`.`section` = `fsa`.`section`)))) group by `f`.`faculty_id`,`f`.`employee_id`,`faculty_name`,`d`.`department_name`,`sem`.`semester_number`,`ay`.`year_label`,`sub`.`subject_code`,`sub`.`subject_name`,`fsa`.`section`,`fsa`.`is_active` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_student_profile`
--

/*!50001 DROP VIEW IF EXISTS `vw_student_profile`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_student_profile` AS select `s`.`student_id` AS `student_id`,`s`.`usn` AS `usn`,concat(`s`.`first_name`,' ',`s`.`last_name`) AS `student_name`,`s`.`email` AS `email`,`s`.`phone` AS `phone`,`s`.`admission_year` AS `admission_year`,`s`.`current_semester` AS `current_semester`,`s`.`status` AS `student_status`,`d`.`department_code` AS `department_code`,`d`.`department_name` AS `department_name`,`c`.`course_code` AS `course_code`,`c`.`course_name` AS `course_name`,`u`.`login_identifier` AS `login_identifier`,`u`.`account_status` AS `account_status` from (((`students` `s` join `departments` `d` on((`d`.`department_id` = `s`.`department_id`))) join `courses` `c` on((`c`.`course_id` = `s`.`course_id`))) left join `users` `u` on((`u`.`user_id` = `s`.`user_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-17 21:48:10
