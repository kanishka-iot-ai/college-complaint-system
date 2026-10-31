<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Administrator Login - College Complaint System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body style="background: linear-gradient(135deg, #0f172a 0%, #1e1b4b 100%); min-height: 100vh;">

    <div class="auth-wrapper">
        <div class="auth-card" style="border-top: 5px solid #0d9488;">
            <div class="auth-header">
                <img src="${pageContext.request.contextPath}/images/cu_logo.png" alt="CU Logo" class="brand-logo-card">
                <h1>Admin Portal</h1>
                <p>Authorized Administrative Personnel Only</p>
            </div>

            <c:if test="${not empty errorMsg}">
                <div class="alert alert-error">
                    <svg class="ui-icon-sm" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                    <span>${errorMsg}</span>
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/adminLogin" method="POST">
                <div class="form-group">
                    <label class="form-label" for="email">Admin Email</label>
                    <input type="email" id="email" name="email" class="form-control" placeholder="e.g. admin@college.edu" required autofocus>
                </div>

                <div class="form-group">
                    <label class="form-label" for="password">Security Password</label>
                    <input type="password" id="password" name="password" class="form-control" placeholder="••••••••" required>
                </div>

                <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 1rem; padding: 0.85rem; background: #0d9488; border-color: #0d9488;">
                    Enter Admin Console
                </button>
            </form>

            <div class="auth-footer">
                <p style="font-size: 0.8rem; color: #94a3b8;">
                    Demo Credentials:<br>
                    <strong>admin@college.edu</strong> / <strong>Admin@123</strong>
                </p>
                <div style="margin-top: 1rem;">
                    <a href="${pageContext.request.contextPath}/login.jsp" style="color: #64748b; font-size: 0.85rem;">
                        &larr; Switch to Student Login
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
