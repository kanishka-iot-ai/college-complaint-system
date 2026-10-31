package com.college.complaint;

import com.college.complaint.model.*;
import com.college.complaint.util.BCryptUtil;
import com.college.complaint.util.ValidationUtil;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.sql.Timestamp;

import static org.junit.jupiter.api.Assertions.*;

/**
 * JUnit 5 Automated Test Suite for College Complaint Management System.
 */
public class CollegeComplaintSystemTest {

    @Test
    @DisplayName("ValidationUtil: Email Format Validation")
    void testEmailValidation() {
        assertTrue(ValidationUtil.isValidEmail("student@college.edu"));
        assertTrue(ValidationUtil.isValidEmail("admin@grievance.college.ac.in"));
        assertFalse(ValidationUtil.isValidEmail("plainaddress"));
        assertFalse(ValidationUtil.isValidEmail("@missingusername.com"));
        assertFalse(ValidationUtil.isValidEmail(null));
    }

    @Test
    @DisplayName("ValidationUtil: Mobile Phone Validation (10 digits)")
    void testPhoneValidation() {
        assertTrue(ValidationUtil.isValidPhone("9876543210"));
        assertFalse(ValidationUtil.isValidPhone("12345"));
        assertFalse(ValidationUtil.isValidPhone("98765abcde"));
        assertFalse(ValidationUtil.isValidPhone(null));
    }

    @Test
    @DisplayName("ValidationUtil: Academic Semester Validation (1-8)")
    void testSemesterValidation() {
        assertTrue(ValidationUtil.isValidSemester(1));
        assertTrue(ValidationUtil.isValidSemester(8));
        assertFalse(ValidationUtil.isValidSemester(0));
        assertFalse(ValidationUtil.isValidSemester(9));
    }

    @Test
    @DisplayName("Security: BCrypt Hashing & Verification")
    void testBCryptPasswordSecurity() {
        String password = "SecureStudentPass@2026";
        String hashed = BCryptUtil.hashPassword(password);

        assertNotNull(hashed);
        assertTrue(hashed.startsWith("$2a$") || hashed.startsWith("$2b$") || hashed.startsWith("$2y$"));
        assertTrue(BCryptUtil.checkPassword(password, hashed));
        assertFalse(BCryptUtil.checkPassword("WrongPassword", hashed));
    }

    @Test
    @DisplayName("Model Integrity: Complaint & Resolution Beans")
    void testComplaintAndResolutionModels() {
        Complaint complaint = new Complaint();
        complaint.setComplaintId(101);
        complaint.setTitle("Wi-Fi down in Library");
        complaint.setPriority("High");
        complaint.setStatus("Submitted");

        assertEquals(101, complaint.getComplaintId());
        assertEquals("Wi-Fi down in Library", complaint.getTitle());
        assertEquals("High", complaint.getPriority());
        assertEquals("Submitted", complaint.getStatus());

        Resolution resolution = new Resolution();
        resolution.setResolutionId(201);
        resolution.setComplaintId(101);
        resolution.setRemarks("Access point rebooted.");

        assertEquals(201, resolution.getResolutionId());
        assertEquals(101, resolution.getComplaintId());
        assertTrue(resolution.getRemarks().contains("rebooted"));
    }
}
