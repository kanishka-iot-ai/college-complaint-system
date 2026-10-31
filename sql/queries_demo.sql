-- ============================================================
--  College Complaint Management System
--  Standalone Query Demonstration File
--  20+ Well-Commented SQL Queries
--  Run AFTER college_complaint_db.sql has been executed.
-- ============================================================

USE college_complaint_db;

-- ============================================================
--  SECTION 1 – BASIC SELECT QUERIES
-- ============================================================

-- Q1. List all students with their department and semester
-- Demonstrates: Simple SELECT, column aliasing
SELECT
    student_id,
    name          AS student_name,
    email,
    department,
    semester,
    phone,
    DATE(created_at) AS registered_on
FROM students
ORDER BY name ASC;

-- ──────────────────────────────────────────────────────────────

-- Q2. List all complaint categories
-- Demonstrates: Full table scan on a small lookup table
SELECT category_id, category_name, description
FROM   categories
ORDER  BY category_name ASC;

-- ──────────────────────────────────────────────────────────────

-- Q3. List all complaints ordered by priority (High first) then date
-- Demonstrates: ORDER BY with FIELD() for custom sort
SELECT
    complaint_id,
    title,
    priority,
    status,
    created_at
FROM complaints
ORDER BY
    FIELD(priority, 'High', 'Medium', 'Low'),
    created_at ASC;

-- ============================================================
--  SECTION 2 – WHERE CLAUSE FILTERING
-- ============================================================

-- Q4. Find all unresolved, high-priority complaints
-- Demonstrates: WHERE with AND, NOT IN
SELECT
    complaint_id,
    title,
    priority,
    status,
    assigned_department,
    created_at
FROM complaints
WHERE priority = 'High'
  AND status NOT IN ('Resolved', 'Rejected')
ORDER BY created_at ASC;

-- ──────────────────────────────────────────────────────────────

-- Q5. Find students from the CS or IT department in semester >= 3
-- Demonstrates: WHERE with IN, AND, comparison operator
SELECT
    student_id,
    name,
    department,
    semester
FROM students
WHERE department IN ('CS', 'IT')
  AND semester >= 3
ORDER BY department, semester;

-- ──────────────────────────────────────────────────────────────

-- Q6. Search complaints by keyword in title
-- Demonstrates: WHERE with LIKE (pattern matching)
SELECT complaint_id, title, status, priority
FROM   complaints
WHERE  title LIKE '%Wi-Fi%'
    OR title LIKE '%Internet%';

-- ──────────────────────────────────────────────────────────────

-- Q7. Complaints filed in the last 30 days
-- Demonstrates: WHERE with date arithmetic using NOW() / INTERVAL
SELECT complaint_id, title, status, created_at
FROM   complaints
WHERE  created_at >= NOW() - INTERVAL 30 DAY
ORDER  BY created_at DESC;

-- ============================================================
--  SECTION 3 – JOINS
-- ============================================================

-- Q8. Full complaint details using INNER JOIN across 3 tables
-- Demonstrates: Multi-table INNER JOIN, column aliasing
SELECT
    c.complaint_id,
    s.name              AS student_name,
    s.department,
    cat.category_name,
    c.title,
    c.priority,
    c.status,
    c.assigned_department,
    c.created_at
FROM complaints c
INNER JOIN students   s   ON c.student_id  = s.student_id
INNER JOIN categories cat ON c.category_id = cat.category_id
ORDER BY c.created_at DESC;

-- ──────────────────────────────────────────────────────────────

-- Q9. All complaints with resolution details (if resolved)
-- Demonstrates: LEFT JOIN — keeps unresolved complaints (NULL for resolution cols)
SELECT
    c.complaint_id,
    c.title,
    c.status,
    r.remarks          AS resolution_remarks,
    a.name             AS resolved_by,
    r.resolution_date
FROM complaints c
LEFT JOIN resolutions r ON c.complaint_id = r.complaint_id
LEFT JOIN admins      a ON r.admin_id     = a.admin_id
ORDER BY c.complaint_id;

-- ──────────────────────────────────────────────────────────────

