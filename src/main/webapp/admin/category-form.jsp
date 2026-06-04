<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<jsp:include page="../header.jsp">
    <jsp:param name="pageTitle" value="${not empty category.id ? 'Kategoriyi Düzenle' : 'Yeni Kategori Ekle'} - Yönetici Paneli" />
</jsp:include>

<div class="row my-4 animated-fade-in">
    <!-- Admin Sidebar -->
    <div class="col-lg-3 col-md-4 mb-4">
        <div class="card border-0 shadow-sm rounded-4 p-3 bg-white">
            <h5 class="fw-bold mb-3 px-2 text-dark border-bottom pb-2">
                <i class="bi bi-shield-fill-check text-primary me-2"></i>Yönetici İşlemleri
            </h5>
            <div class="d-flex flex-column gap-1">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="category-sidebar-link">
                    <i class="bi bi-speedometer2 me-2"></i>Kontrol Paneli
                </a>
                <a href="${pageContext.request.contextPath}/admin/products" class="category-sidebar-link">
                    <i class="bi bi-box-seam me-2"></i>Ürün Yönetimi
                </a>
                <a href="${pageContext.request.contextPath}/admin/categories" class="category-sidebar-link active">
                    <i class="bi bi-grid me-2"></i>Kategori Yönetimi
                </a>
                <a href="${pageContext.request.contextPath}/admin/orders" class="category-sidebar-link">
                    <i class="bi bi-receipt me-2"></i>Sipariş Yönetimi
                </a>
                <a href="${pageContext.request.contextPath}/admin/users" class="category-sidebar-link">
                    <i class="bi bi-people me-2"></i>Kullanıcı Yönetimi
                </a>
            </div>
        </div>
    </div>

    <!-- Main Section -->
    <div class="col-lg-9 col-md-8">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="fw-bold mb-0">
                <c:choose>
                    <c:when test="${not empty category.id}">
                        <i class="bi bi-pencil-square text-primary me-2"></i>Kategoriyi Düzenle (#${category.id})
                    </c:when>
                    <c:otherwise>
                        <i class="bi bi-plus-circle text-primary me-2"></i>Yeni Kategori Ekle
                    </c:otherwise>
                </c:choose>
            </h3>
            <a href="${pageContext.request.contextPath}/admin/categories" class="btn btn-premium-outline py-2">
                <i class="bi bi-arrow-left me-1"></i> Geri Dön
            </a>
        </div>

        <div class="card border-0 shadow-sm rounded-4 p-5 bg-white">
            <form action="${pageContext.request.contextPath}/admin/category-form" method="POST">
                <c:if test="${not empty category.id}">
                    <input type="hidden" name="id" value="${category.id}">
                </c:if>

                <div class="mb-3">
                    <label for="name" class="form-label fw-semibold">Kategori Adı <span class="text-danger">*</span></label>
                    <input type="text" class="form-control form-control-premium" id="name" name="name" 
                           placeholder="Örn: Telefon" value="${category.name}" required>
                </div>

                <div class="mb-4">
                    <label for="description" class="form-label fw-semibold">Açıklama</label>
                    <textarea class="form-control form-control-premium" id="description" name="description" rows="4" 
                              placeholder="Kategori kapsamını açıklayınız">${category.description}</textarea>
                </div>

                <div class="mb-4 form-check form-switch p-3 rounded bg-light border d-inline-flex align-items-center gap-2 ms-0 ps-5" style="width:auto;">
                    <input class="form-check-input ms-0" type="checkbox" role="switch" id="isActive" name="isActive" value="true" 
                           ${empty category or category.active ? 'checked' : ''}>
                    <label class="form-check-label fw-semibold text-dark" for="isActive">Kategoriyi Aktifleştir</label>
                </div>

                <div class="mt-4 pt-3 border-top d-flex gap-2">
                    <button type="submit" class="btn btn-premium px-5 py-2.5">
                        <i class="bi bi-save me-2"></i>Kaydet
                    </button>
                    <a href="${pageContext.request.contextPath}/admin/categories" class="btn btn-secondary px-4 py-2.5">İptal</a>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="../footer.jsp" />
