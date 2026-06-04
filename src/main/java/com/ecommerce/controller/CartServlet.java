package com.ecommerce.controller;

import com.ecommerce.dao.ProductDAO;
import com.ecommerce.model.CartItem;
import com.ecommerce.model.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "CartServlet", urlPatterns = {"/cart"})
public class CartServlet extends HttpServlet {
    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
            session.setAttribute("cart", cart);
        }

        double grandTotal = 0.0;
        for (CartItem item : cart) {
            grandTotal += item.getSubtotal();
        }
        
        request.setAttribute("grandTotal", grandTotal);
        request.getRequestDispatcher("/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        HttpSession session = request.getSession();
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
            session.setAttribute("cart", cart);
        }

        String productIdParam = request.getParameter("productId");
        if (productIdParam == null) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        try {
            int productId = Integer.parseInt(productIdParam);
            Product product = productDAO.getProductById(productId);

            if (product == null || !product.isActive()) {
                session.setAttribute("errorMsg", "Ürün mevcut değil veya aktif değil.");
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }

            if ("add".equals(action)) {
                int quantity = 1;
                String qtyParam = request.getParameter("quantity");
                if (qtyParam != null && !qtyParam.trim().isEmpty()) {
                    quantity = Integer.parseInt(qtyParam);
                }

                // Check if already in cart
                CartItem existingItem = null;
                for (CartItem item : cart) {
                    if (item.getProduct().getId() == productId) {
                        existingItem = item;
                        break;
                    }
                }

                int currentCartQty = (existingItem != null) ? existingItem.getQuantity() : 0;
                int targetQty = currentCartQty + quantity;

                if (targetQty > product.getStock()) {
                    session.setAttribute("errorMsg", "Yetersiz stok! En fazla " + product.getStock() + " adet ekleyebilirsiniz. Sepetinizde zaten " + currentCartQty + " adet var.");
                } else if (targetQty <= 0) {
                    session.setAttribute("errorMsg", "Geçersiz miktar.");
                } else {
                    if (existingItem != null) {
                        existingItem.setQuantity(targetQty);
                    } else {
                        cart.add(new CartItem(product, quantity));
                    }
                    session.setAttribute("successMsg", product.getName() + " sepete eklendi.");
                }

            } else if ("update".equals(action)) {
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                if (quantity <= 0) {
                    // Remove if quantity set to 0 or less
                    cart.removeIf(item -> item.getProduct().getId() == productId);
                } else if (quantity > product.getStock()) {
                    session.setAttribute("errorMsg", "Stok sınırını aştınız! Maksimum stok: " + product.getStock());
                } else {
                    for (CartItem item : cart) {
                        if (item.getProduct().getId() == productId) {
                            item.setQuantity(quantity);
                            break;
                        }
                    }
                    session.setAttribute("successMsg", "Sepet güncellendi.");
                }

            } else if ("remove".equals(action)) {
                cart.removeIf(item -> item.getProduct().getId() == productId);
                session.setAttribute("successMsg", "Ürün sepetten çıkarıldı.");
            }

        } catch (NumberFormatException e) {
            session.setAttribute("errorMsg", "Bir hata oluştu.");
        }

        response.sendRedirect(request.getContextPath() + "/cart");
    }
}
