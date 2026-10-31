package com.college.complaint.model;

import java.sql.Timestamp;

/**
 * Represents a complaint filed by a student.
 * The fields {@code studentName} and {@code categoryName} are convenience fields
 * populated by JOIN queries and are NOT persisted to the database directly.
 */
public class Complaint {

    private int complaintId;
    private int studentId;
    private int categoryId;
    private String title;
    private String description;
    private String priority;
    private String status;
    private String assignedDepartment;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Transient convenience fields (populated via JOINs)
    private String studentName;
    private String categoryName;

    // -------------------------------------------------------------------------
    // Constructors
    // -------------------------------------------------------------------------

    /** No-arg constructor. */
    public Complaint() {
    }

    /** Full constructor (persisted fields only). */
    public Complaint(int complaintId, int studentId, int categoryId, String title,
                     String description, String priority, String status,
                     String assignedDepartment, Timestamp createdAt, Timestamp updatedAt) {
        this.complaintId         = complaintId;
        this.studentId           = studentId;
        this.categoryId          = categoryId;
        this.title               = title;
        this.description         = description;
        this.priority            = priority;
        this.status              = status;
        this.assignedDepartment  = assignedDepartment;
        this.createdAt           = createdAt;
        this.updatedAt           = updatedAt;
    }

    // -------------------------------------------------------------------------
    // Getters and Setters
    // -------------------------------------------------------------------------

    public int getComplaintId() { return complaintId; }
    public void setComplaintId(int complaintId) { this.complaintId = complaintId; }

    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }

    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getPriority() { return priority; }
    public void setPriority(String priority) { this.priority = priority; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getAssignedDepartment() { return assignedDepartment; }
    public void setAssignedDepartment(String assignedDepartment) { this.assignedDepartment = assignedDepartment; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    // Convenience / transient fields
    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

    // -------------------------------------------------------------------------
    // toString
    // -------------------------------------------------------------------------

    @Override
    public String toString() {
        return "Complaint{" +
               "complaintId=" + complaintId +
               ", studentId=" + studentId +
               ", categoryId=" + categoryId +
               ", title='" + title + '\'' +
               ", priority='" + priority + '\'' +
               ", status='" + status + '\'' +
               ", assignedDepartment='" + assignedDepartment + '\'' +
               ", createdAt=" + createdAt +
               ", updatedAt=" + updatedAt +
               '}';
    }
}
