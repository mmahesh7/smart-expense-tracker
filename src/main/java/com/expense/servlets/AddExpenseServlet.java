package com.expense.servlets;

import com.expense.dao.CategoryDAO;
import com.expense.dao.ExpenseDAO;
import com.expense.model.Expense;
import com.expense.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * Servlet for adding expenses
 */
@WebServlet("/add-expense")
public class AddExpenseServlet extends HttpServlet {
    private ExpenseDAO expenseDAO;
    private CategoryDAO categoryDAO;
    
    @Override
    public void init() throws ServletException {
        expenseDAO = new ExpenseDAO();
        categoryDAO = new CategoryDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }
        
        try {
            // Get categories for dropdown
            request.setAttribute("categories", categoryDAO.getAllCategories());
            request.getRequestDispatcher("/views/add-expense.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error loading categories.");
            response.sendRedirect("dashboard");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        int userId = user.getUserId();
        
        try {
            // Get form parameters
            String amountStr = request.getParameter("amount");
            String categoryIdStr = request.getParameter("categoryId");
            String description = request.getParameter("description");
            String expenseDateStr = request.getParameter("expenseDate");
            String paymentMethod = request.getParameter("paymentMethod");
            
            // Validate required fields
            if (amountStr == null || amountStr.trim().isEmpty() ||
                categoryIdStr == null || categoryIdStr.trim().isEmpty() ||
                expenseDateStr == null || expenseDateStr.trim().isEmpty()) {
                
                session.setAttribute("errorMessage", "Amount, category, and date are required!");
                response.sendRedirect("add-expense");
                return;
            }
            
            // Parse and validate amount
            BigDecimal amount;
            try {
                amount = new BigDecimal(amountStr);
                if (amount.compareTo(BigDecimal.ZERO) <= 0) {
                    session.setAttribute("errorMessage", "Amount must be greater than zero!");
                    response.sendRedirect("add-expense");
                    return;
                }
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "Invalid amount format!");
                response.sendRedirect("add-expense");
                return;
            }
            
            // Parse category ID
            int categoryId = Integer.parseInt(categoryIdStr);
            
            // Parse date
            LocalDate expenseDate = LocalDate.parse(expenseDateStr);
            
            // Validate date is not in future
            if (expenseDate.isAfter(LocalDate.now())) {
                session.setAttribute("errorMessage", "Expense date cannot be in the future!");
                response.sendRedirect("add-expense");
                return;
            }
            
            // Set default payment method if not provided
            if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
                paymentMethod = "CASH";
            }
            
            // Create expense object
            Expense expense = new Expense(userId, categoryId, amount, description, expenseDate, paymentMethod);
            
            // Save expense
            boolean success = expenseDAO.addExpense(expense);
            
            if (success) {
                session.setAttribute("successMessage", "Expense added successfully!");
                response.sendRedirect("dashboard"); // REDIRECT - prevents duplicate on refresh
            } else {
                session.setAttribute("errorMessage", "Failed to add expense. Please try again.");
                response.sendRedirect("add-expense");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "An error occurred while adding expense.");
            response.sendRedirect("add-expense");
        }
    }
}