package com.expense.servlets;

import com.expense.dao.BudgetDAO;
import com.expense.model.Budget;
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
 * Servlet for budget management
 */
@WebServlet("/budget")
public class BudgetServlet extends HttpServlet {
    private BudgetDAO budgetDAO;
    
    @Override
    public void init() throws ServletException {
        System.out.println("💰 BudgetServlet initialized");
        budgetDAO = new BudgetDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("🔍 BudgetServlet doGet called");
        
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            System.out.println("🚫 User not logged in, redirecting to login");
            response.sendRedirect("login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        int userId = user.getUserId();
        
        System.out.println("👤 User ID: " + userId);
        
        try {
            // Get current month and year
            LocalDate now = LocalDate.now();
            int currentMonth = now.getMonthValue();
            int currentYear = now.getYear();
            
            System.out.println("📅 Getting budget for: " + currentMonth + "/" + currentYear);
            
            // Get current budget status
            Budget budgetStatus = budgetDAO.getBudgetStatus(userId, currentMonth, currentYear);
            
            System.out.println("💰 Budget status: " + (budgetStatus != null ? "Found" : "Not found"));
            
            request.setAttribute("budgetStatus", budgetStatus);
            request.setAttribute("currentMonth", currentMonth);
            request.setAttribute("currentYear", currentYear);
            
            // Forward to JSP
            System.out.println("➡️ Forwarding to budget.jsp");
            request.getRequestDispatcher("/views/budget.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("❌ Error in BudgetServlet doGet: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error loading budget information: " + e.getMessage());
            response.sendRedirect("dashboard");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("🔍 BudgetServlet doPost called");
        
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
            String monthStr = request.getParameter("month");
            String yearStr = request.getParameter("year");
            String budgetAmountStr = request.getParameter("budgetAmount");
            
            System.out.println("📊 Form data - Month: " + monthStr + ", Year: " + yearStr + ", Amount: " + budgetAmountStr);
            
            // Validate required fields
            if (monthStr == null || monthStr.trim().isEmpty() ||
                yearStr == null || yearStr.trim().isEmpty() ||
                budgetAmountStr == null || budgetAmountStr.trim().isEmpty()) {
                
                session.setAttribute("errorMessage", "Month, year, and budget amount are required!");
                response.sendRedirect("budget");
                return;
            }
            
            // Parse parameters
            int month = Integer.parseInt(monthStr);
            int year = Integer.parseInt(yearStr);
            BigDecimal budgetAmount = new BigDecimal(budgetAmountStr);
            
            // Validate budget amount
            if (budgetAmount.compareTo(BigDecimal.ZERO) <= 0) {
                session.setAttribute("errorMessage", "Budget amount must be greater than zero!");
                response.sendRedirect("budget");
                return;
            }
            
            // Validate month and year
            if (month < 1 || month > 12) {
                session.setAttribute("errorMessage", "Invalid month!");
                response.sendRedirect("budget");
                return;
            }
            
            // Create budget object
            Budget budget = new Budget(userId, month, year, budgetAmount);
            
            // Save budget
            boolean success = budgetDAO.setBudget(budget);
            
            if (success) {
                session.setAttribute("successMessage", "Budget set successfully!");
                System.out.println("✅ Budget set successfully");
            } else {
                session.setAttribute("errorMessage", "Failed to set budget. Please try again.");
                System.out.println("❌ Failed to set budget");
            }
            
            response.sendRedirect("budget");
            
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid number format!");
            response.sendRedirect("budget");
        } catch (Exception e) {
            System.err.println("❌ Error in BudgetServlet doPost: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "An error occurred while setting budget.");
            response.sendRedirect("budget");
        }
    }
}