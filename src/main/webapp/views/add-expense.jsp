<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Expense - Smart Expense Tracker</title>
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
    <div class="max-w-2xl mx-auto px-4 py-8">
        <!-- Header -->
        <div class="mb-8">
            <a href="dashboard" class="inline-flex items-center text-indigo-600 hover:text-indigo-500 mb-4">
                <i class="fas fa-arrow-left mr-2"></i> Back to Dashboard
            </a>
            <h1 class="text-3xl font-bold text-gray-800">Add New Expense</h1>
            <p class="text-gray-600 mt-2">Track your spending by adding a new expense</p>
        </div>

        <!-- Display Messages -->
        <c:if test="${not empty successMessage}">
            <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-6">
                <i class="fas fa-check-circle mr-2"></i>${successMessage}
            </div>
        </c:if>
        
        <c:if test="${not empty errorMessage}">
            <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-6">
                <i class="fas fa-exclamation-circle mr-2"></i>${errorMessage}
            </div>
        </c:if>

        <!-- Expense Form -->
        <div class="bg-white rounded-xl shadow-sm p-6">
            <form action="add-expense" method="post" onsubmit="return validateForm()">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <!-- Amount -->
                    <div class="md:col-span-2">
                        <label for="amount" class="block text-sm font-medium text-gray-700 mb-2">
                            Amount *
                        </label>
                        <div class="relative">
                            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                <span class="text-gray-500">₹</span>
                            </div>
                            <input type="number" id="amount" name="amount" step="0.01" min="0.01"
                                   class="block w-full pl-10 pr-3 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500"
                                   placeholder="0.00" required>
                        </div>
                    </div>

                    <!-- Category -->
                    <div>
                        <label for="categoryId" class="block text-sm font-medium text-gray-700 mb-2">
                            Category *
                        </label>
                        <select id="categoryId" name="categoryId" 
                                class="block w-full px-3 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500" required>
                            <option value="">Select a category</option>
                            <c:forEach var="category" items="${categories}">
                                <option value="${category.categoryId}">${category.categoryName}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Date -->
                    <div>
                        <label for="expenseDate" class="block text-sm font-medium text-gray-700 mb-2">
                            Date *
                        </label>
                        <input type="date" id="expenseDate" name="expenseDate" 
                               class="block w-full px-3 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500"
                               value="${now}" required>
                    </div>

                    <!-- Payment Method -->
                    <div>
                        <label for="paymentMethod" class="block text-sm font-medium text-gray-700 mb-2">
                            Payment Method
                        </label>
                        <select id="paymentMethod" name="paymentMethod" 
                                class="block w-full px-3 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500">
                            <option value="CASH">Cash</option>
                            <option value="CARD">Card</option>
                            <option value="UPI">UPI</option>
                        </select>
                    </div>

                    <!-- Description -->
                    <div class="md:col-span-2">
                        <label for="description" class="block text-sm font-medium text-gray-700 mb-2">
                            Description
                        </label>
                        <textarea id="description" name="description" rows="3"
                                  class="block w-full px-3 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500"
                                  placeholder="Add a description for this expense (optional)"></textarea>
                    </div>
                </div>

                <!-- Form Actions -->
                <div class="flex flex-wrap gap-4 mt-8 pt-6 border-t border-gray-200">
                    <button type="submit" 
                            class="bg-indigo-600 text-white px-8 py-3 rounded-lg hover:bg-indigo-700 focus:ring-4 focus:ring-indigo-200 transition duration-200 font-medium">
                        <i class="fas fa-plus mr-2"></i>Add Expense
                    </button>
                    <a href="dashboard" 
                       class="bg-gray-200 text-gray-700 px-8 py-3 rounded-lg hover:bg-gray-300 transition duration-200 font-medium">
                        Cancel
                    </a>
                </div>
            </form>
        </div>

        <!-- Quick Tips -->
        <div class="mt-8 bg-blue-50 rounded-xl p-6">
            <h3 class="text-lg font-semibold text-blue-800 mb-3">
                <i class="fas fa-lightbulb mr-2"></i>Quick Tips
            </h3>
            <ul class="text-blue-700 space-y-2">
                <li class="flex items-start">
                    <i class="fas fa-check-circle mt-1 mr-2 text-blue-500"></i>
                    <span>Be specific with descriptions for better tracking</span>
                </li>
                <li class="flex items-start">
                    <i class="fas fa-check-circle mt-1 mr-2 text-blue-500"></i>
                    <span>Choose the right category for accurate reports</span>
                </li>
                <li class="flex items-start">
                    <i class="fas fa-check-circle mt-1 mr-2 text-blue-500"></i>
                    <span>Record expenses daily to maintain accurate records</span>
                </li>
            </ul>
        </div>
    </div>

    <script>
        // Set today's date as default
        document.getElementById('expenseDate').valueAsDate = new Date();

        function validateForm() {
            const amount = document.getElementById('amount').value;
            const category = document.getElementById('categoryId').value;
            const date = document.getElementById('expenseDate').value;

            if (!amount || amount <= 0) {
                alert('Please enter a valid amount greater than zero.');
                return false;
            }

            if (!category) {
                alert('Please select a category.');
                return false;
            }

            if (!date) {
                alert('Please select a date.');
                return false;
            }

            // Check if date is in future
            const selectedDate = new Date(date);
            const today = new Date();
            if (selectedDate > today) {
                alert('Expense date cannot be in the future.');
                return false;
            }

            return true;
        }

        // Real-time amount validation
        document.getElementById('amount').addEventListener('input', function() {
            if (this.value < 0) {
                this.value = '';
            }
        });
    </script>
</body>
</html>