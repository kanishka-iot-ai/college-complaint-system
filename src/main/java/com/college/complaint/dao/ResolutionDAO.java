package com.college.complaint.dao;

import com.college.complaint.model.Resolution;
import com.college.complaint.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Data Access Object for {@link Resolution} entities.
 */
public class ResolutionDAO {

    // -------------------------------------------------------------------------
    // Helper: map a ResultSet row to a Resolution object
    // -------------------------------------------------------------------------
    private Resolution mapRow(ResultSet rs) throws SQLException {
        Resolution r = new Resolution();
        r.setResolutionId(rs.getInt("resolution_id"));
        r.setComplaintId(rs.getInt("complaint_id"));
        r.setAdminId(rs.getInt("admin_id"));
        r.setRemarks(rs.getString("remarks"));
        r.setResolutionDate(rs.getTimestamp("resolution_date"));
        return r;
    }

    // -------------------------------------------------------------------------
    // getResolutionByComplaintId
    // -------------------------------------------------------------------------

    /**
     * Fetches the resolution record for the given complaint, including the admin's name
     * via a JOIN on the admins table.
     *
     * @param complaintId the complaint whose resolution is requested
     * @return the {@link Resolution}, or {@code null} if none exists yet
     * @throws SQLException on database error
     */
    public Resolution getResolutionByComplaintId(int complaintId) throws SQLException {
        String sql = "SELECT r.*, a.name AS admin_name " +
                     "FROM resolutions r " +
                     "JOIN admins a ON r.admin_id = a.admin_id " +
                     "WHERE r.complaint_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, complaintId);
            rs = ps.executeQuery();
            if (rs.next()) {
                Resolution resolution = mapRow(rs);
                resolution.setAdminName(rs.getString("admin_name"));
                return resolution;
            }
            return null;
        } finally {
            DBConnection.closeResources(conn, ps, rs);
        }
    }

    // -------------------------------------------------------------------------
    // addOrUpdateResolution
    // -------------------------------------------------------------------------

    /**
     * Inserts a new resolution or updates the existing one for the same complaint
     * using an INSERT … ON DUPLICATE KEY UPDATE pattern (keyed on complaint_id).
     *
     * @param r the resolution to persist
     * @return {@code true} if at least one row was affected
     * @throws SQLException on database error
     */
    public boolean addOrUpdateResolution(Resolution r) throws SQLException {
        String sql = "INSERT INTO resolutions (complaint_id, admin_id, remarks, resolution_date) " +
                     "VALUES (?, ?, ?, NOW()) " +
                     "ON DUPLICATE KEY UPDATE " +
                     "admin_id = VALUES(admin_id), " +
                     "remarks = VALUES(remarks), " +
                     "resolution_date = NOW()";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, r.getComplaintId());
            ps.setInt(2, r.getAdminId());
            ps.setString(3, r.getRemarks());
            return ps.executeUpdate() > 0;
        } finally {
            DBConnection.closeResources(conn, ps, null);
        }
    }
}
