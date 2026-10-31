package com.college.complaint.util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Utility class that wraps the jBCrypt library for password hashing and verification.
 */
public class BCryptUtil {

    private BCryptUtil() {
        // Utility class – no instantiation
    }

    /**
     * Hashes a plain-text password using BCrypt with a work factor of 10.
     *
     * @param plainPassword the raw password to hash
     * @return the BCrypt hashed password string
     */
    public static String hashPassword(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(10));
    }

    /**
     * Verifies a plain-text password against a stored BCrypt hash.
     *
     * @param plainPassword  the raw password to check
     * @param hashedPassword the stored BCrypt hash
     * @return {@code true} if the password matches the hash; {@code false} otherwise
     */
    public static boolean checkPassword(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null) {
            return false;
        }
        return BCrypt.checkpw(plainPassword, hashedPassword);
    }
}
