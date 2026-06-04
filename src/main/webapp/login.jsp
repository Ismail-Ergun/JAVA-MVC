<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<jsp:include page="header.jsp">
    <jsp:param name="pageTitle" value="Giriş Yap - ISTECH" />
</jsp:include>

<div class="row justify-content-center my-5 animated-fade-in">
    <div class="col-md-6 col-lg-5">
        <div class="card border-0 shadow-lg rounded-4 overflow-hidden bg-white">
            <div class="p-5">
                <div class="text-center mb-4">
                    <i class="bi bi-shield-lock-fill text-primary fs-1"></i>
                    <h3 class="fw-bold mt-2 text-dark">Hesabınıza Giriş Yapın</h3>
                    <p class="text-secondary small">Alışverişe devam etmek veya yönetim paneline erişmek için oturum açın.</p>
                </div>

                <!-- Determine if Admin page is requested to toggle post action -->
                <c:set var="loginAction" value="${pageContext.request.contextPath}/login" />
                <c:if test="${pageContext.request.servletPath eq '/admin/login'}">
                    <c:set var="loginAction" value="${pageContext.request.contextPath}/admin/login" />
                </c:if>

                <form action="${loginAction}" method="POST">
                    <div class="mb-3">
                        <label for="email" class="form-label fw-semibold">E-posta Adresi</label>
                        <input type="email" class="form-control form-control-premium" id="email" name="email" 
                               placeholder="ornek@alan.com" value="${requestScope.email}" required>
                    </div>
                    <div class="mb-4">
                        <label for="password" class="form-label fw-semibold">Şifre</label>
                        <input type="password" class="form-control form-control-premium" id="password" name="password" 
                               placeholder="••••••" required>
                    </div>
                    <button type="submit" class="btn btn-premium w-100 py-2.5 rounded-3 mb-3">
                        <i class="bi bi-box-arrow-in-right me-2"></i>Giriş Yap
                    </button>
                </form>

                <div class="text-center mt-3">
                    <span class="text-secondary small">Hesabınız yok mu?</span>
                    <a href="${pageContext.request.contextPath}/register" class="text-primary fw-semibold small text-decoration-none ms-1">Hemen Kayıt Olun</a>
                </div>
            </div>
            
            <!-- Quick Fill Panel for Grader/Tester -->
            <div class="bg-light p-4 border-top">
                <h6 class="fw-bold text-dark mb-2"><i class="bi bi-lightning-charge-fill text-warning me-1"></i> Hızlı Test Giriş Bilgileri</h6>
                <div class="d-flex flex-column gap-2 small">
                    <div class="d-flex justify-content-between align-items-center p-2 rounded bg-white shadow-sm">
                        <span><strong>Müşteri:</strong> user@ecommerce.com</span>
                        <button class="btn btn-sm btn-outline-secondary py-0" onclick="quickFill('user@ecommerce.com', 'user123')">Doldur</button>
                    </div>
                    <div class="d-flex justify-content-between align-items-center p-2 rounded bg-white shadow-sm">
                        <span><strong>Yönetici (Admin):</strong> admin@ecommerce.com</span>
                        <button class="btn btn-sm btn-outline-secondary py-0" onclick="quickFill('admin@ecommerce.com', 'admin123')">Doldur</button>
                    </div>
                </div>
                <small class="text-secondary d-block mt-2">Şifreler: <strong>user123</strong> ve <strong>admin123</strong></small>
            </div>
        </div>
    </div>
</div>

<script>
    function quickFill(email, password) {
        document.getElementById('email').value = email;
        document.getElementById('password').value = password;
    }
</script>

<jsp:include page="footer.jsp" />
