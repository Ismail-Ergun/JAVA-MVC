<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<jsp:include page="../header.jsp">
    <jsp:param name="pageTitle" value="${not empty product.id ? 'Ürünü Düzenle' : 'Yeni Ürün Ekle'} - Yönetici Paneli" />
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
                <a href="${pageContext.request.contextPath}/admin/products" class="category-sidebar-link active">
                    <i class="bi bi-box-seam me-2"></i>Ürün Yönetimi
                </a>
                <a href="${pageContext.request.contextPath}/admin/categories" class="category-sidebar-link">
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
                    <c:when test="${not empty product.id}">
                        <i class="bi bi-pencil-square text-primary me-2"></i>Ürünü Düzenle (#${product.id})
                    </c:when>
                    <c:otherwise>
                        <i class="bi bi-plus-circle text-primary me-2"></i>Yeni Ürün Ekle
                    </c:otherwise>
                </c:choose>
            </h3>
            <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-premium-outline py-2">
                <i class="bi bi-arrow-left me-1"></i> Geri Dön
            </a>
        </div>

        <div class="card border-0 shadow-sm rounded-4 p-5 bg-white">
            <form action="${pageContext.request.contextPath}/admin/product-form" method="POST">
                <c:if test="${not empty product.id}">
                    <input type="hidden" name="id" value="${product.id}">
                </c:if>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="name" class="form-label fw-semibold">Ürün Adı <span class="text-danger">*</span></label>
                        <input type="text" class="form-control form-control-premium" id="name" name="name" 
                               placeholder="Örn: iPhone 15 Pro Max" value="${product.name}" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="categoryId" class="form-label fw-semibold">Kategori <span class="text-danger">*</span></label>
                        <select class="form-select form-control-premium" id="categoryId" name="categoryId" required>
                            <option value="">-- Kategori Seçiniz --</option>
                            <c:forEach var="cat" items="${categories}">
                                <option value="${cat.id}" ${product.categoryId == cat.id ? 'selected' : ''}>
                                    ${cat.name}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="price" class="form-label fw-semibold">Fiyat (TL) <span class="text-danger">*</span></label>
                        <input type="number" step="0.01" class="form-control form-control-premium" id="price" name="price" 
                               placeholder="0.00" min="0.01" value="${product.price}" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="stock" class="form-label fw-semibold">Stok Miktarı <span class="text-danger">*</span></label>
                        <input type="number" class="form-control form-control-premium" id="stock" name="stock" 
                               placeholder="0" min="0" value="${product.stock}" required>
                    </div>
                </div>

                <div class="mb-3">
                    <label for="imageUrl" class="form-label fw-semibold">Ürün Görsel Yolu (URL)</label>
                    <input type="url" class="form-control form-control-premium" id="imageUrl" name="imageUrl" 
                           placeholder="https://domain.com/resim.jpg" value="${product.imageUrl}">
                </div>

                <div class="mb-4">
                    <label for="description" class="form-label fw-semibold">Açıklama</label>
                    <textarea class="form-control form-control-premium" id="description" name="description" rows="4" 
                              placeholder="Ürün özelliklerini detaylı bir şekilde yazınız">${product.description}</textarea>
                </div>

                <div class="mb-4 form-check form-switch p-3 rounded bg-light border d-inline-flex align-items-center gap-2 ms-0 ps-5" style="width:auto;">
                    <input class="form-check-input ms-0" type="checkbox" role="switch" id="isActive" name="isActive" value="true" 
                           ${empty product or product.active ? 'checked' : ''}>
                    <label class="form-check-label fw-semibold text-dark" for="isActive">Ürünü Aktifleştir / Satışa Aç</label>
                </div>

                <div class="mt-4 pt-3 border-top d-flex gap-2">
                    <button type="submit" class="btn btn-premium px-5 py-2.5">
                        <i class="bi bi-save me-2"></i>Kaydet
                    </button>
                    <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-secondary px-4 py-2.5">İptal</a>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="../footer.jsp" />
