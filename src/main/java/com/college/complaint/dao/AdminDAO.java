package com.college.complaint.dao;

import com.college.complaint.model.Admin;
import com.college.complaint.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Data Access Object for {@link Admin} entities.
 */
public class AdminDAO {

    // -------------------------------------------------------------------------
    // Helper: map a ResultSet row to an Admin object
    // -------------------------------------------------------------------------
    private Admin mapRow(ResultSet rs) throws SQLException {
        Admin a = new Admin();
        a.setAdminId(rs.getInt("admin_id"));
        a.setName(rs.getString("name"));
        a.setEmail(rs.getString("email"));
        a.setPasswordHash(rs.getString("password_hash"));
        a.setCreatedAt(rs.getTimestamp("created_at"));
        return a;
    }

    // -------------------------------------------------------------------------
    // getAdminByEmail
    // -------------------------------------------------------------------------

    /**
     * Fetches an admin by their e-mail address.
     *
     * @param email the e-mail to look up
     * @return the matching {@link Admin}, or {@code null} if not found
     * @throws SQLException on database error
     */
    public Admin getAdminByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM admins WHERE email = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            rs = ps.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
            return null;
        } finally {
            DBConnection.closeResources(conn, ps, rs);
        }
    }

    // -------------------------------------------------------------------------
    // getAdminById
    // -------------------------------------------------------------------------

    /**
     * Fetches an admin by their primary key.
     *
     * @param id the admin's ID
     * @return the matching {@link Admin}, or {@code null} if not found
     * @throws SQLException on database error
     */
    public Admin getAdminById(int id) throws SQLException {
        String sql = "SELECT * FROM admins WHERE admin_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
            return null;
        } finally {
            DBConnection.closeResources(conn, ps, rs);
        }
    }
}
