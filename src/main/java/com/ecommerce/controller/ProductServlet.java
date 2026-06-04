package com.ecommerce.controller;

import com.ecommerce.dao.CategoryDAO;
import com.ecommerce.dao.ProductDAO;
import com.ecommerce.model.Category;
import com.ecommerce.model.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ProductServlet", urlPatterns = {"/products", "/product-detail"})
public class ProductServlet extends HttpServlet {
    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        List<Category> categories = categoryDAO.getActiveCategories();
        request.setAttribute("categories", categories);

        if ("/product-detail".equals(path)) {
            handleProductDetail(request, response);
        } else {
            handleProductList(request, response);
        }
    }

    private void handleProductList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String categoryIdParam = request.getParameter("categoryId");
        String keyword = request.getParameter("keyword");
        
        List<Product> products;
        
        if (categoryIdParam != null && !categoryIdParam.trim().isEmpty()) {
            try {
                int categoryId = Integer.parseInt(categoryIdParam);
                products = productDAO.getActiveProductsByCategoryId(categoryId);
                Category selectedCategory = categoryDAO.getCategoryById(categoryId);
                request.setAttribute("selectedCategory", selectedCategory);
            } catch (NumberFormatException e) {
                products = productDAO.getAllProducts(false);
            }
        } else if (keyword != null && !keyword.trim().isEmpty()) {
            products = productDAO.searchProducts(keyword);
            request.setAttribute("keyword", keyword);
        } else {
            products = productDAO.getAllProducts(false);
        }

        request.setAttribute("products", products);
        request.getRequestDispatcher("/products.jsp").forward(request, response);
    }

    private void handleProductDetail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            Product product = productDAO.getProductById(id);
            if (product == null || !product.isActive()) {
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }
            request.setAttribute("product", product);
            request.getRequestDispatcher("/product-detail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }
}
