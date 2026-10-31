package com.college.complaint.servlet.student;

import com.college.complaint.dao.StudentDAO;
import com.college.complaint.model.Student;
import com.college.complaint.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/student/profile")
public class StudentProfileServlet extends HttpServlet {

    private final StudentDAO studentDAO = new StudentDAO();

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

        // Retrieve and expose any flash messages
        String successMsg = (String) session.getAttribute("successMsg");
        if (successMsg != null) {
            request.setAttribute("successMsg", successMsg);
            session.removeAttribute("successMsg");
        }

        request.setAttribute("student", loggedStudent);
        request.getRequestDispatcher("/student/profile.jsp").forward(request, response);
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

        String name        = request.getParameter("name");
        String department  = request.getParameter("department");
        String semesterStr = request.getParameter("semester");
        String phone       = request.getParameter("phone");

        // Validate fields
        if (!ValidationUtil.isNotEmpty(name) || !ValidationUtil.isNotEmpty(department)
                || !ValidationUtil.isNotEmpty(semesterStr) || !ValidationUtil.isNotEmpty(phone)) {
            request.setAttribute("errorMsg", "All fields are required.");
            request.setAttribute("student", loggedStudent);
            request.getRequestDispatcher("/student/profile.jsp").forward(request, response);
            return;
        }

        if (!ValidationUtil.isValidPhone(phone)) {
            request.setAttribute("errorMsg", "Please enter a valid 10-digit phone number.");
            request.setAttribute("student", loggedStudent);
            request.getRequestDispatcher("/student/profile.jsp").forward(request, response);
            return;
        }

        int semester;
        try {
            semester = Integer.parseInt(semesterStr.trim());
            if (semester < 1 || semester > 8) {
                request.setAttribute("errorMsg", "Semester must be between 1 and 8.");
                request.setAttribute("student", loggedStudent);
                request.getRequestDispatcher("/student/profile.jsp").forward(request, response);
                return;
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMsg", "Invalid semester value.");
            request.setAttribute("student", loggedStudent);
            request.getRequestDispatcher("/student/profile.jsp").forward(request, response);
            return;
        }

        // Apply updates to the student object
        loggedStudent.setName(name.trim());
        loggedStudent.setDepartment(department.trim());
        loggedStudent.setSemester(semester);
        loggedStudent.setPhone(phone.trim());

        try {
            boolean updated = studentDAO.updateStudent(loggedStudent);

            if (updated) {
                // Refresh the session object with updated details
                session.setAttribute("loggedStudent", loggedStudent);
                session.setAttribute("successMsg", "Profile updated successfully.");
            } else {
                session.setAttribute("errorMsg", "Failed to update profile. Please try again.");
            }
        } catch (java.sql.SQLException e) {
            session.setAttribute("errorMsg", "Database error updating profile: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/student/profile");
    }
}
