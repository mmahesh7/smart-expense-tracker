package com.expense.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

/**
 * Password utility class for hashing and verifying passwords
 * Uses SHA-256 with salt for security
 */
public class PasswordUtil {
    
    /**
     * Hash a password with SHA-256 and salt
     * @param password The plain text password to hash
     * @return The hashed password with salt (format: salt:hash)
     */
    public static String hashPassword(String password) {
        try {
            // Generate random salt
            SecureRandom random = new SecureRandom();
            byte[] salt = new byte[16];
            random.nextBytes(salt);
            
            // Create MessageDigest instance for SHA-256
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            
            // Add salt to digest
            md.update(salt);
            
            // Get the hash bytes
            byte[] hashedPassword = md.digest(password.getBytes());
            
            // Encode salt and hash to Base64
            String saltBase64 = Base64.getEncoder().encodeToString(salt);
            String hashBase64 = Base64.getEncoder().encodeToString(hashedPassword);
            
            // Return salt:hash format
            return saltBase64 + ":" + hashBase64;
            
        } catch (NoSuchAlgorithmException e) {
            System.err.println("SHA-256 algorithm not available: " + e.getMessage());
            throw new RuntimeException("Password hashing failed", e);
        }
    }
    
    /**
     * Verify if plain text password matches the stored hash
     * @param password The plain text password to verify
     * @param storedHash The stored hash (format: salt:hash)
     * @return true if password matches, false otherwise
     */
    public static boolean verifyPassword(String password, String storedHash) {
        try {
            // Split stored hash into salt and hash
            String[] parts = storedHash.split(":");
            if (parts.length != 2) {
                return false;
            }
            
            String saltBase64 = parts[0];
            String storedHashBase64 = parts[1];
            
            // Decode salt from Base64
            byte[] salt = Base64.getDecoder().decode(saltBase64);
            
            // Create MessageDigest instance for SHA-256
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            
            // Add salt to digest
            md.update(salt);
            
            // Hash the provided password
            byte[] hashedPassword = md.digest(password.getBytes());
            String providedHashBase64 = Base64.getEncoder().encodeToString(hashedPassword);
            
            // Compare the hashes
            return storedHashBase64.equals(providedHashBase64);
            
        } catch (NoSuchAlgorithmException e) {
            System.err.println("SHA-256 algorithm not available: " + e.getMessage());
            return false;
        } catch (IllegalArgumentException e) {
            System.err.println("Invalid hash format: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Check if password meets basic security requirements
     * @param password The password to validate
     * @return true if password is valid, false otherwise
     */
    public static boolean isValidPassword(String password) {
        if (password == null || password.length() < 6) {
            return false;
        }
        return true;
    }
}