<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Grievance Dossier CU/GRC/2026/<fmt:formatNumber value="${complaint.complaintId}" minIntegerDigits="3" groupingUsed="false"/> - Admin Console</title>
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
                        <span>${sessionScope.loggedAdmin.name}</span>
                    </div>
                </div>

                <ul class="sidebar-menu">
                    <li class="sidebar-item">
                        <a href="${pageContext.request.contextPath}/admin/dashboard">
                            <svg class="ui-icon" viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="9"></rect><rect x="14" y="3" width="7" height="5"></rect><rect x="14" y="12" width="7" height="9"></rect><rect x="3" y="16" width="7" height="5"></rect></svg>
                            <span>Dashboard</span>
                        </a>
                    </li>
                    <li class="sidebar-item active">
                        <a href="${pageContext.request.contextPath}/admin/allComplaints">
                            <svg class="ui-icon" viewBox="0 0 24 24"><path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"></path></svg>
                            <span>Grievance Dossiers</span>
                        </a>
                    </li>
                    <li class="sidebar-item">
                        <a href="${pageContext.request.contextPath}/admin/studentManagement">
                            <svg class="ui-icon" viewBox="0 0 24 24"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                            <span>Student Registry</span>
                        </a>
                    </li>
                    <li class="sidebar-item">
                        <a href="${pageContext.request.contextPath}/admin/reports">
                            <svg class="ui-icon" viewBox="0 0 24 24"><line x1="18" y1="20" x2="18" y2="10"></line><line x1="12" y1="20" x2="12" y2="4"></line><line x1="6" y1="20" x2="6" y2="14"></line></svg>
                            <span>Statistical ATR Reports</span>
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
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Admin Console</a></li>
                    <li class="breadcrumb-separator">/</li>
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/allComplaints">Grievance Dossiers</a></li>
                    <li class="breadcrumb-separator">/</li>
                    <li class="breadcrumb-item active" aria-current="page">CU/GRC/2026/<fmt:formatNumber value="${complaint.complaintId}" minIntegerDigits="3" groupingUsed="false"/></li>
                </ol>
            </nav>

            <div class="page-header">
                <div>
                    <h1 class="page-title">Grievance Dossier CU/GRC/2026/<fmt:formatNumber value="${complaint.complaintId}" minIntegerDigits="3" groupingUsed="false"/></h1>
                    <p class="page-subtitle">Submitted by <strong>${complaint.studentName}</strong> (UID: ${complaint.studentId}) on <fmt:formatDate value="${complaint.createdAt}" pattern="dd MMMM yyyy, hh:mm a"/></p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/admin/allComplaints" class="btn btn-outline">
                        &larr; Return to Dossier Register
                    </a>
                </div>
            </div>

            <c:if test="${not empty sessionScope.successMsg}">
                <div class="alert alert-success">
                    <svg class="ui-icon-sm" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"></polyline></svg>
                    <span>${sessionScope.successMsg}</span>
                </div>
                <c:remove var="successMsg" scope="session"/>
            </c:if>

            <c:if test="${not empty errorMsg}">
                <div class="alert alert-error">
                    <svg class="ui-icon-sm" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                    <span>${errorMsg}</span>
                </div>
            </c:if>

            <!-- Admin Action Box (Update Status, Assign Dept, Remarks) -->
            <div class="card admin-action-card" style="border: 2px solid #0d9488; background-color: #f0fdfa;">
                <div class="card-header" style="background-color: #ccfbf1; border-bottom: 1px solid #99f6e4;">
                    <h2 class="card-title" style="color: #0f766e; display: flex; align-items: center; gap: 0.5rem;">
                        <svg class="ui-icon" style="color: #0f766e;" viewBox="0 0 24 24"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path></svg>
                        <span>Competent Authority Action &amp; Order Record</span>
                    </h2>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/admin/updateComplaint" method="POST" onsubmit="return confirmStatusUpdate();">
                        <input type="hidden" name="complaintId" value="${complaint.complaintId}">

                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label" for="newStatus" style="font-weight: 600;">Disposal Status Order *</label>
                                <select id="newStatus" name="newStatus" class="form-control" required style="border-color: #0d9488;">
                                    <option value="Submitted" ${complaint.status == 'Submitted' ? 'selected' : ''}>Submitted (Formal Intake)</option>
                                    <option value="Pending" ${complaint.status == 'Pending' ? 'selected' : ''}>Pending Inquiry Proceedings</option>
                                    <option value="In Progress" ${complaint.status == 'In Progress' ? 'selected' : ''}>Under Active Investigation</option>
                                    <option value="Resolved" ${complaint.status == 'Resolved' ? 'selected' : ''}>Resolved (ATR Executed &amp; Disposed)</option>
                                    <option value="Rejected" ${complaint.status == 'Rejected' ? 'selected' : ''}>Dismissed as Non-Actionable</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="assignedDepartment" style="font-weight: 600;">Designated Department Cell</label>
                                <input type="text" id="assignedDepartment" name="assignedDepartment" class="form-control" 
                                       placeholder="e.g. Electrical Maintenance Cell, IT Operations, Estate Office" 
                                       value="${complaint.assignedDepartment}">
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="remarks" style="font-weight: 600;">Official Order &amp; Action Taken Remarks *</label>
                            <textarea id="remarks" name="remarks" class="form-control" 
                                      placeholder="Detail the inquiry findings, corrective steps ordered, or grounds for disposition..." 
                                      rows="3" required></textarea>
                        </div>

                        <button type="submit" class="btn btn-primary" style="background: #0d9488; border-color: #0d9488; padding: 0.8rem 1.8rem;">
                            Record Official Disposition &amp; Issue ATR
                        </button>
                    </form>
                </div>
            </div>

            <!-- Complaint Full Details -->
            <div class="card">
                <div class="card-header" style="justify-content: space-between;">
                    <h2 class="card-title">${complaint.title}</h2>
                    <div style="display: flex; gap: 0.5rem;">
                        <c:choose>
                            <c:when test="${complaint.priority == 'High'}"><span class="badge badge-priority-high">Priority: High</span></c:when>
                            <c:when test="${complaint.priority == 'Medium'}"><span class="badge badge-priority-medium">Priority: Medium</span></c:when>
                            <c:otherwise><span class="badge badge-priority-low">Priority: Low</span></c:otherwise>
                        </c:choose>

                        <c:choose>
                            <c:when test="${complaint.status == 'Submitted'}"><span class="badge badge-submitted">Status: Submitted</span></c:when>
                            <c:when test="${complaint.status == 'Pending'}"><span class="badge badge-pending">Status: Pending</span></c:when>
                            <c:when test="${complaint.status == 'In Progress'}"><span class="badge badge-inprogress">Status: In Progress</span></c:when>
                            <c:when test="${complaint.status == 'Resolved'}"><span class="badge badge-resolved">Status: Resolved</span></c:when>
                            <c:otherwise><span class="badge badge-rejected">Status: Rejected</span></c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="card-body">
                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1.25rem; margin-bottom: 1.5rem; padding-bottom: 1.25rem; border-bottom: 1px solid var(--border);">
                        <div>
                            <span style="font-size: 0.8rem; text-transform: uppercase; color: var(--muted); font-weight: 600;">Category</span>
                            <div style="font-weight: 600; font-size: 1.05rem; margin-top: 0.2rem;">${complaint.categoryName}</div>
                        </div>
                        <div>
                            <span style="font-size: 0.8rem; text-transform: uppercase; color: var(--muted); font-weight: 600;">Filed by Student</span>
                            <div style="font-weight: 600; font-size: 1.05rem; margin-top: 0.2rem;">${complaint.studentName}</div>
                        </div>
                        <div>
                            <span style="font-size: 0.8rem; text-transform: uppercase; color: var(--muted); font-weight: 600;">Assigned Department</span>
                            <div style="font-weight: 600; font-size: 1.05rem; margin-top: 0.2rem;">
                                ${not empty complaint.assignedDepartment ? complaint.assignedDepartment : '<span style="color: var(--muted); font-style: italic;">Unassigned</span>'}
                            </div>
                        </div>
                        <div>
                            <span style="font-size: 0.8rem; text-transform: uppercase; color: var(--muted); font-weight: 600;">Last Updated</span>
                            <div style="font-weight: 600; font-size: 1.05rem; margin-top: 0.2rem;">
                                <fmt:formatDate value="${complaint.updatedAt}" pattern="dd MMM yyyy, hh:mm a"/>
                            </div>
                        </div>
                    </div>

                    <div>
                        <h3 style="font-size: 1rem; color: var(--slate); margin-bottom: 0.5rem;">Submitted Grievance Description</h3>
                        <div style="background-color: #f8fafc; padding: 1.25rem; border-radius: var(--radius-sm); border: 1px solid var(--border); line-height: 1.6; white-space: pre-line;">
                            ${complaint.description}
                        </div>
                    </div>
                </div>
            </div>

            <!-- Action Taken Report (ATR) Card (if resolved) -->
            <c:if test="${not empty resolution}">
                <div class="card atr-document-card" style="border-left: 5px solid #0d9488;">
                    <div class="card-header" style="background-color: #f0fdfa; justify-content: space-between; align-items: center;">
                        <h2 class="card-title" style="color: #0f766e; display: flex; align-items: center; gap: 0.5rem;">
                            <svg class="ui-icon" style="color: #0f766e;" viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg>
                            <span>Official Action Taken Report (ATR)</span>
                        </h2>
                        <div style="display: flex; gap: 0.75rem; align-items: center;">
                            <span class="badge badge-resolved">ATR Formally Certified</span>
                            <button type="button" class="btn btn-outline btn-sm" onclick="window.print();" style="border-color: #0d9488; color: #0d9488;">
                                <svg class="ui-icon-sm" viewBox="0 0 24 24"><polyline points="6 9 6 2 18 2 18 9"></polyline><path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"></path><rect x="6" y="14" width="12" height="8"></rect></svg>
                                Print ATR Record
                            </button>
                        </div>
                    </div>
                    <div class="card-body">
                        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1rem; margin-bottom: 1rem; padding-bottom: 1rem; border-bottom: 1px dashed var(--border);">
                            <div>
                                <span style="font-size: 0.8rem; color: var(--muted); text-transform: uppercase;">Redressal Officer</span>
                                <div style="font-weight: 600; color: var(--dark);">${resolution.adminName}</div>
                            </div>
                            <div>
                                <span style="font-size: 0.8rem; color: var(--muted); text-transform: uppercase;">Certification Date</span>
                                <div style="font-weight: 600; color: var(--dark);"><fmt:formatDate value="${resolution.resolutionDate}" pattern="dd MMMM yyyy, hh:mm a"/></div>
                            </div>
                            <div>
                                <span style="font-size: 0.8rem; color: var(--muted); text-transform: uppercase;">Institutional Reference</span>
                                <div style="font-weight: 600; color: var(--dark);">ATR-CU-2026-${complaint.complaintId}</div>
                            </div>
                        </div>
                        <h4 style="font-size: 0.9rem; color: var(--slate); margin-bottom: 0.4rem;">Findings &amp; Remedial Measures Executed:</h4>
                        <div style="background: #ffffff; padding: 1.25rem; border-radius: 4px; border: 1px solid #99f6e4; line-height: 1.6;">
                            ${resolution.remarks}
                        </div>
                    </div>
                </div>
            </c:if>

            <!-- Complete Audit History Timeline -->
            <div class="card">
                <div class="card-header">
                    <h2 class="card-title">Full Status Transition History</h2>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${not empty history}">
                            <div class="timeline">
                                <c:forEach var="h" items="${history}">
                                    <div class="timeline-item">
                                        <div class="timeline-date">
                                            <fmt:formatDate value="${h.changedAt}" pattern="dd MMM yyyy, hh:mm a"/>
                                            <c:if test="${not empty h.adminName}">
                                                &bull; by <strong>${h.adminName}</strong>
                                            </c:if>
                                        </div>
                                        <div class="timeline-content">
                                            <div style="font-weight: 600; margin-bottom: 0.25rem;">
                                                Transition: 
                                                <span style="color: var(--muted);">${not empty h.oldStatus ? h.oldStatus : 'Submitted'}</span>
                                                &rarr; <span style="color: #0d9488; font-weight: 700;">${h.newStatus}</span>
                                            </div>
                                            <c:if test="${not empty h.remarks}">
                                                <p style="font-size: 0.9rem; color: var(--slate); margin-top: 0.25rem;">
                                                    &ldquo;${h.remarks}&rdquo;
                                                </p>
                                            </c:if>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <p style="color: var(--muted); font-style: italic;">No previous status transitions recorded for this ticket.</p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </main>
    </div>

    <script src="${pageContext.request.contextPath}/js/main.js"></script>
    <script src="${pageContext.request.contextPath}/js/admin.js"></script>
</body>
</html>
