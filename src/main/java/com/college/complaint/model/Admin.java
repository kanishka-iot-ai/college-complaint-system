package com.college.complaint.model;

import java.sql.Timestamp;

/**
 * Represents an administrator in the College Complaint Management System.
 */
public class Admin {

    private int adminId;
    private String name;
    private String email;
    private String passwordHash;
    private Timestamp createdAt;

    // -------------------------------------------------------------------------
    // Constructors
    // -------------------------------------------------------------------------

    /** No-arg constructor. */
    public Admin() {
    }

    /** Full constructor. */
    public Admin(int adminId, String name, String email, String passwordHash, Timestamp createdAt) {
        this.adminId      = adminId;
        this.name         = name;
        this.email        = email;
        this.passwordHash = passwordHash;
        this.createdAt    = createdAt;
    }

    // -------------------------------------------------------------------------
    // Getters and Setters
    // -------------------------------------------------------------------------

    public int getAdminId() { return adminId; }
    public void setAdminId(int adminId) { this.adminId = adminId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    // -------------------------------------------------------------------------
    // toString
    // -------------------------------------------------------------------------

    @Override
    public String toString() {
        return "Admin{" +
               "adminId=" + adminId +
               ", name='" + name + '\'' +
               ", email='" + email + '\'' +
               ", createdAt=" + createdAt +
               '}';
    }
}
