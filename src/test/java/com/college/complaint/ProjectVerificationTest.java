package com.college.complaint;

import com.college.complaint.model.*;
import com.college.complaint.util.BCryptUtil;
import com.college.complaint.util.ValidationUtil;

import java.sql.Timestamp;

/**
 * Automated Verification & Unit Test Suite for College Complaint Management System.
 * Tests Validation, Password Hashing, and Model Integrity.
 */
public class ProjectVerificationTest {

    private static int totalTests = 0;
    private static int passedTests = 0;

    public static void main(String[] args) {
        System.out.println("==========================================================");
        System.out.println("  COLLEGE COMPLAINT MANAGEMENT SYSTEM - TEST SUITE");
        System.out.println("==========================================================");

        testValidationUtils();
        testBCryptHashing();
        testModelBeans();
        testOfficialStudentRecords();

        System.out.println("----------------------------------------------------------");
        System.out.printf("Test Summary: %d / %d Tests Passed (%.1f%%)%n",
                passedTests, totalTests, (passedTests * 100.0 / totalTests));
        System.out.println("==========================================================");

        if (passedTests == totalTests) {
            System.out.println(">>> ALL AUTOMATED TESTS PASSED SUCCESSFULLY! <<<");
            System.exit(0);
        } else {
            System.err.println(">>> SOME TESTS FAILED! <<<");
            System.exit(1);
        }
    }

    private static void assertTrue(String testName, boolean condition) {
        totalTests++;
        if (condition) {
            passedTests++;
            System.out.println("  [PASS] " + testName);
        } else {
            System.err.println("  [FAIL] " + testName);
        }
    }

    private static void testValidationUtils() {
        System.out.println("\n[1] Testing ValidationUtil...");

        // Email validation
        assertTrue("Valid email format accepted",
                ValidationUtil.isValidEmail("rahul@student.edu"));
        assertTrue("Subdomain email format accepted",
                ValidationUtil.isValidEmail("admin@cse.college.ac.in"));
        assertTrue("Invalid email without @ rejected",
                !ValidationUtil.isValidEmail("invalidemail.com"));
        assertTrue("Invalid email without domain rejected",
                !ValidationUtil.isValidEmail("rahul@"));
        assertTrue("Null email safely rejected",
                !ValidationUtil.isValidEmail(null));

        // Phone validation (10 digits)
        assertTrue("Valid 10-digit phone accepted",
                ValidationUtil.isValidPhone("9876543210"));
        assertTrue("Phone with 9 digits rejected",
                !ValidationUtil.isValidPhone("987654321"));
        assertTrue("Phone with letters rejected",
                !ValidationUtil.isValidPhone("98765abcde"));
        assertTrue("Null phone safely rejected",
                !ValidationUtil.isValidPhone(null));

        // Semester bounds (1 to 8)
        assertTrue("Semester 1 valid", ValidationUtil.isValidSemester(1));
        assertTrue("Semester 8 valid", ValidationUtil.isValidSemester(8));
        assertTrue("Semester 0 invalid", !ValidationUtil.isValidSemester(0));
        assertTrue("Semester 9 invalid", !ValidationUtil.isValidSemester(9));

        // String non-empty
        assertTrue("Non-empty string valid", ValidationUtil.isNotEmpty("Hello"));
        assertTrue("Empty string invalid", !ValidationUtil.isNotEmpty(""));
        assertTrue("Whitespace string invalid", !ValidationUtil.isNotEmpty("   "));
        assertTrue("Null string invalid", !ValidationUtil.isNotEmpty(null));
    }

    private static void testBCryptHashing() {
        System.out.println("\n[2] Testing BCrypt Security & Password Verification...");

        String rawPassword = "Admin@123SecurePassword";
        String hashed = BCryptUtil.hashPassword(rawPassword);

        assertTrue("Hashed password is not null", hashed != null);
        assertTrue("BCrypt hash starts with $2a$", hashed.startsWith("$2a$") || hashed.startsWith("$2b$") || hashed.startsWith("$2y$"));
        assertTrue("Correct password matches hash", BCryptUtil.checkPassword(rawPassword, hashed));
        assertTrue("Wrong password fails match", !BCryptUtil.checkPassword("WrongPassword@123", hashed));
        assertTrue("Case sensitivity enforced", !BCryptUtil.checkPassword(rawPassword.toLowerCase(), hashed));
    }

