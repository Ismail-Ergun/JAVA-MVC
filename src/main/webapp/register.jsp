<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<jsp:include page="header.jsp">
    <jsp:param name="pageTitle" value="Kayıt Ol - ISTECH" />
</jsp:include>

<div class="row justify-content-center my-4 animated-fade-in">
    <div class="col-md-7 col-lg-6">
        <div class="card border-0 shadow-lg rounded-4 bg-white p-5">
            <div class="text-center mb-4">
                <i class="bi bi-person-plus-fill text-primary fs-1"></i>
                <h3 class="fw-bold mt-2 text-dark">Yeni Hesap Oluşturun</h3>
                <p class="text-secondary small">Kayıt olarak sipariş geçmişinizi görüntüleyebilir ve hızlı alışveriş yapabilirsiniz.</p>
            </div>

            <form action="${pageContext.request.contextPath}/register" method="POST" onsubmit="return validateForm()">
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="fullName" class="form-label fw-semibold">Ad Soyad <span class="text-danger">*</span></label>
                        <input type="text" class="form-control form-control-premium" id="fullName" name="fullName" 
                               placeholder="Ahmet Yılmaz" value="${requestScope.fullName}" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="email" class="form-label fw-semibold">E-posta Adresi <span class="text-danger">*</span></label>
                        <input type="email" class="form-control form-control-premium" id="email" name="email" 
                               placeholder="ahmet@alan.com" value="${requestScope.email}" required>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="password" class="form-label fw-semibold">Şifre <span class="text-danger">*</span></label>
                        <input type="password" class="form-control form-control-premium" id="password" name="password" 
                               placeholder="En az 6 karakter" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="phone" class="form-label fw-semibold">Telefon Numarası</label>
                        <input type="tel" class="form-control form-control-premium" id="phone" name="phone" 
                               placeholder="05xxxxxxxxx" value="${requestScope.phone}">
                    </div>
                </div>

                <div class="mb-4">
                    <label for="address" class="form-label fw-semibold">Teslimat Adresi</label>
                    <textarea class="form-control form-control-premium" id="address" name="address" rows="3" 
                              placeholder="Mahalle, Cadde, Sokak, Daire, İlçe/İl bilgilerini yazınız">${requestScope.address}</textarea>
                </div>

                <button type="submit" class="btn btn-premium w-100 py-2.5 rounded-3 mb-3">
                    <i class="bi bi-person-check-fill me-2"></i>Kayıt İşlemini Tamamla
                </button>
            </form>

            <div class="text-center mt-2">
                <span class="text-secondary small">Zaten hesabınız var mı?</span>
                <a href="${pageContext.request.contextPath}/login" class="text-primary fw-semibold small text-decoration-none ms-1">Giriş Yapın</a>
            </div>
        </div>
    </div>
</div>

<script>
    function validateForm() {
        var password = document.getElementById('password').value;
        if (password.length < 6) {
            alert('Şifre en az 6 karakter olmalıdır.');
            return false;
        }
        return true;
    }
</script>

<jsp:include page="footer.jsp" />
