/**
 * Form validation utilities for Smart Expense Tracker
 */

// Common validation patterns
const patterns = {
    email: /^[^\s@]+@[^\s@]+\.[^\s@]+$/,
    username: /^[a-zA-Z0-9_]{3,20}$/,
    amount: /^\d+(\.\d{1,2})?$/,
    date: /^\d{4}-\d{2}-\d{2}$/
};

// Validation messages
const messages = {
    required: 'This field is required',
    email: 'Please enter a valid email address',
    username: 'Username must be 3-20 characters (letters, numbers, underscore only)',
    passwordLength: 'Password must be at least 6 characters long',
    passwordMatch: 'Passwords do not match',
    amount: 'Please enter a valid amount (e.g., 100.50)',
    dateFuture: 'Date cannot be in the future',
    dateInvalid: 'Please enter a valid date'
};

// Validate email format
function validateEmail(email) {
    if (!email) return { isValid: false, message: messages.required };
    if (!patterns.email.test(email)) return { isValid: false, message: messages.email };
    return { isValid: true, message: '' };
}

// Validate username format
function validateUsername(username) {
    if (!username) return { isValid: false, message: messages.required };
    if (!patterns.username.test(username)) return { isValid: false, message: messages.username };
    return { isValid: true, message: '' };
}

// Validate password strength and length
function validatePassword(password) {
    if (!password) return { isValid: false, message: messages.required };
    if (password.length < 6) return { isValid: false, message: messages.passwordLength };
    return { isValid: true, message: '' };
}

// Validate password confirmation
function validatePasswordConfirmation(password, confirmPassword) {
    if (!confirmPassword) return { isValid: false, message: messages.required };
    if (password !== confirmPassword) return { isValid: false, message: messages.passwordMatch };
    return { isValid: true, message: '' };
}

// Validate amount (positive number with up to 2 decimal places)
function validateAmount(amount) {
    if (!amount) return { isValid: false, message: messages.required };
    if (!patterns.amount.test(amount)) return { isValid: false, message: messages.amount };
    if (parseFloat(amount) <= 0) return { isValid: false, message: 'Amount must be greater than zero' };
    return { isValid: true, message: '' };
}

// Validate date (not in future)
function validateDate(dateString) {
    if (!dateString) return { isValid: false, message: messages.required };
    if (!patterns.date.test(dateString)) return { isValid: false, message: messages.dateInvalid };
    
    const selectedDate = new Date(dateString);
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    
    if (selectedDate > today) return { isValid: false, message: messages.dateFuture };
    return { isValid: true, message: '' };
}

// Validate registration form
function validateRegistrationForm(formData) {
    const errors = {};
    
    // Validate full name
	if (!formData.fullName || !formData.fullName.trim()) {
	    errors.fullName = messages.required;
	}
    
    // Validate email
    const emailValidation = validateEmail(formData.email);
    if (!emailValidation.isValid) {
        errors.email = emailValidation.message;
    }
    
    // Validate username
    const usernameValidation = validateUsername(formData.username);
    if (!usernameValidation.isValid) {
        errors.username = usernameValidation.message;
    }
    
    // Validate password
    const passwordValidation = validatePassword(formData.password);
    if (!passwordValidation.isValid) {
        errors.password = passwordValidation.message;
    }
    
    // Validate password confirmation
    const confirmValidation = validatePasswordConfirmation(formData.password, formData.confirmPassword);
    if (!confirmValidation.isValid) {
        errors.confirmPassword = confirmValidation.message;
    }
    
    return {
        isValid: Object.keys(errors).length === 0,
        errors: errors
    };
}

// Validate login form
function validateLoginForm(formData) {
    const errors = {};
    
	if (!formData.username || !formData.username.trim()) {
	    errors.username = messages.required;
	}

    
	if (!formData.password || !formData.password.trim()) {
	    errors.password = messages.required;
	}

    
    return {
        isValid: Object.keys(errors).length === 0,
        errors: errors
    };
}

