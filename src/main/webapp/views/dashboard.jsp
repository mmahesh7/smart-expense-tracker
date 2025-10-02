<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Smart Expense Tracker</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body class="bg-gray-50">
    <!-- Navigation Bar -->
	<nav class="bg-white shadow-lg">
	    <div class="max-w-7xl mx-auto px-4">
	        <div class="flex justify-between items-center py-4">
	            <!-- Logo -->
	            <div class="flex items-center space-x-3">
	                <div class="w-8 h-8 bg-indigo-600 rounded-lg flex items-center justify-center">
	                    <i class="fas fa-wallet text-white text-sm"></i>
	                </div>
	                <span class="text-xl font-bold text-gray-800">ExpenseTracker</span>
	            </div>

	            <!-- User Menu -->
	            <div class="flex items-center space-x-4">
	                <span class="text-gray-700">Welcome, <strong>${sessionScope.fullName}</strong></span>
	                <div class="relative">
	                    <button onclick="toggleDropdown()" class="w-10 h-10 bg-indigo-100 rounded-full flex items-center justify-center focus:outline-none focus:ring-2 focus:ring-indigo-500">
	                        <i class="fas fa-user text-indigo-600"></i>
	                    </button>
	                    <div id="userDropdown" class="absolute right-0 mt-2 w-48 bg-white rounded-lg shadow-lg py-2 hidden z-50">
	                        <a href="view-expenses" class="block px-4 py-2 text-gray-700 hover:bg-gray-100">
	                            <i class="fas fa-receipt mr-2"></i>View Expenses
	                        </a>
	                        <a href="budget" class="block px-4 py-2 text-gray-700 hover:bg-gray-100">
	                            <i class="fas fa-chart-pie mr-2"></i>Budget
	                        </a>
	                        <hr class="my-2">
	                        <a href="logout" class="block px-4 py-2 text-red-600 hover:bg-gray-100">
	                            <i class="fas fa-sign-out-alt mr-2"></i>Logout
	                        </a>
	                    </div>
	                </div>
	            </div>
	        </div>
	    </div>
	</nav>

    <!-- Main Content -->
    <div class="max-w-7xl mx-auto px-4 py-8">
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

        <!-- Quick Actions -->
        <div class="flex flex-wrap gap-4 mb-8">
            <a href="add-expense" class="bg-indigo-600 text-white px-6 py-3 rounded-lg hover:bg-indigo-700 transition duration-200 font-medium">
                <i class="fas fa-plus mr-2"></i>Add Expense
            </a>
            <a href="view-expenses" class="bg-white text-gray-700 border border-gray-300 px-6 py-3 rounded-lg hover:bg-gray-50 transition duration-200 font-medium">
                <i class="fas fa-list mr-2"></i>View All Expenses
            </a>
            <a href="budget" class="bg-white text-gray-700 border border-gray-300 px-6 py-3 rounded-lg hover:bg-gray-50 transition duration-200 font-medium">
                <i class="fas fa-chart-pie mr-2"></i>Manage Budget
            </a>
        </div>

        <!-- Stats Cards -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
            <!-- Total Spending Card -->
            <div class="bg-white rounded-xl shadow-sm p-6 border-l-4 border-blue-500">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-gray-500 text-sm">Total Spending</p>
                        <p class="text-2xl font-bold text-gray-800 mt-1">
                            ₹<fmt:formatNumber value="${monthlyTotal != null ? monthlyTotal : 0}" pattern="#,##0.00"/>
                        </p>
                        <p class="text-gray-500 text-sm mt-1">${currentMonth} ${currentYear}</p>
                    </div>
                    <div class="w-12 h-12 bg-blue-100 rounded-lg flex items-center justify-center">
                        <i class="fas fa-money-bill-wave text-blue-600 text-xl"></i>
                    </div>
                </div>
            </div>

            <!-- Budget Status Card -->
            <div class="bg-white rounded-xl shadow-sm p-6 border-l-4 
                <c:choose>
                    <c:when test="${budgetStatus.status == 'exceeded'}">border-red-500</c:when>
                    <c:when test="${budgetStatus.status == 'warning'}">border-yellow-500</c:when>
                    <c:when test="${budgetStatus != null}">border-green-500</c:when>
                    <c:otherwise>border-gray-500</c:otherwise>
                </c:choose>">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-gray-500 text-sm">Budget Status</p>
                        <c:if test="${not empty budgetStatus}">
                            <p class="text-2xl font-bold text-gray-800 mt-1">
                                <fmt:formatNumber value="${budgetStatus.percentageUsed}" pattern="#,##0.0"/>%
                            </p>
                            <p class="text-sm mt-1 
                                <c:choose>
                                    <c:when test="${budgetStatus.status == 'exceeded'}">text-red-600</c:when>
                                    <c:when test="${budgetStatus.status == 'warning'}">text-yellow-600</c:when>
                                    <c:otherwise>text-green-600</c:otherwise>
                                </c:choose>">
                                <c:choose>
                                    <c:when test="${budgetStatus.status == 'exceeded'}">Budget Exceeded</c:when>
                                    <c:when test="${budgetStatus.status == 'warning'}">Approaching Limit</c:when>
                                    <c:otherwise>Within Budget</c:otherwise>
                                </c:choose>
                            </p>
                        </c:if>
                        <c:if test="${empty budgetStatus}">
                            <p class="text-lg text-gray-600 mt-1">No budget set</p>
                            <a href="budget" class="text-blue-600 text-sm hover:underline">Set budget</a>
                        </c:if>
                    </div>
                    <div class="w-12 h-12 
                        <c:choose>
                            <c:when test="${budgetStatus.status == 'exceeded'}">bg-red-100 text-red-600</c:when>
                            <c:when test="${budgetStatus.status == 'warning'}">bg-yellow-100 text-yellow-600</c:when>
                            <c:when test="${budgetStatus != null}">bg-green-100 text-green-600</c:when>
                            <c:otherwise>bg-gray-100 text-gray-600</c:otherwise>
                        </c:choose> rounded-lg flex items-center justify-center">
                        <i class="fas fa-chart-pie text-xl"></i>
                    </div>
                </div>
            </div>

            <!-- Recent Transactions Card -->
            <div class="bg-white rounded-xl shadow-sm p-6 border-l-4 border-purple-500">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-gray-500 text-sm">Recent Transactions</p>
                        <p class="text-2xl font-bold text-gray-800 mt-1">${fn:length(recentExpenses)}</p>
                        <p class="text-gray-500 text-sm mt-1">Last 7 days</p>
                    </div>
                    <div class="w-12 h-12 bg-purple-100 rounded-lg flex items-center justify-center">
                        <i class="fas fa-receipt text-purple-600 text-xl"></i>
                    </div>
                </div>
            </div>
        </div>

        <!-- Charts Section - 3 Charts in Grid -->
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8 mb-8">
            <!-- Pie Chart -->
            <div class="bg-white rounded-xl shadow-sm p-6">
                <h3 class="text-lg font-semibold text-gray-800 mb-4">Spending by Category</h3>
                <div class="h-80">
                    <canvas id="categoryChart"></canvas>
                </div>
            </div>

            <!-- Monthly Trend Chart -->
            <div class="bg-white rounded-xl shadow-sm p-6">
                <h3 class="text-lg font-semibold text-gray-800 mb-4">Monthly Spending Trend</h3>
                <div class="h-80">
                    <canvas id="monthlyTrendChart"></canvas>
                </div>
            </div>

            <!-- Budget Progress Chart -->
            <div class="bg-white rounded-xl shadow-sm p-6">
                <h3 class="text-lg font-semibold text-gray-800 mb-4">Budget Progress</h3>
                <div class="h-80">
                    <canvas id="budgetProgressChart"></canvas>
                </div>
                <c:if test="${not empty budgetStatus}">
                    <div class="mt-4 grid grid-cols-3 gap-2 text-center text-sm">
                        <div class="p-2 bg-gray-50 rounded">
                            <p class="text-gray-500">Budget</p>
                            <p class="font-semibold">₹<fmt:formatNumber value="${budgetStatus.budgetAmount}" pattern="#,##0.00"/></p>
                        </div>
                        <div class="p-2 bg-gray-50 rounded">
                            <p class="text-gray-500">Spent</p>
                            <p class="font-semibold">₹<fmt:formatNumber value="${budgetStatus.totalSpent}" pattern="#,##0.00"/></p>
                        </div>
                        <div class="p-2 bg-gray-50 rounded">
                            <p class="text-gray-500">Remaining</p>
                            <p class="font-semibold 
                                <c:choose>
                                    <c:when test="${budgetStatus.budgetAmount.subtract(budgetStatus.totalSpent).doubleValue() < 0}">text-red-600</c:when>
                                    <c:otherwise>text-green-600</c:otherwise>
                                </c:choose>">
                                ₹<fmt:formatNumber value="${budgetStatus.budgetAmount.subtract(budgetStatus.totalSpent)}" pattern="#,##0.00"/>
                            </p>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>

        <!-- Recent Expenses Section -->
        <div class="bg-white rounded-xl shadow-sm p-6">
            <div class="flex justify-between items-center mb-4">
                <h3 class="text-lg font-semibold text-gray-800">Recent Expenses</h3>
                <a href="view-expenses" class="text-indigo-600 text-sm hover:underline">View All</a>
            </div>
            <div class="space-y-4">
                <c:forEach var="expense" items="${recentExpenses}" end="6">
                    <div class="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                        <div class="flex items-center space-x-3">
                            <div class="w-10 h-10 ${expense.categoryColor} rounded-lg flex items-center justify-center">
                                <i class="${expense.categoryIcon} text-white text-sm"></i>
                            </div>
                            <div>
                                <p class="font-medium text-gray-800">${expense.categoryName}</p>
                                <p class="text-sm text-gray-500">
                                    <c:choose>
                                        <c:when test="${not empty expense.description}">${expense.description}</c:when>
                                        <c:otherwise>No description</c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                        </div>
                        <div class="text-right">
                            <p class="font-semibold text-gray-800">
                                ₹<fmt:formatNumber value="${expense.amount}" pattern="#,##0.00"/>
                            </p>
                            <p class="text-sm text-gray-500">
                                <fmt:formatDate value="${expense.expenseDateAsDate}" pattern="MMM dd"/>
                            </p>
                        </div>
                    </div>
                </c:forEach>
                <c:if test="${empty recentExpenses}">
                    <div class="text-center py-8 text-gray-500">
                        <i class="fas fa-receipt text-4xl mb-3 opacity-50"></i>
                        <p>No recent expenses</p>
                        <a href="add-expense" class="text-indigo-600 hover:underline mt-2 inline-block">Add your first expense</a>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <script>
        // Category Pie Chart
        const categoryData = [
            <c:forEach var="category" items="${categorySpending}" varStatus="status">
            {
                category: "${fn:escapeXml(category[0])}",
                amount: parseFloat(${category[1]}),
                color: "${category[2]}"
            }<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];

        console.log("Category Data:", categoryData);

        if (categoryData.length > 0 && categoryData.some(item => item.amount > 0)) {
            const ctx = document.getElementById('categoryChart').getContext('2d');
            
            new Chart(ctx, {
                type: 'pie',
                data: {
                    labels: categoryData.map(item => item.category),
                    datasets: [{
                        data: categoryData.map(item => item.amount),
                        backgroundColor: categoryData.map(item => item.color || '#6b7280'),
                        borderWidth: 2,
                        borderColor: '#ffffff'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'right',
                            labels: {
                                padding: 20,
                                usePointStyle: true,
                                font: {
                                    size: 12
                                }
                            }
                        },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    const label = context.label || '';
                                    const value = context.raw || 0;
                                    const total = context.dataset.data.reduce((a, b) => a + b, 0);
                                    const percentage = Math.round((value / total) * 100);
                                    return label + ': ₹' + value.toFixed(2) + ' (' + percentage + '%)';
                                }
                            }
                        }
                    }
                }
            });
        } else {
            const chartContainer = document.getElementById('categoryChart').parentElement;
            chartContainer.innerHTML = `
                <div class="flex items-center justify-center h-80 text-gray-500">
                    <div class="text-center">
                        <i class="fas fa-chart-pie text-4xl mb-3 opacity-50"></i>
                        <p>No spending data available</p>
                        <p class="text-sm mt-1">Add expenses to see category breakdown</p>
                    </div>
                </div>
            `;
        }

        // Monthly Trend Chart
        const monthlyTrendData = [
            <c:forEach var="month" items="${monthlyTrend}" varStatus="status">
            {
                month: "${month[0]}",
                amount: parseFloat(${month[1]}),
                label: "${month[2]}"
            }<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];

        console.log("Monthly Trend Data:", monthlyTrendData);

        if (monthlyTrendData.length > 0) {
            const trendCtx = document.getElementById('monthlyTrendChart').getContext('2d');
            
            new Chart(trendCtx, {
                type: 'line',
                data: {
                    labels: monthlyTrendData.map(item => item.month),
                    datasets: [{
                        label: 'Monthly Spending',
                        data: monthlyTrendData.map(item => item.amount),
                        borderColor: '#4f46e5',
                        backgroundColor: 'rgba(79, 70, 229, 0.1)',
                        borderWidth: 3,
                        fill: true,
                        tension: 0.4,
                        pointBackgroundColor: '#4f46e5',
                        pointBorderColor: '#ffffff',
                        pointBorderWidth: 2,
                        pointRadius: 6,
                        pointHoverRadius: 8
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: false
                        },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    return 'Spent: ₹' + context.raw.toFixed(2);
                                }
                            }
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            grid: {
                                color: 'rgba(0, 0, 0, 0.1)'
                            },
                            ticks: {
                                callback: function(value) {
                                    return '₹' + value.toLocaleString();
                                }
                            }
                        },
                        x: {
                            grid: {
                                display: false
                            }
                        }
                    }
                }
            });
        } else {
            const trendContainer = document.getElementById('monthlyTrendChart').parentElement;
            trendContainer.innerHTML = `
                <div class="flex items-center justify-center h-80 text-gray-500">
                    <div class="text-center">
                        <i class="fas fa-chart-line text-4xl mb-3 opacity-50"></i>
                        <p>No trend data available</p>
                        <p class="text-sm mt-1">Add expenses to see spending trends</p>
                    </div>
                </div>
            `;
        }

        // Budget Progress Chart
        <c:choose>
            <c:when test="${not empty budgetStatus}">
                const budgetCtx = document.getElementById('budgetProgressChart').getContext('2d');
                const spent = parseFloat(${budgetStatus.totalSpent});
                const budgetAmount = parseFloat(${budgetStatus.budgetAmount});
                const remaining = Math.max(0, budgetAmount - spent);
                
                new Chart(budgetCtx, {
                    type: 'doughnut',
                    data: {
                        labels: ['Spent', 'Remaining'],
                        datasets: [{
                            data: [spent, remaining],
                            backgroundColor: [
                                spent > budgetAmount ? '#ef4444' : '#f59e0b',
                                '#10b981'
                            ],
                            borderWidth: 0
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        cutout: '70%',
                        plugins: {
                            legend: {
                                position: 'bottom',
                                labels: {
                                    padding: 15,
                                    usePointStyle: true,
                                    font: {
                                        size: 11
                                    }
                                }
                            },
                            tooltip: {
                                callbacks: {
                                    label: function(context) {
                                        const label = context.label || '';
                                        const value = context.raw || 0;
                                        const total = spent + remaining;
                                        const percentage = Math.round((value / total) * 100);
                                        return label + ': ₹' + value.toFixed(2) + ' (' + percentage + '%)';
                                    }
                                }
                            }
                        }
                    }
                });
            </c:when>
            <c:otherwise>
                const budgetContainer = document.getElementById('budgetProgressChart').parentElement;
                budgetContainer.innerHTML = `
                    <div class="flex items-center justify-center h-80 text-gray-500">
                        <div class="text-center">
                            <i class="fas fa-chart-pie text-4xl mb-3 opacity-50"></i>
                            <p>No budget set</p>
                            <a href="budget" class="text-indigo-600 hover:underline mt-2 inline-block">Set a budget</a>
                        </div>
                    </div>
                `;
            </c:otherwise>
        </c:choose>
    </script>

    <script>
    // Dropdown toggle function
    function toggleDropdown() {
        const dropdown = document.getElementById('userDropdown');
        dropdown.classList.toggle('hidden');
    }

    // Close dropdown when clicking outside
    window.addEventListener('click', function(event) {
        const dropdown = document.getElementById('userDropdown');
        const button = event.target.closest('button');
        
        if (!button && dropdown && !dropdown.contains(event.target)) {
            dropdown.classList.add('hidden');
        }
    });
</script>
</body>
</html>