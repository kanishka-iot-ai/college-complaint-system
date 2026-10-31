package com.college.complaint.servlet.admin;

import com.college.complaint.dao.ComplaintDAO;
import com.college.complaint.dao.StudentDAO;
import com.college.complaint.model.Admin;
import com.college.complaint.model.Complaint;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private final ComplaintDAO complaintDAO = new ComplaintDAO();
    private final StudentDAO   studentDAO   = new StudentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");

        // Session check
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedAdmin") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
            return;
        }

        Admin loggedAdmin = (Admin) session.getAttribute("loggedAdmin");

        // Retrieve and expose any flash messages
        String successMsg = (String) session.getAttribute("successMsg");
        if (successMsg != null) {
            request.setAttribute("successMsg", successMsg);
            session.removeAttribute("successMsg");
        }

        try {
            // Load overall dashboard statistics (total, pending, resolved, etc.)
            Map<String, Integer> dashboardStats = complaintDAO.getDashboardStats();

            // Load total student count
            int totalStudents = studentDAO.getTotalStudentCount();

            // Load per-category statistics
            List<Object[]> categoryStats = complaintDAO.getCategoryStats();

            // Load the 10 most recent complaints
            List<Complaint> recentComplaints = complaintDAO.getRecentComplaints(10);

            request.setAttribute("stats", dashboardStats);
            request.setAttribute("dashboardStats", dashboardStats);
            request.setAttribute("totalStudents", totalStudents);
            request.setAttribute("categoryStats", categoryStats);
            request.setAttribute("recentComplaints", recentComplaints);
            request.setAttribute("admin", loggedAdmin);
        } catch (java.sql.SQLException e) {
            request.setAttribute("errorMsg", "Database error loading dashboard: " + e.getMessage());
        }

        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }
}
