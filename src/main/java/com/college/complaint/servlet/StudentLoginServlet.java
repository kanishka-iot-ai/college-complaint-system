package com.college.complaint.servlet;

import com.college.complaint.dao.StudentDAO;
import com.college.complaint.model.Student;
import com.college.complaint.util.BCryptUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/studentLogin")
public class StudentLoginServlet extends HttpServlet {

    private final StudentDAO studentDAO = new StudentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");

        String identifier = request.getParameter("identifier");
        if (identifier == null || identifier.trim().isEmpty()) {
            identifier = request.getParameter("email");
        }
        String password = request.getParameter("password");

        if (identifier == null || identifier.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMsg", "University UID or Email and password are required.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        Student student = null;
        try {
            student = studentDAO.getStudentByIdentifier(identifier.trim());
        } catch (java.sql.SQLException e) {
            request.setAttribute("errorMsg", "Database error during login: " + e.getMessage());
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        if (student == null) {
            request.setAttribute("errorMsg", "No account found matching UID or Email: " + identifier.trim());
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        boolean passwordMatches = BCryptUtil.checkPassword(password, student.getPasswordHash());

        if (!passwordMatches) {
            request.setAttribute("errorMsg", "Invalid credentials. Please verify your UID/Email and password.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        // If authenticated successfully and account was pending activation, activate it
        if (!student.isActive()) {
            try {
                studentDAO.activateStudent(student.getUid(), student.getPasswordHash());
                student.setActive(true);
            } catch (java.sql.SQLException ignored) {}
        }

        // Invalidate any existing session and create a fresh one
        HttpSession oldSession = request.getSession(false);
        if (oldSession != null) {
            oldSession.invalidate();
        }

        HttpSession session = request.getSession(true);
        session.setAttribute("loggedStudent", student);
        session.setMaxInactiveInterval(30 * 60); // 30 minutes

        response.sendRedirect(request.getContextPath() + "/student/dashboard");
    }
}
