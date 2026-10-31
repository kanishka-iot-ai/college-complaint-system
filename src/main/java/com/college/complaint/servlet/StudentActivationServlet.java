package com.college.complaint.servlet;

import com.college.complaint.dao.StudentDAO;
import com.college.complaint.model.Student;
import com.college.complaint.util.BCryptUtil;
import com.college.complaint.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Servlet handling first-time student account activation and password setup.
 * Matches student's university UID and institutional email, verifies identity,
 * hashes the new password with BCrypt, and marks account status active.
 */
@WebServlet("/activate")
public class StudentActivationServlet extends HttpServlet {

    private final StudentDAO studentDAO = new StudentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        request.getRequestDispatcher("/activate.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");

        String uid             = request.getParameter("uid");
        String email           = request.getParameter("email");
        String newPassword     = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (!ValidationUtil.isNotEmpty(uid) || !ValidationUtil.isNotEmpty(email)
                || !ValidationUtil.isNotEmpty(newPassword) || !ValidationUtil.isNotEmpty(confirmPassword)) {
            request.setAttribute("errorMsg", "All fields are required for activation.");
            request.setAttribute("uid", uid);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/activate.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("errorMsg", "Passwords do not match.");
            request.setAttribute("uid", uid);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/activate.jsp").forward(request, response);
            return;
        }

        if (!ValidationUtil.isValidPassword(newPassword)) {
            request.setAttribute("errorMsg", "Password must be at least 6 characters long.");
            request.setAttribute("uid", uid);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/activate.jsp").forward(request, response);
            return;
        }

        try {
            Student student = studentDAO.getStudentByUid(uid.trim());
            if (student == null) {
                request.setAttribute("errorMsg", "No student record found with UID: " + uid.trim());
                request.setAttribute("uid", uid);
                request.setAttribute("email", email);
                request.getRequestDispatcher("/activate.jsp").forward(request, response);
                return;
            }

            if (!student.getEmail().equalsIgnoreCase(email.trim())) {
                request.setAttribute("errorMsg", "The provided email does not match the official record for UID: " + uid.trim());
                request.setAttribute("uid", uid);
                request.setAttribute("email", email);
                request.getRequestDispatcher("/activate.jsp").forward(request, response);
                return;
            }

            String hashedPassword = BCryptUtil.hashPassword(newPassword);
            boolean activated = studentDAO.activateStudent(student.getUid(), hashedPassword);

            if (activated) {
                HttpSession session = request.getSession(true);
                session.setAttribute("successMsg", "Account activated successfully for " + student.getName() + " (" + student.getUid() + ")! You can now log in.");
                response.sendRedirect(request.getContextPath() + "/login.jsp");
            } else {
                request.setAttribute("errorMsg", "Failed to activate account. Please contact administrative support.");
                request.getRequestDispatcher("/activate.jsp").forward(request, response);
            }
        } catch (java.sql.SQLException e) {
            request.setAttribute("errorMsg", "Database error during activation: " + e.getMessage());
            request.getRequestDispatcher("/activate.jsp").forward(request, response);
        }
    }
}
