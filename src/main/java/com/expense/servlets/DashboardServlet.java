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
            
            // Set attributes for JSP
            request.setAttribute("monthlyTotal", monthlyTotal);
            request.setAttribute("categorySpending", categorySpending);
            request.setAttribute("recentExpenses", recentExpenses);
            request.setAttribute("budgetStatus", budgetStatus);
            request.setAttribute("currentMonth", now.getMonth().toString());
            request.setAttribute("currentYear", currentYear);
            
            // Forward to dashboard
            request.getRequestDispatcher("/views/dashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading dashboard data.");
            request.getRequestDispatcher("/views/dashboard.jsp").forward(request, response);
        }
    }
}