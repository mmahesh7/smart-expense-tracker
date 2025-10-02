package com.expense.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Budget model class representing the budgets table
 */
public class Budget {
    private int budgetId;
    private int userId;
    private int month;
    private int year;
    private BigDecimal budgetAmount;
    private int alertThreshold;
    private LocalDateTime createdAt;
    
    // Additional fields for display (calculated)
    private BigDecimal totalSpent;
    private double percentageUsed;
    private String status; // "safe", "warning", "exceeded"
    
    // Default constructor
    public Budget() {
    }
    
    // Parameterized constructor for new budgets (without budgetId and createdAt)
    public Budget(int userId, int month, int year, BigDecimal budgetAmount) {
        this.userId = userId;
        this.month = month;
        this.year = year;
        this.budgetAmount = budgetAmount;
        this.alertThreshold = 80; // Default threshold
    }
    
    // Full parameterized constructor
    public Budget(int budgetId, int userId, int month, int year, 
                  BigDecimal budgetAmount, int alertThreshold, LocalDateTime createdAt) {
        this.budgetId = budgetId;
        this.userId = userId;
        this.month = month;
        this.year = year;
        this.budgetAmount = budgetAmount;
        this.alertThreshold = alertThreshold;
        this.createdAt = createdAt;
    }
    
    // Getters and Setters
    public int getBudgetId() {
        return budgetId;
    }
    
    public void setBudgetId(int budgetId) {
        this.budgetId = budgetId;
    }
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public int getMonth() {
        return month;
    }
    
    public void setMonth(int month) {
        this.month = month;
    }
    
    public int getYear() {
        return year;
    }
    
    public void setYear(int year) {
        this.year = year;
    }
    
    public BigDecimal getBudgetAmount() {
        return budgetAmount;
    }
    
    public void setBudgetAmount(BigDecimal budgetAmount) {
        this.budgetAmount = budgetAmount;
    }
    
    public int getAlertThreshold() {
        return alertThreshold;
    }
    
    public void setAlertThreshold(int alertThreshold) {
        this.alertThreshold = alertThreshold;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    // Additional calculated field getters and setters
    public BigDecimal getTotalSpent() {
        return totalSpent;
    }
    
    public void setTotalSpent(BigDecimal totalSpent) {
        this.totalSpent = totalSpent;
    }
    
    public double getPercentageUsed() {
        return percentageUsed;
    }
    
    public void setPercentageUsed(double percentageUsed) {
        this.percentageUsed = percentageUsed;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    /**
     * Calculate and set the status based on percentage used
     */
    public void calculateStatus() {
        if (percentageUsed >= 100) {
            this.status = "exceeded";
        } else if (percentageUsed >= alertThreshold) {
            this.status = "warning";
        } else {
            this.status = "safe";
        }
    }
    
    @Override
    public String toString() {
        return "Budget{" +
                "budgetId=" + budgetId +
                ", userId=" + userId +
                ", month=" + month +
                ", year=" + year +
                ", budgetAmount=" + budgetAmount +
                ", alertThreshold=" + alertThreshold +
                ", createdAt=" + createdAt +
                '}';
    }
}