package com.college.complaint.dao;

import com.college.complaint.model.Complaint;
import com.college.complaint.model.Resolution;
import com.college.complaint.model.ComplaintHistory;
import com.college.complaint.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Data Access Object for {@link Complaint} entities.
 * Handles all complaint-related database operations including
 * submission, retrieval (with filters), status updates, and dashboard statistics.
 */
public class ComplaintDAO {

    // -------------------------------------------------------------------------
    // Helper: map a ResultSet row to a Complaint object
    // Assumes the query always selects c.* plus optional join columns.
    // -------------------------------------------------------------------------
    private Complaint mapRow(ResultSet rs) throws SQLException {
        Complaint c = new Complaint();
        c.setComplaintId(rs.getInt("complaint_id"));
        c.setStudentId(rs.getInt("student_id"));
        c.setCategoryId(rs.getInt("category_id"));
        c.setTitle(rs.getString("title"));
        c.setDescription(rs.getString("description"));
        c.setPriority(rs.getString("priority"));
        c.setStatus(rs.getString("status"));
        c.setAssignedDepartment(rs.getString("assigned_department"));
        c.setCreatedAt(rs.getTimestamp("created_at"));
        c.setUpdatedAt(rs.getTimestamp("updated_at"));
        return c;
    }

    // -------------------------------------------------------------------------
    // submitComplaint
    // -------------------------------------------------------------------------

