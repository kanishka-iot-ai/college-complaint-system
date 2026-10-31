<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en" class="home-page">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Grievance Redressal Portal - Chandigarh University</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="home-page">

    <nav class="navbar">
        <a href="${pageContext.request.contextPath}/" class="navbar-brand">
            <span class="brand-icon"><img src="${pageContext.request.contextPath}/images/cu_logo.png" alt="CU Logo"></span>
            <span>CU Grievance Redressal Portal</span>
        </a>
        <ul class="nav-links">
            <li><a href="${pageContext.request.contextPath}/" class="nav-link" style="color: var(--primary); font-weight: 600;">Home</a></li>
            <li><a href="${pageContext.request.contextPath}/login.jsp" class="nav-link">Student Login</a></li>
            <li><a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-primary btn-sm">Register</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/login.jsp" class="nav-link" style="color: #64748b;">Admin Portal</a></li>
        </ul>
    </nav>

    <main class="home-wrapper">
        <div class="home-header">
            <div class="home-badge">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path></svg>
                Statutory Student Grievance Redressal Cell
            </div>
            <h1 class="home-title">Chandigarh University <span>Redressal Portal</span></h1>
            <p class="home-subtitle">
                Official institutional gateway for lodging complaints regarding academic facilities, campus services, and infrastructure, with transparent tracking and certified Action Taken Reports (ATRs) as mandated by UGC regulations.
            </p>
        </div>

        <div class="home-gateways">
            <!-- Pillar 1: Student Redressal Cell -->
            <div class="gateway-card">
                <div>
                    <div class="gateway-icon">
                        <svg class="ui-icon" viewBox="0 0 24 24"><path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"></path><line x1="12" y1="11" x2="12" y2="17"></line><line x1="9" y1="14" x2="15" y2="14"></line></svg>
                    </div>
                    <h3 class="gateway-heading">Student Redressal Cell</h3>
                    <p class="gateway-desc">
                        Lodge grievance dossiers across 11 statutory categories (Hostel, Labs, Electricity, Washrooms, Library, Internet, Faculty). Track live progress with full audit trail.
                    </p>
                </div>
                <div class="gateway-actions">
                    <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-primary">Student Sign In &rarr;</a>
                    <a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-outline">New Student Registration</a>
                </div>
            </div>

            <!-- Pillar 2: Institutional ATR & Compliance -->
            <div class="gateway-card info-card">
                <div>
                    <div class="gateway-icon">
                        <svg class="ui-icon" viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg>
                    </div>
                    <h3 class="gateway-heading">Inquiry &amp; Certified ATR</h3>
                    <p class="gateway-desc">
                        Automated complaint ID generation, formal department allocation, strict resolution SLAs, and printable certified Action Taken Reports (ATRs) with administrative remarks.
                    </p>
                </div>
                <div class="gateway-actions">
                    <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-outline" style="border-color: #3b82f6; color: #1d4ed8;">Track Existing Dossier</a>
                    <a href="${pageContext.request.contextPath}/admin/login.jsp" class="btn btn-outline" style="color: #64748b; font-size: 0.85rem;">View Redressal Charter</a>
                </div>
            </div>

            <!-- Pillar 3: Committee Administration -->
            <div class="gateway-card admin-card">
                <div>
                    <div class="gateway-icon">
                        <svg class="ui-icon" viewBox="0 0 24 24"><rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect><line x1="9" y1="3" x2="9" y2="21"></line><line x1="15" y1="3" x2="15" y2="21"></line><line x1="3" y1="9" x2="21" y2="9"></line><line x1="3" y1="15" x2="21" y2="15"></line></svg>
                    </div>
                    <h3 class="gateway-heading">Committee Console</h3>
                    <p class="gateway-desc">
                        Super Admin and Member Secretary management workspace: dynamic analytics, complaint dispatch, status updates, priority escalation, and student registry audit.
                    </p>
                </div>
                <div class="gateway-actions">
                    <a href="${pageContext.request.contextPath}/admin/login.jsp" class="btn btn-secondary">Admin Console Login &rarr;</a>
                    <span style="font-size: 0.78rem; color: #94a3b8; text-align: center;">Authorized GRC Members Only</span>
                </div>
            </div>
        </div>

        <div class="home-trust-strip">
            <div class="trust-item">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path></svg>
                <span>UGC Statutory Compliance</span>
            </div>
            <div class="trust-item">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                <span>Real-Time Status Auditing</span>
            </div>
            <div class="trust-item">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                <span>Certified Digital ATRs</span>
            </div>
            <div class="trust-item">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                <span>20 Student Records Synced</span>
            </div>
        </div>
    </main>

    <footer class="home-footer">
        &copy; 2026 Chandigarh University Grievance Redressal Cell | Official Academic Management Portal
    </footer>

</body>
</html>