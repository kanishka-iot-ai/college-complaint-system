<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lodge Grievance Dossier - Chandigarh University</title>
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
                    <li class="sidebar-item active">
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
                    <li class="breadcrumb-item active" aria-current="page">Lodge Grievance</li>
                </ol>
            </nav>

            <div class="page-header">
                <div>
                    <h1 class="page-title">Lodge Academic or Campus Grievance</h1>
                    <p class="page-subtitle">Submit formal details to the Grievance Redressal Committee for inquiry and Action Taken Report (ATR) issuance.</p>
                </div>
            </div>

            <c:if test="${not empty errorMsg}">
                <div class="alert alert-error">
                    <svg class="ui-icon-sm" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                    <span>${errorMsg}</span>
                </div>
            </c:if>

            <div class="card" style="max-width: 800px;">
                <div class="card-header">
                    <h2 class="card-title">Grievance Intake Registration Dossier</h2>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/student/submitComplaint" method="POST" onsubmit="return validateComplaintForm();">
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label" for="categoryId">Domain Category *</label>
                                <select id="categoryId" name="categoryId" class="form-control" required>
                                    <option value="">-- Select Domain / Facility Category --</option>
                                    <c:forEach var="cat" items="${categories}">
                                        <option value="${cat.categoryId}">${cat.categoryName}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Urgency / Severity Level *</label>
                                <div class="radio-group" style="padding-top: 0.5rem; display: flex; gap: 1.5rem;">
                                    <label class="radio-label">
                                        <input type="radio" name="priority" value="Low">
                                        <span class="badge badge-priority-low">Low</span>
                                    </label>
                                    <label class="radio-label">
                                        <input type="radio" name="priority" value="Medium" checked>
                                        <span class="badge badge-priority-medium">Medium</span>
                                    </label>
                                    <label class="radio-label">
                                        <input type="radio" name="priority" value="High">
                                        <span class="badge badge-priority-high">High (Urgent)</span>
                                    </label>
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="title">Grievance Title / Subject Matter *</label>
                            <input type="text" id="title" name="title" class="form-control" 
                                   placeholder="e.g. Projector audio failure in Room 304, Academic Block 2" required maxlength="200">
                        </div>

                        <div class="form-group">
                            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.5rem;">
                                <label class="form-label" for="description" style="margin-bottom: 0;">Comprehensive Statement &amp; Facts *</label>
                                <span style="font-size: 0.8rem; color: #64748b;">
                                    <span id="charCount">0</span> / 500 characters
                                </span>
                            </div>
                            <textarea id="description" name="description" class="form-control" 
                                      placeholder="Detail the precise location, date/time observed, equipment details, and specific impact on academic activities..." required maxlength="500"></textarea>
                        </div>

                        <div style="display: flex; gap: 1rem; margin-top: 1.5rem;">
                            <button type="submit" class="btn btn-primary" style="padding: 0.8rem 1.8rem;">
                                <svg class="ui-icon-sm" viewBox="0 0 24 24"><path d="M12 5v14"></path><path d="M5 12h14"></path></svg>
                                Lodge Grievance Dossier
                            </button>
                            <a href="${pageContext.request.contextPath}/student/dashboard" class="btn btn-outline">
                                Cancel
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>

    <script src="${pageContext.request.contextPath}/js/main.js"></script>
    <script>
        const desc = document.getElementById('description');
        const count = document.getElementById('charCount');
        if (desc && count) {
            desc.addEventListener('input', () => {
                count.textContent = desc.value.length;
            });
        }
    </script>
</body>
</html>
