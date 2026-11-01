<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>500 - Server Error | College Complaint System</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/cu_logo.png">
    <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/favicon.ico">
    <link rel="apple-touch-icon" href="${pageContext.request.contextPath}/images/cu_logo.png">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        /* ---- Error Page Styles ---- */
        body {
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #b71c1c 0%, #c62828 50%, #e53935 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .error-container {
            background: #ffffff;
            border-radius: 16px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.35);
            padding: 60px 50px;
            text-align: center;
            max-width: 580px;
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
            color: #b71c1c;
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
            margin: 0 0 10px 0;
            line-height: 1.6;
        }

        .error-hint {
            font-size: 14px;
            color: #9e9e9e;
            margin: 0 0 32px 0;
        }

        .error-divider {
            width: 60px;
            height: 4px;
            background: linear-gradient(90deg, #b71c1c, #e53935);
            border-radius: 2px;
            margin: 0 auto 28px auto;
        }

        .btn-home {
            display: inline-block;
            background: linear-gradient(135deg, #b71c1c, #e53935);
            color: #ffffff;
            text-decoration: none;
            padding: 14px 36px;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            letter-spacing: 0.5px;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            box-shadow: 0 4px 14px rgba(183, 28, 28, 0.35);
        }

        .btn-home:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(183, 28, 28, 0.45);
            color: #ffffff;
            text-decoration: none;
        }

        .btn-home:active {
            transform: translateY(0);
        }

        .btn-retry {
            display: inline-block;
            background: transparent;
            color: #b71c1c;
            text-decoration: none;
            padding: 13px 28px;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            border: 2px solid #b71c1c;
            margin-left: 12px;
            transition: background 0.2s ease, color 0.2s ease;
        }

        .btn-retry:hover {
            background: #b71c1c;
            color: #ffffff;
            text-decoration: none;
        }

        .college-badge {
            display: inline-block;
            background: #ffebee;
            color: #b71c1c;
            font-size: 12px;
            font-weight: 600;
            padding: 4px 12px;
            border-radius: 20px;
            margin-bottom: 20px;
            letter-spacing: 1px;
            text-transform: uppercase;
        }

        .error-details {
            margin-top: 32px;
            padding: 16px;
            background: #fff8f8;
            border: 1px solid #ffcdd2;
            border-radius: 8px;
            text-align: left;
        }

        .error-details summary {
            font-size: 13px;
            color: #b71c1c;
            cursor: pointer;
            font-weight: 600;
        }

        .error-details pre {
            font-size: 11px;
            color: #757575;
            margin: 10px 0 0 0;
            white-space: pre-wrap;
            word-break: break-all;
            max-height: 120px;
            overflow-y: auto;
        }

        .actions {
            margin-top: 28px;
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
            gap: 10px;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <span class="college-badge">Chandigarh University Grievance Redressal</span>
        <div style="display: flex; justify-content: center; margin-bottom: 12px;">
            <svg style="width: 56px; height: 56px; stroke: #b71c1c; stroke-width: 2; fill: none;" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
        </div>
        <div class="error-code">500</div>
        <div class="error-divider"></div>
        <h1 class="error-title">Internal Server Error</h1>
        <p class="error-subtitle">
            Something went wrong on our end. Please try again in a moment.
        </p>
        <p class="error-hint">
            If the problem persists, please contact the system administrator.
        </p>

        <div class="actions">
            <a href="${pageContext.request.contextPath}/index.jsp" class="btn-home">
                &#8592; Back to Home
            </a>
            <a href="javascript:history.back()" class="btn-retry">
                &#8635; Try Again
            </a>
        </div>

        <%-- Only show technical details in development (remove in production) --%>
        <%
            Throwable throwable = (Throwable) request.getAttribute("javax.servlet.error.exception");
            if (throwable != null) {
        %>
        <div class="error-details">
            <details>
                <summary>Technical Details (Development Mode)</summary>
                <pre><%
                    out.print(throwable.getClass().getName() + ": " + throwable.getMessage());
                    java.io.StringWriter sw = new java.io.StringWriter();
                    throwable.printStackTrace(new java.io.PrintWriter(sw));
                    // Show first 600 chars of stack trace
                    String stack = sw.toString();
                    if (stack.length() > 600) stack = stack.substring(0, 600) + "\n...";
                    out.print("\n\n" + stack);
                %></pre>
            </details>
        </div>
        <% } %>
    </div>
</body>
</html>