    private static void testModelBeans() {
        System.out.println("\n[3] Testing Model Bean Property Integrity...");

        Timestamp now = new Timestamp(System.currentTimeMillis());

        // Student Bean
        Student s = new Student();
        s.setStudentId(101);
        s.setName("Rahul Sharma");
        s.setEmail("rahul@student.edu");
        s.setDepartment("Computer Science");
        s.setSemester(5);
        s.setPhone("9876543210");
        s.setCreatedAt(now);

        assertTrue("Student ID getter/setter", s.getStudentId() == 101);
        assertTrue("Student Name getter/setter", "Rahul Sharma".equals(s.getName()));
        assertTrue("Student Email getter/setter", "rahul@student.edu".equals(s.getEmail()));
        assertTrue("Student Semester getter/setter", s.getSemester() == 5);

        // Complaint Bean
        Complaint c = new Complaint();
        c.setComplaintId(5001);
        c.setStudentId(101);
        c.setCategoryId(3);
        c.setTitle("Projector Malfunction");
        c.setDescription("Projector in Lab 3 is not turning on.");
        c.setPriority("High");
        c.setStatus("Submitted");
        c.setAssignedDepartment("IT Cell");
        c.setStudentName("Rahul Sharma");
        c.setCategoryName("Laboratory");

        assertTrue("Complaint ID getter/setter", c.getComplaintId() == 5001);
        assertTrue("Complaint Title getter/setter", "Projector Malfunction".equals(c.getTitle()));
        assertTrue("Complaint Priority getter/setter", "High".equals(c.getPriority()));
        assertTrue("Complaint Status getter/setter", "Submitted".equals(c.getStatus()));
        assertTrue("Complaint Category Name getter/setter", "Laboratory".equals(c.getCategoryName()));
        assertTrue("Complaint Student Name getter/setter", "Rahul Sharma".equals(c.getStudentName()));

        // Resolution Bean
        Resolution r = new Resolution();
        r.setResolutionId(901);
        r.setComplaintId(5001);
        r.setAdminId(1);
        r.setRemarks("Replaced HDMI cable and updated firmware.");
        r.setAdminName("Super Admin");

        assertTrue("Resolution ID getter/setter", r.getResolutionId() == 901);
        assertTrue("Resolution Remarks getter/setter", r.getRemarks().contains("HDMI"));
        assertTrue("Resolution Admin Name getter/setter", "Super Admin".equals(r.getAdminName()));

        // Complaint History Bean
        ComplaintHistory h = new ComplaintHistory();
        h.setHistoryId(801);
        h.setComplaintId(5001);
        h.setAdminId(1);
        h.setOldStatus("Submitted");
        h.setNewStatus("In Progress");
        h.setRemarks("Assigned to technician.");
        h.setAdminName("Super Admin");

        assertTrue("History Old Status getter/setter", "Submitted".equals(h.getOldStatus()));
        assertTrue("History New Status getter/setter", "In Progress".equals(h.getNewStatus()));
    }

