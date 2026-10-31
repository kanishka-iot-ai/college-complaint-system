<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Academic Profile - Chandigarh University</title>
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
                    <li class="sidebar-item">
                        <a href="${pageContext.request.contextPath}/student/myComplaints">
                            <svg class="ui-icon" viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg>
                            <span>My Grievance Dossiers</span>
                        </a>
                    </li>
                    <li class="sidebar-item active">
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
                    <li class="breadcrumb-item active" aria-current="page">Academic Profile</li>
                </ol>
            </nav>

            <div class="page-header">
                <div>
                    <h1 class="page-title">Personal Profile &amp; Academic Records</h1>
                    <p class="page-subtitle">Official identity details registered with Chandigarh University Grievance Redressal Cell.</p>
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

            <div class="card" style="max-width: 750px;">
                <div class="card-header" style="justify-content: space-between; align-items: center;">
                    <h2 class="card-title">Student Account Profile</h2>
                    <span style="font-size: 0.85rem; color: var(--muted);">
                        Registered on: <fmt:formatDate value="${sessionScope.loggedStudent.createdAt}" pattern="dd MMM yyyy"/>
                    </span>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/student/profile" method="POST">
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label" for="uid">University UID (Read Only)</label>
                                <input type="text" id="uid" class="form-control" 
                                       value="${sessionScope.loggedStudent.uid}" readonly style="background-color: #f1f5f9; cursor: not-allowed; font-weight: 600; color: #1e3a8a;">
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="section">Section / Academic Category (Read Only)</label>
                                <input type="text" id="section" class="form-control" 
                                       value="${sessionScope.loggedStudent.section}" readonly style="background-color: #f1f5f9; cursor: not-allowed; font-weight: 600; color: #0d9488;">
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label" for="name">Full Name *</label>
                                <input type="text" id="name" name="name" class="form-control" 
                                       value="${sessionScope.loggedStudent.name}" required>
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="email">Institutional Email (Read Only)</label>
                                <input type="email" id="email" class="form-control" 
                                       value="${sessionScope.loggedStudent.email}" readonly style="background-color: #f1f5f9; cursor: not-allowed;">
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label" for="department">Department *</label>
                                <select id="department" name="department" class="form-control" required>
                                    <option value="Computer Science" ${sessionScope.loggedStudent.department == 'Computer Science' ? 'selected' : ''}>Computer Science &amp; Engineering</option>
                                    <option value="Information Technology" ${sessionScope.loggedStudent.department == 'Information Technology' ? 'selected' : ''}>Information Technology</option>
                                    <option value="Electronics" ${sessionScope.loggedStudent.department == 'Electronics' ? 'selected' : ''}>Electronics &amp; Communication</option>
                                    <option value="Mechanical" ${sessionScope.loggedStudent.department == 'Mechanical' ? 'selected' : ''}>Mechanical Engineering</option>
                                    <option value="Civil" ${sessionScope.loggedStudent.department == 'Civil' ? 'selected' : ''}>Civil Engineering</option>
                                    <option value="Electrical" ${sessionScope.loggedStudent.department == 'Electrical' ? 'selected' : ''}>Electrical Engineering</option>
                                    <option value="Management" ${sessionScope.loggedStudent.department == 'Management' ? 'selected' : ''}>Management Studies (MBA)</option>
                                    <option value="Computer Applications" ${sessionScope.loggedStudent.department == 'Computer Applications' ? 'selected' : ''}>Computer Applications (MCA)</option>
                                    <option value="Other" ${sessionScope.loggedStudent.department == 'Other' ? 'selected' : ''}>Other</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="semester">Semester (1-8) *</label>
                                <select id="semester" name="semester" class="form-control" required>
                                    <c:forEach var="sem" begin="1" end="8">
                                        <option value="${sem}" ${sessionScope.loggedStudent.semester == sem ? 'selected' : ''}>Semester ${sem}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="phone">Contact Mobile Number *</label>
                            <input type="tel" id="phone" name="phone" class="form-control" 
                                   value="${sessionScope.loggedStudent.phone}" maxlength="10" required>
                        </div>

                        <button type="submit" class="btn btn-primary" style="margin-top: 1rem;">
                            Update Academic Profile Information
                        </button>
                    </form>
                </div>
            </div>
        </main>
    </div>

    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