// Validate expense form
function validateExpenseForm(formData) {
    const errors = {};
    
    // Validate amount
    const amountValidation = validateAmount(formData.amount);
    if (!amountValidation.isValid) {
        errors.amount = amountValidation.message;
    }
    
    // Validate category
    if (!formData.categoryId) {
        errors.categoryId = messages.required;
    }
    
    // Validate date
    const dateValidation = validateDate(formData.expenseDate);
    if (!dateValidation.isValid) {
        errors.expenseDate = dateValidation.message;
    }
    
    return {
        isValid: Object.keys(errors).length === 0,
        errors: errors
    };
}

// Validate budget form
function validateBudgetForm(formData) {
    const errors = {};
    
    if (!formData.month) {
        errors.month = messages.required;
    }
    
    if (!formData.year) {
        errors.year = messages.required;
    } else if (formData.year < 2020 || formData.year > 2030) {
        errors.year = 'Year must be between 2020 and 2030';
    }
    
    const amountValidation = validateAmount(formData.budgetAmount);
    if (!amountValidation.isValid) {
        errors.budgetAmount = amountValidation.message;
    }
    
    return {
        isValid: Object.keys(errors).length === 0,
        errors: errors
    };
}

// Show validation error
function showError(fieldId, message) {
    const field = document.getElementById(fieldId);
    const errorElement = document.getElementById(fieldId + 'Error') || createErrorElement(fieldId);
    
    field.classList.add('border-red-500');
    field.classList.remove('border-gray-300');
    errorElement.textContent = message;
    errorElement.classList.remove('hidden');
}

// Hide validation error
function hideError(fieldId) {
    const field = document.getElementById(fieldId);
    const errorElement = document.getElementById(fieldId + 'Error');
    
    if (field) {
        field.classList.remove('border-red-500');
        field.classList.add('border-gray-300');
    }
    
    if (errorElement) {
        errorElement.classList.add('hidden');
    }
}

// Create error element if it doesn't exist
function createErrorElement(fieldId) {
    const field = document.getElementById(fieldId);
    const errorElement = document.createElement('div');
    errorElement.id = fieldId + 'Error';
    errorElement.className = 'text-red-600 text-sm mt-1';
    
    field.parentNode.appendChild(errorElement);
    return errorElement;
}

// Real-time validation for input fields
function setupRealTimeValidation(fieldId, validator) {
    const field = document.getElementById(fieldId);
    if (!field) return;
    
    field.addEventListener('blur', function() {
        const value = this.value;
        const validation = validator(value);
        
        if (!validation.isValid) {
            showError(fieldId, validation.message);
        } else {
            hideError(fieldId);
        }
    });
    
    field.addEventListener('input', function() {
        hideError(fieldId);
    });
}

// Initialize all real-time validations
function initRealTimeValidations() {
    // Registration form validations
    setupRealTimeValidation('email', validateEmail);
    setupRealTimeValidation('username', validateUsername);
    setupRealTimeValidation('password', validatePassword);
    
    // Expense form validations
    setupRealTimeValidation('amount', validateAmount);
    setupRealTimeValidation('expenseDate', validateDate);
}

// Password strength indicator
function checkPasswordStrength(password) {
    if (!password) return { strength: 0, message: '' };
    
    let strength = 0;
    let message = '';
    
    // Length check
    if (password.length >= 6) strength += 25;
    
    // Lowercase check
    if (/[a-z]/.test(password)) strength += 25;
    
    // Uppercase check
    if (/[A-Z]/.test(password)) strength += 25;
    
    // Number check
    if (/[0-9]/.test(password)) strength += 25;
    
    // Determine message
    if (strength < 50) {
        message = 'Weak password';
    } else if (strength < 75) {
        message = 'Medium strength password';
    } else {
        message = 'Strong password';
    }
    
    return { strength, message };
}

// Toggle password visibility
function togglePasswordVisibility(fieldId) {
    const field = document.getElementById(fieldId);
    const type = field.getAttribute('type') === 'password' ? 'text' : 'password';
    field.setAttribute('type', type);
}

// Export functions for use in other modules
if (typeof module !== 'undefined' && module.exports) {
    module.exports = {
        validateEmail,
        validateUsername,
        validatePassword,
        validatePasswordConfirmation,
        validateAmount,
        validateDate,
        validateRegistrationForm,
        validateLoginForm,
        validateExpenseForm,
        validateBudgetForm,
        showError,
        hideError,
        setupRealTimeValidation,
        initRealTimeValidations,
        checkPasswordStrength,
        togglePasswordVisibility
    };
}