<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // Check if user is already logged in
    HttpSession userSession = request.getSession(false);
    if (userSession != null && userSession.getAttribute("user") != null) {
        response.sendRedirect("dashboard");
    } else {
        response.sendRedirect("login");
    }
%>