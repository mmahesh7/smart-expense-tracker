package com.expense.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    // Update these with your MySQL credentials
    private static final String URL = "jdbc:mysql://localhost:3306/expense_tracker?useSSL=false&serverTimezone=UTC";
    private static final String USERNAME = "root";      // Your MySQL username
    private static final String PASSWORD = "Mahesh@mySQL";  // Your MySQL password
    
    static {
        try {
            // Maven automatically provides the MySQL driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("✅ MySQL Driver loaded successfully (via Maven)");
        } catch (ClassNotFoundException e) {
            System.err.println("❌ MySQL Driver not found!");
            System.err.println("💡 Run: mvn clean compile to download dependencies");
            e.printStackTrace();
        }
    }
    
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }

	/**
     * Close database connection
     * @param connection Connection to close
     */
    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
                System.out.println("Database connection closed successfully");
            } catch (SQLException e) {
                System.err.println("Error closing database connection: " + e.getMessage());
            }
        }
    }

}