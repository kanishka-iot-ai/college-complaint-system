/**
 * admin.js — Admin-Specific JavaScript
 * College Complaint Management System
 *
 * Functions:
 *  - drawCategoryChart(canvasId, labels, data)
 *  - initFilterReset()
 *  - initStatusUpdateConfirm()
 *  - updateStatusHint(selectElement)
 *  - initAdminPage()
 */

'use strict';

/* ==========================================================================
   1. CHART DRAWING — Horizontal Bar Chart (Canvas 2D API)
   ========================================================================== */

/**
 * Draw a horizontal bar chart on a <canvas> element using the Canvas 2D API.
 *
 * @param {string}   canvasId - The id of the target <canvas> element.
 * @param {string[]} labels   - Array of category name strings (Y-axis labels).
 * @param {number[]} data     - Array of complaint counts matching each label.
 *
 * Usage (from JSP):
 *   drawCategoryChart('categoryChart', ['Infrastructure','Academic','Hostel'], [12, 8, 5]);
 */
function drawCategoryChart(canvasId, labels, data) {
    const canvas = document.getElementById(canvasId);
    if (!canvas) {
        console.warn('[admin.js] drawCategoryChart: canvas #' + canvasId + ' not found.');
        return;
    }
    if (!labels || !data || labels.length === 0) {
        console.warn('[admin.js] drawCategoryChart: no data provided.');
        return;
    }

    const ctx = canvas.getContext('2d');

    // --- Layout constants ---
    const PADDING_LEFT   = 160;  // space for labels on the left
    const PADDING_RIGHT  = 60;   // space for value labels on the right
    const PADDING_TOP    = 20;
    const PADDING_BOTTOM = 20;
    const BAR_HEIGHT     = 32;
    const BAR_GAP        = 16;
    const CORNER_RADIUS  = 5;

    // Bar colour palette (cycles if more categories than colours)
    const COLORS = [
        '#1a237e', '#1565c0', '#00897b', '#6a1b9a',
        '#e65100', '#2e7d32', '#c62828', '#f57f17',
        '#0277bd', '#37474f', '#4527a0', '#00695c'
    ];

    const numBars       = labels.length;
    const maxVal        = Math.max(...data, 1);

    // Compute canvas dimensions
    const totalHeight = PADDING_TOP + numBars * (BAR_HEIGHT + BAR_GAP) + PADDING_BOTTOM;
    canvas.width      = canvas.parentElement ? canvas.parentElement.clientWidth || 600 : 600;
    canvas.height     = totalHeight;

    const chartWidth = canvas.width - PADDING_LEFT - PADDING_RIGHT;

    // Clear
    ctx.clearRect(0, 0, canvas.width, canvas.height);

    // Grid lines (subtle vertical lines)
    const gridLines = 5;
    ctx.strokeStyle = '#e0e0e0';
    ctx.lineWidth   = 1;
    for (let i = 0; i <= gridLines; i++) {
        const x = PADDING_LEFT + (chartWidth / gridLines) * i;
        ctx.beginPath();
        ctx.moveTo(x, PADDING_TOP);
        ctx.lineTo(x, totalHeight - PADDING_BOTTOM);
        ctx.stroke();
    }

    // Draw each bar
    labels.forEach(function (label, i) {
        const y        = PADDING_TOP + i * (BAR_HEIGHT + BAR_GAP);
        const barWidth = data[i] > 0 ? (data[i] / maxVal) * chartWidth : 0;
        const color    = COLORS[i % COLORS.length];

        // --- Category label (left side) ---
        ctx.fillStyle = '#37474f';
        ctx.font      = '13px "Segoe UI", sans-serif';
        ctx.textAlign = 'right';
        ctx.textBaseline = 'middle';
        const labelText = label.length > 20 ? label.substring(0, 18) + '…' : label;
        ctx.fillText(labelText, PADDING_LEFT - 10, y + BAR_HEIGHT / 2);

        // --- Bar background (track) ---
        ctx.fillStyle = '#f5f5f5';
        _roundRect(ctx, PADDING_LEFT, y, chartWidth, BAR_HEIGHT, CORNER_RADIUS);
        ctx.fill();

        // --- Filled bar ---
        if (barWidth > 0) {
            // Gradient fill
            const grad = ctx.createLinearGradient(PADDING_LEFT, 0, PADDING_LEFT + barWidth, 0);
            grad.addColorStop(0, color);
            grad.addColorStop(1, _lightenColor(color, 30));
            ctx.fillStyle = grad;
            _roundRect(ctx, PADDING_LEFT, y, barWidth, BAR_HEIGHT, CORNER_RADIUS);
            ctx.fill();
        }

        // --- Value label (end of bar) ---
        ctx.fillStyle    = '#212121';
        ctx.font         = 'bold 13px "Segoe UI", sans-serif';
        ctx.textAlign    = 'left';
        ctx.textBaseline = 'middle';
        const valueLabelX = PADDING_LEFT + barWidth + 8;
        ctx.fillText(data[i], valueLabelX, y + BAR_HEIGHT / 2);
    });

    // Left axis line
    ctx.strokeStyle = '#bdbdbd';
    ctx.lineWidth   = 1.5;
    ctx.beginPath();
    ctx.moveTo(PADDING_LEFT, PADDING_TOP);
    ctx.lineTo(PADDING_LEFT, totalHeight - PADDING_BOTTOM);
    ctx.stroke();
}

