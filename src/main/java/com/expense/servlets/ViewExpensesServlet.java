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
import java.util.List;

/**
 * Servlet for viewing and filtering expenses
 */
@WebServlet("/view-expenses")
public class ViewExpensesServlet extends HttpServlet {
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
        
        User user = (User) session.getAttribute("user");
        int userId = user.getUserId();
        
        try {
            // Get filter parameters
            String filter = request.getParameter("filter");
            String startDateStr = request.getParameter("startDate");
            String endDateStr = request.getParameter("endDate");
            String searchKeyword = request.getParameter("search");
            
            List<Expense> expenses;
            LocalDate startDate = null;
            LocalDate endDate = null;
            
            // Apply filters
            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                // Search by description
                expenses = expenseDAO.searchExpenses(userId, searchKeyword.trim());
                request.setAttribute("searchKeyword", searchKeyword.trim());
                request.setAttribute("filterType", "search");
                
            } else if (startDateStr != null && !startDateStr.trim().isEmpty() &&
                       endDateStr != null && !endDateStr.trim().isEmpty()) {
                // Custom date range filter
                startDate = LocalDate.parse(startDateStr);
                endDate = LocalDate.parse(endDateStr);
                expenses = expenseDAO.getExpensesByDateRange(userId, startDate, endDate);
                request.setAttribute("startDate", startDateStr);
                request.setAttribute("endDate", endDateStr);
                request.setAttribute("filterType", "custom");
                
            } else if (filter != null && !filter.isEmpty()) {
                // Quick filter options
                endDate = LocalDate.now();
                
                switch (filter) {
                    case "week":
                        startDate = LocalDate.now().minusWeeks(1);
                        request.setAttribute("filterType", "week");
                        break;
                    case "month":
                        startDate = LocalDate.now().withDayOfMonth(1);
                        request.setAttribute("filterType", "month");
                        break;
                    case "year":
                        startDate = LocalDate.now().withDayOfYear(1);
                        request.setAttribute("filterType", "year");
                        break;
                    default:
                        // All time
                        startDate = LocalDate.now().minusYears(10);
                        request.setAttribute("filterType", "all");
                }
                
                expenses = expenseDAO.getExpensesByDateRange(userId, startDate, endDate);
                
            } else {
                // Default: show all expenses
                expenses = expenseDAO.getUserExpenses(userId);
                request.setAttribute("filterType", "all");
            }
            
            // Calculate total amount
            BigDecimal totalAmount = BigDecimal.ZERO;
            for (Expense expense : expenses) {
                totalAmount = totalAmount.add(expense.getAmount());
            }
            
            // Get categories for filter dropdown
            request.setAttribute("categories", categoryDAO.getAllCategories());
            request.setAttribute("expenses", expenses);
            request.setAttribute("totalAmount", totalAmount);
            request.setAttribute("expenseCount", expenses.size());
            
            request.getRequestDispatcher("/views/view-expenses.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error loading expenses.");
            response.sendRedirect("dashboard");
        }
    }
}