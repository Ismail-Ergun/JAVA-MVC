package com.ecommerce.controller;

import com.ecommerce.dao.OrderDAO;
import com.ecommerce.dao.UserDAO;
import com.ecommerce.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "AdminLoginServlet", urlPatterns = {"/admin/login", "/admin/dashboard", "/admin/logout"})
public class AdminLoginServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();
    private final OrderDAO orderDAO = new OrderDAO(); // Used to fetch stats for dashboard

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        HttpSession session = request.getSession();

        if ("/admin/logout".equals(path)) {
            if (session != null) {
                session.removeAttribute("user");
            }
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        User user = (User) session.getAttribute("user");

        if ("/admin/dashboard".equals(path)) {
            if (user == null || !user.isAdmin()) {
                session.setAttribute("errorMsg", "Yönetim paneline erişim yetkiniz yok.");
                response.sendRedirect(request.getContextPath() + "/admin/login");
                return;
            }

            // Load metrics for dashboard
            request.setAttribute("totalProducts", orderDAO.getTotalProductCount());
            request.setAttribute("totalCategories", orderDAO.getTotalCategoryCount());
            request.setAttribute("totalUsers", orderDAO.getTotalUserCount());
            request.setAttribute("totalOrders", orderDAO.getTotalOrderCount());
            request.setAttribute("pendingOrders", orderDAO.getPendingOrderCount());

            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
        } else {
            // /admin/login
            if (user != null && user.isAdmin()) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                return;
            }
            request.getRequestDispatcher("/login.jsp").forward(request, response); // Reuse login view
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMsg", "E-posta ve şifre boş bırakılamaz.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        User user = userDAO.login(email.trim(), password);

        if (user != null && user.isAdmin()) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        } else if (user != null) {
            request.setAttribute("errorMsg", "Admin yetkiniz bulunmamaktadır.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMsg", "E-posta veya şifre hatalı.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}
