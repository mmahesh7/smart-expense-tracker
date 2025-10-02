<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Budget - Smart Expense Tracker</title>
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
    <div class="max-w-4xl mx-auto px-4 py-8">
        <!-- Header -->
        <div class="mb-8">
            <a href="dashboard" class="inline-flex items-center text-indigo-600 hover:text-indigo-500 mb-4">
                <i class="fas fa-arrow-left mr-2"></i> Back to Dashboard
            </a>
            <h1 class="text-3xl font-bold text-gray-800">Budget Management</h1>
            <p class="text-gray-600 mt-2">Set and track your monthly spending limits</p>
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

        <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
            <!-- Set Budget Form -->
            <div class="bg-white rounded-xl shadow-sm p-6">
                <h2 class="text-xl font-semibold text-gray-800 mb-6">Set Monthly Budget</h2>
                
                <form action="budget" method="post" onsubmit="return validateBudgetForm()">
                    <div class="space-y-4">
                        <!-- Month and Year -->
                        <div class="grid grid-cols-2 gap-4">
                            <div>
                                <label for="month" class="block text-sm font-medium text-gray-700 mb-2">
                                    Month *
                                </label>
                                <select id="month" name="month" 
                                        class="block w-full px-3 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500" required>
                                    <option value="">Select Month</option>
                                    <option value="1">January</option>
                                    <option value="2">February</option>
                                    <option value="3">March</option>
                                    <option value="4">April</option>
                                    <option value="5">May</option>
                                    <option value="6">June</option>
                                    <option value="7">July</option>
                                    <option value="8">August</option>
                                    <option value="9">September</option>
                                    <option value="10">October</option>
                                    <option value="11">November</option>
                                    <option value="12">December</option>
                                </select>
                            </div>
                            
                            <div>
                                <label for="year" class="block text-sm font-medium text-gray-700 mb-2">
                                    Year *
                                </label>
                                <input type="number" id="year" name="year" 
                                       value="${currentYear}" min="2020" max="2030"
                                       class="block w-full px-3 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500" required>
                            </div>
                        </div>

                        <!-- Budget Amount -->
                        <div>
                            <label for="budgetAmount" class="block text-sm font-medium text-gray-700 mb-2">
                                Budget Amount *
                            </label>
                            <div class="relative">
                                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                    <span class="text-gray-500">₹</span>
                                </div>
                                <input type="number" id="budgetAmount" name="budgetAmount" step="0.01" min="0.01"
                                       class="block w-full pl-10 pr-3 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500"
                                       placeholder="5000.00" required>
                            </div>
                        </div>

                        <!-- Submit Button -->
                        <button type="submit" 
                                class="w-full bg-indigo-600 text-white py-3 px-4 rounded-lg hover:bg-indigo-700 focus:ring-4 focus:ring-indigo-200 transition duration-200 font-medium">
                            <i class="fas fa-save mr-2"></i>Set Budget
                        </button>
                    </div>
                </form>

                <!-- Budget Tips -->
                <div class="mt-6 pt-6 border-t border-gray-200">
                    <h4 class="font-medium text-gray-800 mb-2">Budgeting Tips</h4>
                    <ul class="text-sm text-gray-600 space-y-1">
                        <li class="flex items-start">
                            <i class="fas fa-check text-green-500 mr-2 mt-0.5"></i>
                            <span>Set realistic budgets based on your income</span>
                        </li>
                        <li class="flex items-start">
                            <i class="fas fa-check text-green-500 mr-2 mt-0.5"></i>
                            <span>Review and adjust budgets monthly</span>
                        </li>
                        <li class="flex items-start">
                            <i class="fas fa-check text-green-500 mr-2 mt-0.5"></i>
                            <span>Track spending regularly to stay on target</span>
                        </li>
                    </ul>
                </div>
            </div>

            <!-- Current Budget Status -->
            <div class="bg-white rounded-xl shadow-sm p-6">
                <h2 class="text-xl font-semibold text-gray-800 mb-6">Current Budget Status</h2>
                
                <c:choose>
                    <c:when test="${not empty budgetStatus && budgetStatus.budgetAmount != null && budgetStatus.budgetAmount > 0}">
                        <!-- Budget Progress -->
                        <div class="mb-6">
                            <div class="flex justify-between items-center mb-2">
                                <span class="text-sm font-medium text-gray-700">Budget Usage</span>
                                <span class="text-sm font-semibold 
                                    <c:choose>
                                        <c:when test="${budgetStatus.percentageUsed >= 100}">text-red-600</c:when>
                                        <c:when test="${budgetStatus.percentageUsed >= 80}">text-yellow-600</c:when>
                                        <c:otherwise>text-green-600</c:otherwise>
                                    </c:choose>">
                                    <fmt:formatNumber value="${budgetStatus.percentageUsed}" pattern="#,##0.0"/>%
                                </span>
                            </div>
                            <div class="w-full bg-gray-200 rounded-full h-3">
                                <div class="h-3 rounded-full 
                                    <c:choose>
                                        <c:when test="${budgetStatus.percentageUsed >= 100}">bg-red-500</c:when>
                                        <c:when test="${budgetStatus.percentageUsed >= 80}">bg-yellow-500</c:when>
                                        <c:otherwise>bg-green-500</c:otherwise>
                                    </c:choose>" 
                                    style="width: ${budgetStatus.percentageUsed > 100 ? 100 : budgetStatus.percentageUsed}%">
                                </div>
                            </div>
                        </div>

                        <!-- Budget Details -->
                        <div class="space-y-4">
                            <div class="flex justify-between items-center p-3 bg-gray-50 rounded-lg">
                                <span class="text-gray-600">Budget Amount:</span>
                                <span class="font-semibold text-gray-800">
                                    ₹<fmt:formatNumber value="${budgetStatus.budgetAmount}" pattern="#,##0.00"/>
                                </span>
                            </div>
                            
                            <div class="flex justify-between items-center p-3 bg-gray-50 rounded-lg">
                                <span class="text-gray-600">Amount Spent:</span>
                                <span class="font-semibold text-gray-800">
                                    ₹<fmt:formatNumber value="${budgetStatus.totalSpent}" pattern="#,##0.00"/>
                                </span>
                            </div>
                            
                            <div class="flex justify-between items-center p-3 bg-gray-50 rounded-lg">
                                <span class="text-gray-600">Remaining:</span>
                                <span class="font-semibold 
                                    <c:choose>
                                        <c:when test="${budgetStatus.budgetAmount - budgetStatus.totalSpent < 0}">text-red-600</c:when>
                                        <c:otherwise>text-green-600</c:otherwise>
                                    </c:choose>">
                                    ₹<fmt:formatNumber value="${budgetStatus.budgetAmount - budgetStatus.totalSpent}" pattern="#,##0.00"/>
                                </span>
                            </div>
                        </div>

                        <!-- Status Alert -->
                        <div class="mt-6 p-4 rounded-lg 
                            <c:choose>
                                <c:when test="${budgetStatus.status == 'exceeded'}">bg-red-100 border border-red-200</c:when>
                                <c:when test="${budgetStatus.status == 'warning'}">bg-yellow-100 border border-yellow-200</c:when>
                                <c:otherwise>bg-green-100 border border-green-200</c:otherwise>
                            </c:choose>">
                            <div class="flex items-center">
                                <i class="
                                    <c:choose>
                                        <c:when test="${budgetStatus.status == 'exceeded'}">fas fa-exclamation-triangle text-red-600</c:when>
                                        <c:when test="${budgetStatus.status == 'warning'}">fas fa-exclamation-circle text-yellow-600</c:when>
                                        <c:otherwise>fas fa-check-circle text-green-600</c:otherwise>
                                    </c:choose> text-lg mr-3">
                                </i>
                                <div>
                                    <h4 class="font-semibold 
                                        <c:choose>
                                            <c:when test="${budgetStatus.status == 'exceeded'}">text-red-800</c:when>
                                            <c:when test="${budgetStatus.status == 'warning'}">text-yellow-800</c:when>
                                            <c:otherwise>text-green-800</c:otherwise>
                                        </c:choose>">
                                        <c:choose>
                                            <c:when test="${budgetStatus.status == 'exceeded'}">Budget Exceeded!</c:when>
                                            <c:when test="${budgetStatus.status == 'warning'}">Approaching Budget Limit</c:when>
                                            <c:otherwise>Within Budget</c:otherwise>
                                        </c:choose>
                                    </h4>
                                    <p class="text-sm 
                                        <c:choose>
                                            <c:when test="${budgetStatus.status == 'exceeded'}">text-red-700</c:when>
                                            <c:when test="${budgetStatus.status == 'warning'}">text-yellow-700</c:when>
                                            <c:otherwise>text-green-700</c:otherwise>
                                        </c:choose> mt-1">
                                        <c:choose>
                                            <c:when test="${budgetStatus.status == 'exceeded'}">
                                                You've exceeded your budget by ₹<fmt:formatNumber value="${budgetStatus.totalSpent - budgetStatus.budgetAmount}" pattern="#,##0.00"/>
                                            </c:when>
                                            <c:when test="${budgetStatus.status == 'warning'}">
                                                You've used <fmt:formatNumber value="${budgetStatus.percentageUsed}" pattern="#,##0.0"/>% of your budget
                                            </c:when>
                                            <c:otherwise>
                                                Great job! You're within your budget
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                </div>
                            </div>
                        </div>
                    </c:when>
                    
                    <c:otherwise>
                        <!-- No Budget Set -->
                        <div class="text-center py-8">
                            <div class="w-16 h-16 bg-gray-200 rounded-full flex items-center justify-center mx-auto mb-4">
                                <i class="fas fa-chart-pie text-gray-400 text-2xl"></i>
                            </div>
                            <h3 class="text-lg font-medium text-gray-900 mb-2">No Budget Set</h3>
                            <p class="text-gray-600 mb-4">Set a monthly budget to start tracking your spending limits.</p>
                            <div class="bg-yellow-50 border border-yellow-200 rounded-lg p-4">
                                <p class="text-yellow-800 text-sm">
                                    <i class="fas fa-info-circle mr-1"></i>
                                    Setting a budget helps you control spending and save money.
                                </p>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <script>
        function validateBudgetForm() {
            const month = document.getElementById('month').value;
            const year = document.getElementById('year').value;
            const amount = document.getElementById('budgetAmount').value;

            if (!month) {
                alert('Please select a month.');
                return false;
            }

            if (!year || year < 2020 || year > 2030) {
                alert('Please enter a valid year between 2020 and 2030.');
                return false;
            }

            if (!amount || amount <= 0) {
                alert('Please enter a valid budget amount greater than zero.');
                return false;
            }

            return true;
        }

        // Set current month as default if not already set
        document.addEventListener('DOMContentLoaded', function() {
            const monthSelect = document.getElementById('month');
            const currentMonth = new Date().getMonth() + 1;
            
            // Only set if no value is selected
            if (!monthSelect.value) {
                monthSelect.value = currentMonth;
            }
        });
    </script>
</body>
</html>