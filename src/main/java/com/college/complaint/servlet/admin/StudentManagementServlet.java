package com.college.complaint.servlet.admin;

import com.college.complaint.dao.StudentDAO;
import com.college.complaint.model.Admin;
import com.college.complaint.model.Student;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/studentManagement")
public class StudentManagementServlet extends HttpServlet {

    private final StudentDAO studentDAO = new StudentDAO();

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

        // Retrieve and expose any flash messages
        String successMsg = (String) session.getAttribute("successMsg");
        if (successMsg != null) {
            request.setAttribute("successMsg", successMsg);
            session.removeAttribute("successMsg");
        }
        String errorMsg = (String) session.getAttribute("errorMsg");
        if (errorMsg != null) {
            request.setAttribute("errorMsg", errorMsg);
            session.removeAttribute("errorMsg");
        }

        try {
            String search = request.getParameter("search");
            String section = request.getParameter("section");

            // Load filtered or all registered students
            List<Student> students = studentDAO.getAllStudentsFiltered(search, section);
            request.setAttribute("students", students);
            request.setAttribute("admin", loggedAdmin);
            request.setAttribute("searchParam", search != null ? search : "");
            request.setAttribute("sectionParam", section != null ? section : "ALL");
        } catch (java.sql.SQLException e) {
            request.setAttribute("errorMsg", "Database error loading students: " + e.getMessage());
        }

        request.getRequestDispatcher("/admin/student_management.jsp").forward(request, response);
    }
}
