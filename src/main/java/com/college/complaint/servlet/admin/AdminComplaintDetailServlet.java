package com.college.complaint.servlet.admin;

import com.college.complaint.dao.CategoryDAO;
import com.college.complaint.dao.ComplaintDAO;
import com.college.complaint.model.Admin;
import com.college.complaint.model.Category;
import com.college.complaint.model.Complaint;
import com.college.complaint.model.ComplaintHistory;
import com.college.complaint.model.Resolution;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/complaintDetail")
public class AdminComplaintDetailServlet extends HttpServlet {

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

        String complaintIdStr = request.getParameter("id");
        if (complaintIdStr == null || complaintIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/allComplaints");
            return;
        }

        int complaintId;
        try {
            complaintId = Integer.parseInt(complaintIdStr.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/allComplaints");
            return;
        }

        try {
            // Load complaint
            Complaint complaint = complaintDAO.getComplaintById(complaintId);
            if (complaint == null) {
                session.setAttribute("errorMsg", "Complaint not found.");
                response.sendRedirect(request.getContextPath() + "/admin/allComplaints");
                return;
            }

            // Load resolution (may be null)
            Resolution resolution = complaintDAO.getResolutionByComplaintId(complaintId);

            // Load history / audit trail
            List<ComplaintHistory> history = complaintDAO.getComplaintHistory(complaintId);

            // Load categories (for reassignment or reference in the detail view)
            List<Category> categories = categoryDAO.getAllCategories();

            request.setAttribute("complaint",  complaint);
            request.setAttribute("resolution", resolution);
            request.setAttribute("history",    history);
            request.setAttribute("categories", categories);
            request.setAttribute("admin",      loggedAdmin);
        } catch (java.sql.SQLException e) {
            session.setAttribute("errorMsg", "Database error loading complaint: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/allComplaints");
            return;
        }

        // Expose flash messages
        String successMsg = (String) session.getAttribute("successMsg");
        if (successMsg != null) {
            request.setAttribute("successMsg", successMsg);
            session.removeAttribute("successMsg");
        }

        request.getRequestDispatcher("/admin/complaint_detail.jsp").forward(request, response);
    }
}