-- Q10. All categories including those with zero complaints (RIGHT JOIN)
-- Demonstrates: RIGHT JOIN — ensures all categories appear even without complaints
SELECT
    cat.category_id,
    cat.category_name,
    COUNT(c.complaint_id) AS total_complaints
FROM complaints c
RIGHT JOIN categories cat ON c.category_id = cat.category_id
GROUP BY cat.category_id, cat.category_name
ORDER BY total_complaints DESC;

-- ──────────────────────────────────────────────────────────────

-- Q11. Complaint audit trail — history with admin names
-- Demonstrates: INNER JOIN on complaint_history, sorted timeline
SELECT
    ch.history_id,
    c.title               AS complaint_title,
    a.name                AS changed_by_admin,
    ch.old_status,
    ch.new_status,
    ch.remarks,
    ch.changed_at
FROM complaint_history ch
INNER JOIN complaints c ON ch.complaint_id = c.complaint_id
INNER JOIN admins     a ON ch.admin_id     = a.admin_id
ORDER BY ch.complaint_id, ch.changed_at ASC;

-- ============================================================
--  SECTION 4 – AGGREGATE FUNCTIONS & GROUP BY
-- ============================================================

-- Q12. Count complaints per status
-- Demonstrates: COUNT(*), GROUP BY, ORDER BY aggregate alias
SELECT
    status,
    COUNT(*) AS complaint_count
FROM complaints
GROUP BY status
ORDER BY complaint_count DESC;

-- ──────────────────────────────────────────────────────────────

-- Q13. Count complaints per student (most active complainants first)
-- Demonstrates: COUNT, GROUP BY, JOIN, ORDER BY
SELECT
    s.student_id,
    s.name           AS student_name,
    s.department,
    COUNT(c.complaint_id) AS total_complaints
FROM students s
LEFT JOIN complaints c ON s.student_id = c.student_id
GROUP BY s.student_id, s.name, s.department
ORDER BY total_complaints DESC;

-- ──────────────────────────────────────────────────────────────

-- Q14. Complaint pivot per category: total / resolved / pending
-- Demonstrates: Conditional aggregation with CASE WHEN inside SUM
SELECT
    cat.category_name,
    COUNT(c.complaint_id)                                      AS total,
    SUM(CASE WHEN c.status = 'Resolved'    THEN 1 ELSE 0 END) AS resolved,
    SUM(CASE WHEN c.status = 'Pending'     THEN 1 ELSE 0 END) AS pending,
    SUM(CASE WHEN c.status = 'In Progress' THEN 1 ELSE 0 END) AS in_progress,
    SUM(CASE WHEN c.status = 'Rejected'    THEN 1 ELSE 0 END) AS rejected
FROM categories cat
LEFT JOIN complaints c ON cat.category_id = c.category_id
GROUP BY cat.category_id, cat.category_name
ORDER BY total DESC;

-- ──────────────────────────────────────────────────────────────

-- Q15. Overall system statistics with aggregate functions
-- Demonstrates: COUNT, SUM, MIN, MAX, AVG (on numeric expression),
--               ROUND, DATEDIFF
SELECT
    COUNT(*)                                                             AS total_complaints,
    SUM(CASE WHEN status = 'Resolved' THEN 1 ELSE 0 END)               AS total_resolved,
    SUM(CASE WHEN priority = 'High'   THEN 1 ELSE 0 END)               AS high_priority,
    MIN(created_at)                                                      AS first_complaint_date,
    MAX(created_at)                                                      AS latest_complaint_date,
    ROUND(
        100.0 * SUM(CASE WHEN status = 'Resolved' THEN 1 ELSE 0 END)
              / COUNT(*), 2
    )                                                                    AS resolution_rate_pct
FROM complaints;

-- ============================================================
--  SECTION 5 – HAVING CLAUSE
-- ============================================================

-- Q16. Categories with more than zero complaints
-- Demonstrates: GROUP BY + HAVING filter on aggregate
SELECT
    cat.category_name,
    COUNT(c.complaint_id) AS total_complaints
FROM categories cat
INNER JOIN complaints c ON cat.category_id = c.category_id
GROUP BY cat.category_id, cat.category_name
HAVING COUNT(c.complaint_id) > 0
ORDER BY total_complaints DESC;

