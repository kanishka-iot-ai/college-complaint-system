<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Grievance Dossier CU/GRC/2026/<fmt:formatNumber value="${complaint.complaintId}" minIntegerDigits="3" groupingUsed="false"/> - Student Portal</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/cu_logo.png">
    <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/favicon.ico">
    <link rel="apple-touch-icon" href="${pageContext.request.contextPath}/images/cu_logo.png">
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
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/student/myComplaints">My Grievance Dossiers</a></li>
                    <li class="breadcrumb-separator">/</li>
                    <li class="breadcrumb-item active" aria-current="page">CU/GRC/2026/<fmt:formatNumber value="${complaint.complaintId}" minIntegerDigits="3" groupingUsed="false"/></li>
                </ol>
            </nav>

            <div class="page-header">
                <div>
                    <h1 class="page-title">Grievance Dossier CU/GRC/2026/<fmt:formatNumber value="${complaint.complaintId}" minIntegerDigits="3" groupingUsed="false"/></h1>
                    <p class="page-subtitle">Submitted on <fmt:formatDate value="${complaint.createdAt}" pattern="dd MMMM yyyy, hh:mm a"/></p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/student/myComplaints" class="btn btn-outline">
                        &larr; Return to Dossier Register
                    </a>
                </div>
            </div>

            <!-- Complaint Overview Card -->
            <div class="card">
                <div class="card-header" style="flex-wrap: wrap; gap: 0.5rem; justify-content: space-between;">
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
                            <span style="font-size: 0.8rem; text-transform: uppercase; color: var(--muted); font-weight: 600;">Domain Category</span>
                            <div style="font-weight: 600; font-size: 1.05rem; margin-top: 0.2rem;">${complaint.categoryName}</div>
                        </div>
                        <div>
                            <span style="font-size: 0.8rem; text-transform: uppercase; color: var(--muted); font-weight: 600;">Designated Department Cell</span>
                            <div style="font-weight: 600; font-size: 1.05rem; margin-top: 0.2rem;">
                                ${not empty complaint.assignedDepartment ? complaint.assignedDepartment : '<span style="color: var(--muted); font-weight: normal;">Pending Cell Allocation</span>'}
                            </div>
                        </div>
                        <div>
                            <span style="font-size: 0.8rem; text-transform: uppercase; color: var(--muted); font-weight: 600;">Last Proceeding Update</span>
                            <div style="font-weight: 600; font-size: 1.05rem; margin-top: 0.2rem;">
                                <fmt:formatDate value="${complaint.updatedAt}" pattern="dd MMM yyyy, hh:mm a"/>
                            </div>
                        </div>
                    </div>

                    <div>
                        <h3 style="font-size: 1rem; color: var(--slate); margin-bottom: 0.5rem;">Submitted Grievance Statement</h3>
                        <div style="background-color: #f8fafc; padding: 1.25rem; border-radius: var(--radius-sm); border: 1px solid var(--border); line-height: 1.6; white-space: pre-line;">
                            ${complaint.description}
                        </div>
                    </div>
                </div>
            </div>

            <!-- Resolution Section (Action Taken Report) -->
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
                                Print ATR Certificate
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
                                <span style="font-size: 0.8rem; color: var(--muted); text-transform: uppercase;">Statutory Reference</span>
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

            <!-- Audit History Timeline -->
            <div class="card">
                <div class="card-header">
                    <h2 class="card-title">Statutory Inquiry Timeline &amp; Status Transitions</h2>
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
                                                Status transition: 
                                                <span style="color: var(--muted);">${not empty h.oldStatus ? h.oldStatus : 'Intake'}</span>
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
                            <p style="color: var(--muted); font-style: italic;">No administrative history recorded yet.</p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </main>
    </div>

    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
