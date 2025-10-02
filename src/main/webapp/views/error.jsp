<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - Smart Expense Tracker</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gray-50 min-h-screen flex items-center justify-center">
    <div class="max-w-md w-full mx-4 text-center">
        <!-- Error Icon -->
        <div class="w-20 h-20 bg-red-100 rounded-full flex items-center justify-center mx-auto mb-6">
            <i class="fas fa-exclamation-triangle text-red-600 text-3xl"></i>
        </div>

        <!-- Error Message -->
        <h1 class="text-2xl font-bold text-gray-800 mb-4">
            <c:choose>
                <c:when test="${pageContext.errorData.statusCode == 404}">
                    Page Not Found
                </c:when>
                <c:when test="${pageContext.errorData.statusCode == 500}">
                    Server Error
                </c:when>
                <c:otherwise>
                    Something Went Wrong
                </c:otherwise>
            </c:choose>
        </h1>

        <p class="text-gray-600 mb-2">
            <c:choose>
                <c:when test="${pageContext.errorData.statusCode == 404}">
                    The page you're looking for doesn't exist.
                </c:when>
                <c:when test="${pageContext.errorData.statusCode == 500}">
                    We're experiencing some technical difficulties. Please try again later.
                </c:when>
                <c:otherwise>
                    An unexpected error has occurred.
                </c:otherwise>
            </c:choose>
        </p>

        <p class="text-gray-500 text-sm mb-8">
            Error Code: ${pageContext.errorData.statusCode}
        </p>

        <!-- Action Buttons -->
        <div class="space-y-4">
            <a href="dashboard" class="block w-full bg-indigo-600 text-white py-3 px-4 rounded-lg hover:bg-indigo-700 transition duration-200 font-medium">
                <i class="fas fa-home mr-2"></i>Go to Dashboard
            </a>
            
            <a href="login" class="block w-full bg-gray-200 text-gray-700 py-3 px-4 rounded-lg hover:bg-gray-300 transition duration-200 font-medium">
                <i class="fas fa-sign-in-alt mr-2"></i>Back to Login
            </a>
        </div>

        <!-- Support Contact -->
        <div class="mt-8 pt-6 border-t border-gray-200">
            <p class="text-gray-500 text-sm">
                Need help? Contact support at 
                <a href="mailto:support@expensetracker.com" class="text-indigo-600 hover:text-indigo-500">
                    support@expensetracker.com
                </a>
            </p>
        </div>
    </div>
</body>
</html>