<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Registration - College Complaint System</title>
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/favicon.ico?v=20261101">
    <link rel="icon" type="image/png" sizes="32x32" href="${pageContext.request.contextPath}/images/favicon-32x32.png?v=20261101">
    <link rel="icon" type="image/png" sizes="16x16" href="${pageContext.request.contextPath}/images/favicon-16x16.png?v=20261101">
    <link rel="apple-touch-icon" sizes="180x180" href="${pageContext.request.contextPath}/images/apple-touch-icon.png?v=20261101">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body style="background: linear-gradient(135deg, #1e3a8a 0%, #0f172a 100%); min-height: 100vh;">

    <div class="auth-wrapper">
        <div class="auth-card wide">
            <div class="auth-header">
                <img src="${pageContext.request.contextPath}/images/cu_logo.png?v=20261101" alt="CU Logo" class="brand-logo-card">
                <h1>Student Registration</h1>
                <p>Create an account to submit complaints and follow up on inquiries</p>
            </div>

            <c:if test="${not empty errorMsg}">
                <div class="alert alert-error">
                    <svg class="ui-icon-sm" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                    <span>${errorMsg}</span>
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/register" method="POST" onsubmit="return validateRegistrationForm();">
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label" for="name">Full Name *</label>
                        <input type="text" id="name" name="name" class="form-control" placeholder="e.g. Rahul Sharma" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="email">College Email Address *</label>
                        <input type="email" id="email" name="email" class="form-control" placeholder="e.g. rahul@student.edu" required>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label" for="department">Department / Branch *</label>
                        <select id="department" name="department" class="form-control" required>
                            <option value="">-- Select Department --</option>
                            <option value="Computer Science">Computer Science & Engineering</option>
                            <option value="Information Technology">Information Technology</option>
                            <option value="Electronics">Electronics & Communication</option>
                            <option value="Mechanical">Mechanical Engineering</option>
                            <option value="Civil">Civil Engineering</option>
                            <option value="Electrical">Electrical Engineering</option>
                            <option value="Management">Management Studies (MBA)</option>
                            <option value="Computer Applications">Computer Applications (MCA)</option>
                            <option value="Other">Other</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="semester">Current Semester *</label>
                        <select id="semester" name="semester" class="form-control" required>
                            <option value="">-- Select Semester --</option>
                            <option value="1">Semester 1</option>
                            <option value="2">Semester 2</option>
                            <option value="3">Semester 3</option>
                            <option value="4">Semester 4</option>
                            <option value="5">Semester 5</option>
                            <option value="6">Semester 6</option>
                            <option value="7">Semester 7</option>
                            <option value="8">Semester 8</option>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="phone">Contact Mobile Number *</label>
                    <input type="tel" id="phone" name="phone" class="form-control" placeholder="10-digit mobile number" maxlength="10" required>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label" for="password">Create Password *</label>
                        <input type="password" id="password" name="password" class="form-control" placeholder="Min. 8 characters" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="confirmPassword">Confirm Password *</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" placeholder="Re-enter password" required>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 1rem; padding: 0.85rem;">
                    Complete Registration
                </button>
            </form>

            <div class="auth-footer">
                <p>Already have an account? <a href="${pageContext.request.contextPath}/login.jsp" style="font-weight: 600;">Sign In here</a></p>
                <div style="margin-top: 0.75rem;">
                    <a href="${pageContext.request.contextPath}/" style="color: #94a3b8; font-size: 0.85rem;">
                        &larr; Back to Home Page
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
