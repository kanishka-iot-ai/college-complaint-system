package com.college.complaint.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

/**
 * Utility class for managing database connections.
 * Attempts JNDI lookup first, falls back to DriverManager.
 */
public class DBConnection {

    private static final String JNDI_NAME = "java:comp/env/jdbc/CollegeDB";
    private static final String JDBC_URL =
        "jdbc:mysql://localhost:3306/college_complaint_db?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD_KEY = "DB_PASSWORD";

    private DBConnection() {
        // Utility class – no instantiation
    }

    /**
     * Returns a database connection.
     * Tries JNDI DataSource first; falls back to DriverManager on failure.
     *
     * @return a valid {@link Connection}
     * @throws SQLException if neither JNDI nor DriverManager can supply a connection
     */
    public static Connection getConnection() throws SQLException {
        // --- Attempt JNDI lookup ---
        try {
            Context ctx = new InitialContext();
            DataSource ds = (DataSource) ctx.lookup(JNDI_NAME);
            if (ds != null) {
                return ds.getConnection();
            }
        } catch (NamingException e) {
            // JNDI not available (e.g., running outside an app server); use fallback
            System.err.println("[DBConnection] JNDI lookup failed, using DriverManager fallback: " + e.getMessage());
        }

        // --- Fallback: DriverManager ---
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL JDBC driver not found on classpath.", e);
        }

        String envUrl = System.getenv("DB_URL");
        String envUser = System.getenv("DB_USER");
        String envPass = System.getenv("DB_PASSWORD");

        String url = (envUrl != null && !envUrl.trim().isEmpty()) ? envUrl : JDBC_URL;
        String user = (envUser != null && !envUser.trim().isEmpty()) ? envUser : DB_USER;
        String password = (envPass != null) ? envPass : System.getProperty(DB_PASSWORD_KEY, "root");

        return DriverManager.getConnection(url, user, password);
    }

    /**
     * Safely closes a {@link ResultSet}, {@link PreparedStatement}, and {@link Connection}.
     * Null arguments are silently ignored.
     *
     * @param conn the connection to close (may be null)
     * @param ps   the prepared statement to close (may be null)
     * @param rs   the result set to close (may be null)
     */
    public static void closeResources(Connection conn, PreparedStatement ps, ResultSet rs) {
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException e) {
                System.err.println("[DBConnection] Failed to close ResultSet: " + e.getMessage());
            }
        }
        if (ps != null) {
            try {
                ps.close();
            } catch (SQLException e) {
                System.err.println("[DBConnection] Failed to close PreparedStatement: " + e.getMessage());
            }
        }
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                System.err.println("[DBConnection] Failed to close Connection: " + e.getMessage());
            }
        }
    }
}
