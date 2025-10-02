package com.expense.model;

/**
 * Category model class representing the categories table
 */
public class Category {
    private int categoryId;
    private String categoryName;
    private String icon;
    private String color;
    private boolean isDefault;
    
    // Default constructor
    public Category() {
    }
    
    // Parameterized constructor
    public Category(int categoryId, String categoryName, String icon, String color, boolean isDefault) {
        this.categoryId = categoryId;
        this.categoryName = categoryName;
        this.icon = icon;
        this.color = color;
        this.isDefault = isDefault;
    }
    
    // Getters and Setters
    public int getCategoryId() {
        return categoryId;
    }
    
    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }
    
    public String getCategoryName() {
        return categoryName;
    }
    
    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }
    
    public String getIcon() {
        return icon;
    }
    
    public void setIcon(String icon) {
        this.icon = icon;
    }
    
    public String getColor() {
        return color;
    }
    
    public void setColor(String color) {
        this.color = color;
    }
    
    public boolean isDefault() {
        return isDefault;
    }
    
    public void setDefault(boolean isDefault) {
        this.isDefault = isDefault;
    }
    
    @Override
    public String toString() {
        return "Category{" +
                "categoryId=" + categoryId +
                ", categoryName='" + categoryName + '\'' +
                ", icon='" + icon + '\'' +
                ", color='" + color + '\'' +
                ", isDefault=" + isDefault +
                '}';
    }
}