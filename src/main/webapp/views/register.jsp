<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Smart Expense Tracker</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gradient-to-br from-green-50 to-blue-100 min-h-screen flex items-center justify-center py-8">
    <div class="max-w-md w-full mx-4">
        <!-- Card -->
        <div class="bg-white rounded-2xl shadow-xl p-8">
            <!-- Header -->
            <div class="text-center mb-8">
                <div class="w-16 h-16 bg-green-600 rounded-full flex items-center justify-center mx-auto mb-4">
                    <i class="fas fa-user-plus text-white text-2xl"></i>
                </div>
                <h1 class="text-2xl font-bold text-gray-800">Create Account</h1>
                <p class="text-gray-600 mt-2">Join us to track your expenses</p>
            </div>

            <!-- Display Messages -->
            <c:if test="${not empty successMessage}">
			    <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-4">
			        ${successMessage}
			    </div>
			    <c:remove var="successMessage" scope="session"/>
			</c:if>
			
			<c:if test="${not empty errorMessage}">
			    <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
			        ${errorMessage}
			    </div>
			    <c:remove var="errorMessage" scope="session"/>
			</c:if>

            <!-- Registration Form -->
            <form action="register" method="post" onsubmit="return validateForm()">
                <div class="space-y-4">
                    <!-- Full Name -->
                    <div>
                        <label for="fullName" class="block text-sm font-medium text-gray-700 mb-1">
                            Full Name *
                        </label>
                        <div class="relative">
                            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                <i class="fas fa-user text-gray-400"></i>
                            </div>
                            <input type="text" id="fullName" name="fullName" 
                                   value="${fullName}" 
                                   class="block w-full pl-10 pr-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-green-500"
                                   placeholder="Enter your full name" required>
                        </div>
                    </div>

                    <!-- Email -->
                    <div>
                        <label for="email" class="block text-sm font-medium text-gray-700 mb-1">
                            Email Address *
                        </label>
                        <div class="relative">
                            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                <i class="fas fa-envelope text-gray-400"></i>
                            </div>
                            <input type="email" id="email" name="email" 
                                   value="${email}" 
                                   class="block w-full pl-10 pr-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-green-500"
                                   placeholder="Enter your email" required>
                        </div>
                    </div>

                    <!-- Username -->
                    <div>
                        <label for="username" class="block text-sm font-medium text-gray-700 mb-1">
                            Username *
                        </label>
                        <div class="relative">
                            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                <i class="fas fa-at text-gray-400"></i>
                            </div>
                            <input type="text" id="username" name="username" 
                                   value="${username}" 
                                   class="block w-full pl-10 pr-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-green-500"
                                   placeholder="Choose a username" required>
                        </div>
                    </div>

                    <!-- Password -->
                    <div>
                        <label for="password" class="block text-sm font-medium text-gray-700 mb-1">
                            Password *
                        </label>
                        <div class="relative">
                            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                <i class="fas fa-lock text-gray-400"></i>
                            </div>
                            <input type="password" id="password" name="password" 
                                   class="block w-full pl-10 pr-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-green-500"
                                   placeholder="Create a password" required>
                            <div class="absolute inset-y-0 right-0 pr-3 flex items-center">
                                <button type="button" onclick="togglePassword('password')" 
                                        class="text-gray-400 hover:text-gray-500">
                                    <i class="fas fa-eye"></i>
                                </button>
                            </div>
                        </div>
                        <p class="text-xs text-gray-500 mt-1">Must be at least 6 characters long</p>
                    </div>

                    <!-- Confirm Password -->
                    <div>
                        <label for="confirmPassword" class="block text-sm font-medium text-gray-700 mb-1">
                            Confirm Password *
                        </label>
                        <div class="relative">
                            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                <i class="fas fa-lock text-gray-400"></i>
                            </div>
                            <input type="password" id="confirmPassword" name="confirmPassword" 
                                   class="block w-full pl-10 pr-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-green-500"
                                   placeholder="Confirm your password" required>
                            <div class="absolute inset-y-0 right-0 pr-3 flex items-center">
                                <button type="button" onclick="togglePassword('confirmPassword')" 
                                        class="text-gray-400 hover:text-gray-500">
                                    <i class="fas fa-eye"></i>
                                </button>
                            </div>
                        </div>
                        <div id="passwordMatch" class="text-xs mt-1 hidden"></div>
                    </div>

                    <!-- Submit Button -->
                    <button type="submit" 
                            class="w-full bg-green-600 text-white py-2 px-4 rounded-lg hover:bg-green-700 focus:ring-4 focus:ring-green-200 transition duration-200 font-medium mt-4">
                        Create Account
                    </button>
                </div>
            </form>

            <!-- Login Link -->
            <div class="mt-6 text-center">
                <p class="text-gray-600">
                    Already have an account?
                    <a href="login" class="text-green-600 hover:text-green-500 font-medium">
                        Sign in here
                    </a>
                </p>
            </div>
        </div>

        <!-- Footer -->
        <div class="text-center mt-6">
            <p class="text-gray-500 text-sm">
                &copy; 2024 Smart Expense Tracker. All rights reserved.
            </p>
        </div>
    </div>

    <script>
        function togglePassword(fieldId) {
            const field = document.getElementById(fieldId);
            const type = field.getAttribute('type') === 'password' ? 'text' : 'password';
            field.setAttribute('type', type);
        }

        function validateForm() {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const matchDiv = document.getElementById('passwordMatch');

            if (password.length < 6) {
                matchDiv.textContent = 'Password must be at least 6 characters long!';
                matchDiv.className = 'text-red-600 text-xs mt-1';
                matchDiv.classList.remove('hidden');
                return false;
            }

            if (password !== confirmPassword) {
                matchDiv.textContent = 'Passwords do not match!';
                matchDiv.className = 'text-red-600 text-xs mt-1';
                matchDiv.classList.remove('hidden');
                return false;
            }

            matchDiv.textContent = 'Passwords match!';
            matchDiv.className = 'text-green-600 text-xs mt-1';
            matchDiv.classList.remove('hidden');
            return true;
        }

        // Real-time password validation
        document.getElementById('confirmPassword').addEventListener('input', validateForm);
        document.getElementById('password').addEventListener('input', validateForm);
    </script>
</body>
</html>