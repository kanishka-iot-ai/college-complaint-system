<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 - Page Not Found | College Complaint System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        /* ---- Error Page Styles ---- */
        body {
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #1a237e 0%, #283593 50%, #1565c0 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .error-container {
            background: #ffffff;
            border-radius: 16px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            padding: 60px 50px;
            text-align: center;
            max-width: 560px;
            width: 90%;
            animation: fadeInUp 0.6s ease;
        }

        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(30px); }
            to   { opacity: 1; transform: translateY(0);    }
        }

        .error-code {
            font-size: 100px;
            font-weight: 800;
            color: #1a237e;
            line-height: 1;
            margin: 0 0 10px 0;
            letter-spacing: -4px;
        }

        .error-icon {
            font-size: 64px;
            margin-bottom: 12px;
            display: block;
        }

        .error-title {
            font-size: 28px;
            font-weight: 700;
            color: #212121;
            margin: 0 0 12px 0;
        }

        .error-subtitle {
            font-size: 16px;
            color: #757575;
            margin: 0 0 36px 0;
            line-height: 1.6;
        }

        .error-divider {
            width: 60px;
            height: 4px;
            background: linear-gradient(90deg, #1a237e, #1565c0);
            border-radius: 2px;
            margin: 0 auto 28px auto;
        }

        .btn-home {
            display: inline-block;
            background: linear-gradient(135deg, #1a237e, #1565c0);
            color: #ffffff;
            text-decoration: none;
            padding: 14px 36px;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            letter-spacing: 0.5px;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            box-shadow: 0 4px 14px rgba(26, 35, 126, 0.35);
        }

        .btn-home:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(26, 35, 126, 0.45);
            color: #ffffff;
            text-decoration: none;
        }

        .btn-home:active {
            transform: translateY(0);
        }

        .suggestions {
            margin-top: 32px;
            padding-top: 24px;
            border-top: 1px solid #eeeeee;
        }

        .suggestions p {
            font-size: 14px;
            color: #9e9e9e;
            margin: 0 0 10px 0;
        }

        .suggestions a {
            color: #1565c0;
            text-decoration: none;
            font-size: 14px;
            margin: 0 10px;
        }

        .suggestions a:hover {
            text-decoration: underline;
        }

        .college-badge {
            display: inline-block;
            background: #e8eaf6;
            color: #1a237e;
            font-size: 12px;
            font-weight: 600;
            padding: 4px 12px;
            border-radius: 20px;
            margin-bottom: 20px;
            letter-spacing: 1px;
            text-transform: uppercase;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <span class="college-badge">Chandigarh University Grievance Redressal</span>
        <div style="display: flex; justify-content: center; margin-bottom: 12px;">
            <svg style="width: 56px; height: 56px; stroke: #1a237e; stroke-width: 2; fill: none;" viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
        </div>
        <div class="error-code">404</div>
        <div class="error-divider"></div>
        <h1 class="error-title">Page Not Found</h1>
        <p class="error-subtitle">
            Oops! The page you're looking for doesn't exist or has been moved.
            It might have been deleted, or you may have mistyped the URL.
        </p>
        <a href="${pageContext.request.contextPath}/index.jsp" class="btn-home">
            &#8592; Back to Home
        </a>

        <div class="suggestions">
            <p>You might be looking for:</p>
            <a href="${pageContext.request.contextPath}/index.jsp">Home</a>
            <a href="${pageContext.request.contextPath}/login.jsp">Login</a>
            <a href="${pageContext.request.contextPath}/student/dashboard.jsp">My Dashboard</a>
        </div>
    </div>
</body>
</html>
