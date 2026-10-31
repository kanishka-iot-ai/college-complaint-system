<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Grievance Dossiers - Chandigarh University</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

    <nav class="navbar">
        <a href="${pageContext.request.contextPath}/student/dashboard" class="navbar-brand">
            <span class="brand-icon"><img src="${pageContext.request.contextPath}/images/cu_logo.png" alt="CU Logo"></span>
            <span>Student Redressal Portal</span>
        </a>
        <div style="display: flex; align-items: center; gap: 1rem;">
            <span style="font-size: 0.95rem; color: var(--slate); display: inline-flex; align-items: center; gap: 0.4rem;">
                <svg class="ui-icon-sm" viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                <strong>${sessionScope.loggedStudent.name}</strong>
                <c:if test="${not empty sessionScope.loggedStudent.uid}">
                    <span class="badge badge-section-innovation">${sessionScope.loggedStudent.uid}</span>
                </c:if>
            </span>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-sm">Log Out</a>
        </div>
    </nav>

    <div class="app-layout">
        <aside class="sidebar">
            <div>
                <div class="sidebar-header">
                    <div class="sidebar-title">Student Portal</div>
                    <div class="sidebar-user">
                        <img src="${pageContext.request.contextPath}/images/cu_logo.png" alt="CU Logo" class="sidebar-user-logo">
                        <span>${sessionScope.loggedStudent.name}</span>
                    </div>
                </div>

                <ul class="sidebar-menu">
                    <li class="sidebar-item">
                        <a href="${pageContext.request.contextPath}/student/dashboard">
                            <svg class="ui-icon" viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="9"></rect><rect x="14" y="3" width="7" height="5"></rect><rect x="14" y="12" width="7" height="9"></rect><rect x="3" y="16" width="7" height="5"></rect></svg>
                            <span>Dashboard Overview</span>
                        </a>
                    </li>
                    <li class="sidebar-item">
                        <a href="${pageContext.request.contextPath}/student/submitComplaint">
                            <svg class="ui-icon" viewBox="0 0 24 24"><path d="M12 5v14"></path><path d="M5 12h14"></path></svg>
                            <span>Lodge Grievance</span>
                        </a>
                    </li>
                    <li class="sidebar-item active">
                        <a href="${pageContext.request.contextPath}/student/myComplaints">
                            <svg class="ui-icon" viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg>
                            <span>My Grievance Dossiers</span>
                        </a>
                    </li>
                    <li class="sidebar-item">
                        <a href="${pageContext.request.contextPath}/student/profile">
                            <svg class="ui-icon" viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                            <span>Academic Profile</span>
                        </a>
                    </li>
                </ul>
            </div>

            <div class="sidebar-footer">
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-sm" style="width: 100%; color: #cbd5e1; border-color: rgba(255,255,255,0.2);">
                    <svg class="ui-icon-sm" viewBox="0 0 24 24"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path><polyline points="16 17 21 12 16 7"></polyline><line x1="21" y1="12" x2="9" y2="12"></line></svg>
                    <span>Sign Out</span>
                </a>
            </div>
        </aside>

        <main class="main-content">
            <nav class="breadcrumb-container" aria-label="Breadcrumb" style="margin: -1.25rem -1rem 1.25rem -1rem; padding: 0.75rem 1.25rem;">
                <ol class="breadcrumb-list">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/student/dashboard">Student Portal</a></li>
                    <li class="breadcrumb-separator">/</li>
                    <li class="breadcrumb-item active" aria-current="page">My Grievance Dossiers</li>
                </ol>
            </nav>

            <div class="page-header">
                <div>
                    <h1 class="page-title">My Registered Grievance Dossiers</h1>
                    <p class="page-subtitle">Track real-time inquiry status transitions, designated maintenance cells, and certified Action Taken Reports (ATRs).</p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/student/submitComplaint" class="btn btn-primary">
                        <svg class="ui-icon-sm" viewBox="0 0 24 24"><path d="M12 5v14"></path><path d="M5 12h14"></path></svg>
                        Lodge Grievance Dossier
                    </a>
                </div>
            </div>

            <c:if test="${not empty successMsg}">
                <div class="alert alert-success">
                    <svg class="ui-icon-sm" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"></polyline></svg>
                    <span>${successMsg}</span>
                </div>
            </c:if>

            <c:if test="${not empty errorMsg}">
                <div class="alert alert-error">
                    <svg class="ui-icon-sm" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                    <span>${errorMsg}</span>
                </div>
            </c:if>

            <div class="card">
                <div class="card-header" style="flex-wrap: wrap; gap: 1rem; justify-content: space-between;">
                    <h2 class="card-title">Grievance Proceeding Register</h2>
                    <div style="max-width: 320px; width: 100%;">
                        <input type="text" id="tableSearch" class="form-control" placeholder="Search dossiers by keyword or ID..." style="padding: 0.45rem 0.85rem; font-size: 0.9rem;">
                    </div>
                </div>

                <div class="card-body" style="padding: 0;">
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th class="col-ref">Reference ID</th>
                                    <th class="col-title">Subject &amp; Allegation</th>
                                    <th class="col-category">Domain</th>
                                    <th class="col-priority">Priority</th>
                                    <th class="col-status">Status</th>
                                    <th class="col-dept">Designated Cell</th>
                                    <th class="col-date">Date Lodged</th>
                                    <th class="col-actions">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty complaints}">
                                        <c:forEach var="c" items="${complaints}">
                                            <tr>
                                                <td><strong>CU/GRC/2026/<fmt:formatNumber value="${c.complaintId}" minIntegerDigits="3" groupingUsed="false"/></strong></td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/student/complaintDetail?id=${c.complaintId}" style="font-weight: 600; color: var(--primary);">
                                                        ${c.title}
                                                    </a>
                                                </td>
                                                <td>${c.categoryName}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${c.priority == 'High'}"><span class="badge badge-priority-high">High</span></c:when>
                                                        <c:when test="${c.priority == 'Medium'}"><span class="badge badge-priority-medium">Medium</span></c:when>
                                                        <c:otherwise><span class="badge badge-priority-low">Low</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${c.status == 'Submitted'}"><span class="badge badge-submitted">Submitted</span></c:when>
                                                        <c:when test="${c.status == 'Pending'}"><span class="badge badge-pending">Pending</span></c:when>
                                                        <c:when test="${c.status == 'In Progress'}"><span class="badge badge-inprogress">In Progress</span></c:when>
                                                        <c:when test="${c.status == 'Resolved'}"><span class="badge badge-resolved">Resolved</span></c:when>
                                                        <c:otherwise><span class="badge badge-rejected">Rejected</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty c.assignedDepartment}">
                                                            <span style="color: var(--slate); font-size: 0.9rem;">${c.assignedDepartment}</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span style="color: var(--muted); font-style: italic;">Unassigned</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td><fmt:formatDate value="${c.createdAt}" pattern="dd MMM yyyy, hh:mm a"/></td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/student/complaintDetail?id=${c.complaintId}" class="btn btn-outline btn-sm">
                                                        Review ATR
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="8" style="text-align: center; padding: 2.5rem; color: var(--muted);">
                                                No complaints filed yet under this student account.
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
</body>
</html>
