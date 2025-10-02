<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Expenses - Smart Expense Tracker</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gray-50">
    <!-- Navigation Bar -->
    <nav class="bg-white shadow-lg">
        <div class="max-w-7xl mx-auto px-4">
            <div class="flex justify-between items-center py-4">
                <!-- Logo -->
                <div class="flex items-center space-x-3">
                    <a href="dashboard" class="flex items-center space-x-3">
                        <div class="w-8 h-8 bg-indigo-600 rounded-lg flex items-center justify-center">
                            <i class="fas fa-wallet text-white text-sm"></i>
                        </div>
                        <span class="text-xl font-bold text-gray-800">ExpenseTracker</span>
                    </a>
                </div>

                <!-- User Menu -->
                <div class="flex items-center space-x-4">
                    <span class="text-gray-700">Welcome, <strong>${sessionScope.fullName}</strong></span>
                    <a href="logout" class="text-gray-600 hover:text-gray-800">
                        <i class="fas fa-sign-out-alt"></i>
                    </a>
                </div>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="max-w-7xl mx-auto px-4 py-8">
        <!-- Header -->
        <div class="mb-8">
            <a href="dashboard" class="inline-flex items-center text-indigo-600 hover:text-indigo-500 mb-4">
                <i class="fas fa-arrow-left mr-2"></i> Back to Dashboard
            </a>
            <div class="flex flex-wrap justify-between items-center">
                <div>
                    <h1 class="text-3xl font-bold text-gray-800">All Expenses</h1>
                    <p class="text-gray-600 mt-2">View and manage your expense history</p>
                </div>
                <a href="add-expense" class="bg-indigo-600 text-white px-6 py-3 rounded-lg hover:bg-indigo-700 transition duration-200 font-medium mt-4 md:mt-0">
                    <i class="fas fa-plus mr-2"></i>Add New Expense
                </a>
            </div>
        </div>

        <!-- Display Messages -->
        <c:if test="${not empty successMessage}">
            <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-6">
                <i class="fas fa-check-circle mr-2"></i>${successMessage}
            </div>
            <c:remove var="successMessage" scope="session"/>
        </c:if>
        
        <c:if test="${not empty errorMessage}">
            <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-6">
                <i class="fas fa-exclamation-circle mr-2"></i>${errorMessage}
            </div>
            <c:remove var="errorMessage" scope="session"/>
        </c:if>

        <!-- Filters Section -->
        <div class="bg-white rounded-xl shadow-sm p-6 mb-6">
            <h3 class="text-lg font-semibold text-gray-800 mb-4">Filter Expenses</h3>
            <form action="view-expenses" method="get" class="grid grid-cols-1 md:grid-cols-4 gap-4">
                <!-- Quick Filters -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">Quick Filters</label>
                    <select name="filter" id="filterSelect" class="block w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500">
                        <option value="">All Time</option>
                        <option value="week" ${param.filter == 'week' ? 'selected' : ''}>This Week</option>
                        <option value="month" ${param.filter == 'month' ? 'selected' : ''}>This Month</option>
                        <option value="year" ${param.filter == 'year' ? 'selected' : ''}>This Year</option>
                    </select>
                </div>

                <!-- Custom Date Range -->
                <div id="startDateDiv">
                    <label class="block text-sm font-medium text-gray-700 mb-2">Start Date</label>
                    <input type="date" name="startDate" value="${param.startDate}"
                           class="block w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500">
                </div>

                <div id="endDateDiv">
                    <label class="block text-sm font-medium text-gray-700 mb-2">End Date</label>
                    <input type="date" name="endDate" value="${param.endDate}"
                           class="block w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500">
                </div>

                <!-- Search -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">Search</label>
                    <div class="flex space-x-2">
                        <input type="text" name="search" value="${param.search}"
                               class="block w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500"
                               placeholder="Search descriptions...">
                        <button type="submit" class="bg-indigo-600 text-white px-4 py-2 rounded-lg hover:bg-indigo-700 transition duration-200">
                            <i class="fas fa-search"></i>
                        </button>
                    </div>
                </div>
            </form>

            <!-- Active Filters -->
            <c:if test="${not empty param.filter or not empty param.search or not empty param.startDate}">
                <div class="mt-4 flex flex-wrap gap-2">
                    <c:if test="${not empty param.filter}">
                        <span class="bg-blue-100 text-blue-800 px-3 py-1 rounded-full text-sm">
                            Filter: ${param.filter}
                            <a href="view-expenses" class="ml-1 text-blue-600 hover:text-blue-800">
                                <i class="fas fa-times"></i>
                            </a>
                        </span>
                    </c:if>
                    <c:if test="${not empty param.startDate and not empty param.endDate}">
                        <span class="bg-purple-100 text-purple-800 px-3 py-1 rounded-full text-sm">
                            Date Range: ${param.startDate} to ${param.endDate}
                            <a href="view-expenses" class="ml-1 text-purple-600 hover:text-purple-800">
                                <i class="fas fa-times"></i>
                            </a>
                        </span>
                    </c:if>
                    <c:if test="${not empty param.search}">
                        <span class="bg-green-100 text-green-800 px-3 py-1 rounded-full text-sm">
                            Search: "${param.search}"
                            <a href="view-expenses" class="ml-1 text-green-600 hover:text-green-800">
                                <i class="fas fa-times"></i>
                            </a>
                        </span>
                    </c:if>
                    <a href="view-expenses" class="text-gray-600 hover:text-gray-800 text-sm flex items-center">
                        <i class="fas fa-times mr-1"></i> Clear all
                    </a>
                </div>
            </c:if>
        </div>

        <!-- Expenses Table -->
        <div class="bg-white rounded-xl shadow-sm overflow-hidden">
            <div class="overflow-x-auto">
                <table class="min-w-full divide-y divide-gray-200">
                    <thead class="bg-gray-50">
                        <tr>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Category
                            </th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Description
                            </th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Amount
                            </th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Date
                            </th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Payment
                            </th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Actions
                            </th>
                        </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-200">
                        <c:forEach var="expense" items="${expenses}">
                            <tr class="hover:bg-gray-50">
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <div class="flex items-center">
                                        <div class="w-8 h-8 ${expense.categoryColor} rounded-lg flex items-center justify-center mr-3">
                                            <i class="${expense.categoryIcon} text-white text-sm"></i>
                                        </div>
                                        <span class="text-sm font-medium text-gray-900">${expense.categoryName}</span>
                                    </div>
                                </td>
                                <td class="px-6 py-4">
                                    <div class="text-sm text-gray-900 max-w-xs truncate">
                                        <c:choose>
                                            <c:when test="${not empty expense.description}">${expense.description}</c:when>
                                            <c:otherwise><span class="text-gray-400">No description</span></c:otherwise>
                                        </c:choose>
                                    </div>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <span class="text-sm font-semibold text-gray-900">
                                        ₹<fmt:formatNumber value="${expense.amount}" pattern="#,##0.00"/>
                                    </span>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <span class="text-sm text-gray-500">
                                        <fmt:formatDate value="${expense.expenseDateAsDate}" pattern="MMM dd, yyyy"/>
                                    </span>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium 
                                        <c:choose>
                                            <c:when test="${expense.paymentMethod == 'CASH'}">bg-green-100 text-green-800</c:when>
                                            <c:when test="${expense.paymentMethod == 'CARD'}">bg-blue-100 text-blue-800</c:when>
                                            <c:when test="${expense.paymentMethod == 'UPI'}">bg-purple-100 text-purple-800</c:when>
                                            <c:otherwise>bg-gray-100 text-gray-800</c:otherwise>
                                        </c:choose>">
                                        ${expense.paymentMethod}
                                    </span>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                                    <form action="delete-expense" method="post" class="inline" onsubmit="return confirmDelete()">
                                        <input type="hidden" name="expenseId" value="${expense.expenseId}">
                                        <button type="submit" class="text-red-600 hover:text-red-900">
                                            <i class="fas fa-trash"></i> Delete
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                        
                        <c:if test="${empty expenses}">
                            <tr>
                                <td colspan="6" class="px-6 py-12 text-center">
                                    <div class="text-gray-500">
                                        <i class="fas fa-receipt text-4xl mb-3 opacity-50"></i>
                                        <p class="text-lg">No expenses found</p>
                                        <p class="text-sm mt-1">
                                            <c:choose>
                                                <c:when test="${not empty param.filter or not empty param.search or not empty param.startDate}">
                                                    Try adjusting your filters or search terms
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="add-expense" class="text-indigo-600 hover:underline">Add your first expense</a>
                                                </c:otherwise>
                                            </c:choose>
                                        </p>
                                    </div>
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Total Summary -->
        <c:if test="${not empty expenses}">
            <div class="mt-6 bg-indigo-50 rounded-xl p-6">
                <div class="flex justify-between items-center">
                    <div>
                        <h3 class="text-lg font-semibold text-indigo-800">Total Expenses</h3>
                        <p class="text-indigo-600">
                            <c:choose>
                                <c:when test="${filterType == 'week'}">This Week</c:when>
                                <c:when test="${filterType == 'month'}">This Month</c:when>
                                <c:when test="${filterType == 'year'}">This Year</c:when>
                                <c:when test="${filterType == 'custom'}">Custom Date Range</c:when>
                                <c:when test="${filterType == 'search'}">Search Results</c:when>
                                <c:otherwise>All Time</c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                    <div class="text-right">
                        <p class="text-3xl font-bold text-indigo-800">
                            ₹<fmt:formatNumber value="${totalAmount != null ? totalAmount : 0}" pattern="#,##0.00"/>
                        </p>
                        <p class="text-indigo-600">${expenseCount} expense(s)</p>
                    </div>
                </div>
            </div>
        </c:if>
    </div>

    <script>
        function confirmDelete() {
            return confirm('Are you sure you want to delete this expense? This action cannot be undone.');
        }

        // Show/hide custom date inputs based on filter selection
        const filterSelect = document.getElementById('filterSelect');
        const startDateDiv = document.getElementById('startDateDiv');
        const endDateDiv = document.getElementById('endDateDiv');

        function toggleCustomDates() {
            const filterValue = filterSelect.value;
            
            // Always show date inputs for custom filtering
            if (filterValue === '' || filterValue === 'week' || filterValue === 'month' || filterValue === 'year') {
                // Show date inputs even with quick filters so users can override
                startDateDiv.style.display = 'block';
                endDateDiv.style.display = 'block';
            } else {
                startDateDiv.style.display = 'block';
                endDateDiv.style.display = 'block';
            }
        }

        if (filterSelect) {
            filterSelect.addEventListener('change', toggleCustomDates);
            
            // Initialize on page load
            document.addEventListener('DOMContentLoaded', toggleCustomDates);
        }
    </script>
</body>
</html>