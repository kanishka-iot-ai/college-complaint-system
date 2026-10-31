package com.college.complaint.dao;

import com.college.complaint.model.Student;
import com.college.complaint.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for {@link Student} entities.
 * Supports official University UID, Section categorization, and Account Activation.
 */
public class StudentDAO {

    // -------------------------------------------------------------------------
    // Helper: map a ResultSet row to a Student object
    // -------------------------------------------------------------------------
    private Student mapRow(ResultSet rs) throws SQLException {
        Student s = new Student();
        s.setStudentId(rs.getInt("student_id"));
        
        // Handle optional/added columns gracefully
        try {
            s.setUid(rs.getString("uid"));
        } catch (SQLException ignored) {}

        s.setName(rs.getString("name"));
        s.setEmail(rs.getString("email"));

        try {
            s.setSection(rs.getString("section"));
        } catch (SQLException ignored) {}

        s.setPasswordHash(rs.getString("password_hash"));
        s.setDepartment(rs.getString("department"));

        int sem = rs.getInt("semester");
        s.setSemester(rs.wasNull() ? null : sem);

        s.setPhone(rs.getString("phone"));

        try {
            s.setActive(rs.getBoolean("is_active"));
        } catch (SQLException ignored) {
            s.setActive(true);
        }

        s.setCreatedAt(rs.getTimestamp("created_at"));
        return s;
    }

    // -------------------------------------------------------------------------
    // registerStudent
    // -------------------------------------------------------------------------

