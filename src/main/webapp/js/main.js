/**
 * College Complaint Management System - Core JavaScript
 */

document.addEventListener('DOMContentLoaded', function () {
    // 0. Ensure viewport lock when app layout is present
    if (document.querySelector('.app-layout')) {
        document.documentElement.classList.add('has-app-layout');
        document.body.classList.add('has-app-layout');
    }

    // 1. Auto-dismiss flash alerts after 5 seconds
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(function (alert) {
        setTimeout(function () {
            alert.style.transition = 'opacity 0.5s ease';
            alert.style.opacity = '0';
            setTimeout(function () {
                alert.remove();
            }, 500);
        }, 5000);
    });

    // 2. Character counter for complaint description
    const descTextarea = document.getElementById('description');
    const charCounter = document.getElementById('charCount');
    if (descTextarea && charCounter) {
        descTextarea.addEventListener('input', function () {
            const currentLen = this.value.length;
            charCounter.textContent = currentLen;
            if (currentLen > 500) {
                charCounter.style.color = '#ef4444';
                charCounter.style.fontWeight = 'bold';
            } else {
                charCounter.style.color = '#64748b';
                charCounter.style.fontWeight = 'normal';
            }
        });
    }

    // 3. Client-side Live Search on Tables (e.g. My Complaints / Students)
    const tableSearchInput = document.getElementById('tableSearch');
    if (tableSearchInput) {
        tableSearchInput.addEventListener('keyup', function () {
            const query = this.value.toLowerCase().trim();
            const table = document.querySelector('.table tbody');
            if (!table) return;
            const rows = table.getElementsByTagName('tr');

            for (let i = 0; i < rows.length; i++) {
                const text = rows[i].textContent.toLowerCase();
                if (text.indexOf(query) > -1) {
                    rows[i].style.display = '';
                } else {
                    rows[i].style.display = 'none';
                }
            }
        });
    }

    // 4. Accessible Mobile Navigation Drawer
    const sidebar = document.querySelector('.sidebar');
    const navbar = document.querySelector('.navbar');

    if (sidebar && navbar && !document.querySelector('.drawer-toggle-btn')) {
        const toggleBtn = document.createElement('button');
        toggleBtn.type = 'button';
        toggleBtn.className = 'drawer-toggle-btn';
        toggleBtn.setAttribute('aria-label', 'Toggle Navigation Drawer');
        toggleBtn.innerHTML = `
            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <line x1="3" y1="12" x2="21" y2="12"></line>
                <line x1="3" y1="6" x2="21" y2="6"></line>
                <line x1="3" y1="18" x2="21" y2="18"></line>
            </svg>
        `;

        const backdrop = document.createElement('div');
        backdrop.className = 'sidebar-backdrop';
        document.body.appendChild(backdrop);

        navbar.prepend(toggleBtn);

        function toggleDrawer() {
            sidebar.classList.toggle('drawer-open');
            backdrop.classList.toggle('active');
        }

        toggleBtn.addEventListener('click', toggleDrawer);
        backdrop.addEventListener('click', toggleDrawer);

        // Close drawer on Esc key
        document.addEventListener('keydown', function (e) {
            if (e.key === 'Escape' && sidebar.classList.contains('drawer-open')) {
                toggleDrawer();
            }
        });
    }
});

// Client-side Validation for Student Registration
function validateRegistrationForm() {
    const name = document.getElementById('name').value.trim();
    const email = document.getElementById('email').value.trim();
    const password = document.getElementById('password').value;
    const confirmPassword = document.getElementById('confirmPassword').value;
    const phone = document.getElementById('phone').value.trim();
    const semester = document.getElementById('semester').value;

    if (!name || !email || !password || !confirmPassword || !phone || !semester) {
        alert('All fields are mandatory. Please fill in all details.');
        return false;
    }

    // Email pattern check
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
        alert('Please enter a valid email address.');
        return false;
    }

    // Phone check (10 digits)
    const phoneRegex = /^[0-9]{10}$/;
    if (!phoneRegex.test(phone)) {
        alert('Please enter a valid 10-digit mobile number.');
        return false;
    }

    // Password length & confirmation
    if (password.length < 8) {
        alert('Password must be at least 8 characters long.');
        return false;
    }

    if (password !== confirmPassword) {
        alert('Passwords do not match. Please re-enter.');
        return false;
    }

    return true;
}

// Client-side Validation for Submitting Complaint
function validateComplaintForm() {
    const category = document.getElementById('categoryId').value;
    const title = document.getElementById('title').value.trim();
    const description = document.getElementById('description').value.trim();

    if (!category) {
        alert('Please select a complaint category.');
        return false;
    }

    if (!title || title.length < 5) {
        alert('Please provide a meaningful title (at least 5 characters).');
        return false;
    }

    if (!description || description.length < 15) {
        alert('Please provide detailed description (at least 15 characters).');
        return false;
    }

    return true;
}

// Client-side confirmation for Admin Status Updates
function confirmStatusUpdate() {
    const newStatus = document.getElementById('newStatus').value;
    const remarks = document.getElementById('remarks').value.trim();

    if (!remarks) {
        alert('Administrator remarks are required for recording this update.');
        return false;
    }

    return confirm('Are you sure you want to change complaint status to "' + newStatus + '"?');
}
