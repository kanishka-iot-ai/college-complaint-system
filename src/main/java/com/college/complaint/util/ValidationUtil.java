package com.college.complaint.util;

import java.util.regex.Pattern;

/**
 * Utility class providing common input validation and sanitisation helpers.
 */
public class ValidationUtil {

    // Pre-compiled regex patterns for performance
    private static final Pattern EMAIL_PATTERN =
        Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");

    private static final Pattern PHONE_PATTERN =
        Pattern.compile("^[0-9]{10}$");

    private static final Pattern PASSWORD_PATTERN =
        Pattern.compile("^(?=.*[A-Z])(?=.*\\d).{8,}$");

    private ValidationUtil() {
        // Utility class – no instantiation
    }

    /**
     * Validates an e-mail address using a standard regex.
     *
     * @param email the e-mail string to validate
     * @return {@code true} if the e-mail is syntactically valid
     */
    public static boolean isValidEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        return EMAIL_PATTERN.matcher(email.trim()).matches();
    }

    /**
     * Validates a phone number — must be exactly 10 digits.
     *
     * @param phone the phone number string to validate
     * @return {@code true} if the phone number is exactly 10 digits
     */
    public static boolean isValidPhone(String phone) {
        if (phone == null || phone.trim().isEmpty()) {
            return false;
        }
        return PHONE_PATTERN.matcher(phone.trim()).matches();
    }

    /**
     * Checks that a string is neither null nor blank after trimming.
     *
     * @param s the string to check
     * @return {@code true} if the string is non-null and non-empty after trimming
     */
    public static boolean isNotEmpty(String s) {
        return s != null && !s.trim().isEmpty();
    }

    /**
     * Sanitises a string by trimming leading and trailing whitespace.
     * Returns an empty string if the input is null.
     *
     * @param s the string to sanitise
     * @return the trimmed string, or {@code ""} if {@code s} is null
     */
    public static String sanitize(String s) {
        return s == null ? "" : s.trim();
    }

    /**
     * Validates that a semester value is in the range [1, 8].
     *
     * @param sem the semester number to validate
     * @return {@code true} if {@code sem} is between 1 and 8 inclusive
     */
    public static boolean isValidSemester(int sem) {
        return sem >= 1 && sem <= 8;
    }

    /**
     * Validates a password — minimum 8 characters, at least one uppercase letter and one digit.
     *
     * @param password the password to validate
     * @return {@code true} if the password meets the requirements
     */
    public static boolean isValidPassword(String password) {
        if (password == null) {
            return false;
        }
        return PASSWORD_PATTERN.matcher(password).matches();
    }
}
