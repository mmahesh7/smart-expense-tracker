package com.expense.servlets;

import com.expense.dao.ExpenseDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Servlet for deleting expenses
 */
@WebServlet("/delete-expense")
public class DeleteExpenseServlet extends HttpServlet {
    private ExpenseDAO expenseDAO;
    
    @Override
    public void init() throws ServletException {
        expenseDAO = new ExpenseDAO();
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
        
        int userId = (Integer) session.getAttribute("userId");
        
        try {
            // Get expense ID to delete
            String expenseIdStr = request.getParameter("expenseId");
            
            if (expenseIdStr == null || expenseIdStr.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Invalid expense ID!");
                response.sendRedirect("view-expenses");
                return;
            }
            
            int expenseId = Integer.parseInt(expenseIdStr);
            
            // Delete expense (only if it belongs to the user)
            boolean success = expenseDAO.deleteExpense(expenseId, userId);
            
            if (success) {
                session.setAttribute("successMessage", "Expense deleted successfully!");
            } else {
                session.setAttribute("errorMessage", "Failed to delete expense or expense not found!");
            }
            
            response.sendRedirect("view-expenses");
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "An error occurred while deleting expense.");
            response.sendRedirect("view-expenses");
        }
    }
}