package com.college.complaint.model;

import java.sql.Timestamp;

/**
 * Represents a single entry in the status-change history of a complaint.
 * {@code adminName} is a transient convenience field populated by JOIN queries.
 */
public class ComplaintHistory {

    private int historyId;
    private int complaintId;
    private int adminId;
    private String oldStatus;
    private String newStatus;
    private String remarks;
    private Timestamp changedAt;

    // Transient convenience field
    private String adminName;

    // -------------------------------------------------------------------------
    // Constructors
    // -------------------------------------------------------------------------

    /** No-arg constructor. */
    public ComplaintHistory() {
    }

    /** Full constructor (persisted fields). */
    public ComplaintHistory(int historyId, int complaintId, int adminId,
                            String oldStatus, String newStatus,
                            String remarks, Timestamp changedAt) {
        this.historyId   = historyId;
        this.complaintId = complaintId;
        this.adminId     = adminId;
        this.oldStatus   = oldStatus;
        this.newStatus   = newStatus;
        this.remarks     = remarks;
        this.changedAt   = changedAt;
    }

    // -------------------------------------------------------------------------
    // Getters and Setters
    // -------------------------------------------------------------------------

    public int getHistoryId() { return historyId; }
    public void setHistoryId(int historyId) { this.historyId = historyId; }

    public int getComplaintId() { return complaintId; }
    public void setComplaintId(int complaintId) { this.complaintId = complaintId; }

    public int getAdminId() { return adminId; }
    public void setAdminId(int adminId) { this.adminId = adminId; }

    public String getOldStatus() { return oldStatus; }
    public void setOldStatus(String oldStatus) { this.oldStatus = oldStatus; }

    public String getNewStatus() { return newStatus; }
    public void setNewStatus(String newStatus) { this.newStatus = newStatus; }

    public String getRemarks() { return remarks; }
    public void setRemarks(String remarks) { this.remarks = remarks; }

    public Timestamp getChangedAt() { return changedAt; }
    public void setChangedAt(Timestamp changedAt) { this.changedAt = changedAt; }

    public String getAdminName() { return adminName; }
    public void setAdminName(String adminName) { this.adminName = adminName; }

    // -------------------------------------------------------------------------
    // toString
    // -------------------------------------------------------------------------

    @Override
    public String toString() {
        return "ComplaintHistory{" +
               "historyId=" + historyId +
               ", complaintId=" + complaintId +
               ", adminId=" + adminId +
               ", oldStatus='" + oldStatus + '\'' +
               ", newStatus='" + newStatus + '\'' +
               ", remarks='" + remarks + '\'' +
               ", changedAt=" + changedAt +
               '}';
    }
}
