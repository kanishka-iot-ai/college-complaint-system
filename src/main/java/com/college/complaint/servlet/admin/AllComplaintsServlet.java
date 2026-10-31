package com.college.complaint.servlet.admin;

import com.college.complaint.dao.CategoryDAO;
import com.college.complaint.dao.ComplaintDAO;
import com.college.complaint.model.Admin;
import com.college.complaint.model.Category;
import com.college.complaint.model.Complaint;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/allComplaints")
public class AllComplaintsServlet extends HttpServlet {

    private final ComplaintDAO complaintDAO = new ComplaintDAO();
    private final CategoryDAO  categoryDAO  = new CategoryDAO();

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

        // Optional filter parameters (may be null or empty)
        String status   = request.getParameter("status");
        String priority = request.getParameter("priority");
        String category = request.getParameter("category");
        String search   = request.getParameter("search");

        // Normalise empty strings to null so DAO can ignore them
        status   = (status   != null && !status.trim().isEmpty())   ? status.trim()   : null;
        priority = (priority != null && !priority.trim().isEmpty())  ? priority.trim() : null;
        category = (category != null && !category.trim().isEmpty())  ? category.trim() : null;
        search   = (search   != null && !search.trim().isEmpty())   ? search.trim()   : null;

        try {
            // Load filtered complaints
            List<Complaint> complaints = complaintDAO.getAllComplaintsFiltered(status, priority, category, search);

            // Load categories for the filter dropdown
            List<Category> categories = categoryDAO.getAllCategories();

            request.setAttribute("complaints", complaints);
            request.setAttribute("categories", categories);
            request.setAttribute("filterStatus",   status);
            request.setAttribute("filterPriority", priority);
            request.setAttribute("filterCategory", category);
            request.setAttribute("filterSearch",   search);
            request.setAttribute("admin", loggedAdmin);
        } catch (java.sql.SQLException e) {
            request.setAttribute("errorMsg", "Database error loading complaints: " + e.getMessage());
        }

        request.getRequestDispatcher("/admin/all_complaints.jsp").forward(request, response);
    }
}
