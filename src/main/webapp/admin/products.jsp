<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<jsp:include page="../header.jsp">
    <jsp:param name="pageTitle" value="Ürün Yönetimi - Yönetici Paneli" />
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
            <h3 class="fw-bold mb-0"><i class="bi bi-box-seam-fill text-primary me-2"></i>Ürün Yönetimi</h3>
            <a href="${pageContext.request.contextPath}/admin/product-form" class="btn btn-premium py-2">
                <i class="bi bi-plus-circle me-1"></i> Yeni Ürün Ekle
            </a>
        </div>

        <div class="card border-0 shadow-sm rounded-4 p-4 bg-white">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th scope="col" class="border-0 rounded-start">Görsel</th>
                            <th scope="col" class="border-0">Ürün Adı</th>
                            <th scope="col" class="border-0">Kategori</th>
                            <th scope="col" class="border-0">Fiyat</th>
                            <th scope="col" class="border-0">Stok</th>
                            <th scope="col" class="border-0">Durum</th>
                            <th scope="col" class="border-0 rounded-end text-end" style="width: 140px;">İşlemler</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="p" items="${products}">
                            <tr>
                                <td>
                                    <img src="${not empty p.imageUrl ? p.imageUrl : 'https://placehold.co/100x100?text=Urun'}" 
                                         alt="${p.name}" class="rounded shadow-sm" style="width: 50px; height: 50px; object-fit: cover;">
                                </td>
                                <td>
                                    <h6 class="fw-bold mb-0 text-dark">${p.name}</h6>
                                    <small class="text-secondary d-block" style="max-width: 200px; text-overflow: ellipsis; white-space: nowrap; overflow: hidden;">
                                        ${p.description}
                                    </small>
                                </td>
                                <td><span class="badge bg-light text-dark border fw-semibold">${p.categoryName}</span></td>
                                <td>
                                    <span class="fw-bold text-primary">
                                        <fmt:formatNumber value="${p.price}" type="currency" currencySymbol="₺" maxFractionDigits="2" />
                                    </span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${p.stock > 0}">
                                            <span class="fw-semibold text-dark">${p.stock} adet</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-danger fw-bold">Tükendi</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${p.active}">
                                            <span class="badge bg-success-subtle text-success border border-success-subtle px-2 py-1.5 fw-bold">Aktif</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary-subtle text-secondary border border-secondary-subtle px-2 py-1.5 fw-bold">Pasif</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-end">
                                    <div class="d-flex justify-content-end gap-1">
                                        <a href="${pageContext.request.contextPath}/admin/product-form?id=${p.id}" class="btn btn-sm btn-outline-primary px-2.5 py-1.5" title="Düzenle">
                                            <i class="bi bi-pencil-square"></i>
                                        </a>
                                        <form action="${pageContext.request.contextPath}/admin/products" method="POST" onsubmit="return confirm('Bu ürünü silmek istediğinize emin misiniz?');" style="margin:0;">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="id" value="${p.id}">
                                            <button type="submit" class="btn btn-sm btn-outline-danger px-2.5 py-1.5" title="Sil">
                                                <i class="bi bi-trash3"></i>
                                            </button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../footer.jsp" />
