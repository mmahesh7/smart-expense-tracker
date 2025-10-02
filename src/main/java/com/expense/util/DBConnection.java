package com.expense.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    // ADD allowPublicKeyRetrieval=true & useSSL=false
    private static final String URL = "jdbc:mysql://localhost:3306/expense_tracker?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String USERNAME = "root";      // Your MySQL username
    private static final String PASSWORD = "your_password";  // Your MySQL password
    
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println(" MySQL Driver loaded successfully");
        } catch (ClassNotFoundException e) {
            System.err.println(" MySQL Driver not found!");
            e.printStackTrace();
        }
    }
    
    public static Connection getConnection() throws SQLException {
        try {
            Connection connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);
            System.out.println(" Database connection established successfully");
            return connection;
        } catch (SQLException e) {
            System.err.println(" Database connection failed: " + e.getMessage());
            throw e;
        }
    }
    
    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
                System.out.println(" Database connection closed");
            } catch (SQLException e) {
                System.err.println(" Error closing connection: " + e.getMessage());
            }
        }
    }
}