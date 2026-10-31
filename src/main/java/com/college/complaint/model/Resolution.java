package com.college.complaint.model;

import java.sql.Timestamp;

/**
 * Represents the resolution record for a resolved complaint.
 * {@code adminName} is a transient convenience field populated by JOIN queries.
 */
public class Resolution {

    private int resolutionId;
    private int complaintId;
    private int adminId;
    private String remarks;
    private Timestamp resolutionDate;

    // Transient convenience field
    private String adminName;

    // -------------------------------------------------------------------------
    // Constructors
    // -------------------------------------------------------------------------

    /** No-arg constructor. */
    public Resolution() {
    }

    /** Full constructor (persisted fields). */
    public Resolution(int resolutionId, int complaintId, int adminId,
                      String remarks, Timestamp resolutionDate) {
        this.resolutionId   = resolutionId;
        this.complaintId    = complaintId;
        this.adminId        = adminId;
        this.remarks        = remarks;
        this.resolutionDate = resolutionDate;
    }

    // -------------------------------------------------------------------------
    // Getters and Setters
    // -------------------------------------------------------------------------

    public int getResolutionId() { return resolutionId; }
    public void setResolutionId(int resolutionId) { this.resolutionId = resolutionId; }

    public int getComplaintId() { return complaintId; }
    public void setComplaintId(int complaintId) { this.complaintId = complaintId; }

    public int getAdminId() { return adminId; }
    public void setAdminId(int adminId) { this.adminId = adminId; }

    public String getRemarks() { return remarks; }
    public void setRemarks(String remarks) { this.remarks = remarks; }

    public Timestamp getResolutionDate() { return resolutionDate; }
    public void setResolutionDate(Timestamp resolutionDate) { this.resolutionDate = resolutionDate; }

    public String getAdminName() { return adminName; }
    public void setAdminName(String adminName) { this.adminName = adminName; }

    // -------------------------------------------------------------------------
    // toString
    // -------------------------------------------------------------------------

    @Override
    public String toString() {
        return "Resolution{" +
               "resolutionId=" + resolutionId +
               ", complaintId=" + complaintId +
               ", adminId=" + adminId +
               ", remarks='" + remarks + '\'' +
               ", resolutionDate=" + resolutionDate +
               '}';
    }
}