/**
 * Helper: draw a rounded rectangle path.
 * @param {CanvasRenderingContext2D} ctx
 * @param {number} x
 * @param {number} y
 * @param {number} width
 * @param {number} height
 * @param {number} radius
 */
function _roundRect(ctx, x, y, width, height, radius) {
    if (width < 2 * radius) radius = width / 2;
    if (height < 2 * radius) radius = height / 2;
    ctx.beginPath();
    ctx.moveTo(x + radius, y);
    ctx.arcTo(x + width, y, x + width, y + height, radius);
    ctx.arcTo(x + width, y + height, x, y + height, radius);
    ctx.arcTo(x, y + height, x, y, radius);
    ctx.arcTo(x, y, x + width, y, radius);
    ctx.closePath();
}

/**
 * Helper: lighten a hex color by the given amount.
 * @param {string} hex   - e.g. '#1a237e'
 * @param {number} amount - 0-255 brightness to add
 * @returns {string}
 */
function _lightenColor(hex, amount) {
    const num = parseInt(hex.replace('#', ''), 16);
    const r   = Math.min(255, (num >> 16) + amount);
    const g   = Math.min(255, ((num >> 8) & 0xff) + amount);
    const b   = Math.min(255, (num & 0xff) + amount);
    return '#' + [r, g, b].map(function (v) {
        return v.toString(16).padStart(2, '0');
    }).join('');
}

/* ==========================================================================
   2. FILTER FORM — Reset Button
   ========================================================================== */

/**
 * Initialise the admin filter form reset functionality.
 * Clears all <select> dropdowns, text inputs, and date inputs
 * within any element that has the class "admin-filter-bar".
 */
function initFilterReset() {
    var resetBtns = document.querySelectorAll('.btn-filter-reset');
    resetBtns.forEach(function (btn) {
        btn.addEventListener('click', function (e) {
            e.preventDefault();

            // Find the closest filter form or the entire filter bar
            var filterBar = btn.closest('.admin-filter-bar') ||
                            btn.closest('form') ||
                            document.querySelector('.admin-filter-bar');

            if (!filterBar) return;

            // Reset all selects to first option
            filterBar.querySelectorAll('select').forEach(function (sel) {
                sel.selectedIndex = 0;
            });

            // Clear text inputs
            filterBar.querySelectorAll('input[type="text"], input[type="search"]').forEach(function (inp) {
                inp.value = '';
            });

            // Clear date inputs
            filterBar.querySelectorAll('input[type="date"]').forEach(function (inp) {
                inp.value = '';
            });

            // If inside a form, optionally submit to refresh (uncomment if desired)
            // var form = btn.closest('form');
            // if (form) form.submit();

            // Feedback: briefly highlight the filter bar
            filterBar.style.transition = 'background 0.3s ease';
            filterBar.style.background = '#e8f5e9';
            setTimeout(function () {
                filterBar.style.background = '';
            }, 500);
        });
    });
}

