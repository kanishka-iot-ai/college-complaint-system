package com.college.complaint.servlet.student;

import com.college.complaint.dao.ComplaintDAO;
import com.college.complaint.model.Complaint;
import com.college.complaint.model.Student;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/student/dashboard")
public class StudentDashboardServlet extends HttpServlet {

    private final ComplaintDAO complaintDAO = new ComplaintDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");

        // Session check
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedStudent") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Student loggedStudent = (Student) session.getAttribute("loggedStudent");
        int studentId = loggedStudent.getStudentId();

        try {
            // Load dashboard statistics
            Map<String, Integer> stats = complaintDAO.getStudentDashboardStats(studentId);

            // Load 5 most recent complaints
            List<Complaint> recentComplaints = complaintDAO.getRecentComplaintsByStudent(studentId, 5);

            request.setAttribute("totalComplaints", stats != null ? stats.get("total") : 0);
            request.setAttribute("pendingComplaints", stats != null ? stats.get("pending") : 0);
            request.setAttribute("inProgressComplaints", stats != null ? stats.get("inProgress") : 0);
            request.setAttribute("resolvedComplaints", stats != null ? stats.get("resolved") : 0);
            request.setAttribute("dashboardStats", stats);
            request.setAttribute("recentComplaints", recentComplaints);
            request.setAttribute("student", loggedStudent);
        } catch (java.sql.SQLException e) {
            request.setAttribute("errorMsg", "Database error loading dashboard: " + e.getMessage());
        }

        request.getRequestDispatcher("/student/dashboard.jsp").forward(request, response);
    }
}
