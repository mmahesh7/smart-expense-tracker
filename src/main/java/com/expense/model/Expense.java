package com.expense.model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;

/**
 * Expense model class representing the expenses table
 */
public class Expense {
    private int expenseId;
    private int userId;
    private int categoryId;
    private BigDecimal amount;
    private String description;
    private LocalDate expenseDate;
    private String paymentMethod;
    private LocalDateTime createdAt;
    
    // Additional fields for display (not in database)
    private String categoryName;
    private String categoryColor;
    private String categoryIcon;
    
    // Default constructor
    public Expense() {
    }
    
    // Parameterized constructor for new expenses (without expenseId and createdAt)
    public Expense(int userId, int categoryId, BigDecimal amount, String description, 
                   LocalDate expenseDate, String paymentMethod) {
        this.userId = userId;
        this.categoryId = categoryId;
        this.amount = amount;
        this.description = description;
        this.expenseDate = expenseDate;
        this.paymentMethod = paymentMethod;
    }
    
    // Full parameterized constructor
    public Expense(int expenseId, int userId, int categoryId, BigDecimal amount, 
                   String description, LocalDate expenseDate, String paymentMethod, 
                   LocalDateTime createdAt) {
        this.expenseId = expenseId;
        this.userId = userId;
        this.categoryId = categoryId;
        this.amount = amount;
        this.description = description;
        this.expenseDate = expenseDate;
        this.paymentMethod = paymentMethod;
        this.createdAt = createdAt;
    }
    
    // Getters and Setters
    public int getExpenseId() { return expenseId; }
    public void setExpenseId(int expenseId) { this.expenseId = expenseId; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }
    
    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public LocalDate getExpenseDate() { return expenseDate; }
    public void setExpenseDate(LocalDate expenseDate) { this.expenseDate = expenseDate; }

    // New helper method for JSP
    public Date getExpenseDateAsDate() {
        if (expenseDate != null) {
            return Date.from(expenseDate.atStartOfDay(ZoneId.systemDefault()).toInstant());
        }
        return null;
    }
    
    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }
    
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    
    // Additional display field getters and setters
    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }
    
    public String getCategoryColor() { return categoryColor; }
    public void setCategoryColor(String categoryColor) { this.categoryColor = categoryColor; }
    
    public String getCategoryIcon() { return categoryIcon; }
    public void setCategoryIcon(String categoryIcon) { this.categoryIcon = categoryIcon; }
    
    @Override
    public String toString() {
        return "Expense{" +
                "expenseId=" + expenseId +
                ", userId=" + userId +
                ", categoryId=" + categoryId +
                ", amount=" + amount +
                ", description='" + description + '\'' +
                ", expenseDate=" + expenseDate +
                ", paymentMethod='" + paymentMethod + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
