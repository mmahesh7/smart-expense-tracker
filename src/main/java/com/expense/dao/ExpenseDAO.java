package com.expense.dao;

import com.expense.model.Expense;
import com.expense.util.DBConnection;

import java.sql.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Expense operations
 */
public class ExpenseDAO {
    
    /**
     * Add new expense
     */
    public boolean addExpense(Expense expense) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "INSERT INTO expenses (user_id, category_id, amount, description, expense_date, payment_method) VALUES (?, ?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            
            pstmt.setInt(1, expense.getUserId());
            pstmt.setInt(2, expense.getCategoryId());
            pstmt.setBigDecimal(3, expense.getAmount());
            pstmt.setString(4, expense.getDescription());
            pstmt.setDate(5, Date.valueOf(expense.getExpenseDate()));
            pstmt.setString(6, expense.getPaymentMethod());
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error adding expense: " + e.getMessage());
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
     * Delete expense (only if it belongs to the user)
     */
    public boolean deleteExpense(int expenseId, int userId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "DELETE FROM expenses WHERE expense_id = ? AND user_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, expenseId);
            pstmt.setInt(2, userId);
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error deleting expense: " + e.getMessage());
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
     * Get all expenses for a user
     */
    public List<Expense> getUserExpenses(int userId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Expense> expenses = new ArrayList<>();
        
        try {
            conn = DBConnection.getConnection();
            // Join with categories to get category name and color
            String sql = "SELECT e.*, c.category_name, c.color, c.icon " +
                        "FROM expenses e " +
                        "JOIN categories c ON e.category_id = c.category_id " +
                        "WHERE e.user_id = ? " +
                        "ORDER BY e.expense_date DESC, e.created_at DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Expense expense = new Expense(
                    rs.getInt("expense_id"),
                    rs.getInt("user_id"),
                    rs.getInt("category_id"),
                    rs.getBigDecimal("amount"),
                    rs.getString("description"),
                    rs.getDate("expense_date").toLocalDate(),
                    rs.getString("payment_method"),
                    rs.getTimestamp("created_at").toLocalDateTime()
                );
                
                // Set additional display fields
                expense.setCategoryName(rs.getString("category_name"));
                expense.setCategoryColor(rs.getString("color"));
                expense.setCategoryIcon(rs.getString("icon"));
                
                expenses.add(expense);
            }
            return expenses;
            
        } catch (SQLException e) {
            System.err.println("Error getting user expenses: " + e.getMessage());
            return expenses;
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
     * Get expenses by date range
     */
    public List<Expense> getExpensesByDateRange(int userId, LocalDate startDate, LocalDate endDate) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Expense> expenses = new ArrayList<>();
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT e.*, c.category_name, c.color, c.icon " +
                        "FROM expenses e " +
                        "JOIN categories c ON e.category_id = c.category_id " +
                        "WHERE e.user_id = ? AND e.expense_date BETWEEN ? AND ? " +
                        "ORDER BY e.expense_date DESC, e.created_at DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            pstmt.setDate(2, Date.valueOf(startDate));
            pstmt.setDate(3, Date.valueOf(endDate));
            
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Expense expense = new Expense(
                    rs.getInt("expense_id"),
                    rs.getInt("user_id"),
                    rs.getInt("category_id"),
                    rs.getBigDecimal("amount"),
                    rs.getString("description"),
                    rs.getDate("expense_date").toLocalDate(),
                    rs.getString("payment_method"),
                    rs.getTimestamp("created_at").toLocalDateTime()
                );
                
                expense.setCategoryName(rs.getString("category_name"));
                expense.setCategoryColor(rs.getString("color"));
                expense.setCategoryIcon(rs.getString("icon"));
                
                expenses.add(expense);
            }
            return expenses;
            
        } catch (SQLException e) {
            System.err.println("Error getting expenses by date range: " + e.getMessage());
            return expenses;
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
     * Get total monthly spending for a user
     */
    public BigDecimal getMonthlyTotal(int userId, int month, int year) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT COALESCE(SUM(amount), 0) as total " +
                        "FROM expenses " +
                        "WHERE user_id = ? AND MONTH(expense_date) = ? AND YEAR(expense_date) = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            pstmt.setInt(2, month);
            pstmt.setInt(3, year);
            
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getBigDecimal("total");
            }
            return BigDecimal.ZERO;
            
        } catch (SQLException e) {
            System.err.println("Error getting monthly total: " + e.getMessage());
            return BigDecimal.ZERO;
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
     * Get category-wise spending for a month
     */
    public List<Object[]> getCategoryWiseSpending(int userId, int month, int year) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Object[]> categorySpending = new ArrayList<>();
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT c.category_name, c.color, c.icon, COALESCE(SUM(e.amount), 0) as total " +
                        "FROM categories c " +
                        "LEFT JOIN expenses e ON c.category_id = e.category_id " +
                        "AND e.user_id = ? AND MONTH(e.expense_date) = ? AND YEAR(e.expense_date) = ? " +
                        "GROUP BY c.category_id, c.category_name, c.color, c.icon " +
                        "HAVING total > 0 " +
                        "ORDER BY total DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            pstmt.setInt(2, month);
            pstmt.setInt(3, year);
            
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Object[] data = new Object[4];
                data[0] = rs.getString("category_name"); // Category name
                data[1] = rs.getBigDecimal("total");     // Total amount
                data[2] = rs.getString("color");         // Color for chart
                data[3] = rs.getString("icon");          // Icon for display
                categorySpending.add(data);
            }
            return categorySpending;
            
        } catch (SQLException e) {
            System.err.println("Error getting category-wise spending: " + e.getMessage());
            return categorySpending;
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
     * Search expenses by description
     */
    public List<Expense> searchExpenses(int userId, String keyword) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Expense> expenses = new ArrayList<>();
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT e.*, c.category_name, c.color, c.icon " +
                        "FROM expenses e " +
                        "JOIN categories c ON e.category_id = c.category_id " +
                        "WHERE e.user_id = ? AND e.description LIKE ? " +
                        "ORDER BY e.expense_date DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            pstmt.setString(2, "%" + keyword + "%");
            
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Expense expense = new Expense(
                    rs.getInt("expense_id"),
                    rs.getInt("user_id"),
                    rs.getInt("category_id"),
                    rs.getBigDecimal("amount"),
                    rs.getString("description"),
                    rs.getDate("expense_date").toLocalDate(),
                    rs.getString("payment_method"),
                    rs.getTimestamp("created_at").toLocalDateTime()
                );
                
                expense.setCategoryName(rs.getString("category_name"));
                expense.setCategoryColor(rs.getString("color"));
                expense.setCategoryIcon(rs.getString("icon"));
                
                expenses.add(expense);
            }
            return expenses;
            
        } catch (SQLException e) {
            System.err.println("Error searching expenses: " + e.getMessage());
            return expenses;
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
}