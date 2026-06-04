package com.ecommerce.controller;

import com.ecommerce.dao.OrderDAO;
import com.ecommerce.model.CartItem;
import com.ecommerce.model.Order;
import com.ecommerce.model.OrderItem;
import com.ecommerce.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "OrderServlet", urlPatterns = {"/checkout", "/my-orders", "/order-detail"})
public class OrderServlet extends HttpServlet {
    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String path = request.getServletPath();
        if ("/my-orders".equals(path)) {
            List<Order> orders = orderDAO.getOrdersByUserId(user.getId());
            request.setAttribute("orders", orders);
            request.getRequestDispatcher("/my-orders.jsp").forward(request, response);
        } else if ("/order-detail".equals(path)) {
            String idParam = request.getParameter("id");
            if (idParam != null) {
                try {
                    int orderId = Integer.parseInt(idParam);
                    Order order = orderDAO.getOrderById(orderId);
                    // Security check: only owner or admin can view
                    if (order != null && (order.getUserId() == user.getId() || user.isAdmin())) {
                        request.setAttribute("order", order);
                        request.getRequestDispatcher("/my-orders.jsp").forward(request, response);
                        return;
                    }
                } catch (NumberFormatException e) {
                    // Ignore
                }
            }
            response.sendRedirect(request.getContextPath() + "/my-orders");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            session.setAttribute("errorMsg", "Sipariş oluşturmak için giriş yapmalısınız.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String path = request.getServletPath();
        if ("/checkout".equals(path)) {
            List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
            if (cart == null || cart.isEmpty()) {
                session.setAttribute("errorMsg", "Sepetiniz boş. Sipariş oluşturulamaz.");
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }

            // Create Order
            Order order = new Order();
            order.setUserId(user.getId());
            order.setStatus("Beklemede");
            
            double total = 0.0;
            List<OrderItem> items = new ArrayList<>();
            for (CartItem ci : cart) {
                OrderItem item = new OrderItem();
                item.setProductId(ci.getProduct().getId());
                item.setQuantity(ci.getQuantity());
                item.setUnitPrice(ci.getProduct().getPrice());
                item.setSubtotal(ci.getSubtotal());
                
                total += ci.getSubtotal();
                items.add(item);
            }
            order.setTotalAmount(total);
            order.setItems(items);

            // Execute Transaction
            boolean success = orderDAO.createOrder(order);
            if (success) {
                session.removeAttribute("cart"); // Clear cart
                session.setAttribute("successMsg", "Siparişiniz başarıyla oluşturuldu.");
                response.sendRedirect(request.getContextPath() + "/my-orders");
            } else {
                session.setAttribute("errorMsg", "Sipariş oluşturulurken bir hata oluştu. Lütfen ürün stoklarını kontrol ediniz.");
                response.sendRedirect(request.getContextPath() + "/cart");
            }
        }
    }
}
