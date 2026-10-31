package com.college.complaint.dao;

import com.college.complaint.model.ComplaintHistory;
import com.college.complaint.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for {@link ComplaintHistory} entities.
 */
public class ComplaintHistoryDAO {

    // -------------------------------------------------------------------------
    // Helper: map a ResultSet row to a ComplaintHistory object
    // -------------------------------------------------------------------------
    private ComplaintHistory mapRow(ResultSet rs) throws SQLException {
        ComplaintHistory h = new ComplaintHistory();
        h.setHistoryId(rs.getInt("history_id"));
        h.setComplaintId(rs.getInt("complaint_id"));
        h.setAdminId(rs.getInt("admin_id"));
        h.setOldStatus(rs.getString("old_status"));
        h.setNewStatus(rs.getString("new_status"));
        h.setRemarks(rs.getString("remarks"));
        h.setChangedAt(rs.getTimestamp("changed_at"));
        return h;
    }

    // -------------------------------------------------------------------------
    // getHistoryByComplaintId
    // -------------------------------------------------------------------------

    /**
     * Returns the full status-change history for a complaint, newest entry first.
     * Includes the admin's name via a JOIN.
     *
     * @param complaintId the complaint whose history is requested
     * @return ordered list of history entries (may be empty)
     * @throws SQLException on database error
     */
    public List<ComplaintHistory> getHistoryByComplaintId(int complaintId) throws SQLException {
        String sql = "SELECT ch.*, a.name AS admin_name " +
                     "FROM complaint_history ch " +
                     "LEFT JOIN admins a ON ch.admin_id = a.admin_id " +
                     "WHERE ch.complaint_id = ? " +
                     "ORDER BY ch.changed_at DESC";
        List<ComplaintHistory> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, complaintId);
            rs = ps.executeQuery();
            while (rs.next()) {
                ComplaintHistory h = mapRow(rs);
                h.setAdminName(rs.getString("admin_name"));
                list.add(h);
            }
        } finally {
            DBConnection.closeResources(conn, ps, rs);
        }
        return list;
    }

    // -------------------------------------------------------------------------
    // addHistory
    // -------------------------------------------------------------------------

    /**
     * Inserts a new history entry.
     *
     * @param h the history entry to persist
     * @return {@code true} if the row was inserted successfully
     * @throws SQLException on database error
     */
    public boolean addHistory(ComplaintHistory h) throws SQLException {
        String sql = "INSERT INTO complaint_history (complaint_id, admin_id, old_status, new_status, remarks) " +
                     "VALUES (?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, h.getComplaintId());
            ps.setInt(2, h.getAdminId());
            ps.setString(3, h.getOldStatus());
            ps.setString(4, h.getNewStatus());
            ps.setString(5, h.getRemarks());
            return ps.executeUpdate() > 0;
        } finally {
            DBConnection.closeResources(conn, ps, null);
        }
    }
}
