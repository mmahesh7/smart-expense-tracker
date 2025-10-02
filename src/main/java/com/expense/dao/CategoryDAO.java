package com.expense.dao;

import com.expense.model.Category;
import com.expense.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Category operations
 */
public class CategoryDAO {
    
    /**
     * Get all categories
     */
    public List<Category> getAllCategories() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Category> categories = new ArrayList<>();
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM categories ORDER BY category_name";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Category category = new Category(
                    rs.getInt("category_id"),
                    rs.getString("category_name"),
                    rs.getString("icon"),
                    rs.getString("color"),
                    rs.getBoolean("is_default")
                );
                categories.add(category);
            }
            return categories;
            
        } catch (SQLException e) {
            System.err.println("Error getting all categories: " + e.getMessage());
            return categories;
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
     * Get category by ID
     */
    public Category getCategoryById(int categoryId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM categories WHERE category_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, categoryId);
            
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return new Category(
                    rs.getInt("category_id"),
                    rs.getString("category_name"),
                    rs.getString("icon"),
                    rs.getString("color"),
                    rs.getBoolean("is_default")
                );
            }
            return null;
            
        } catch (SQLException e) {
            System.err.println("Error getting category by ID: " + e.getMessage());
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
}