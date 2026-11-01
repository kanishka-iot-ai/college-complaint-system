<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Complaints - Admin Console</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/cu_logo.png">
    <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/favicon.ico">
    <link rel="apple-touch-icon" href="${pageContext.request.contextPath}/images/cu_logo.png">
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
                    <li class="sidebar-item active">
                        <a href="${pageContext.request.contextPath}/admin/allComplaints">
                            <svg class="ui-icon" viewBox="0 0 24 24"><path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"></path></svg> Grievance Dossiers
                        </a>
                    </li>
                    <li class="sidebar-item">
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
                    <li class="breadcrumb-item active" aria-current="page">Grievance Repository</li>
                </ol>
            </nav>

            <div class="page-header">
                <div>
                    <h1 class="page-title">Institutional Grievance Repository</h1>
                    <p class="page-subtitle">Statutory tracking, departmental assignment, inquiry proceedings, and Action Taken Reports.</p>
                </div>
            </div>

            <c:if test="${not empty sessionScope.successMsg}">
                <div class="alert alert-success">
                    <span>${sessionScope.successMsg}</span>
                </div>
                <c:remove var="successMsg" scope="session"/>
            </c:if>

            <!-- Comprehensive Filter Bar -->
            <form action="${pageContext.request.contextPath}/admin/allComplaints" method="GET" class="filter-bar">
                <div class="form-group" style="min-width: 220px;">
                    <label class="form-label">Search Keyword (Title, Student, Ref No.)</label>
                    <input type="text" name="search" class="form-control" placeholder="Search by Ref. No., Student Name, or Keyword..." value="${searchQuery}">
                </div>

                <div class="form-group">
                    <label class="form-label">Disposal Status</label>
                    <select name="status" class="form-control">
                        <option value="">All Statuses</option>
                        <option value="Submitted" ${selectedStatus == 'Submitted' ? 'selected' : ''}>Submitted</option>
                        <option value="Pending" ${selectedStatus == 'Pending' ? 'selected' : ''}>Pending Inquiry</option>
                        <option value="In Progress" ${selectedStatus == 'In Progress' ? 'selected' : ''}>Under Review</option>
                        <option value="Resolved" ${selectedStatus == 'Resolved' ? 'selected' : ''}>Resolved (Disposed)</option>
                        <option value="Rejected" ${selectedStatus == 'Rejected' ? 'selected' : ''}>Dismissed</option>
                    </select>
                </div>

                <div class="form-group">
                    <label class="form-label">Severity Level</label>
                    <select name="priority" class="form-control">
                        <option value="">All Severity Levels</option>
                        <option value="Low" ${selectedPriority == 'Low' ? 'selected' : ''}>Low</option>
                        <option value="Medium" ${selectedPriority == 'Medium' ? 'selected' : ''}>Medium</option>
                        <option value="High" ${selectedPriority == 'High' ? 'selected' : ''}>High</option>
                    </select>
                </div>

                <div class="form-group">
                    <label class="form-label">Academic Domain</label>
                    <select name="category" class="form-control">
                        <option value="">All Domains</option>
                        <c:forEach var="cat" items="${categories}">
                            <option value="${cat.categoryName}" ${selectedCategory == cat.categoryName ? 'selected' : ''}>
                                ${cat.categoryName}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div style="display: flex; gap: 0.5rem; align-items: flex-end;">
                    <button type="submit" class="btn btn-primary" style="background: #0d9488; border-color: #0d9488;">
                        Apply Filter
                    </button>
                    <a href="${pageContext.request.contextPath}/admin/allComplaints" class="btn btn-outline">
                        Reset
                    </a>
                </div>
            </form>

            <!-- Complaints Table -->
            <div class="card">
                <div class="card-header" style="justify-content: space-between;">
                    <h2 class="card-title">Grievance Dossier Register (${complaints.size()} records)</h2>
                    <input type="text" id="tableSearch" class="form-control" placeholder="Filter visible table rows..." style="max-width: 250px; padding: 0.35rem 0.75rem; font-size: 0.85rem;">
                </div>
                <div class="card-body" style="padding: 0;">
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th class="col-ref">Grievance Ref. No.</th>
                                    <th>Student Name</th>
                                    <th class="col-category">Academic Domain</th>
                                    <th class="col-title">Subject Summary</th>
                                    <th class="col-priority">Severity</th>
                                    <th class="col-status">Status</th>
                                    <th>Assigned Cell</th>
                                    <th class="col-date">Registered Date</th>
                                    <th class="col-action">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty complaints}">
                                        <c:forEach var="c" items="${complaints}">
                                            <tr>
                                                <td class="col-ref">CU/GRC/2026/00${c.complaintId}</td>
                                                <td>
                                                    <strong>${c.studentName}</strong>
                                                </td>
                                                <td>${c.categoryName}</td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/admin/complaintDetail?id=${c.complaintId}" style="color: var(--primary); font-weight: 600;">
                                                        ${c.title}
                                                    </a>
                                                </td>
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
                                                            ${c.assignedDepartment}
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span style="color: var(--muted); font-style: italic;">Unassigned Cell</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td><fmt:formatDate value="${c.createdAt}" pattern="dd MMM yyyy"/></td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/admin/complaintDetail?id=${c.complaintId}" class="btn btn-outline btn-sm">
                                                        Review Dossier
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="9" style="text-align: center; padding: 2.5rem; color: var(--muted);">
                                                No complaints match the specified search and filter criteria.
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
