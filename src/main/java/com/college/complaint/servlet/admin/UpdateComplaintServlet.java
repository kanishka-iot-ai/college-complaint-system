package com.college.complaint.servlet.admin;

import com.college.complaint.dao.ComplaintDAO;
import com.college.complaint.model.Admin;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/admin/updateComplaint")
public class UpdateComplaintServlet extends HttpServlet {

    private final ComplaintDAO complaintDAO = new ComplaintDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Session check
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedAdmin") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
            return;
        }

        Admin loggedAdmin = (Admin) session.getAttribute("loggedAdmin");

        String complaintIdStr      = request.getParameter("complaintId");
        String newStatus           = request.getParameter("newStatus");
        String assignedDepartment  = request.getParameter("assignedDepartment");
        String remarks             = request.getParameter("remarks");

        // Basic validation
        if (complaintIdStr == null || complaintIdStr.trim().isEmpty()
                || newStatus == null || newStatus.trim().isEmpty()) {
            session.setAttribute("errorMsg", "Complaint ID and new status are required.");
            response.sendRedirect(request.getContextPath() + "/admin/allComplaints");
            return;
        }

        int complaintId;
        try {
            complaintId = Integer.parseInt(complaintIdStr.trim());
        } catch (NumberFormatException e) {
            session.setAttribute("errorMsg", "Invalid complaint ID.");
            response.sendRedirect(request.getContextPath() + "/admin/allComplaints");
            return;
        }

        // Normalise optional fields
        assignedDepartment = (assignedDepartment != null && !assignedDepartment.trim().isEmpty())
                ? assignedDepartment.trim() : null;
        remarks = (remarks != null && !remarks.trim().isEmpty()) ? remarks.trim() : null;

        int adminId = loggedAdmin.getAdminId();

        try {
            boolean updated = complaintDAO.updateComplaintStatus(
                    complaintId, newStatus.trim(), assignedDepartment, remarks, adminId);

            if (updated) {
                session.setAttribute("successMsg", "Complaint status updated successfully.");
            } else {
                session.setAttribute("errorMsg", "Failed to update complaint status. Please try again.");
            }
        } catch (java.sql.SQLException e) {
            session.setAttribute("errorMsg", "Database error updating status: " + e.getMessage());
        }

        response.sendRedirect(
                request.getContextPath() + "/admin/complaintDetail?id=" + complaintId);
    }
}
