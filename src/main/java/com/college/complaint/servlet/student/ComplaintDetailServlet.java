package com.college.complaint.servlet.student;

import com.college.complaint.dao.ComplaintDAO;
import com.college.complaint.model.Complaint;
import com.college.complaint.model.ComplaintHistory;
import com.college.complaint.model.Resolution;
import com.college.complaint.model.Student;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/student/complaintDetail")
public class ComplaintDetailServlet extends HttpServlet {

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

        String complaintIdStr = request.getParameter("id");
        if (complaintIdStr == null || complaintIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/student/myComplaints");
            return;
        }

        int complaintId;
        try {
            complaintId = Integer.parseInt(complaintIdStr.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/student/myComplaints");
            return;
        }

        try {
            // Load the complaint
            Complaint complaint = complaintDAO.getComplaintById(complaintId);

            if (complaint == null) {
                request.setAttribute("errorMsg", "Complaint not found.");
                response.sendRedirect(request.getContextPath() + "/student/myComplaints");
                return;
            }

            // Security check: ensure this complaint belongs to the logged-in student
            if (complaint.getStudentId() != loggedStudent.getStudentId()) {
                request.setAttribute("errorMsg", "You are not authorised to view this complaint.");
                response.sendRedirect(request.getContextPath() + "/student/myComplaints");
                return;
            }

            // Load resolution (may be null if not yet resolved)
            Resolution resolution = complaintDAO.getResolutionByComplaintId(complaintId);

            // Load complaint history / audit trail
            List<ComplaintHistory> history = complaintDAO.getComplaintHistory(complaintId);

            request.setAttribute("complaint", complaint);
            request.setAttribute("resolution", resolution);
            request.setAttribute("history", history);
            request.setAttribute("student", loggedStudent);
        } catch (java.sql.SQLException e) {
            request.setAttribute("errorMsg", "Database error loading complaint: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/student/myComplaints");
            return;
        }

        request.getRequestDispatcher("/student/complaint_detail.jsp").forward(request, response);
    }
}
