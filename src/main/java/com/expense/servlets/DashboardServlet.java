package com.expense.servlets;

import com.expense.dao.BudgetDAO;
import com.expense.dao.CategoryDAO;
import com.expense.dao.ExpenseDAO;
import com.expense.model.Budget;
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
import java.util.ArrayList;
import java.util.List;

/**
 * Servlet for dashboard page
 */
@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    private ExpenseDAO expenseDAO;
    private BudgetDAO budgetDAO;
    private CategoryDAO categoryDAO;
    
    @Override
    public void init() throws ServletException {
        expenseDAO = new ExpenseDAO();
        budgetDAO = new BudgetDAO();
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
            User user = (User) session.getAttribute("user");
            int userId = user.getUserId();
            
            // Get current month and year
            LocalDate now = LocalDate.now();
            int currentMonth = now.getMonthValue();
            int currentYear = now.getYear();
            
            // Get dashboard data
            BigDecimal monthlyTotal = expenseDAO.getMonthlyTotal(userId, currentMonth, currentYear);
            List<Object[]> categorySpending = expenseDAO.getCategoryWiseSpending(userId, currentMonth, currentYear);
            List<Expense> recentExpenses = expenseDAO.getExpensesByDateRange(
                userId, now.minusDays(7), now); // Last 7 days
            
            // Get budget status
            Budget budgetStatus = budgetDAO.getBudgetStatus(userId, currentMonth, currentYear);
            
            // Get monthly trend data for last 6 months
            List<Object[]> monthlyTrend = getMonthlyTrendData(userId, currentMonth, currentYear);
            
            // Set attributes for JSP
            request.setAttribute("monthlyTotal", monthlyTotal);
            request.setAttribute("categorySpending", categorySpending);
            request.setAttribute("recentExpenses", recentExpenses);
            request.setAttribute("budgetStatus", budgetStatus);
            request.setAttribute("monthlyTrend", monthlyTrend);
            request.setAttribute("currentMonth", now.getMonth().toString());
            request.setAttribute("currentYear", currentYear);
            
            // Forward to dashboard
            request.getRequestDispatcher("/views/dashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading dashboard data: " + e.getMessage());
            request.getRequestDispatcher("/views/dashboard.jsp").forward(request, response);
        }
    }
    
    /**
     * Get monthly trend data for the last 6 months
     */
    private List<Object[]> getMonthlyTrendData(int userId, int currentMonth, int currentYear) {
        List<Object[]> monthlyTrend = new ArrayList<>();
        
        // Get data for last 6 months
        for (int i = 5; i >= 0; i--) {
            LocalDate date = LocalDate.now().minusMonths(i);
            int month = date.getMonthValue();
            int year = date.getYear();
            String monthName = date.getMonth().toString().substring(0, 3); // Short month name
            
            BigDecimal monthlyTotal = expenseDAO.getMonthlyTotal(userId, month, year);
            if (monthlyTotal == null) {
                monthlyTotal = BigDecimal.ZERO;
            }
            
            Object[] monthData = new Object[3];
            monthData[0] = monthName;              // Month name for display
            monthData[1] = monthlyTotal;           // Total amount
            monthData[2] = monthName + " " + year; // Full label
            
            monthlyTrend.add(monthData);
        }
        
        return monthlyTrend;
    }
}