    /**
     * Inserts a new student record into the database.
     *
     * @param s the student to register
     * @return {@code true} if the row was inserted successfully
     * @throws SQLException on database error
     */
    public boolean registerStudent(Student s) throws SQLException {
        String sql = "INSERT INTO students (uid, name, email, section, password_hash, department, semester, phone, is_active) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, s.getUid());
            ps.setString(2, s.getName());
            ps.setString(3, s.getEmail() != null ? s.getEmail().toLowerCase() : null);
            ps.setString(4, s.getSection());
            ps.setString(5, s.getPasswordHash());
            ps.setString(6, s.getDepartment());
            if (s.getSemester() != null) {
                ps.setInt(7, s.getSemester());
            } else {
                ps.setNull(7, Types.INTEGER);
            }
            ps.setString(8, s.getPhone());
            ps.setBoolean(9, s.isActive());
            return ps.executeUpdate() > 0;
        } finally {
            DBConnection.closeResources(conn, ps, null);
        }
    }

    // -------------------------------------------------------------------------
    // getStudentByIdentifier (UID or Email)
    // -------------------------------------------------------------------------

    /**
     * Fetches a student by either their University UID or registered email.
     *
     * @param identifier UID or email address
     * @return the matching {@link Student}, or {@code null} if not found
     * @throws SQLException on database error
     */
    public Student getStudentByIdentifier(String identifier) throws SQLException {
        if (identifier == null || identifier.trim().isEmpty()) {
            return null;
        }
        String cleanId = identifier.trim().toLowerCase();
        String sql = "SELECT * FROM students WHERE LOWER(uid) = ? OR LOWER(email) = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, cleanId);
            ps.setString(2, cleanId);
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
    // getStudentByEmail
    // -------------------------------------------------------------------------

    /**
     * Fetches a student by their e-mail address.
     *
     * @param email the e-mail to look up
     * @return the matching {@link Student}, or {@code null} if not found
     * @throws SQLException on database error
     */
    public Student getStudentByEmail(String email) throws SQLException {
        if (email == null) return null;
        String sql = "SELECT * FROM students WHERE LOWER(email) = LOWER(?)";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, email.trim());
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
    // getStudentByUid
    // -------------------------------------------------------------------------

    /**
     * Fetches a student by their university UID.
     *
     * @param uid the UID to look up
     * @return the matching {@link Student}, or {@code null} if not found
     * @throws SQLException on database error
     */
    public Student getStudentByUid(String uid) throws SQLException {
        if (uid == null) return null;
        String sql = "SELECT * FROM students WHERE LOWER(uid) = LOWER(?)";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, uid.trim());
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
    // getStudentById
    // -------------------------------------------------------------------------

    /**
     * Fetches a student by their primary key.
     *
     * @param studentId the student's ID
     * @return the matching {@link Student}, or {@code null} if not found
     * @throws SQLException on database error
     */
    public Student getStudentById(int studentId) throws SQLException {
        String sql = "SELECT * FROM students WHERE student_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, studentId);
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
    // updateStudent
    // -------------------------------------------------------------------------

    /**
     * Updates the mutable profile fields of an existing student.
     *
     * @param s the student with updated values (studentId is used as the key)
     * @return {@code true} if a row was updated
     * @throws SQLException on database error
     */
    public boolean updateStudent(Student s) throws SQLException {
        String sql = "UPDATE students SET name = ?, department = ?, semester = ?, phone = ?, section = ? " +
                     "WHERE student_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, s.getName());
            ps.setString(2, s.getDepartment());
            if (s.getSemester() != null) {
                ps.setInt(3, s.getSemester());
            } else {
                ps.setNull(3, Types.INTEGER);
            }
            ps.setString(4, s.getPhone());
            ps.setString(5, s.getSection());
            ps.setInt(6, s.getStudentId());
            return ps.executeUpdate() > 0;
        } finally {
            DBConnection.closeResources(conn, ps, null);
        }
    }

    // -------------------------------------------------------------------------
    // activateStudent
    // -------------------------------------------------------------------------

    /**
     * Activates a student account and sets their new secure password hash.
     *
     * @param uid university UID
     * @param newPasswordHash new BCrypt password hash
     * @return {@code true} if updated successfully
     * @throws SQLException on database error
     */
    public boolean activateStudent(String uid, String newPasswordHash) throws SQLException {
        if (uid == null || newPasswordHash == null) return false;
        String sql = "UPDATE students SET password_hash = ?, is_active = TRUE WHERE LOWER(uid) = LOWER(?)";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, newPasswordHash);
            ps.setString(2, uid.trim());
            return ps.executeUpdate() > 0;
        } finally {
            DBConnection.closeResources(conn, ps, null);
        }
    }

    // -------------------------------------------------------------------------
    // emailExists & uidExists
    // -------------------------------------------------------------------------

    /**
     * Checks whether an e-mail address is already registered.
     */
    public boolean emailExists(String email) throws SQLException {
        if (email == null) return false;
        String sql = "SELECT 1 FROM students WHERE LOWER(email) = LOWER(?)";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, email.trim());
            rs = ps.executeQuery();
            return rs.next();
        } finally {
            DBConnection.closeResources(conn, ps, rs);
        }
    }

    /**
     * Checks whether a UID is already registered.
     */
    public boolean uidExists(String uid) throws SQLException {
        if (uid == null) return false;
        String sql = "SELECT 1 FROM students WHERE LOWER(uid) = LOWER(?)";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, uid.trim());
            rs = ps.executeQuery();
            return rs.next();
        } finally {
            DBConnection.closeResources(conn, ps, rs);
        }
    }

    // -------------------------------------------------------------------------
    // getAllStudents
    // -------------------------------------------------------------------------

    /**
     * Returns all students ordered by student ID ascending.
     *
     * @return list of all students
     * @throws SQLException on database error
     */
    public List<Student> getAllStudents() throws SQLException {
        String sql = "SELECT * FROM students ORDER BY student_id ASC";
        List<Student> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } finally {
            DBConnection.closeResources(conn, ps, rs);
        }
        return list;
    }

    // -------------------------------------------------------------------------
    // getAllStudentsFiltered
    // -------------------------------------------------------------------------

    /**
     * Retrieves students matching optional search term (UID, name, email) and section filter.
     *
     * @param search optional keyword for search
     * @param section optional section filter
     * @return filtered list of students
     * @throws SQLException on database error
     */
    public List<Student> getAllStudentsFiltered(String search, String section) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT * FROM students WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (LOWER(uid) LIKE ? OR LOWER(name) LIKE ? OR LOWER(email) LIKE ?) ");
            String term = "%" + search.trim().toLowerCase() + "%";
            params.add(term);
            params.add(term);
            params.add(term);
        }

        if (section != null && !section.trim().isEmpty() && !"ALL".equalsIgnoreCase(section.trim())) {
            sql.append("AND section = ? ");
            params.add(section.trim());
        }

        sql.append("ORDER BY student_id ASC");

        List<Student> list = new ArrayList<>();
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
                list.add(mapRow(rs));
            }
        } finally {
            DBConnection.closeResources(conn, ps, rs);
        }
        return list;
    }

    // -------------------------------------------------------------------------
    // getTotalStudentCount
    // -------------------------------------------------------------------------

    /**
     * Returns the total number of registered students.
     *
     * @return total student count
     * @throws SQLException on database error
     */
    public int getTotalStudentCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM students";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        } finally {
            DBConnection.closeResources(conn, ps, rs);
        }
    }
}
