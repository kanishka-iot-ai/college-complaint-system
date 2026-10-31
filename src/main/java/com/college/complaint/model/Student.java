package com.college.complaint.model;

import java.sql.Timestamp;

/**
 * Represents a student registered in the College Complaint Management System.
 * Includes official University UID, Section/Category, and Account Activation status.
 */
public class Student {

    private int studentId;
    private String uid;
    private String name;
    private String email;
    private String section;
    private String passwordHash;
    private String department;
    private Integer semester;
    private String phone;
    private boolean isActive;
    private Timestamp createdAt;

    // -------------------------------------------------------------------------
    // Constructors
    // -------------------------------------------------------------------------

    /** No-arg constructor. */
    public Student() {
    }

    /** Constructor with core identity fields. */
    public Student(int studentId, String uid, String name, String email, String section) {
        this.studentId = studentId;
        this.uid       = uid;
        this.name      = name;
        this.email     = email;
        this.section   = section;
    }

    /** Full constructor. */
    public Student(int studentId, String uid, String name, String email, String section,
                   String passwordHash, String department, Integer semester,
                   String phone, boolean isActive, Timestamp createdAt) {
        this.studentId    = studentId;
        this.uid          = uid;
        this.name         = name;
        this.email        = email;
        this.section      = section;
        this.passwordHash = passwordHash;
        this.department   = department;
        this.semester     = semester;
        this.phone        = phone;
        this.isActive     = isActive;
        this.createdAt    = createdAt;
    }

    // -------------------------------------------------------------------------
    // Getters and Setters
    // -------------------------------------------------------------------------

    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }

    public String getUid() { return uid; }
    public void setUid(String uid) { this.uid = uid; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getSection() { return section; }
    public void setSection(String section) { this.section = section; }

    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }

    public String getDepartment() { return department; }
    public void setDepartment(String department) { this.department = department; }

    public Integer getSemester() { return semester; }
    public void setSemester(Integer semester) { this.semester = semester; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    // -------------------------------------------------------------------------
    // toString
    // -------------------------------------------------------------------------

    @Override
    public String toString() {
        return "Student{" +
               "studentId=" + studentId +
               ", uid='" + uid + '\'' +
               ", name='" + name + '\'' +
               ", email='" + email + '\'' +
               ", section='" + section + '\'' +
               ", department='" + department + '\'' +
               ", semester=" + semester +
               ", isActive=" + isActive +
               '}';
    }
}
