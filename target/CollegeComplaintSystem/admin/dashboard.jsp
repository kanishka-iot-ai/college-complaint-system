<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Grievance Management</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body>

    <!-- Admin Top Nav -->
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
        <!-- Admin Sidebar -->
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
                    <li class="sidebar-item active">
                        <a href="${pageContext.request.contextPath}/admin/dashboard">
                            <svg class="ui-icon" viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="9"></rect><rect x="14" y="3" width="7" height="5"></rect><rect x="14" y="12" width="7" height="9"></rect><rect x="3" y="16" width="7" height="5"></rect></svg> Dashboard
                        </a>
                    </li>
                    <li class="sidebar-item">
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

        <!-- Admin Main Content -->
        <main class="main-content">
            <nav class="breadcrumb-container" aria-label="Breadcrumb" style="margin: -1.25rem -1rem 1.25rem -1rem; padding: 0.75rem 1.25rem;">
                <ol class="breadcrumb-list">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Admin Console</a></li>
                    <li class="breadcrumb-separator">/</li>
                    <li class="breadcrumb-item active" aria-current="page">Executive Dashboard</li>
                </ol>
            </nav>

            <div class="page-header">
                <div>
                    <h1 class="page-title">Executive Redressal Overview</h1>
                    <p class="page-subtitle">Statutory metrics across student grievance submissions, pending inquiries, and Action Taken Reports.</p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/admin/allComplaints" class="btn btn-primary" style="background-color: #0d9488;">
                        Manage Grievance Dossiers &rarr;
                    </a>
                </div>
            </div>

            <!-- 6 Statistical Cards -->
            <div class="stats-grid" style="grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));">
                <div class="stat-card" style="border-left: 4px solid #6366f1;">
                    <div class="stat-info">
                        <h3>Registered Students</h3>
                        <div class="stat-value">${totalStudents}</div>
                    </div>
                    <div class="stat-icon"><svg class="ui-icon-lg" style="margin:0; color:#6366f1;" viewBox="0 0 24 24"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg></div>
                </div>

                <div class="stat-card blue">
                    <div class="stat-info">
                        <h3>Total Grievances</h3>
                        <div class="stat-value">${stats.total}</div>
                    </div>
                    <div class="stat-icon"><svg class="ui-icon-lg" style="margin:0; color:#2563eb;" viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg></div>
                </div>

                <div class="stat-card orange">
                    <div class="stat-info">
                        <h3>Pending Inquiries</h3>
                        <div class="stat-value">${stats.pending}</div>
                    </div>
                    <div class="stat-icon"><svg class="ui-icon-lg" style="margin:0; color:#f59e0b;" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg></div>
                </div>

                <div class="stat-card purple">
                    <div class="stat-info">
                        <h3>Under Review</h3>
                        <div class="stat-value">${stats.inProgress}</div>
                    </div>
                    <div class="stat-icon"><svg class="ui-icon-lg" style="margin:0; color:#8b5cf6;" viewBox="0 0 24 24"><polyline points="23 4 23 10 17 10"></polyline><polyline points="1 20 1 14 7 14"></polyline><path d="M3.51 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.49 15"></path></svg></div>
                </div>

                <div class="stat-card green">
                    <div class="stat-info">
                        <h3>Disposed (Resolved)</h3>
                        <div class="stat-value">${stats.resolved}</div>
                    </div>
                    <div class="stat-icon"><svg class="ui-icon-lg" style="margin:0; color:#10b981;" viewBox="0 0 24 24"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg></div>
                </div>

                <div class="stat-card red">
                    <div class="stat-info">
                        <h3>Dismissed</h3>
                        <div class="stat-value">${stats.rejected}</div>
                    </div>
                    <div class="stat-icon"><svg class="ui-icon-lg" style="margin:0; color:#ef4444;" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"></circle><line x1="15" y1="9" x2="9" y2="15"></line><line x1="9" y1="9" x2="15" y2="15"></line></svg></div>
                </div>
            </div>

            <!-- Two Columns: Category Analytics Chart + Recent Tickets -->
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(350px, 1fr)); gap: 1.5rem; margin-bottom: 2rem;">
                
                <!-- Category Chart -->
                <div class="card">
                    <div class="card-header">
                        <h2 class="card-title">Category-wise Distribution</h2>
                    </div>
                    <div class="card-body">
                        <canvas id="categoryChart" width="450" height="260"></canvas>
                        <div style="margin-top: 1rem; display: flex; flex-wrap: wrap; gap: 0.5rem;">
                            <c:forEach var="entry" items="${categoryStats}">
                                <span style="font-size: 0.8rem; background: #f1f5f9; padding: 0.2rem 0.5rem; border-radius: 4px; border: 1px solid var(--border);">
                                    <strong>${entry[0]}</strong>: ${entry[1]}
                                </span>
                            </c:forEach>
                        </div>
                    </div>
                </div>

                <!-- Fast Actions & Priority Alert -->
                <div class="card">
                    <div class="card-header">
                        <h2 class="card-title">Quick Search & Filter</h2>
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/admin/allComplaints" method="GET">
                            <div class="form-group">
                                <label class="form-label">Search Keyword (ID / Student / Title)</label>
                                <input type="text" name="search" class="form-control" placeholder="e.g. Rahul, Hostel, #101">
                            </div>
                            <div class="form-row">
                                <div class="form-group">
                                    <label class="form-label">Status</label>
                                    <select name="status" class="form-control">
                                        <option value="">All Statuses</option>
                                        <option value="Submitted">Submitted</option>
                                        <option value="Pending">Pending</option>
                                        <option value="In Progress">In Progress</option>
                                        <option value="Resolved">Resolved</option>
                                        <option value="Rejected">Rejected</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Priority</label>
                                    <select name="priority" class="form-control">
                                        <option value="">All Priorities</option>
                                        <option value="High">High</option>
                                        <option value="Medium">Medium</option>
                                        <option value="Low">Low</option>
                                    </select>
                                </div>
                            </div>
                            <button type="submit" class="btn btn-primary" style="width: 100%; background: #0d9488; border-color: #0d9488;">
                                <svg class="ui-icon-sm" viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg> Query Grievance Register
                            </button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Recent Complaints Table -->
            <div class="card">
                <div class="card-header">
                    <h2 class="card-title">Latest 10 Complaint Submissions</h2>
                    <a href="${pageContext.request.contextPath}/admin/allComplaints" class="btn btn-outline btn-sm">
                        View Complete Register &rarr;
                    </a>
                </div>
                <div class="card-body" style="padding: 0;">
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Student</th>
                                    <th>Category</th>
                                    <th>Title</th>
                                    <th>Priority</th>
                                    <th>Status</th>
                                    <th>Date</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty recentComplaints}">
                                        <c:forEach var="c" items="${recentComplaints}">
                                            <tr>
                                                <td><strong>#${c.complaintId}</strong></td>
                                                <td>${c.studentName}</td>
                                                <td>${c.categoryName}</td>
                                                <td>${c.title}</td>
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
                                                <td><fmt:formatDate value="${c.createdAt}" pattern="dd MMM, hh:mm a"/></td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/admin/complaintDetail?id=${c.complaintId}" class="btn btn-outline btn-sm">
                                                        Manage
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="8" style="text-align: center; padding: 2rem; color: var(--muted);">
                                                No complaints available.
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
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const labels = [];
            const data = [];
            <c:forEach var="entry" items="${categoryStats}">
                labels.push("${entry[0]}");
                data.push(${entry[1]});
            </c:forEach>
            if (typeof drawCategoryChart === 'function') {
                drawCategoryChart('categoryChart', labels, data);
            }
        });
    </script>
</body>
</html>