    /**
     * Inserts a new complaint into the database.
     * The initial status is set to 'Submitted'.
     *
     * @param c the complaint to persist
     * @return {@code true} if the row was inserted successfully
     * @throws SQLException on database error
     */
    public boolean submitComplaint(Complaint c) throws SQLException {
        String sql = "INSERT INTO complaints " +
                     "(student_id, category_id, title, description, priority, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, c.getStudentId());
            ps.setInt(2, c.getCategoryId());
            ps.setString(3, c.getTitle());
            ps.setString(4, c.getDescription());
            ps.setString(5, c.getPriority());
            ps.setString(6, c.getStatus() != null ? c.getStatus() : "Submitted");
            return ps.executeUpdate() > 0;
        } finally {
            DBConnection.closeResources(conn, ps, null);
        }
    }

    // -------------------------------------------------------------------------
    // getComplaintsByStudentId
    // -------------------------------------------------------------------------

    /**
     * Returns all complaints filed by a specific student, newest first.
     * Includes the category name via a JOIN.
     *
     * @param studentId the student's ID
     * @return ordered list of the student's complaints
     * @throws SQLException on database error
     */
    public List<Complaint> getComplaintsByStudentId(int studentId) throws SQLException {
        String sql = "SELECT c.*, cat.category_name " +
                     "FROM complaints c " +
                     "JOIN categories cat ON c.category_id = cat.category_id " +
                     "WHERE c.student_id = ? " +
                     "ORDER BY c.created_at DESC";
        List<Complaint> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, studentId);
            rs = ps.executeQuery();
            while (rs.next()) {
                Complaint complaint = mapRow(rs);
                complaint.setCategoryName(rs.getString("category_name"));
                list.add(complaint);
            }
        } finally {
            DBConnection.closeResources(conn, ps, rs);
        }
        return list;
    }

    // -------------------------------------------------------------------------
    // getComplaintById
    // -------------------------------------------------------------------------

    /**
     * Fetches a single complaint by its primary key.
     * Includes both student name and category name via JOINs.
     *
     * @param complaintId the complaint ID
     * @return the matching {@link Complaint}, or {@code null} if not found
     * @throws SQLException on database error
     */
    public Complaint getComplaintById(int complaintId) throws SQLException {
        String sql = "SELECT c.*, s.name AS student_name, cat.category_name " +
                     "FROM complaints c " +
                     "JOIN students s ON c.student_id = s.student_id " +
                     "JOIN categories cat ON c.category_id = cat.category_id " +
                     "WHERE c.complaint_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, complaintId);
            rs = ps.executeQuery();
            if (rs.next()) {
                Complaint complaint = mapRow(rs);
                complaint.setStudentName(rs.getString("student_name"));
                complaint.setCategoryName(rs.getString("category_name"));
                return complaint;
            }
            return null;
        } finally {
            DBConnection.closeResources(conn, ps, rs);
        }
    }

    // -------------------------------------------------------------------------
    // getAllComplaints
    // -------------------------------------------------------------------------

    /**
     * Returns all complaints in the system, newest first.
     * Includes student name and category name via JOINs.
     *
     * @return list of all complaints
     * @throws SQLException on database error
     */
    public List<Complaint> getAllComplaints() throws SQLException {
        String sql = "SELECT c.*, s.name AS student_name, cat.category_name " +
                     "FROM complaints c " +
                     "JOIN students s ON c.student_id = s.student_id " +
                     "JOIN categories cat ON c.category_id = cat.category_id " +
                     "ORDER BY c.created_at DESC";
        List<Complaint> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Complaint complaint = mapRow(rs);
                complaint.setStudentName(rs.getString("student_name"));
                complaint.setCategoryName(rs.getString("category_name"));
                list.add(complaint);
            }
        } finally {
            DBConnection.closeResources(conn, ps, rs);
        }
        return list;
    }

    // -------------------------------------------------------------------------
    // getAllComplaintsFiltered
    // -------------------------------------------------------------------------

    /**
     * Returns complaints that match the given optional filters.
     * Any filter that is {@code null} or blank is ignored.
     * The {@code search} parameter is applied against complaint title and description.
     *
     * @param status   filter by status (exact match)
     * @param priority filter by priority (exact match)
     * @param category filter by category name (exact match)
     * @param search   free-text search against title / description
     * @return filtered list of complaints, newest first
     * @throws SQLException on database error
     */
    public List<Complaint> getAllComplaintsFiltered(String status, String priority,
                                                    String category, String search)
            throws SQLException {

        StringBuilder sql = new StringBuilder(
                "SELECT c.*, s.name AS student_name, cat.category_name " +
                "FROM complaints c " +
                "JOIN students s ON c.student_id = s.student_id " +
                "JOIN categories cat ON c.category_id = cat.category_id " +
                "WHERE 1 = 1 ");

        List<Object> params = new ArrayList<>();

        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND c.status = ? ");
            params.add(status.trim());
        }
        if (priority != null && !priority.trim().isEmpty()) {
            sql.append("AND c.priority = ? ");
            params.add(priority.trim());
        }
        if (category != null && !category.trim().isEmpty()) {
            sql.append("AND cat.category_name = ? ");
            params.add(category.trim());
        }
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (c.title LIKE ? OR c.description LIKE ?) ");
            String likeVal = "%" + search.trim() + "%";
            params.add(likeVal);
            params.add(likeVal);
        }

        sql.append("ORDER BY c.created_at DESC");

        List<Complaint> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            rs = ps.executeQuery();
            while (rs.next()) {
                Complaint complaint = mapRow(rs);
                complaint.setStudentName(rs.getString("student_name"));
                complaint.setCategoryName(rs.getString("category_name"));
                list.add(complaint);
            }
        } finally {
            DBConnection.closeResources(conn, ps, rs);
        }
        return list;
    }

    // -------------------------------------------------------------------------
    // updateComplaintStatus
    // -------------------------------------------------------------------------

    /**
     * Updates the status of a complaint using a database transaction.
     * <ol>
     *   <li>Reads the current (old) status.</li>
     *   <li>Updates the complaints table.</li>
     *   <li>Inserts a history record.</li>
     *   <li>If the new status is {@code "Resolved"}, inserts or updates the
     *       resolution record.</li>
     *   <li>Commits on success; rolls back on any failure.</li>
     * </ol>
     *
     * @param complaintId    the complaint to update
     * @param newStatus      the new status value
     * @param assignedDept   the department now handling the complaint (may be null)
     * @param remarks        admin remarks for the history/resolution record
     * @param adminId        the admin performing the update
     * @return {@code true} if the transaction completed successfully
     * @throws SQLException on database error
     */
    public boolean updateComplaintStatus(int complaintId, String newStatus,
                                         String assignedDept, String remarks,
                                         int adminId) throws SQLException {

        Connection conn = null;
        PreparedStatement psRead   = null;
        PreparedStatement psUpdate = null;
        PreparedStatement psHist   = null;
        PreparedStatement psRes    = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // --- Step 1: Read old status ---
            psRead = conn.prepareStatement(
                    "SELECT status FROM complaints WHERE complaint_id = ?");
            psRead.setInt(1, complaintId);
            rs = psRead.executeQuery();
            String oldStatus = "Unknown";
            if (rs.next()) {
                oldStatus = rs.getString("status");
            }
            rs.close();
            rs = null;
            psRead.close();
            psRead = null;

            // --- Step 2: Update complaint ---
            psUpdate = conn.prepareStatement(
                    "UPDATE complaints " +
                    "SET status = ?, assigned_department = ?, updated_at = NOW() " +
                    "WHERE complaint_id = ?");
            psUpdate.setString(1, newStatus);
            psUpdate.setString(2, assignedDept);
            psUpdate.setInt(3, complaintId);
            psUpdate.executeUpdate();

            // --- Step 3: Insert history record ---
            psHist = conn.prepareStatement(
                    "INSERT INTO complaint_history " +
                    "(complaint_id, admin_id, old_status, new_status, remarks) " +
                    "VALUES (?, ?, ?, ?, ?)");
            psHist.setInt(1, complaintId);
            psHist.setInt(2, adminId);
            psHist.setString(3, oldStatus);
            psHist.setString(4, newStatus);
            psHist.setString(5, remarks);
            psHist.executeUpdate();

            // --- Step 4: If resolved, upsert resolution ---
            if ("Resolved".equalsIgnoreCase(newStatus)) {
                psRes = conn.prepareStatement(
                        "INSERT INTO resolutions (complaint_id, admin_id, remarks, resolution_date) " +
                        "VALUES (?, ?, ?, NOW()) " +
                        "ON DUPLICATE KEY UPDATE " +
                        "admin_id = VALUES(admin_id), " +
                        "remarks = VALUES(remarks), " +
                        "resolution_date = NOW()");
                psRes.setInt(1, complaintId);
                psRes.setInt(2, adminId);
                psRes.setString(3, remarks);
                psRes.executeUpdate();
            }

            conn.commit();
            return true;

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException rollbackEx) {
                    System.err.println("[ComplaintDAO] Rollback failed: " + rollbackEx.getMessage());
                }
            }
            throw e;
        } finally {
            if (rs     != null) { try { rs.close();      } catch (SQLException ignore) {} }
            if (psRead != null) { try { psRead.close();  } catch (SQLException ignore) {} }
            if (psUpdate != null) { try { psUpdate.close(); } catch (SQLException ignore) {} }
            if (psHist != null) { try { psHist.close();  } catch (SQLException ignore) {} }
            if (psRes  != null) { try { psRes.close();   } catch (SQLException ignore) {} }
            if (conn   != null) {
                try { conn.setAutoCommit(true); } catch (SQLException ignore) {}
                try { conn.close();             } catch (SQLException ignore) {}
            }
        }
    }

    // -------------------------------------------------------------------------
    // getComplaintCountByStatus
    // -------------------------------------------------------------------------

    /**
     * Returns the number of complaints matching the given status.
     *
     * @param status the status to count (e.g., "Submitted", "Resolved")
     * @return the count
     * @throws SQLException on database error
     */
    public int getComplaintCountByStatus(String status) throws SQLException {
        String sql = "SELECT COUNT(*) FROM complaints WHERE status = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        } finally {
            DBConnection.closeResources(conn, ps, rs);
        }
    }

    // -------------------------------------------------------------------------
    // getDashboardStats
    // -------------------------------------------------------------------------

    /**
     * Aggregates complaint counts for the admin dashboard.
     *
     * @return a map with keys: {@code total}, {@code submitted}, {@code pending},
     *         {@code inProgress}, {@code resolved}, {@code rejected}
     * @throws SQLException on database error
     */
    public Map<String, Integer> getDashboardStats() throws SQLException {
        String sql = "SELECT " +
                     "COUNT(*) AS total, " +
                     "SUM(CASE WHEN status = 'Submitted'   THEN 1 ELSE 0 END) AS submitted, " +
                     "SUM(CASE WHEN status = 'Pending'     THEN 1 ELSE 0 END) AS pending, " +
                     "SUM(CASE WHEN status = 'In Progress' THEN 1 ELSE 0 END) AS inProgress, " +
                     "SUM(CASE WHEN status = 'Resolved'    THEN 1 ELSE 0 END) AS resolved, " +
                     "SUM(CASE WHEN status = 'Rejected'    THEN 1 ELSE 0 END) AS rejected " +
                     "FROM complaints";
        Map<String, Integer> stats = new HashMap<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) {
                stats.put("total",      rs.getInt("total"));
                stats.put("submitted",  rs.getInt("submitted"));
                stats.put("pending",    rs.getInt("pending"));
                stats.put("inProgress", rs.getInt("inProgress"));
                stats.put("resolved",   rs.getInt("resolved"));
                stats.put("rejected",   rs.getInt("rejected"));
            } else {
                stats.put("total", 0);
                stats.put("submitted", 0);
                stats.put("pending", 0);
                stats.put("inProgress", 0);
                stats.put("resolved", 0);
                stats.put("rejected", 0);
            }
        } finally {
            DBConnection.closeResources(conn, ps, rs);
        }
        return stats;
    }

    // -------------------------------------------------------------------------
    // getStudentDashboardStats
    // -------------------------------------------------------------------------

    /**
     * Aggregates complaint counts for a specific student's dashboard.
     *
     * @param studentId the student's ID
     * @return a map with keys: {@code total}, {@code submitted}, {@code pending},
     *         {@code inProgress}, {@code resolved}, {@code rejected}
     * @throws SQLException on database error
     */
    public Map<String, Integer> getStudentDashboardStats(int studentId) throws SQLException {
        String sql = "SELECT " +
                     "COUNT(*) AS total, " +
                     "SUM(CASE WHEN status = 'Submitted'   THEN 1 ELSE 0 END) AS submitted, " +
                     "SUM(CASE WHEN status = 'Pending'     THEN 1 ELSE 0 END) AS pending, " +
                     "SUM(CASE WHEN status = 'In Progress' THEN 1 ELSE 0 END) AS inProgress, " +
                     "SUM(CASE WHEN status = 'Resolved'    THEN 1 ELSE 0 END) AS resolved, " +
                     "SUM(CASE WHEN status = 'Rejected'    THEN 1 ELSE 0 END) AS rejected " +
                     "FROM complaints WHERE student_id = ?";
        Map<String, Integer> stats = new HashMap<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, studentId);
            rs = ps.executeQuery();
            if (rs.next()) {
                stats.put("total",      rs.getInt("total"));
                stats.put("submitted",  rs.getInt("submitted"));
                stats.put("pending",    rs.getInt("pending"));
                stats.put("inProgress", rs.getInt("inProgress"));
                stats.put("resolved",   rs.getInt("resolved"));
                stats.put("rejected",   rs.getInt("rejected"));
            } else {
                stats.put("total", 0);
                stats.put("submitted", 0);
                stats.put("pending", 0);
                stats.put("inProgress", 0);
                stats.put("resolved", 0);
                stats.put("rejected", 0);
            }
        } finally {
            DBConnection.closeResources(conn, ps, rs);
        }
        return stats;
    }

    // -------------------------------------------------------------------------
    // getCategoryStats
    // -------------------------------------------------------------------------

    /**
     * Returns complaint counts grouped by category.
     * Each element in the list is an {@code Object[]} of the form
     * {@code [categoryName (String), count (Long)]}.
     *
     * @return list of [categoryName, count] pairs, ordered by count descending
     * @throws SQLException on database error
     */
    public List<Object[]> getCategoryStats() throws SQLException {
        String sql = "SELECT cat.category_name, COUNT(c.complaint_id) AS cnt " +
                     "FROM categories cat " +
                     "LEFT JOIN complaints c ON cat.category_id = c.category_id " +
                     "GROUP BY cat.category_id, cat.category_name " +
                     "ORDER BY cnt DESC";
        List<Object[]> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Object[]{rs.getString("category_name"), rs.getLong("cnt")});
            }
        } finally {
            DBConnection.closeResources(conn, ps, rs);
        }
        return list;
    }

    // -------------------------------------------------------------------------
    // getRecentComplaints
    // -------------------------------------------------------------------------

    /**
     * Returns the most recent complaints system-wide, limited to {@code limit} rows.
     * Includes student name and category name via JOINs.
     *
     * @param limit the maximum number of complaints to return
     * @return list of recent complaints
     * @throws SQLException on database error
     */
    public List<Complaint> getRecentComplaints(int limit) throws SQLException {
        String sql = "SELECT c.*, s.name AS student_name, cat.category_name " +
                     "FROM complaints c " +
                     "JOIN students s ON c.student_id = s.student_id " +
                     "JOIN categories cat ON c.category_id = cat.category_id " +
                     "ORDER BY c.created_at DESC " +
                     "LIMIT ?";
        List<Complaint> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, limit);
            rs = ps.executeQuery();
            while (rs.next()) {
                Complaint complaint = mapRow(rs);
                complaint.setStudentName(rs.getString("student_name"));
                complaint.setCategoryName(rs.getString("category_name"));
                list.add(complaint);
            }
        } finally {
            DBConnection.closeResources(conn, ps, rs);
        }
        return list;
    }

    // -------------------------------------------------------------------------
    // getRecentComplaintsByStudent
    // -------------------------------------------------------------------------

    /**
     * Returns the most recent complaints for a specific student,
     * limited to {@code limit} rows. Includes category name via a JOIN.
     *
     * @param studentId the student's ID
     * @param limit     the maximum number of complaints to return
     * @return list of recent complaints for the student
     * @throws SQLException on database error
     */
    public List<Complaint> getRecentComplaintsByStudent(int studentId, int limit)
            throws SQLException {
        String sql = "SELECT c.*, cat.category_name " +
                     "FROM complaints c " +
                     "JOIN categories cat ON c.category_id = cat.category_id " +
                     "WHERE c.student_id = ? " +
                     "ORDER BY c.created_at DESC " +
                     "LIMIT ?";
        List<Complaint> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, studentId);
            ps.setInt(2, limit);
            rs = ps.executeQuery();
            while (rs.next()) {
                Complaint complaint = mapRow(rs);
                complaint.setCategoryName(rs.getString("category_name"));
                list.add(complaint);
            }
        } finally {
            DBConnection.closeResources(conn, ps, rs);
        }
        return list;
    }

    // -------------------------------------------------------------------------
    // Delegation methods for Resolution and ComplaintHistory
    // -------------------------------------------------------------------------

    public Resolution getResolutionByComplaintId(int complaintId) throws SQLException {
        return new ResolutionDAO().getResolutionByComplaintId(complaintId);
    }

    public List<ComplaintHistory> getComplaintHistory(int complaintId) throws SQLException {
        return new ComplaintHistoryDAO().getHistoryByComplaintId(complaintId);
    }
}
