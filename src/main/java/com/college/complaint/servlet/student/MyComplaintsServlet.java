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

@WebServlet("/student/myComplaints")
public class MyComplaintsServlet extends HttpServlet {

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

        // Retrieve and expose any flash success message
        String successMsg = (String) session.getAttribute("successMsg");
        if (successMsg != null) {
            request.setAttribute("successMsg", successMsg);
            session.removeAttribute("successMsg");
        }

        try {
            // Load all complaints for this student
            List<Complaint> complaints = complaintDAO.getComplaintsByStudentId(studentId);
            request.setAttribute("complaints", complaints);
            request.setAttribute("student", loggedStudent);
        } catch (java.sql.SQLException e) {
            request.setAttribute("errorMsg", "Database error loading complaints: " + e.getMessage());
        }

        request.getRequestDispatcher("/student/my_complaints.jsp").forward(request, response);
    }
}
