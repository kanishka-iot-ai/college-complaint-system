-- ============================================================
--  College Complaint Management System
--  Database Migration Script: Official 20 Student Records
--  Source: Uploaded PDF Master Records
-- ============================================================

USE college_complaint_db;

START TRANSACTION;

-- ── 1. Schema Alterations ────────────────────────────────────
-- Add uid, section, is_active columns while preserving primary & foreign keys

-- Add uid if not exists
SET @uid_col = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'college_complaint_db' AND TABLE_NAME = 'students' AND COLUMN_NAME = 'uid');
SET @sql = IF(@uid_col = 0, 'ALTER TABLE students ADD COLUMN uid VARCHAR(30) UNIQUE AFTER student_id', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- Add section if not exists
SET @sec_col = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'college_complaint_db' AND TABLE_NAME = 'students' AND COLUMN_NAME = 'section');
SET @sql = IF(@sec_col = 0, 'ALTER TABLE students ADD COLUMN section VARCHAR(100) NOT NULL DEFAULT \'Future Skills & Innovation\' AFTER email', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- Add is_active if not exists
SET @act_col = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'college_complaint_db' AND TABLE_NAME = 'students' AND COLUMN_NAME = 'is_active');
SET @sql = IF(@act_col = 0, 'ALTER TABLE students ADD COLUMN is_active BOOLEAN NOT NULL DEFAULT FALSE AFTER phone', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- Make department, semester, phone nullable as instructed
ALTER TABLE students 
    MODIFY COLUMN department VARCHAR(100) NULL,
    MODIFY COLUMN semester INT NULL,
    MODIFY COLUMN phone VARCHAR(15) NULL;

-- ── 2. Data Migration: 20 Official Student Records ───────────
-- Safely replace demo student rows 1..5 and insert rows 6..20

-- Student 1
INSERT INTO students (student_id, uid, name, email, section, password_hash, department, semester, phone, is_active)
VALUES (1, '26BAI10196', 'MOHAMMED TEHJIB NIZAM CHOWDHURY', '26BAI10196@cuchd.in', 'Future Skills & Innovation',
        '$2a$10$IeeUH8PigG9iDfXmGrlGu.24OwCs2n12H3qlNkFJ4HXy792Ge8MKe', 'Artificial Intelligence', 1, NULL, TRUE)
ON DUPLICATE KEY UPDATE 
    uid = VALUES(uid), name = VALUES(name), email = VALUES(email), 
    section = VALUES(section), password_hash = VALUES(password_hash),
    department = VALUES(department), is_active = VALUES(is_active);

-- Student 2
INSERT INTO students (student_id, uid, name, email, section, password_hash, department, semester, phone, is_active)
VALUES (2, '25BCY70275', 'PIYESH KUMAR DAS', '25BCY70275@cuchd.in', 'Future Skills & Innovation',
        '$2a$10$YXD9js36giMgw8/SKNZUfODW6BIonwhWFMw1NeH8FcdQUImrr/v22', 'Cybersecurity', 3, NULL, TRUE)
ON DUPLICATE KEY UPDATE 
    uid = VALUES(uid), name = VALUES(name), email = VALUES(email), 
    section = VALUES(section), password_hash = VALUES(password_hash),
    department = VALUES(department), is_active = VALUES(is_active);

-- Student 3
INSERT INTO students (student_id, uid, name, email, section, password_hash, department, semester, phone, is_active)
VALUES (3, '26BAI10195', 'Singiri sireesha', '26BAI10195@cuchd.in', 'Future Skills & Innovation',
        '$2a$10$op3JPPlFO/7LoS4nEexskew2MySuHh11cfkjkcGY/YNHf08y//RuO', 'Artificial Intelligence', 1, NULL, TRUE)
ON DUPLICATE KEY UPDATE 
    uid = VALUES(uid), name = VALUES(name), email = VALUES(email), 
    section = VALUES(section), password_hash = VALUES(password_hash),
    department = VALUES(department), is_active = VALUES(is_active);

-- Student 4
INSERT INTO students (student_id, uid, name, email, section, password_hash, department, semester, phone, is_active)
VALUES (4, '26BAI10118', 'APARAJITA GOPE ARPA', '26BAI10118@cuchd.in', 'Future Skills & Innovation',
        '$2a$10$mSdoqnYzE0Dou2m.0Jf6O.gUm9AvIjXC3Exfl3R9D9jooF.zau4di', 'Artificial Intelligence', 1, NULL, TRUE)
ON DUPLICATE KEY UPDATE 
    uid = VALUES(uid), name = VALUES(name), email = VALUES(email), 
    section = VALUES(section), password_hash = VALUES(password_hash),
    department = VALUES(department), is_active = VALUES(is_active);

-- Student 5
INSERT INTO students (student_id, uid, name, email, section, password_hash, department, semester, phone, is_active)
VALUES (5, '26BDS80005', 'AYUSH KUMAR PATEL', '26BDS80005@cuchd.in', 'Future Skills & Innovation',
        '$2a$10$m64MIds6lJCN8ivG4kKhOu4opXz0O0QCp7Adrm2teFpEdBJLMTUHq', 'Data Science', 1, NULL, TRUE)
ON DUPLICATE KEY UPDATE 
    uid = VALUES(uid), name = VALUES(name), email = VALUES(email), 
    section = VALUES(section), password_hash = VALUES(password_hash),
    department = VALUES(department), is_active = VALUES(is_active);

-- Student 6
INSERT INTO students (student_id, uid, name, email, section, password_hash, department, semester, phone, is_active)
VALUES (6, '26BDS80004', 'MD RAZAUDDIN', '26BDS80004@cuchd.in', 'Future Skills & Innovation',
        '$2a$10$mlWgbUerTW/eJHTtOHLDueLvhcZzMScr0PyrbAJ5esvy9.uTj21iy', 'Data Science', 1, NULL, TRUE)
ON DUPLICATE KEY UPDATE 
    uid = VALUES(uid), name = VALUES(name), email = VALUES(email), 
    section = VALUES(section), password_hash = VALUES(password_hash),
    department = VALUES(department), is_active = VALUES(is_active);

-- Student 7
INSERT INTO students (student_id, uid, name, email, section, password_hash, department, semester, phone, is_active)
VALUES (7, '26BAI80018', 'VIDHITA CHAUDHARY', '26BAI80018@cuchd.in', 'Future Skills & Innovation',
        '$2a$10$NvXkuO1eZzfsukzP221xveWwlKlzIutsTgcJwmSHm4qIcqooo6r.G', 'Artificial Intelligence', 1, NULL, TRUE)
ON DUPLICATE KEY UPDATE 
    uid = VALUES(uid), name = VALUES(name), email = VALUES(email), 
    section = VALUES(section), password_hash = VALUES(password_hash),
    department = VALUES(department), is_active = VALUES(is_active);

-- Student 8
INSERT INTO students (student_id, uid, name, email, section, password_hash, department, semester, phone, is_active)
VALUES (8, '25BAI70994', 'MEHAKPREET KAUR', '25BAI70994@cuchd.in', 'Future Skills & Innovation',
        '$2a$10$sGIGiCK34ZgQYUz72ZsIruxMsB6X4ZMfruvOIsUUBnPpsQFGj/tKa', 'Artificial Intelligence', 3, NULL, TRUE)
ON DUPLICATE KEY UPDATE 
    uid = VALUES(uid), name = VALUES(name), email = VALUES(email), 
    section = VALUES(section), password_hash = VALUES(password_hash),
    department = VALUES(department), is_active = VALUES(is_active);

-- Student 9
INSERT INTO students (student_id, uid, name, email, section, password_hash, department, semester, phone, is_active)
VALUES (9, '25BDA70080', 'RIKSHESH SINGH', '25BDA70080@cuchd.in', 'Future Skills & Innovation',
        '$2a$10$oxvhsd7OYXkEghdFcYtoOu89oN6RPw6SKn0MBNcX0syZJVXybmrem', 'Data Analytics', 3, NULL, TRUE)
ON DUPLICATE KEY UPDATE 
    uid = VALUES(uid), name = VALUES(name), email = VALUES(email), 
    section = VALUES(section), password_hash = VALUES(password_hash),
    department = VALUES(department), is_active = VALUES(is_active);

-- Student 10
INSERT INTO students (student_id, uid, name, email, section, password_hash, department, semester, phone, is_active)
VALUES (10, '25BCC70040', 'DHRUV', '25BCC70040@cuchd.in', 'Future Skills & Innovation',
        '$2a$10$2DU8uRJrP5L83SJhi2Jzz.Ja9rfzhVJs5c47RLP1xdZOZ18VbpkHu', 'Cloud Computing', 3, NULL, TRUE)
ON DUPLICATE KEY UPDATE 
    uid = VALUES(uid), name = VALUES(name), email = VALUES(email), 
    section = VALUES(section), password_hash = VALUES(password_hash),
    department = VALUES(department), is_active = VALUES(is_active);

-- Student 11
INSERT INTO students (student_id, uid, name, email, section, password_hash, department, semester, phone, is_active)
VALUES (11, '25BCY70056', 'NAVEEN CHAUDHARY', '25BCY70056@cuchd.in', 'Future Skills & Innovation',
        '$2a$10$ZIpD.4cb4jGvtovsVRtYSuqIKwrTKY1qOgKS6SbkM3JbF2K7ZPFdm', 'Cybersecurity', 3, NULL, TRUE)
ON DUPLICATE KEY UPDATE 
    uid = VALUES(uid), name = VALUES(name), email = VALUES(email), 
    section = VALUES(section), password_hash = VALUES(password_hash),
    department = VALUES(department), is_active = VALUES(is_active);

-- Student 12
INSERT INTO students (student_id, uid, name, email, section, password_hash, department, semester, phone, is_active)
VALUES (12, '25BAI70221', 'VIPLAV MITTAL', '25BAI70221@cuchd.in', 'Future Skills & Innovation',
        '$2a$10$d3f3N8Z6MlZs5c7QJ2w6Xe2NMhGu/L5hcSMSWtP1crZcikUgs75la', 'Artificial Intelligence', 3, NULL, TRUE)
ON DUPLICATE KEY UPDATE 
    uid = VALUES(uid), name = VALUES(name), email = VALUES(email), 
    section = VALUES(section), password_hash = VALUES(password_hash),
    department = VALUES(department), is_active = VALUES(is_active);

-- Student 13
INSERT INTO students (student_id, uid, name, email, section, password_hash, department, semester, phone, is_active)
VALUES (13, '25BDA70085', 'SAHIL KUMAR DOGRA', '25BDA70085@cuchd.in', 'Future Skills & Innovation',
        '$2a$10$E8ZkU5QnZ535xgXzTsUQxuroB1Dv5NslMT1KV/ihHrmz7jBRtd0Uy', 'Data Analytics', 3, NULL, TRUE)
ON DUPLICATE KEY UPDATE 
    uid = VALUES(uid), name = VALUES(name), email = VALUES(email), 
    section = VALUES(section), password_hash = VALUES(password_hash),
    department = VALUES(department), is_active = VALUES(is_active);

-- Student 14
INSERT INTO students (student_id, uid, name, email, section, password_hash, department, semester, phone, is_active)
VALUES (14, '25BDA70265', 'KRIPANSHU SIKDAR', '25BDA70265@cuchd.in', 'Future Skills & Innovation',
        '$2a$10$YMJL74KneM82kp3ONkt8rusHGUc0cLetyXzkII64FDkI8A.06PJ5i', 'Data Analytics', 3, NULL, TRUE)
ON DUPLICATE KEY UPDATE 
    uid = VALUES(uid), name = VALUES(name), email = VALUES(email), 
    section = VALUES(section), password_hash = VALUES(password_hash),
    department = VALUES(department), is_active = VALUES(is_active);

-- Student 15 (Section: Society, Sustainability & Human Values)
INSERT INTO students (student_id, uid, name, email, section, password_hash, department, semester, phone, is_active)
VALUES (15, '25BAI70939', 'VIKALP ANGROYA', '25BAI70939@cuchd.in', 'Society, Sustainability & Human Values',
        '$2a$10$iHpr5Hvf6r1HUVE.ZnzGZubIOzcCkSsmIs.F5UTshRMSYONPNTFfC', 'Artificial Intelligence', 3, NULL, TRUE)
ON DUPLICATE KEY UPDATE 
    uid = VALUES(uid), name = VALUES(name), email = VALUES(email), 
    section = VALUES(section), password_hash = VALUES(password_hash),
    department = VALUES(department), is_active = VALUES(is_active);

-- Student 16
INSERT INTO students (student_id, uid, name, email, section, password_hash, department, semester, phone, is_active)
VALUES (16, '25IBD70002', 'AMAN KUMARI', '25IBD70002@cuchd.in', 'Future Skills & Innovation',
        '$2a$10$GuRrW8g/IkdPmFeW71UJOeIgj7pawHAUQh6b/IYv3CWOJikMNtjky', 'Integrated Big Data', 3, NULL, TRUE)
ON DUPLICATE KEY UPDATE 
    uid = VALUES(uid), name = VALUES(name), email = VALUES(email), 
    section = VALUES(section), password_hash = VALUES(password_hash),
    department = VALUES(department), is_active = VALUES(is_active);

-- Student 17
INSERT INTO students (student_id, uid, name, email, section, password_hash, department, semester, phone, is_active)
VALUES (17, '25BCY70007', 'SAKSHAM KAPATIA', '25BCY70007@cuchd.in', 'Future Skills & Innovation',
        '$2a$10$a46tYSE1CMGQYtU1rMiW5eWFz0gJmyG1Uiv/3tcVdJpJsSBmmj11S', 'Cybersecurity', 3, NULL, TRUE)
ON DUPLICATE KEY UPDATE 
    uid = VALUES(uid), name = VALUES(name), email = VALUES(email), 
    section = VALUES(section), password_hash = VALUES(password_hash),
    department = VALUES(department), is_active = VALUES(is_active);

-- Student 18
INSERT INTO students (student_id, uid, name, email, section, password_hash, department, semester, phone, is_active)
VALUES (18, '25BDA70014', 'SUKRIT SONI', '25BDA70014@cuchd.in', 'Future Skills & Innovation',
        '$2a$10$Ek2mjRh.LFO/3QAiPfvcGOAVcWEIbVdkiSuuUUBqo4hVI2ITQMTlu', 'Data Analytics', 3, NULL, TRUE)
ON DUPLICATE KEY UPDATE 
    uid = VALUES(uid), name = VALUES(name), email = VALUES(email), 
    section = VALUES(section), password_hash = VALUES(password_hash),
    department = VALUES(department), is_active = VALUES(is_active);

-- Student 19
INSERT INTO students (student_id, uid, name, email, section, password_hash, department, semester, phone, is_active)
VALUES (19, '25BAI70107', 'ABHICHAL VERMA', '25BAI70107@cuchd.in', 'Future Skills & Innovation',
        '$2a$10$85WZl580fF7vJin/uG5yIumVH5m22jjcB958f5gQKIAio/yet31la', 'Artificial Intelligence', 3, NULL, TRUE)
ON DUPLICATE KEY UPDATE 
    uid = VALUES(uid), name = VALUES(name), email = VALUES(email), 
    section = VALUES(section), password_hash = VALUES(password_hash),
    department = VALUES(department), is_active = VALUES(is_active);

-- Student 20
INSERT INTO students (student_id, uid, name, email, section, password_hash, department, semester, phone, is_active)
VALUES (20, '25BDA70106', 'ADARSH MANKOTIA', '25BDA70106@cuchd.in', 'Future Skills & Innovation',
        '$2a$10$D6X8JbFAqQyGPj6.//.M.eFDCOsaBkl7rdbSXj0xbLHhUPWpk16L2', 'Data Analytics', 3, NULL, TRUE)
ON DUPLICATE KEY UPDATE 
    uid = VALUES(uid), name = VALUES(name), email = VALUES(email), 
    section = VALUES(section), password_hash = VALUES(password_hash),
    department = VALUES(department), is_active = VALUES(is_active);

-- Clean up any residual demo student IDs above 20 (if complaints don't reference them)
DELETE FROM students WHERE student_id > 20;

COMMIT;

-- ── 3. Verification Queries ──────────────────────────────────
SELECT COUNT(*) AS total_students FROM students;
SELECT student_id, uid, name, email, section, department, is_active FROM students ORDER BY student_id ASC;
