-- ============================================================
--  College Complaint Management System
--  Master Database Script
--  MySQL 8.x Compatible
--  Run: mysql -u root -p < college_complaint_db.sql
-- ============================================================

-- ── Database ─────────────────────────────────────────────────
CREATE DATABASE IF NOT EXISTS college_complaint_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE college_complaint_db;

-- ── Drop tables in FK-safe order ─────────────────────────────
DROP TABLE IF EXISTS complaint_history;
DROP TABLE IF EXISTS resolutions;
DROP TABLE IF EXISTS complaints;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS admins;
DROP TABLE IF EXISTS categories;

-- ─────────────────────────────────────────────────────────────
--  TABLE: students
-- ─────────────────────────────────────────────────────────────
CREATE TABLE students (
    student_id    INT            AUTO_INCREMENT PRIMARY KEY,
    name          VARCHAR(100)   NOT NULL,
    email         VARCHAR(150)   NOT NULL UNIQUE,
    password_hash VARCHAR(255)   NOT NULL,
    department    VARCHAR(100)   NOT NULL,
    semester      INT            NOT NULL CHECK (semester BETWEEN 1 AND 8),
    phone         VARCHAR(15),
    created_at    TIMESTAMP      DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_student_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ─────────────────────────────────────────────────────────────
--  TABLE: admins
-- ─────────────────────────────────────────────────────────────
CREATE TABLE admins (
    admin_id      INT            AUTO_INCREMENT PRIMARY KEY,
    name          VARCHAR(100)   NOT NULL,
    email         VARCHAR(150)   NOT NULL UNIQUE,
    password_hash VARCHAR(255)   NOT NULL,
    created_at    TIMESTAMP      DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ─────────────────────────────────────────────────────────────
--  TABLE: categories
-- ─────────────────────────────────────────────────────────────
CREATE TABLE categories (
    category_id   INT            AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50)    NOT NULL UNIQUE,
    description   VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ─────────────────────────────────────────────────────────────
--  TABLE: complaints
-- ─────────────────────────────────────────────────────────────
CREATE TABLE complaints (
    complaint_id        INT           AUTO_INCREMENT PRIMARY KEY,
    student_id          INT           NOT NULL,
    category_id         INT           NOT NULL,
    title               VARCHAR(200)  NOT NULL,
    description         TEXT          NOT NULL,
    priority            ENUM('Low','Medium','High')
                                      NOT NULL DEFAULT 'Medium',
    status              ENUM('Submitted','Pending','In Progress','Resolved','Rejected')
                                      NOT NULL DEFAULT 'Submitted',
    assigned_department VARCHAR(100),
    created_at          TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_complaints_student
        FOREIGN KEY (student_id)   REFERENCES students(student_id)   ON DELETE CASCADE,
    CONSTRAINT fk_complaints_category
        FOREIGN KEY (category_id)  REFERENCES categories(category_id),
    INDEX idx_complaint_student  (student_id),
    INDEX idx_complaint_category (category_id),
    INDEX idx_complaint_status   (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ─────────────────────────────────────────────────────────────
--  TABLE: resolutions
-- ─────────────────────────────────────────────────────────────
CREATE TABLE resolutions (
    resolution_id   INT       AUTO_INCREMENT PRIMARY KEY,
    complaint_id    INT       NOT NULL UNIQUE,
    admin_id        INT       NOT NULL,
    remarks         TEXT      NOT NULL,
    resolution_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_resolutions_complaint
        FOREIGN KEY (complaint_id) REFERENCES complaints(complaint_id) ON DELETE CASCADE,
    CONSTRAINT fk_resolutions_admin
        FOREIGN KEY (admin_id)     REFERENCES admins(admin_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ─────────────────────────────────────────────────────────────
--  TABLE: complaint_history
-- ─────────────────────────────────────────────────────────────
CREATE TABLE complaint_history (
    history_id   INT         AUTO_INCREMENT PRIMARY KEY,
    complaint_id INT         NOT NULL,
    admin_id     INT         NOT NULL,
    old_status   VARCHAR(50),
    new_status   VARCHAR(50) NOT NULL,
    remarks      TEXT,
    changed_at   TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_history_complaint
        FOREIGN KEY (complaint_id) REFERENCES complaints(complaint_id) ON DELETE CASCADE,
    CONSTRAINT fk_history_admin
        FOREIGN KEY (admin_id)     REFERENCES admins(admin_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
--  SEED DATA
-- ============================================================

-- ── Categories (11) ──────────────────────────────────────────
INSERT INTO categories (category_name, description) VALUES
    ('Classroom',     'Issues related to classrooms, seating, and teaching aids'),
    ('Laboratory',    'Issues related to labs, equipment, and lab safety'),
    ('Library',       'Issues related to library resources and facilities'),
    ('Hostel',        'Issues related to hostel accommodation and amenities'),
    ('Washroom',      'Issues related to washroom cleanliness and maintenance'),
    ('Electricity',   'Issues related to power supply and electrical faults'),
    ('Water Supply',  'Issues related to drinking water and water availability'),
    ('Internet',      'Issues related to campus Wi-Fi and LAN connectivity'),
    ('Faculty',       'Issues related to faculty conduct and teaching quality'),
    ('Canteen',       'Issues related to canteen food quality and hygiene'),
    ('Other',         'Miscellaneous issues not covered by other categories');

-- ── Admins (2) ───────────────────────────────────────────────
-- Passwords are BCrypt hashes (cost=10).
--   Admin@123 → $2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LzTFONlAWnO
--   Dept@123  → $2a$10$P5IQnE.RuNPKi2H0kR.7XOhLAtFEQGj8d5u7cXEiENF2Qz7J.VB7S
INSERT INTO admins (name, email, password_hash) VALUES
    ('Super Admin',      'admin@college.edu',
     '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LzTFONlAWnO'),
    ('Department Admin', 'dept@college.edu',
     '$2a$10$P5IQnE.RuNPKi2H0kR.7XOhLAtFEQGj8d5u7cXEiENF2Qz7J.VB7S');

-- ── Students (5) ─────────────────────────────────────────────
-- All passwords = Student@123
-- BCrypt hash: $2a$10$eCEOBEQNcW.3TLEflvENj.QHqPvMb0N1P.7IqIDGz8KSU.6FkRfIq
INSERT INTO students (name, email, password_hash, department, semester, phone) VALUES
    ('Rahul Sharma', 'rahul@student.edu',
     '$2a$10$eCEOBEQNcW.3TLEflvENj.QHqPvMb0N1P.7IqIDGz8KSU.6FkRfIq',
     'CS',    5, '9876543210'),
    ('Priya Patel',  'priya@student.edu',
     '$2a$10$eCEOBEQNcW.3TLEflvENj.QHqPvMb0N1P.7IqIDGz8KSU.6FkRfIq',
     'IT',    3, '9876543211'),
    ('Arjun Singh',  'arjun@student.edu',
     '$2a$10$eCEOBEQNcW.3TLEflvENj.QHqPvMb0N1P.7IqIDGz8KSU.6FkRfIq',
     'ECE',   6, '9876543212'),
    ('Neha Verma',   'neha@student.edu',
     '$2a$10$eCEOBEQNcW.3TLEflvENj.QHqPvMb0N1P.7IqIDGz8KSU.6FkRfIq',
     'MECH',  2, '9876543213'),
    ('Rohan Kumar',  'rohan@student.edu',
     '$2a$10$eCEOBEQNcW.3TLEflvENj.QHqPvMb0N1P.7IqIDGz8KSU.6FkRfIq',
     'CIVIL', 7, '9876543214');

-- ── Complaints (8) ───────────────────────────────────────────
-- category IDs:  1=Classroom 2=Lab 3=Library 4=Hostel 5=Washroom
--                6=Electricity 7=Water 8=Internet 9=Faculty 10=Canteen 11=Other
-- student IDs:   1=Rahul 2=Priya 3=Arjun 4=Neha 5=Rohan
INSERT INTO complaints
    (student_id, category_id, title, description, priority, status, assigned_department)
VALUES
    -- 1. Resolved
    (1, 8, 'Wi-Fi not working in Block-C',
     'The Wi-Fi access points in Block-C have been non-functional for the past three days, severely affecting online assignments.',
     'High', 'Resolved', 'IT Department'),

    -- 2. In Progress
    (2, 1, 'Projector malfunction in Room 204',
     'The projector in Classroom 204 flickers continuously and often loses signal during lectures.',
     'Medium', 'In Progress', 'Maintenance Department'),

    -- 3. Pending
    (3, 6, 'Power outage in ECE lab every evening',
     'The ECE laboratory experiences a power trip every evening around 5 PM, causing loss of lab work.',
     'High', 'Pending', 'Electrical Department'),

    -- 4. Resolved
    (4, 7, 'No drinking water on 3rd floor',
     'The water cooler on the 3rd floor of the MECH block has been out of order for two weeks.',
     'Medium', 'Resolved', 'Maintenance Department'),

    -- 5. Submitted
    (5, 4, 'Hostel room roof leaking during rain',
     'Room 312 in Boys Hostel has a cracked roof that leaks during rain, damaging belongings and making the room unusable.',
     'High', 'Submitted', NULL),

    -- 6. Rejected
    (1, 10, 'Canteen food quality is very poor',
     'The canteen serves stale food items and the hygiene standards have dropped significantly over the last month.',
     'Low', 'Rejected', 'Canteen Committee'),

    -- 7. Pending
    (2, 5, 'Washrooms near Library not cleaned regularly',
     'The washrooms adjacent to the library are not cleaned daily, causing unhygienic conditions.',
     'Medium', 'Pending', 'Housekeeping Department'),

    -- 8. In Progress
    (3, 9, 'Faculty repeatedly absent without prior notice',
     'The Data Structures faculty has been absent for four consecutive classes without informing students or arranging a substitute.',
     'High', 'In Progress', 'Academic Department');

-- ── Resolutions (2) ──────────────────────────────────────────
-- Resolve complaints 1 and 4 (which have status = 'Resolved')
INSERT INTO resolutions (complaint_id, admin_id, remarks) VALUES
    (1, 1, 'All Wi-Fi access points in Block-C have been replaced and tested. Connectivity restored as of today.'),
    (4, 2, 'Water cooler on the 3rd floor repaired and refilled. Regular maintenance schedule added to the checklist.');

-- ── Complaint History ─────────────────────────────────────────
INSERT INTO complaint_history
    (complaint_id, admin_id, old_status, new_status, remarks)
VALUES
    -- Complaint 1: Submitted → Pending → In Progress → Resolved
    (1, 1, 'Submitted',   'Pending',     'Complaint received and assigned to IT Department.'),
    (1, 1, 'Pending',     'In Progress', 'IT team dispatched to Block-C to investigate.'),
    (1, 1, 'In Progress', 'Resolved',    'Access points replaced; issue fully resolved.'),

    -- Complaint 2: Submitted → In Progress
    (2, 2, 'Submitted',   'Pending',     'Logged and forwarded to Maintenance.'),
    (2, 2, 'Pending',     'In Progress', 'Maintenance team scheduled projector replacement for next week.'),

    -- Complaint 3: Submitted → Pending
    (3, 1, 'Submitted',   'Pending',     'Forwarded to Electrical Department for inspection.'),

    -- Complaint 4: Submitted → Pending → Resolved
    (4, 2, 'Submitted',   'Pending',     'Maintenance team informed.'),
    (4, 2, 'Pending',     'Resolved',    'Water cooler repaired and operational.'),

    -- Complaint 6: Submitted → Rejected
    (6, 1, 'Submitted',   'Rejected',    'Complaint reviewed; canteen follows approved menu and hygiene standards. Rejected after inspection.'),

    -- Complaint 7: Submitted → Pending
    (7, 2, 'Submitted',   'Pending',     'Housekeeping supervisor notified; monitoring in progress.'),

    -- Complaint 8: Submitted → Pending → In Progress
    (8, 1, 'Submitted',   'Pending',     'Forwarded to Academic Department for review.'),
    (8, 1, 'Pending',     'In Progress', 'HOD contacted; substitute faculty arrangements under way.');

-- ============================================================
--  VIEWS
-- ============================================================

-- ── View 1: Full complaint details ───────────────────────────
CREATE OR REPLACE VIEW vw_complaint_details AS
SELECT
    c.complaint_id,
    c.title,
    c.description                        AS complaint_description,
    c.priority,
    c.status,
    c.assigned_department,
    c.created_at                         AS complaint_created_at,
    c.updated_at                         AS complaint_updated_at,
    s.student_id,
    s.name                               AS student_name,
    s.email                              AS student_email,
    s.department                         AS student_department,
    s.semester,
    cat.category_id,
    cat.category_name,
    r.resolution_id,
    r.remarks                            AS resolution_remarks,
    r.resolution_date,
    a.name                               AS resolved_by_admin
FROM complaints c
INNER JOIN students   s   ON c.student_id   = s.student_id
INNER JOIN categories cat ON c.category_id  = cat.category_id
LEFT  JOIN resolutions r  ON c.complaint_id = r.complaint_id
LEFT  JOIN admins      a  ON r.admin_id     = a.admin_id;

-- ── View 2: Complaint statistics per category ─────────────────
CREATE OR REPLACE VIEW vw_complaint_statistics AS
SELECT
    cat.category_name,
    COUNT(c.complaint_id)                                        AS total_complaints,
    SUM(CASE WHEN c.status = 'Resolved'    THEN 1 ELSE 0 END)   AS resolved_count,
    SUM(CASE WHEN c.status = 'Pending'     THEN 1 ELSE 0 END)   AS pending_count,
    SUM(CASE WHEN c.status = 'In Progress' THEN 1 ELSE 0 END)   AS in_progress_count,
    SUM(CASE WHEN c.status = 'Submitted'   THEN 1 ELSE 0 END)   AS submitted_count,
    SUM(CASE WHEN c.status = 'Rejected'    THEN 1 ELSE 0 END)   AS rejected_count
FROM categories cat
LEFT JOIN complaints c ON cat.category_id = c.category_id
GROUP BY cat.category_id, cat.category_name;

-- ── View 3: Per-student complaint summary ─────────────────────
CREATE OR REPLACE VIEW vw_student_complaint_summary AS
SELECT
    s.student_id,
    s.name                                                       AS student_name,
    s.department,
    s.semester,
    COUNT(c.complaint_id)                                        AS total_complaints,
    SUM(CASE WHEN c.status = 'Submitted'   THEN 1 ELSE 0 END)   AS submitted,
    SUM(CASE WHEN c.status = 'Pending'     THEN 1 ELSE 0 END)   AS pending,
    SUM(CASE WHEN c.status = 'In Progress' THEN 1 ELSE 0 END)   AS in_progress,
    SUM(CASE WHEN c.status = 'Resolved'    THEN 1 ELSE 0 END)   AS resolved,
    SUM(CASE WHEN c.status = 'Rejected'    THEN 1 ELSE 0 END)   AS rejected
FROM students s
LEFT JOIN complaints c ON s.student_id = c.student_id
GROUP BY s.student_id, s.name, s.department, s.semester;

-- ============================================================
--  DEMONSTRATION QUERIES  (read-only, no data modification)
-- ============================================================

-- ── SELECT with WHERE ─────────────────────────────────────────
-- All high-priority complaints that are still open
SELECT complaint_id, title, status, priority, created_at
FROM   complaints
WHERE  priority = 'High'
  AND  status   NOT IN ('Resolved', 'Rejected')
ORDER  BY created_at ASC;

-- ── SELECT with ORDER BY ──────────────────────────────────────
-- All students ordered by department then semester
SELECT student_id, name, department, semester
FROM   students
ORDER  BY department ASC, semester ASC;

-- ── SELECT with GROUP BY ──────────────────────────────────────
-- Number of complaints submitted per department (student dept)
SELECT s.department, COUNT(c.complaint_id) AS complaint_count
FROM   students s
JOIN   complaints c ON s.student_id = c.student_id
GROUP  BY s.department;

-- ── SELECT with GROUP BY + HAVING ────────────────────────────
-- Departments with more than 1 complaint
SELECT s.department, COUNT(c.complaint_id) AS complaint_count
FROM   students s
JOIN   complaints c ON s.student_id = c.student_id
GROUP  BY s.department
HAVING COUNT(c.complaint_id) > 1;

-- ── INNER JOIN ────────────────────────────────────────────────
-- Complaints with their category names and student names
SELECT c.complaint_id,
       c.title,
       s.name  AS student_name,
       cat.category_name,
       c.status
FROM   complaints c
INNER  JOIN students   s   ON c.student_id  = s.student_id
INNER  JOIN categories cat ON c.category_id = cat.category_id;

-- ── LEFT JOIN ─────────────────────────────────────────────────
-- All complaints with resolution details (NULL if not yet resolved)
SELECT c.complaint_id,
       c.title,
       c.status,
       r.remarks        AS resolution_remarks,
       r.resolution_date
FROM   complaints c
LEFT   JOIN resolutions r ON c.complaint_id = r.complaint_id;

-- ── RIGHT JOIN ────────────────────────────────────────────────
-- All categories including those with zero complaints
SELECT cat.category_name,
       COUNT(c.complaint_id) AS total_complaints
FROM   complaints c
RIGHT  JOIN categories cat ON c.category_id = cat.category_id
GROUP  BY cat.category_id, cat.category_name;

-- ── Subquery example ─────────────────────────────────────────
-- Students who have filed at least one High-priority complaint
SELECT student_id, name, email, department
FROM   students
WHERE  student_id IN (
    SELECT DISTINCT student_id
    FROM   complaints
    WHERE  priority = 'High'
);

-- ── Aggregate functions ───────────────────────────────────────
-- Overall complaint statistics
SELECT
    COUNT(*)                                                       AS total_complaints,
    SUM(CASE WHEN status = 'Resolved'    THEN 1 ELSE 0 END)       AS resolved,
    SUM(CASE WHEN status = 'Pending'     THEN 1 ELSE 0 END)       AS pending,
    SUM(CASE WHEN status = 'In Progress' THEN 1 ELSE 0 END)       AS in_progress,
    SUM(CASE WHEN status = 'Submitted'   THEN 1 ELSE 0 END)       AS submitted,
    SUM(CASE WHEN status = 'Rejected'    THEN 1 ELSE 0 END)       AS rejected,
    ROUND(
        100.0 * SUM(CASE WHEN status = 'Resolved' THEN 1 ELSE 0 END)
              / COUNT(*), 2
    )                                                              AS resolution_rate_pct
FROM complaints;
