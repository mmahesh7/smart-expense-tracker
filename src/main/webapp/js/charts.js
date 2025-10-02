/**
 * Chart.js utility functions for Smart Expense Tracker
 */

// Initialize all dashboard charts
function initializeDashboardCharts() {
    // Charts are now initialized directly in the JSP
    console.log("Dashboard charts initialized");
}

// Initialize category pie chart
function initCategoryChart(canvasId, categoryData) {
    const canvas = document.getElementById(canvasId);
    
    if (!canvas) {
        console.error('Canvas element not found:', canvasId);
        return;
    }
    
    if (!categoryData || categoryData.length === 0 || !categoryData.some(item => item.amount > 0)) {
        const chartContainer = canvas.parentElement;
        chartContainer.innerHTML = `
            <div class="flex items-center justify-center h-full text-gray-500">
                <div class="text-center">
                    <i class="fas fa-chart-pie text-4xl mb-3 opacity-50"></i>
                    <p>No spending data available</p>
                    <p class="text-sm mt-1">Add expenses to see category breakdown</p>
                </div>
            </div>
        `;
        return;
    }

    const ctx = canvas.getContext('2d');
    
    return new Chart(ctx, {
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
                            size: 11
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
            },
            animation: {
                animateScale: true,
                animateRotate: true
            }
        }
    });
}

// Initialize monthly trend line chart
function initMonthlyTrendChart(canvasId, monthlyData) {
    const canvas = document.getElementById(canvasId);
    
    if (!canvas) {
        console.error('Canvas element not found:', canvasId);
        return;
    }
    
    if (!monthlyData || monthlyData.length === 0) {
        const chartContainer = canvas.parentElement;
        chartContainer.innerHTML = `
            <div class="flex items-center justify-center h-full text-gray-500">
                <div class="text-center">
                    <i class="fas fa-chart-line text-4xl mb-3 opacity-50"></i>
                    <p>No trend data available</p>
                </div>
            </div>
        `;
        return;
    }

    const ctx = canvas.getContext('2d');
    
    return new Chart(ctx, {
        type: 'line',
        data: {
            labels: monthlyData.map(item => item.month),
            datasets: [{
                label: 'Monthly Spending',
                data: monthlyData.map(item => item.amount),
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
}

// Initialize budget progress chart
function initBudgetProgressChart(canvasId, budgetData) {
    const canvas = document.getElementById(canvasId);
    
    if (!canvas) {
        console.error('Canvas element not found:', canvasId);
        return;
    }
    
    const ctx = canvas.getContext('2d');
    
    return new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: ['Spent', 'Remaining'],
            datasets: [{
                data: [budgetData.spent, budgetData.remaining],
                backgroundColor: [
                    budgetData.exceeded ? '#ef4444' : '#f59e0b',
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
                    display: false
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
}

// Utility function to format currency
function formatCurrency(amount) {
    return '₹' + parseFloat(amount).toLocaleString('en-IN', {
        minimumFractionDigits: 2,
        maximumFractionDigits: 2
    });
}

// Utility function to format percentage
function formatPercentage(value) {
    return parseFloat(value).toFixed(1) + '%';
}

// Export functions for use in other modules
if (typeof module !== 'undefined' && module.exports) {
    module.exports = {
        initCategoryChart,
        initMonthlyTrendChart,
        initBudgetProgressChart,
        formatCurrency,
        formatPercentage
    };
}