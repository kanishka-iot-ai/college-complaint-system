package com.college.complaint.servlet.admin;

import com.college.complaint.dao.ComplaintDAO;
import com.college.complaint.dao.StudentDAO;
import com.college.complaint.model.Admin;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/reports")
public class ReportsServlet extends HttpServlet {

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

        try {
            // Load overall complaint statistics (total, pending, in-progress, resolved, rejected)
            Map<String, Integer> dashboardStats = complaintDAO.getDashboardStats();

            // Load per-category complaint breakdown
            List<Object[]> categoryStats = complaintDAO.getCategoryStats();

            // Load total registered students
            int totalStudents = studentDAO.getTotalStudentCount();

            // Derive total complaints count from stats map (key "total")
            int totalComplaints = dashboardStats.getOrDefault("total", 0);

            request.setAttribute("stats",           dashboardStats);
            request.setAttribute("dashboardStats",  dashboardStats);
            request.setAttribute("categoryStats",   categoryStats);
            request.setAttribute("totalStudents",   totalStudents);
            request.setAttribute("totalComplaints", totalComplaints);
            request.setAttribute("admin",           loggedAdmin);
        } catch (java.sql.SQLException e) {
            request.setAttribute("errorMsg", "Database error loading reports: " + e.getMessage());
        }

        request.getRequestDispatcher("/admin/reports.jsp").forward(request, response);
    }
}