/* ==========================================================================
   3. STATUS UPDATE CONFIRM DIALOG
   ========================================================================== */

/**
 * Initialise confirmation dialog for status update form submission.
 * Shows: "Are you sure you want to update this complaint's status to [newStatus]?"
 * before the form is actually submitted.
 */
function initStatusUpdateConfirm() {
    var statusForms = document.querySelectorAll('.status-update-form');

    statusForms.forEach(function (form) {
        form.addEventListener('submit', function (e) {
            var statusSelect = form.querySelector('select.status-select');
            if (!statusSelect) return; // no select found, allow submission

            var newStatus = statusSelect.options[statusSelect.selectedIndex].text ||
                            statusSelect.value;

            var confirmed = window.confirm(
                'Are you sure you want to update this complaint\'s status to "' +
                newStatus + '"?\n\nThis action will notify the student.'
            );

            if (!confirmed) {
                e.preventDefault();
            }
        });
    });
}

/* ==========================================================================
   4. STATUS HINT — Auto-populate Remarks & Update Hint Text
   ========================================================================== */

/**
 * Update the hint text displayed below the Remarks textarea based on
 * the selected complaint status. Also auto-fills hint text when
 * "Rejected" is selected.
 *
 * @param {HTMLSelectElement} selectElement - The status <select> element.
 */
function updateStatusHint(selectElement) {
    if (!selectElement) return;

    var form      = selectElement.closest('.status-update-form') || selectElement.closest('form');
    var hintEl    = form ? form.querySelector('.status-hint') : null;
    var remarksEl = form ? form.querySelector('.remarks-field textarea') : null;

    var hintMessages = {
        'Pending':    {
            text:  'Complaint is awaiting review. No action taken yet.',
            cls:   'hint-warning',
            fill:  ''
        },
        'InProgress': {
            text:  'Complaint is being actively worked on. Describe the current progress in remarks.',
            cls:   'hint-warning',
            fill:  ''
        },
        'Resolved':   {
            text:  'Mark as Resolved when the complaint has been fully addressed. Add a resolution note.',
            cls:   'hint-success',
            fill:  ''
        },
        'Rejected':   {
            text:  'Rejected complaints will be closed. Please provide a clear reason for rejection.',
            cls:   'hint-danger',
            fill:  'This complaint has been reviewed and rejected. Reason: '
        },
        'Closed':     {
            text:  'Complaint will be permanently closed. This action is final.',
            cls:   'hint-danger',
            fill:  ''
        }
    };

    var val  = selectElement.value;
    var info = hintMessages[val] || { text: '', cls: '', fill: '' };

    // Update hint element
    if (hintEl) {
        hintEl.textContent = info.text;
        hintEl.className   = 'status-hint ' + info.cls;
    }

    // Auto-populate remarks for "Rejected" if the field is currently empty
    if (remarksEl && info.fill && remarksEl.value.trim() === '') {
        remarksEl.value = info.fill;
        remarksEl.focus();
        // Move cursor to end
        var len = remarksEl.value.length;
        remarksEl.setSelectionRange(len, len);
    }
}

/* ==========================================================================
   5. MISC ADMIN UTILITIES
   ========================================================================== */

/**
 * Show a toast-style notification in the admin panel.
 * Creates and appends a temporary notification div.
 *
 * @param {string} message  - The message to display.
 * @param {string} type     - 'success' | 'error' | 'info' | 'warning'
 * @param {number} duration - Auto-dismiss time in ms (default 3500)
 */