-- ──────────────────────────────────────────────────────────────

-- Q17. Departments (of students) that have > 1 complaint filed
-- Demonstrates: JOIN + GROUP BY + HAVING with threshold
SELECT
    s.department,
    COUNT(c.complaint_id) AS complaint_count
FROM students s
INNER JOIN complaints c ON s.student_id = c.student_id
GROUP BY s.department
HAVING COUNT(c.complaint_id) > 1
ORDER BY complaint_count DESC;

-- ============================================================
--  SECTION 6 – SUBQUERIES
-- ============================================================

-- Q18. Students who have filed at least one complaint
-- Demonstrates: WHERE … IN (subquery)
SELECT student_id, name, email, department, semester
FROM   students
WHERE  student_id IN (
    SELECT DISTINCT student_id
    FROM   complaints
)
ORDER BY name;

-- ──────────────────────────────────────────────────────────────

-- Q19. Complaints whose category has more than 1 complaint in total
-- Demonstrates: WHERE … IN (correlated-style subquery with GROUP BY / HAVING)
SELECT complaint_id, title, status, category_id
FROM   complaints
WHERE  category_id IN (
    SELECT category_id
    FROM   complaints
    GROUP  BY category_id
    HAVING COUNT(*) > 1
);

-- ──────────────────────────────────────────────────────────────

-- Q20. Find complaints that have NO resolution yet
-- Demonstrates: WHERE NOT EXISTS (correlated subquery)
SELECT
    c.complaint_id,
    c.title,
    c.status,
    c.priority
FROM complaints c
WHERE NOT EXISTS (
    SELECT 1
    FROM   resolutions r
    WHERE  r.complaint_id = c.complaint_id
)
ORDER BY c.priority DESC, c.created_at ASC;

-- ──────────────────────────────────────────────────────────────

-- Q21. Students with highest number of complaints using a derived table
-- Demonstrates: Subquery in FROM clause (derived table)
SELECT
    sub.student_id,
    s.name,
    s.department,
    sub.complaint_count
FROM (
    SELECT student_id, COUNT(*) AS complaint_count
    FROM   complaints
    GROUP  BY student_id
) AS sub
INNER JOIN students s ON sub.student_id = s.student_id
ORDER BY sub.complaint_count DESC
LIMIT 5;

-- ============================================================
--  SECTION 7 – VIEW QUERIES
-- ============================================================

-- Q22. Query the full complaint details view
-- Demonstrates: SELECT from a VIEW
SELECT
    complaint_id,
    title,
    student_name,
    category_name,
    priority,
    status,
    resolved_by_admin,
    resolution_date
FROM vw_complaint_details
ORDER BY complaint_id;

-- ──────────────────────────────────────────────────────────────

-- Q23. Query complaint statistics view — resolved vs total per category
SELECT
    category_name,
    total_complaints,
    resolved_count,
    ROUND(
        CASE WHEN total_complaints > 0
             THEN 100.0 * resolved_count / total_complaints
             ELSE 0 END, 2
    ) AS resolution_pct
FROM vw_complaint_statistics
ORDER BY total_complaints DESC;

-- ──────────────────────────────────────────────────────────────

-- Q24. Query per-student summary view
SELECT
    student_name,
    department,
    semester,
    total_complaints,
    pending,
    in_progress,
    resolved
FROM vw_student_complaint_summary
ORDER BY total_complaints DESC;

-- ============================================================
--  SECTION 8 – STRING & DATE FUNCTIONS
-- ============================================================

-- Q25. Show complaint age in days and a formatted date string
-- Demonstrates: DATEDIFF, DATE_FORMAT, CONCAT, string functions
SELECT
    complaint_id,
    UPPER(title)                                           AS title_upper,
    CONCAT(LEFT(description, 60), '...')                   AS description_preview,
    DATE_FORMAT(created_at, '%d-%b-%Y %H:%i')              AS formatted_date,
    DATEDIFF(NOW(), created_at)                            AS age_in_days,
    status
FROM complaints
ORDER BY age_in_days DESC;

-- ============================================================
--  END OF QUERIES DEMO FILE
-- ============================================================
