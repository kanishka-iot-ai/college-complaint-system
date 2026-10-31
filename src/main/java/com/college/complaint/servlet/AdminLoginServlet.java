package com.college.complaint.servlet;

import com.college.complaint.dao.AdminDAO;
import com.college.complaint.model.Admin;
import com.college.complaint.util.BCryptUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/adminLogin")
public class AdminLoginServlet extends HttpServlet {

    private final AdminDAO adminDAO = new AdminDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");

        String email    = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMsg", "Email and password are required.");
            request.getRequestDispatcher("/admin/login.jsp").forward(request, response);
            return;
        }

        Admin admin = null;
        try {
            admin = adminDAO.getAdminByEmail(email.trim().toLowerCase());
        } catch (java.sql.SQLException e) {
            request.setAttribute("errorMsg", "Database error during login: " + e.getMessage());
            request.getRequestDispatcher("/admin/login.jsp").forward(request, response);
            return;
        }

        if (admin == null) {
            request.setAttribute("errorMsg", "No admin account found with that email address.");
            request.getRequestDispatcher("/admin/login.jsp").forward(request, response);
            return;
        }

        boolean passwordMatches = BCryptUtil.checkPassword(password, admin.getPasswordHash());

        if (!passwordMatches) {
            request.setAttribute("errorMsg", "Invalid email or password.");
            request.getRequestDispatcher("/admin/login.jsp").forward(request, response);
            return;
        }

        // Invalidate any existing session and create a fresh one
        HttpSession oldSession = request.getSession(false);
        if (oldSession != null) {
            oldSession.invalidate();
        }

        HttpSession session = request.getSession(true);
        session.setAttribute("loggedAdmin", admin);
        session.setMaxInactiveInterval(60 * 60); // 60 minutes

        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
    }
}