function showAdminToast(message, type, duration) {
    type     = type     || 'info';
    duration = duration || 3500;

    var colors = {
        success: { bg: '#e8f5e9', border: '#2e7d32', text: '#1b5e20' },
        error:   { bg: '#fce4ec', border: '#b71c1c', text: '#7f0000' },
        warning: { bg: '#fff3e0', border: '#e65100', text: '#bf360c' },
        info:    { bg: '#e3f2fd', border: '#1565c0', text: '#0d47a1' }
    };

    var c   = colors[type] || colors.info;
    var div = document.createElement('div');

    div.textContent = message;
    Object.assign(div.style, {
        position:     'fixed',
        bottom:       '24px',
        right:        '24px',
        background:   c.bg,
        border:       '1px solid ' + c.border,
        borderLeft:   '4px solid ' + c.border,
        color:        c.text,
        padding:      '14px 20px',
        borderRadius: '8px',
        fontSize:     '14px',
        fontWeight:   '600',
        fontFamily:   'Segoe UI, sans-serif',
        boxShadow:    '0 4px 16px rgba(0,0,0,0.15)',
        zIndex:       '9999',
        maxWidth:     '360px',
        animation:    'none',
        opacity:      '1',
        transition:   'opacity 0.4s ease'
    });

    document.body.appendChild(div);

    setTimeout(function () {
        div.style.opacity = '0';
        setTimeout(function () {
            if (div.parentNode) div.parentNode.removeChild(div);
        }, 400);
    }, duration);
}

/**
 * Confirm a destructive action (e.g. deactivating a student account).
 *
 * @param {string} message - Custom confirmation message.
 * @returns {boolean}
 */
function confirmDestructive(message) {
    return window.confirm(message || 'Are you sure? This action cannot be undone.');
}

/**
 * Highlight a table row briefly when an action is taken on it.
 * @param {HTMLElement} row - The <tr> element.
 * @param {string} color    - CSS background color (default light green).
 */
function highlightTableRow(row, color) {
    if (!row) return;
    color = color || '#e8f5e9';
    var orig = row.style.background;
    row.style.transition = 'background 0.3s ease';
    row.style.background = color;
    setTimeout(function () {
        row.style.background = orig;
    }, 1200);
}

/* ==========================================================================
   6. PAGE INITIALISATION
   ========================================================================== */

/**
 * Main initialisation entry point.
 * Called automatically on DOMContentLoaded.
 * Sets up all admin interactive behaviours on the current page.
 */
function initAdminPage() {
    // 1. Filter reset buttons
    initFilterReset();

    // 2. Status update form confirmation
    initStatusUpdateConfirm();

    // 3. Status select hint (attach to existing selects)
    var statusSelects = document.querySelectorAll('select.status-select');
    statusSelects.forEach(function (sel) {
        // Trigger hint on change
        sel.addEventListener('change', function () {
            updateStatusHint(sel);
        });
        // Show initial hint based on current value
        updateStatusHint(sel);
    });

    // 4. Auto-dismiss success/error flash messages (if present)
    var flashMessages = document.querySelectorAll('.flash-message[data-auto-dismiss]');
    flashMessages.forEach(function (msg) {
        var delay = parseInt(msg.getAttribute('data-auto-dismiss')) || 4000;
        setTimeout(function () {
            msg.style.transition = 'opacity 0.5s ease';
            msg.style.opacity    = '0';
            setTimeout(function () {
                if (msg.parentNode) msg.parentNode.removeChild(msg);
            }, 500);
        }, delay);
    });

    // 5. Activate "active" sidebar link based on current URL
    var currentPath = window.location.pathname;
    var navLinks    = document.querySelectorAll('.sidebar .nav-link');
    navLinks.forEach(function (link) {
        if (link.getAttribute('href') && currentPath.endsWith(link.getAttribute('href'))) {
            link.classList.add('active');
        }
    });
}

// Auto-initialise when DOM is ready
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initAdminPage);
} else {
    initAdminPage();
}
