package com.expense.servlets;

import com.expense.dao.UserDAO;
import com.expense.model.User;
import com.expense.util.PasswordUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Servlet for user registration
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // If user is already logged in, redirect to dashboard
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect("dashboard");
            return;
        }
        
        // Forward to registration page
        request.getRequestDispatcher("/views/register.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Get form parameters
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Basic validation
        if (fullName == null || fullName.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            
            request.setAttribute("errorMessage", "All fields are required!");
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
            return;
        }
        
        // Check if passwords match
        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match!");
            request.setAttribute("fullName", fullName);
            request.setAttribute("email", email);
            request.setAttribute("username", username);
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
            return;
        }
        
        // Check password strength
        if (!PasswordUtil.isValidPassword(password)) {
            request.setAttribute("errorMessage", "Password must be at least 6 characters long!");
            request.setAttribute("fullName", fullName);
            request.setAttribute("email", email);
            request.setAttribute("username", username);
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
            return;
        }
        
        try {
            // Check if email already exists
            if (userDAO.isEmailExists(email)) {
                request.setAttribute("errorMessage", "Email already registered!");
                request.setAttribute("fullName", fullName);
                request.setAttribute("username", username);
                request.getRequestDispatcher("/views/register.jsp").forward(request, response);
                return;
            }
            
            // Check if username already exists
            if (userDAO.isUsernameExists(username)) {
                request.setAttribute("errorMessage", "Username already taken!");
                request.setAttribute("fullName", fullName);
                request.setAttribute("email", email);
                request.getRequestDispatcher("/views/register.jsp").forward(request, response);
                return;
            }
            
            // Hash password
            String hashedPassword = PasswordUtil.hashPassword(password);
            
            // Create user object
            User user = new User(username, email, hashedPassword, fullName);
            
            // Register user
            boolean success = userDAO.registerUser(user);
            
            if (success) {
                // Registration successful - redirect to login with success message
                HttpSession session = request.getSession();
                session.setAttribute("successMessage", "Registration successful! Please login.");
                response.sendRedirect("login");
                return;
            } else {
                request.setAttribute("errorMessage", "Registration failed! Please try again.");
                request.getRequestDispatcher("/views/register.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred during registration.");
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
        }
    }
}