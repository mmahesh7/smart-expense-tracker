package com.expense.servlets;

import com.expense.dao.UserDAO;
import com.expense.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Servlet for user login
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Clear any previous error messages from session
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.removeAttribute("errorMessage");
            session.removeAttribute("successMessage");
        }
        
        // If user is already logged in, redirect to dashboard
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect("dashboard");
            return;
        }
        
        // Forward to login page
        request.getRequestDispatcher("/views/login.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        // Basic validation
        if (username == null || username.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            
            request.setAttribute("errorMessage", "Username/Email and password are required!");
            request.getRequestDispatcher("/views/login.jsp").forward(request, response);
            return;
        }
        
        try {
            // Authenticate user
            User user = userDAO.loginUser(username, password);
            
            if (user != null) {
                // Login successful - create session
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setAttribute("userId", user.getUserId());
                session.setAttribute("username", user.getUsername());
                session.setAttribute("fullName", user.getFullName());
                
                // Set session timeout to 30 minutes
                session.setMaxInactiveInterval(30 * 60);
                
                // Redirect to dashboard
                response.sendRedirect("dashboard");
            } else {
                // Login failed
                request.setAttribute("errorMessage", "Invalid username/email or password!");
                request.setAttribute("username", username);
                request.getRequestDispatcher("/views/login.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred during login.");
            request.getRequestDispatcher("/views/login.jsp").forward(request, response);
        }
    }
}