<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Account Activation - Chandigarh University</title>
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/favicon.ico?v=20261101">
    <link rel="icon" type="image/png" sizes="32x32" href="${pageContext.request.contextPath}/images/favicon-32x32.png?v=20261101">
    <link rel="icon" type="image/png" sizes="16x16" href="${pageContext.request.contextPath}/images/favicon-16x16.png?v=20261101">
    <link rel="apple-touch-icon" sizes="180x180" href="${pageContext.request.contextPath}/images/apple-touch-icon.png?v=20261101">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body style="background: linear-gradient(135deg, #1e3a8a 0%, #0f172a 100%); min-height: 100vh;">

    <div class="auth-wrapper">
        <div class="auth-card" style="max-width: 480px;">
            <div class="auth-header">
                <img src="${pageContext.request.contextPath}/images/cu_logo.png?v=20261101" alt="CU Logo" class="brand-logo-card">
                <h1>Student Account Activation</h1>
                <p>Activate your university grievance account and set your secure password</p>
            </div>

            <!-- Error and Flash Success Messages -->
            <c:if test="${not empty errorMsg}">
                <div class="alert alert-error">
                    <svg class="ui-icon-sm" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                    <span>${errorMsg}</span>
                </div>
            </c:if>
            <c:if test="${not empty sessionScope.successMsg}">
                <div class="alert alert-success">
                    <svg class="ui-icon-sm" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"></polyline></svg>
                    <span>${sessionScope.successMsg}</span>
                </div>
                <c:remove var="successMsg" scope="session"/>
            </c:if>

            <form action="${pageContext.request.contextPath}/activate" method="POST">
                <div class="form-group">
                    <label class="form-label" for="uid">University UID</label>
                    <input type="text" id="uid" name="uid" class="form-control" 
                           placeholder="e.g. 26BAI10196" 
                           value="${uid}" 
                           required autofocus 
                           oninput="autoPopulateEmail(this.value)">
                    <small style="color: var(--muted); font-size: 0.8rem;">Enter your official Chandigarh University UID</small>
                </div>

                <div class="form-group">
                    <label class="form-label" for="email">Institutional Email</label>
                    <input type="email" id="email" name="email" class="form-control" 
                           placeholder="e.g. 26BAI10196@cuchd.in" 
                           value="${email}" 
                           required>
                    <small style="color: var(--muted); font-size: 0.8rem;">Must match your official university email ([UID]@cuchd.in)</small>
                </div>

                <div class="form-group">
                    <label class="form-label" for="newPassword">Create New Password</label>
                    <input type="password" id="newPassword" name="newPassword" class="form-control" 
                           placeholder="At least 6 characters" required>
                </div>

                <div class="form-group">
                    <label class="form-label" for="confirmPassword">Confirm New Password</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" 
                           placeholder="Re-enter password" required>
                </div>

                <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 1rem; padding: 0.85rem;">
                    Activate Account &amp; Save Password
                </button>
            </form>

            <div class="auth-footer">
                <p>Already activated? <a href="${pageContext.request.contextPath}/login.jsp" style="font-weight: 600;">Sign In Here</a></p>
                <div style="margin-top: 0.5rem;">
                    <a href="${pageContext.request.contextPath}/" style="color: #94a3b8; font-size: 0.85rem;">
                        &larr; Back to Home Page
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script>
        function autoPopulateEmail(uidVal) {
            const cleanUid = uidVal.trim().toUpperCase();
            const emailInput = document.getElementById('email');
            if (cleanUid && (!emailInput.value || emailInput.value.endsWith('@cuchd.in'))) {
                emailInput.value = cleanUid + '@cuchd.in';
            }
        }
    </script>
</body>
</html>
