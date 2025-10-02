package com.expense.filters;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Enhanced authentication filter with better URL pattern handling
 */
@WebFilter("/*")
public class AuthenticationFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("🔐 AuthenticationFilter initialized");
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String path = requestURI.substring(contextPath.length());
        
        // Allow static resources and public pages
        boolean isStaticResource = path.startsWith("/css/") || 
                                 path.startsWith("/js/") || 
                                 path.startsWith("/images/") ||
                                 path.endsWith(".css") ||
                                 path.endsWith(".js") ||
                                 path.endsWith(".png") ||
                                 path.endsWith(".jpg") ||
                                 path.endsWith(".ico");
        
        boolean isPublicPage = path.equals("/login") || 
                             path.equals("/register") ||
                             path.equals("/") ||
                             path.equals("/index.jsp") ||
                             path.equals("/test-setup.jsp");
        
        boolean isApiRequest = path.startsWith("/api/");
        
        // Check if user is logged in
        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);
        
        // Debug information
        System.out.println("🔍 Filter - Path: " + path + ", LoggedIn: " + isLoggedIn + ", Static: " + isStaticResource);
        
        if (isStaticResource || isPublicPage || isApiRequest) {
            // Allow access to static resources and public pages
            chain.doFilter(request, response);
        } else if (!isLoggedIn) {
            // Redirect to login if not logged in and trying to access protected resource
            System.out.println("🚫 Access denied - redirecting to login");
            httpResponse.sendRedirect(contextPath + "/login");
        } else {
            // User is logged in, allow access
            chain.doFilter(request, response);
        }
    }
    
    @Override
    public void destroy() {
        System.out.println("🔐 AuthenticationFilter destroyed");
    }
}