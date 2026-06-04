package com.ecommerce.controller;

import com.ecommerce.dao.CategoryDAO;
import com.ecommerce.model.Category;
import com.ecommerce.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminCategoryServlet", urlPatterns = {"/admin/categories", "/admin/category-form"})
public class AdminCategoryServlet extends HttpServlet {
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
        if ("/admin/categories".equals(path)) {
            List<Category> categories = categoryDAO.getAllCategories();
            request.setAttribute("categories", categories);
            request.getRequestDispatcher("/admin/categories.jsp").forward(request, response);
        } else if ("/admin/category-form".equals(path)) {
            String idParam = request.getParameter("id");
            if (idParam != null && !idParam.trim().isEmpty()) {
                try {
                    int id = Integer.parseInt(idParam);
                    Category category = categoryDAO.getCategoryById(id);
                    if (category != null) {
                        request.setAttribute("category", category);
                    }
                } catch (NumberFormatException e) {
                    // Ignore
                }
            }
            request.getRequestDispatcher("/admin/category-form.jsp").forward(request, response);
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
        if ("/admin/categories".equals(path)) {
            // Delete action
            String action = request.getParameter("action");
            String idParam = request.getParameter("id");
            if ("delete".equals(action) && idParam != null) {
                try {
                    int id = Integer.parseInt(idParam);
                    boolean success = categoryDAO.deleteCategory(id);
                    if (success) {
                        session.setAttribute("successMsg", "Kategori başarıyla silindi veya pasifleştirildi.");
                    } else {
                        session.setAttribute("errorMsg", "Kategori silinemedi.");
                    }
                } catch (NumberFormatException e) {
                    session.setAttribute("errorMsg", "Geçersiz kategori ID.");
                }
            }
            response.sendRedirect(request.getContextPath() + "/admin/categories");
            
        } else if ("/admin/category-form".equals(path)) {
            // Add or Edit category submission
            String idParam = request.getParameter("id");
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String isActiveParam = request.getParameter("isActive");

            boolean isActive = "true".equals(isActiveParam);

            if (name == null || name.trim().isEmpty()) {
                request.setAttribute("errorMsg", "Kategori adı boş olamaz.");
                reloadCategoryForm(request);
                request.getRequestDispatcher("/admin/category-form.jsp").forward(request, response);
                return;
            }

            Category category = new Category();
            category.setName(name.trim());
            category.setDescription(description != null ? description.trim() : "");
            category.setActive(isActive);

            boolean success;
            if (idParam != null && !idParam.trim().isEmpty()) {
                try {
                    int id = Integer.parseInt(idParam);
                    category.setId(id);
                    success = categoryDAO.updateCategory(category);
                    if (success) {
                        session.setAttribute("successMsg", "Kategori başarıyla güncellendi.");
                    } else {
                        session.setAttribute("errorMsg", "Kategori güncellenemedi.");
                    }
                } catch (NumberFormatException e) {
                    session.setAttribute("errorMsg", "Geçersiz kategori ID.");
                }
            } else {
                success = categoryDAO.addCategory(category);
                if (success) {
                    session.setAttribute("successMsg", "Kategori başarıyla eklendi.");
                } else {
                    session.setAttribute("errorMsg", "Kategori eklenemedi.");
                }
            }

            response.sendRedirect(request.getContextPath() + "/admin/categories");
        }
    }

    private void reloadCategoryForm(HttpServletRequest request) {
        Category temp = new Category();
        String idParam = request.getParameter("id");
        if (idParam != null && !idParam.trim().isEmpty()) {
            try { temp.setId(Integer.parseInt(idParam)); } catch (NumberFormatException e) {}
        }
        temp.setName(request.getParameter("name"));
        temp.setDescription(request.getParameter("description"));
        temp.setActive("true".equals(request.getParameter("isActive")));
        request.setAttribute("category", temp);
    }
}