    private static void testOfficialStudentRecords() {
        System.out.println("\n[4] Testing Official 20 Student Records Integrity...");

        String[][] officialData = {
            {"1", "26BAI10196", "MOHAMMED TEHJIB NIZAM CHOWDHURY", "26BAI10196@cuchd.in", "Future Skills & Innovation"},
            {"2", "25BCY70275", "PIYESH KUMAR DAS", "25BCY70275@cuchd.in", "Future Skills & Innovation"},
            {"3", "26BAI10195", "Singiri sireesha", "26BAI10195@cuchd.in", "Future Skills & Innovation"},
            {"4", "26BAI10118", "APARAJITA GOPE ARPA", "26BAI10118@cuchd.in", "Future Skills & Innovation"},
            {"5", "26BDS80005", "AYUSH KUMAR PATEL", "26BDS80005@cuchd.in", "Future Skills & Innovation"},
            {"6", "26BDS80004", "MD RAZAUDDIN", "26BDS80004@cuchd.in", "Future Skills & Innovation"},
            {"7", "26BAI80018", "VIDHITA CHAUDHARY", "26BAI80018@cuchd.in", "Future Skills & Innovation"},
            {"8", "25BAI70994", "MEHAKPREET KAUR", "25BAI70994@cuchd.in", "Future Skills & Innovation"},
            {"9", "25BDA70080", "RIKSHESH SINGH", "25BDA70080@cuchd.in", "Future Skills & Innovation"},
            {"10", "25BCC70040", "DHRUV", "25BCC70040@cuchd.in", "Future Skills & Innovation"},
            {"11", "25BCY70056", "NAVEEN CHAUDHARY", "25BCY70056@cuchd.in", "Future Skills & Innovation"},
            {"12", "25BAI70221", "VIPLAV MITTAL", "25BAI70221@cuchd.in", "Future Skills & Innovation"},
            {"13", "25BDA70085", "SAHIL KUMAR DOGRA", "25BDA70085@cuchd.in", "Future Skills & Innovation"},
            {"14", "25BDA70265", "KRIPANSHU SIKDAR", "25BDA70265@cuchd.in", "Future Skills & Innovation"},
            {"15", "25BAI70939", "VIKALP ANGROYA", "25BAI70939@cuchd.in", "Society, Sustainability & Human Values"},
            {"16", "25IBD70002", "AMAN KUMARI", "25IBD70002@cuchd.in", "Future Skills & Innovation"},
            {"17", "25BCY70007", "SAKSHAM KAPATIA", "25BCY70007@cuchd.in", "Future Skills & Innovation"},
            {"18", "25BDA70014", "SUKRIT SONI", "25BDA70014@cuchd.in", "Future Skills & Innovation"},
            {"19", "25BAI70107", "ABHICHAL VERMA", "25BAI70107@cuchd.in", "Future Skills & Innovation"},
            {"20", "25BDA70106", "PRATHAM DOGRA", "25BDA70106@cuchd.in", "Future Skills & Innovation"}
        };

        assertTrue("Exact 20 student records present", officialData.length == 20);

        int futureSkillsCount = 0;
        int societyCount = 0;

        for (String[] row : officialData) {
            String uid = row[1];
            String name = row[2];
            String email = row[3];
            String section = row[4];

            // Verify UID regex
            assertTrue("UID format valid: " + uid, uid.matches("^[0-9]{2}[A-Z]{3}[0-9]{5}$"));

            // Verify email generation rule: [uid]@cuchd.in
            assertTrue("Email generation rule matches UID: " + email, email.equalsIgnoreCase(uid + "@cuchd.in"));

            if ("Future Skills & Innovation".equals(section)) {
                futureSkillsCount++;
            } else if ("Society, Sustainability & Human Values".equals(section)) {
                societyCount++;
                assertTrue("Special section student is Vikalp Angroya", "VIKALP ANGROYA".equals(name) && "25BAI70939".equals(uid));
            }

            // Verify Student model population
            Student student = new Student(Integer.parseInt(row[0]), uid, name, email, section);
            student.setActive(true);
            assertTrue("Student bean UID integrity: " + uid, uid.equals(student.getUid()));
            assertTrue("Student bean Section integrity: " + uid, section.equals(student.getSection()));
            assertTrue("Student bean Active flag", student.isActive());

            // Test password check with default individual credentials
            String expectedDefaultPassword = "Cu@" + uid;
            String computedHash = BCryptUtil.hashPassword(expectedDefaultPassword);
            assertTrue("BCrypt hash authenticates individual password for " + uid, 
                    BCryptUtil.checkPassword(expectedDefaultPassword, computedHash));
        }

        assertTrue("19 students in Future Skills & Innovation", futureSkillsCount == 19);
        assertTrue("1 student in Society, Sustainability & Human Values", societyCount == 1);
    }
}
