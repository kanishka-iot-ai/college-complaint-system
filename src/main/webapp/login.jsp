<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Portal Login - Chandigarh University</title>
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/favicon.ico?v=20261101">
    <link rel="icon" type="image/png" sizes="32x32" href="${pageContext.request.contextPath}/images/favicon-32x32.png?v=20261101">
    <link rel="icon" type="image/png" sizes="16x16" href="${pageContext.request.contextPath}/images/favicon-16x16.png?v=20261101">
    <link rel="apple-touch-icon" sizes="180x180" href="${pageContext.request.contextPath}/images/apple-touch-icon.png?v=20261101">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body style="background: linear-gradient(135deg, #1e3a8a 0%, #0f172a 100%); min-height: 100vh;">

    <div class="auth-wrapper">
        <div class="auth-card">
            <div class="auth-header">
                <img src="${pageContext.request.contextPath}/images/cu_logo.png?v=20261101" alt="CU Logo" class="brand-logo-card">
                <h1>Student Redressal Portal</h1>
                <p>Sign in with your University UID or institutional email to access grievance proceedings</p>
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

            <form action="${pageContext.request.contextPath}/studentLogin" method="POST">
                <div class="form-group">
                    <label class="form-label" for="identifier">University UID or Institutional Email</label>
                    <input type="text" id="identifier" name="identifier" class="form-control" placeholder="e.g. 26BAI10196 or 26BAI10196@cuchd.in" required autofocus>
                </div>

                <div class="form-group">
                    <label class="form-label" for="password">Password</label>
                    <input type="password" id="password" name="password" class="form-control" placeholder="••••••••" required>
                </div>

                <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 1rem; padding: 0.85rem;">
                    Sign In to Portal &rarr;
                </button>
            </form>

            <div class="auth-footer">
                <div style="background: #f1f5f9; border-radius: 8px; padding: 0.85rem; margin-bottom: 1rem; text-align: left; font-size: 0.85rem; border: 1px solid #e2e8f0;">
                    <div style="font-weight: 600; color: #1e293b; margin-bottom: 0.25rem;">First-Time Account Activation</div>
                    <div style="color: #64748b; margin-bottom: 0.6rem;">Enrolled students must activate their official university record using their registered UID to set personalized credentials:</div>
                    <a href="${pageContext.request.contextPath}/activate.jsp" class="btn btn-outline btn-sm" style="width: 100%; text-align: center; font-weight: 600; background: #ffffff;">
                        Activate Student Record
                    </a>
                </div>

                <p>New candidate enrollment? <a href="${pageContext.request.contextPath}/register.jsp" style="font-weight: 600;">Register Here</a></p>
                <div style="margin-top: 1rem; padding-top: 1rem; border-top: 1px dashed var(--border);">
                    <a href="${pageContext.request.contextPath}/admin/login.jsp" style="color: #64748b; font-size: 0.85rem;">
                        Administrator Access Portal &rarr;
                    </a>
                </div>
                <div style="margin-top: 0.5rem;">
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
