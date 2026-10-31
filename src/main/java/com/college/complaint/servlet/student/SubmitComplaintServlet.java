package com.college.complaint.servlet.student;

import com.college.complaint.dao.CategoryDAO;
import com.college.complaint.dao.ComplaintDAO;
import com.college.complaint.model.Category;
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

@WebServlet("/student/submitComplaint")
public class SubmitComplaintServlet extends HttpServlet {

    private final ComplaintDAO  complaintDAO  = new ComplaintDAO();
    private final CategoryDAO   categoryDAO   = new CategoryDAO();

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

        try {
            // Load all categories for the dropdown
            List<Category> categories = categoryDAO.getAllCategories();
            request.setAttribute("categories", categories);
        } catch (java.sql.SQLException e) {
            request.setAttribute("errorMsg", "Database error loading categories: " + e.getMessage());
        }

        request.getRequestDispatcher("/student/submit_complaint.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");

        // Session check
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedStudent") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Student loggedStudent = (Student) session.getAttribute("loggedStudent");

        String categoryIdStr = request.getParameter("categoryId");
        String title         = request.getParameter("title");
        String description   = request.getParameter("description");
        String priority      = request.getParameter("priority");

        try {
            // Validate all fields are non-empty
            if (categoryIdStr == null || categoryIdStr.trim().isEmpty()
                    || title == null || title.trim().isEmpty()
                    || description == null || description.trim().isEmpty()
                    || priority == null || priority.trim().isEmpty()) {
                request.setAttribute("errorMsg", "All fields are required. Please fill in the form completely.");
                List<Category> categories = categoryDAO.getAllCategories();
                request.setAttribute("categories", categories);
                request.getRequestDispatcher("/student/submit_complaint.jsp").forward(request, response);
                return;
            }

            int categoryId;
            try {
                categoryId = Integer.parseInt(categoryIdStr.trim());
            } catch (NumberFormatException e) {
                request.setAttribute("errorMsg", "Invalid category selected.");
                List<Category> categories = categoryDAO.getAllCategories();
                request.setAttribute("categories", categories);
                request.getRequestDispatcher("/student/submit_complaint.jsp").forward(request, response);
                return;
            }

            // Build complaint object
            Complaint complaint = new Complaint();
            complaint.setStudentId(loggedStudent.getStudentId());
            complaint.setCategoryId(categoryId);
            complaint.setTitle(title.trim());
            complaint.setDescription(description.trim());
            complaint.setPriority(priority.trim());
            complaint.setStatus("Submitted");

            boolean submitted = complaintDAO.submitComplaint(complaint);

            if (submitted) {
                session.setAttribute("successMsg", "Your complaint has been submitted successfully.");
                response.sendRedirect(request.getContextPath() + "/student/myComplaints");
            } else {
                request.setAttribute("errorMsg", "Failed to submit complaint. Please try again.");
                List<Category> categories = categoryDAO.getAllCategories();
                request.setAttribute("categories", categories);
                request.getRequestDispatcher("/student/submit_complaint.jsp").forward(request, response);
            }
        } catch (java.sql.SQLException e) {
            request.setAttribute("errorMsg", "Database error submitting complaint: " + e.getMessage());
            try {
                request.setAttribute("categories", categoryDAO.getAllCategories());
            } catch (Exception ignored) {}
            request.getRequestDispatcher("/student/submit_complaint.jsp").forward(request, response);
        }
    }
}
