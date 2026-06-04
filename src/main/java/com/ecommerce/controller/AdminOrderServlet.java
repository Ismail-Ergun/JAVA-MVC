package com.ecommerce.controller;

import com.ecommerce.dao.OrderDAO;
import com.ecommerce.dao.UserDAO;
import com.ecommerce.model.Order;
import com.ecommerce.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminOrderServlet", urlPatterns = {"/admin/orders", "/admin/order-detail", "/admin/users"})
public class AdminOrderServlet extends HttpServlet {
    private final OrderDAO orderDAO = new OrderDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || !user.isAdmin()) {
            session.setAttribute("errorMsg", "Bu alana erişim yetkiniz yok.");
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        String path = request.getServletPath();
        if ("/admin/orders".equals(path)) {
            List<Order> orders = orderDAO.getAllOrders();
            request.setAttribute("orders", orders);
            request.getRequestDispatcher("/admin/orders.jsp").forward(request, response);
            
        } else if ("/admin/order-detail".equals(path)) {
            String idParam = request.getParameter("id");
            if (idParam != null) {
                try {
                    int orderId = Integer.parseInt(idParam);
                    Order order = orderDAO.getOrderById(orderId);
                    if (order != null) {
                        request.setAttribute("order", order);
                        request.getRequestDispatcher("/admin/order-detail.jsp").forward(request, response);
                        return;
                    }
                } catch (NumberFormatException e) {
                    // Ignore
                }
            }
            response.sendRedirect(request.getContextPath() + "/admin/orders");
            
        } else if ("/admin/users".equals(path)) {
            List<User> users = userDAO.getAllUsers();
            request.setAttribute("usersList", users); // use usersList to avoid collision with 'user' session attr
            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response); // we can render user list in dashboard or separate
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        String path = request.getServletPath();
        if ("/admin/orders".equals(path)) {
            String action = request.getParameter("action");
            String idParam = request.getParameter("id");
            String status = request.getParameter("status");

            if ("updateStatus".equals(action) && idParam != null && status != null) {
                try {
                    int orderId = Integer.parseInt(idParam);
                    boolean success = orderDAO.updateOrderStatus(orderId, status);
                    if (success) {
                        session.setAttribute("successMsg", "Sipariş durumu '" + status + "' olarak güncellendi.");
                    } else {
                        session.setAttribute("errorMsg", "Sipariş durumu güncellenemedi.");
                    }
                } catch (NumberFormatException e) {
                    session.setAttribute("errorMsg", "Geçersiz sipariş ID.");
                }
            }
            response.sendRedirect(request.getContextPath() + "/admin/orders");
        }
    }
}
