package com.ecommerce.controller;

import com.ecommerce.dao.UserDAO;
import com.ecommerce.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        // Keep input values to repopulate the form
        request.setAttribute("fullName", fullName);
        request.setAttribute("email", email);
        request.setAttribute("phone", phone);
        request.setAttribute("address", address);

        // Server-side validation
        if (fullName == null || fullName.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            
            request.setAttribute("errorMsg", "Lütfen tüm zorunlu alanları (Ad Soyad, E-posta, Şifre) doldurunuz.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (password.length() < 6) {
            request.setAttribute("errorMsg", "Şifre en az 6 karakter olmalıdır.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (userDAO.emailExists(email.trim())) {
            request.setAttribute("errorMsg", "Bu e-posta adresi sistemde zaten kayıtlı.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // Register User
        User user = new User();
        user.setFullName(fullName.trim());
        user.setEmail(email.trim());
        user.setPassword(password);
        user.setPhone(phone != null ? phone.trim() : "");
        user.setAddress(address != null ? address.trim() : "");
        user.setRole("CUSTOMER"); // Defaults to CUSTOMER

        boolean success = userDAO.register(user);
        if (success) {
            request.getSession().setAttribute("successMsg", "Kayıt işleminiz başarıyla tamamlandı. Giriş yapabilirsiniz.");
            response.sendRedirect(request.getContextPath() + "/login");
        } else {
            request.setAttribute("errorMsg", "Kayıt oluşturulurken sistemsel bir hata oluştu.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
}
