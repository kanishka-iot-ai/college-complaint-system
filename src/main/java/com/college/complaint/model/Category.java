package com.college.complaint.model;

/**
 * Represents a complaint category in the College Complaint Management System.
 */
public class Category {

    private int categoryId;
    private String categoryName;
    private String description;

    // -------------------------------------------------------------------------
    // Constructors
    // -------------------------------------------------------------------------

    /** No-arg constructor. */
    public Category() {
    }

    /** Full constructor. */
    public Category(int categoryId, String categoryName, String description) {
        this.categoryId   = categoryId;
        this.categoryName = categoryName;
        this.description  = description;
    }

    // -------------------------------------------------------------------------
    // Getters and Setters
    // -------------------------------------------------------------------------

    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    // -------------------------------------------------------------------------
    // toString
    // -------------------------------------------------------------------------

    @Override
    public String toString() {
        return "Category{" +
               "categoryId=" + categoryId +
               ", categoryName='" + categoryName + '\'' +
               ", description='" + description + '\'' +
               '}';
    }
}
