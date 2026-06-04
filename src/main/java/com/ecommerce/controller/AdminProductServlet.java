package com.ecommerce.controller;

import com.ecommerce.dao.CategoryDAO;
import com.ecommerce.dao.ProductDAO;
import com.ecommerce.model.Category;
import com.ecommerce.model.Product;
import com.ecommerce.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminProductServlet", urlPatterns = {"/admin/products", "/admin/product-form"})
public class AdminProductServlet extends HttpServlet {
    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

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
        if ("/admin/products".equals(path)) {
            List<Product> products = productDAO.getAllProducts(true); // include inactive
            request.setAttribute("products", products);
            request.getRequestDispatcher("/admin/products.jsp").forward(request, response);
        } else if ("/admin/product-form".equals(path)) {
            List<Category> categories = categoryDAO.getAllCategories();
            request.setAttribute("categories", categories);

            String idParam = request.getParameter("id");
            if (idParam != null && !idParam.trim().isEmpty()) {
                try {
                    int id = Integer.parseInt(idParam);
                    Product product = productDAO.getProductById(id);
                    if (product != null) {
                        request.setAttribute("product", product);
                    }
                } catch (NumberFormatException e) {
                    // Ignore
                }
            }
            request.getRequestDispatcher("/admin/product-form.jsp").forward(request, response);
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
        if ("/admin/products".equals(path)) {
            // Handle delete action
            String action = request.getParameter("action");
            String idParam = request.getParameter("id");
            if ("delete".equals(action) && idParam != null) {
                try {
                    int id = Integer.parseInt(idParam);
                    boolean success = productDAO.deleteProduct(id);
                    if (success) {
                        session.setAttribute("successMsg", "Ürün başarıyla silindi veya pasifleştirildi.");
                    } else {
                        session.setAttribute("errorMsg", "Ürün silinemedi.");
                    }
                } catch (NumberFormatException e) {
                    session.setAttribute("errorMsg", "Geçersiz ürün ID.");
                }
            }
            response.sendRedirect(request.getContextPath() + "/admin/products");
            
        } else if ("/admin/product-form".equals(path)) {
            // Handle Add / Edit submit
            String idParam = request.getParameter("id");
            String categoryIdParam = request.getParameter("categoryId");
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String priceParam = request.getParameter("price");
            String stockParam = request.getParameter("stock");
            String imageUrl = request.getParameter("imageUrl");
            String isActiveParam = request.getParameter("isActive");

            boolean isActive = "true".equals(isActiveParam);

            // Server-side validation
            if (name == null || name.trim().isEmpty() ||
                categoryIdParam == null || categoryIdParam.trim().isEmpty() ||
                priceParam == null || priceParam.trim().isEmpty() ||
                stockParam == null || stockParam.trim().isEmpty()) {
                
                request.setAttribute("errorMsg", "Lütfen tüm zorunlu alanları doldurunuz.");
                reloadFormResources(request);
                request.getRequestDispatcher("/admin/product-form.jsp").forward(request, response);
                return;
            }

            double price = 0.0;
            int stock = 0;
            int categoryId = 0;

            try {
                price = Double.parseDouble(priceParam);
                stock = Integer.parseInt(stockParam);
                categoryId = Integer.parseInt(categoryIdParam);

                if (price <= 0) {
                    throw new IllegalArgumentException("Fiyat 0'dan büyük olmalıdır.");
                }
                if (stock < 0) {
                    throw new IllegalArgumentException("Stok miktarı negatif olamaz.");
                }
            } catch (Exception e) {
                request.setAttribute("errorMsg", "Geçersiz sayı formatı veya değer: " + e.getMessage());
                reloadFormResources(request);
                request.getRequestDispatcher("/admin/product-form.jsp").forward(request, response);
                return;
            }

            Product product = new Product();
            product.setCategoryId(categoryId);
            product.setName(name.trim());
            product.setDescription(description != null ? description.trim() : "");
            product.setPrice(price);
            product.setStock(stock);
            product.setImageUrl(imageUrl != null ? imageUrl.trim() : "");
            product.setActive(isActive);

            boolean success;
            if (idParam != null && !idParam.trim().isEmpty()) {
                // Edit
                try {
                    int id = Integer.parseInt(idParam);
                    product.setId(id);
                    success = productDAO.updateProduct(product);
                    if (success) {
                        session.setAttribute("successMsg", "Ürün başarıyla güncellendi.");
                    } else {
                        session.setAttribute("errorMsg", "Ürün güncellenemedi.");
                    }
                } catch (NumberFormatException e) {
                    session.setAttribute("errorMsg", "Geçersiz ürün ID.");
                }
            } else {
                // Add
                success = productDAO.addProduct(product);
                if (success) {
                    session.setAttribute("successMsg", "Ürün başarıyla eklendi.");
                } else {
                    session.setAttribute("errorMsg", "Ürün eklenemedi.");
                }
            }

            response.sendRedirect(request.getContextPath() + "/admin/products");
        }
    }

    private void reloadFormResources(HttpServletRequest request) {
        List<Category> categories = categoryDAO.getAllCategories();
        request.setAttribute("categories", categories);
        
        // Re-construct temp product to populate fields
        Product temp = new Product();
        String idParam = request.getParameter("id");
        if (idParam != null && !idParam.trim().isEmpty()) {
            try { temp.setId(Integer.parseInt(idParam)); } catch (NumberFormatException e) {}
        }
        String categoryIdParam = request.getParameter("categoryId");
        if (categoryIdParam != null && !categoryIdParam.trim().isEmpty()) {
            try { temp.setCategoryId(Integer.parseInt(categoryIdParam)); } catch (NumberFormatException e) {}
        }
        temp.setName(request.getParameter("name"));
        temp.setDescription(request.getParameter("description"));
        String priceParam = request.getParameter("price");
        if (priceParam != null && !priceParam.trim().isEmpty()) {
            try { temp.setPrice(Double.parseDouble(priceParam)); } catch (NumberFormatException e) {}
        }
        String stockParam = request.getParameter("stock");
        if (stockParam != null && !stockParam.trim().isEmpty()) {
            try { temp.setStock(Integer.parseInt(stockParam)); } catch (NumberFormatException e) {}
        }
        temp.setImageUrl(request.getParameter("imageUrl"));
        temp.setActive("true".equals(request.getParameter("isActive")));
        
        request.setAttribute("product", temp);
    }
}
