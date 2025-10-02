package com.expense.dao;

import com.expense.model.Budget;
import com.expense.util.DBConnection;

import java.sql.*;
import java.math.BigDecimal;

/**
 * Data Access Object for Budget operations
 */
public class BudgetDAO {
    
    /**
     * Set or update budget for a user for specific month and year
     */
    public boolean setBudget(Budget budget) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            
            // Use INSERT ... ON DUPLICATE KEY UPDATE to handle both insert and update
            String sql = "INSERT INTO budgets (user_id, month, year, budget_amount, alert_threshold) " +
                        "VALUES (?, ?, ?, ?, ?) " +
                        "ON DUPLICATE KEY UPDATE budget_amount = ?, alert_threshold = ?";
            pstmt = conn.prepareStatement(sql);
            
            pstmt.setInt(1, budget.getUserId());
            pstmt.setInt(2, budget.getMonth());
            pstmt.setInt(3, budget.getYear());
            pstmt.setBigDecimal(4, budget.getBudgetAmount());
            pstmt.setInt(5, budget.getAlertThreshold());
            pstmt.setBigDecimal(6, budget.getBudgetAmount());
            pstmt.setInt(7, budget.getAlertThreshold());
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error setting budget: " + e.getMessage());
            return false;
        } finally {
            // Close resources
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) DBConnection.closeConnection(conn);
            } catch (SQLException e) {
                System.err.println("Error closing resources: " + e.getMessage());
            }
        }
    }
    
    /**
     * Get budget for a user for specific month and year
     */
    public Budget getBudget(int userId, int month, int year) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM budgets WHERE user_id = ? AND month = ? AND year = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            pstmt.setInt(2, month);
            pstmt.setInt(3, year);
            
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return new Budget(
                    rs.getInt("budget_id"),
                    rs.getInt("user_id"),
                    rs.getInt("month"),
                    rs.getInt("year"),
                    rs.getBigDecimal("budget_amount"),
                    rs.getInt("alert_threshold"),
                    rs.getTimestamp("created_at").toLocalDateTime()
                );
            }
            return null;
            
        } catch (SQLException e) {
            System.err.println("Error getting budget: " + e.getMessage());
            return null;
        } finally {
            // Close resources
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) DBConnection.closeConnection(conn);
            } catch (SQLException e) {
                System.err.println("Error closing resources: " + e.getMessage());
            }
        }
    }
    
    /**
     * Get budget status with calculated spending
     */
    public Budget getBudgetStatus(int userId, int month, int year) {
        Budget budget = getBudget(userId, month, year);
        
        if (budget == null) {
            return null;
        }
        
        // Get total spending for the month
        ExpenseDAO expenseDAO = new ExpenseDAO();
        BigDecimal totalSpent = expenseDAO.getMonthlyTotal(userId, month, year);
        
        budget.setTotalSpent(totalSpent);
        
        // Calculate percentage used
        if (budget.getBudgetAmount().compareTo(BigDecimal.ZERO) > 0) {
            double percentage = (totalSpent.doubleValue() / budget.getBudgetAmount().doubleValue()) * 100;
            budget.setPercentageUsed(Math.round(percentage * 100.0) / 100.0); // Round to 2 decimal places
        } else {
            budget.setPercentageUsed(0.0);
        }
        
        // Calculate status
        budget.calculateStatus();
        
        return budget;
    }
}