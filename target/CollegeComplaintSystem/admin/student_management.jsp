<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Records - Admin Console</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body>

    <nav class="navbar" style="border-bottom: 2px solid #0d9488;">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="navbar-brand">
            <span class="brand-icon"><img src="${pageContext.request.contextPath}/images/cu_logo.png" alt="CU Logo"></span>
            <span>Admin Console</span>
        </a>
        <div style="display: flex; align-items: center; gap: 1rem;">
            <span style="font-size: 0.95rem; color: var(--slate);">
                Logged as: <strong>${sessionScope.loggedAdmin.name}</strong>
            </span>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-sm">Sign Out</a>
        </div>
    </nav>

    <div class="app-layout">
        <aside class="sidebar admin-sidebar">
            <div>
                <div class="sidebar-header">
                    <div class="sidebar-title">Grievance Cell</div>
                    <div class="sidebar-user">
                        <img src="${pageContext.request.contextPath}/images/cu_logo.png" alt="CU Logo" class="sidebar-user-logo">
                        <span>Member Secretary, GRC</span>
                    </div>
                </div>

                <ul class="sidebar-menu">
                    <li class="sidebar-item">
                        <a href="${pageContext.request.contextPath}/admin/dashboard">
                            <svg class="ui-icon" viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="9"></rect><rect x="14" y="3" width="7" height="5"></rect><rect x="14" y="12" width="7" height="9"></rect><rect x="3" y="16" width="7" height="5"></rect></svg> Dashboard
                        </a>
                    </li>
                    <li class="sidebar-item">
                        <a href="${pageContext.request.contextPath}/admin/allComplaints">
                            <svg class="ui-icon" viewBox="0 0 24 24"><path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"></path></svg> Grievance Dossiers
                        </a>
                    </li>
                    <li class="sidebar-item active">
                        <a href="${pageContext.request.contextPath}/admin/studentManagement">
                            <svg class="ui-icon" viewBox="0 0 24 24"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg> Student Registry
                        </a>
                    </li>
                    <li class="sidebar-item">
                        <a href="${pageContext.request.contextPath}/admin/reports">
                            <svg class="ui-icon" viewBox="0 0 24 24"><line x1="18" y1="20" x2="18" y2="10"></line><line x1="12" y1="20" x2="12" y2="4"></line><line x1="6" y1="20" x2="6" y2="14"></line></svg> Statistical ATR Reports
                        </a>
                    </li>
                </ul>
            </div>

            <div class="sidebar-footer">
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-sm" style="width: 100%; color: #cbd5e1; border-color: rgba(255,255,255,0.2);">
                    <svg class="ui-icon-sm" viewBox="0 0 24 24"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path><polyline points="16 17 21 12 16 7"></polyline><line x1="21" y1="12" x2="9" y2="12"></line></svg> Sign Out
                </a>
            </div>
        </aside>

        <main class="main-content">
            <nav class="breadcrumb-container" aria-label="Breadcrumb" style="margin: -1.25rem -1rem 1.25rem -1rem; padding: 0.75rem 1.25rem;">
                <ol class="breadcrumb-list">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Admin Console</a></li>
                    <li class="breadcrumb-separator">/</li>
                    <li class="breadcrumb-item active" aria-current="page">Student Registry</li>
                </ol>
            </nav>

            <div class="page-header">
                <div>
                    <h1 class="page-title">Authorized Student Registry</h1>
                    <p class="page-subtitle">Roster of authenticated students authorized to submit campus grievances under UGC Regulations.</p>
                </div>
            </div>

            <div class="card">
                <div class="card-header" style="justify-content: space-between; flex-wrap: wrap; gap: 1rem;">
                    <div>
                        <h2 class="card-title">Enrolled Students (${students.size()} registered)</h2>
                        <span style="font-size: 0.85rem; color: var(--muted);">Direct university records synchronized with UIMS identity services.</span>
                    </div>
                    <form method="GET" action="${pageContext.request.contextPath}/admin/studentManagement" style="display: flex; gap: 0.75rem; flex-wrap: wrap; width: 100%; max-width: 580px;">
                        <select name="section" class="form-control" style="padding: 0.4rem 0.8rem; font-size: 0.85rem; flex: 1; min-width: 200px;" onchange="this.form.submit()">
                            <option value="ALL" ${empty sectionParam || sectionParam == 'ALL' ? 'selected' : ''}>All Academic Sections</option>
                            <option value="Future Skills & Innovation" ${sectionParam == 'Future Skills & Innovation' ? 'selected' : ''}>Future Skills &amp; Innovation (19)</option>
                            <option value="Society, Sustainability & Human Values" ${sectionParam == 'Society, Sustainability & Human Values' ? 'selected' : ''}>Society, Sustainability &amp; Human Values (1)</option>
                        </select>
                        <div style="flex: 1; min-width: 220px;">
                            <input type="text" id="tableSearch" name="search" class="form-control" 
                                   value="${searchParam}" 
                                   placeholder="Search by UID, Name, or Email..." 
                                   style="padding: 0.4rem 0.8rem; font-size: 0.85rem;">
                        </div>
                        <button type="submit" class="btn btn-primary btn-sm">Filter</button>
                        <c:if test="${not empty searchParam || (not empty sectionParam && sectionParam != 'ALL')}">
                            <a href="${pageContext.request.contextPath}/admin/studentManagement" class="btn btn-outline btn-sm">Reset</a>
                        </c:if>
                    </form>
                </div>

                <div class="card-body" style="padding: 0;">
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>University UID</th>
                                    <th>Student Name</th>
                                    <th>Institutional Email</th>
                                    <th>Section / Category</th>
                                    <th>Account Status</th>
                                    <th>Registered Date</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty students}">
                                        <c:forEach var="s" items="${students}">
                                            <tr>
                                                <td><span style="color: var(--muted); font-size: 0.85rem;">#${s.studentId}</span></td>
                                                <td><strong style="color: #1e3a8a; font-family: monospace; font-size: 0.95rem;">${s.uid}</strong></td>
                                                <td><strong>${s.name}</strong></td>
                                                <td><a href="mailto:${s.email}" style="color: var(--primary); text-decoration: underline;">${s.email}</a></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${s.section == 'Society, Sustainability & Human Values'}">
                                                            <span class="badge badge-section-humanities">${s.section}</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge badge-section-innovation">${s.section}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${s.active}">
                                                            <span class="badge-academic badge-academic-success">Active Enrolled</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge-academic badge-academic-neutral">Pending Activation</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td><fmt:formatDate value="${s.createdAt}" pattern="dd MMM yyyy"/></td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="7" style="text-align: center; padding: 2rem; color: var(--muted);">
                                                No students found matching your criteria.
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <script src="${pageContext.request.contextPath}/js/main.js"></script>
    <script src="${pageContext.request.contextPath}/js/admin.js"></script>
</body>
</html>
