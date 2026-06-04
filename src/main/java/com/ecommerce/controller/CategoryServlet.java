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

@WebServlet(name = "CategoryServlet", urlPatterns = {"/category"})
public class CategoryServlet extends HttpServlet {
    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String categoryIdParam = request.getParameter("id");
        if (categoryIdParam != null && !categoryIdParam.trim().isEmpty()) {
            try {
                int categoryId = Integer.parseInt(categoryIdParam);
                Category selectedCategory = categoryDAO.getCategoryById(categoryId);
                if (selectedCategory != null && selectedCategory.isActive()) {
                    List<Product> products = productDAO.getActiveProductsByCategoryId(categoryId);
                    List<Category> categories = categoryDAO.getActiveCategories();
                    
                    request.setAttribute("categories", categories);
                    request.setAttribute("selectedCategory", selectedCategory);
                    request.setAttribute("products", products);
                    
                    request.getRequestDispatcher("/products.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                // Ignore and redirect
            }
        }
        response.sendRedirect(request.getContextPath() + "/products");
    }
}
