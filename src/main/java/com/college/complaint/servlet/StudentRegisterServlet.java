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

@WebServlet("/register")
public class StudentRegisterServlet extends HttpServlet {

    private final StudentDAO studentDAO = new StudentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        response.sendRedirect(request.getContextPath() + "/register.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");

        String name            = request.getParameter("name");
        String email           = request.getParameter("email");
        String password        = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String department      = request.getParameter("department");
        String semesterStr     = request.getParameter("semester");
        String phone           = request.getParameter("phone");

        // Validate required fields
        if (!ValidationUtil.isNotEmpty(name) || !ValidationUtil.isNotEmpty(email)
                || !ValidationUtil.isNotEmpty(password) || !ValidationUtil.isNotEmpty(confirmPassword)
                || !ValidationUtil.isNotEmpty(department) || !ValidationUtil.isNotEmpty(semesterStr)
                || !ValidationUtil.isNotEmpty(phone)) {
            request.setAttribute("errorMsg", "All fields are required.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // Validate email format
        if (!ValidationUtil.isValidEmail(email)) {
            request.setAttribute("errorMsg", "Please enter a valid email address.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // Validate phone
        if (!ValidationUtil.isValidPhone(phone)) {
            request.setAttribute("errorMsg", "Please enter a valid 10-digit phone number.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // Check passwords match
        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMsg", "Passwords do not match.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // Validate password strength
        if (!ValidationUtil.isValidPassword(password)) {
            request.setAttribute("errorMsg", "Password must be at least 6 characters long.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        int semester;
        try {
            semester = Integer.parseInt(semesterStr);
            if (semester < 1 || semester > 8) {
                request.setAttribute("errorMsg", "Semester must be between 1 and 8.");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMsg", "Invalid semester value.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        try {
            // Check email uniqueness
            if (studentDAO.emailExists(email)) {
                request.setAttribute("errorMsg", "An account with this email already exists.");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }

            // Hash password
            String hashedPassword = BCryptUtil.hashPassword(password);

            String uidParam = request.getParameter("uid");
            String sectionParam = request.getParameter("section");

            // Build student object
            Student student = new Student();
            student.setUid(uidParam != null && !uidParam.trim().isEmpty() ? uidParam.trim().toUpperCase() : ("STU" + (System.currentTimeMillis() % 1000000)));
            student.setName(name.trim());
            student.setEmail(email.trim().toLowerCase());
            student.setSection(sectionParam != null && !sectionParam.trim().isEmpty() ? sectionParam.trim() : "Future Skills & Innovation");
            student.setPasswordHash(hashedPassword);
            student.setDepartment(department.trim());
            student.setSemester(semester);
            student.setPhone(phone.trim());
            student.setActive(true);

            boolean registered = studentDAO.registerStudent(student);

            if (registered) {
                HttpSession session = request.getSession(true);
                session.setAttribute("successMsg", "Registration successful! Please log in.");
                response.sendRedirect(request.getContextPath() + "/login.jsp");
            } else {
                request.setAttribute("errorMsg", "Registration failed. Please try again later.");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
            }
        } catch (java.sql.SQLException e) {
            request.setAttribute("errorMsg", "Database error during registration: " + e.getMessage());
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
}
