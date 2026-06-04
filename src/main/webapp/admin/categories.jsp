<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<jsp:include page="../header.jsp">
    <jsp:param name="pageTitle" value="Kategori Yönetimi - Yönetici Paneli" />
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
            <h3 class="fw-bold mb-0"><i class="bi bi-grid-fill text-primary me-2"></i>Kategori Yönetimi</h3>
            <a href="${pageContext.request.contextPath}/admin/category-form" class="btn btn-premium py-2">
                <i class="bi bi-plus-circle me-1"></i> Yeni Kategori Ekle
            </a>
        </div>

        <div class="card border-0 shadow-sm rounded-4 p-4 bg-white">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th scope="col" class="border-0 rounded-start" style="width: 80px;">ID</th>
                            <th scope="col" class="border-0">Kategori Adı</th>
                            <th scope="col" class="border-0">Açıklama</th>
                            <th scope="col" class="border-0">Durum</th>
                            <th scope="col" class="border-0 rounded-end text-end" style="width: 140px;">İşlemler</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="c" items="${categories}">
                            <tr>
                                <td><span class="text-secondary">#${c.id}</span></td>
                                <td><span class="fw-bold text-dark">${c.name}</span></td>
                                <td><span class="text-secondary small">${c.description}</span></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${c.active}">
                                            <span class="badge bg-success-subtle text-success border border-success-subtle px-2 py-1.5 fw-bold">Aktif</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary-subtle text-secondary border border-secondary-subtle px-2 py-1.5 fw-bold">Pasif</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-end">
                                    <div class="d-flex justify-content-end gap-1">
                                        <a href="${pageContext.request.contextPath}/admin/category-form?id=${c.id}" class="btn btn-sm btn-outline-primary px-2.5 py-1.5" title="Düzenle">
                                            <i class="bi bi-pencil-square"></i>
                                        </a>
                                        <form action="${pageContext.request.contextPath}/admin/categories" method="POST" onsubmit="return confirm('Bu kategoriyi silmek istediğinize emin misiniz? (Bağlı ürünler varsa kategori pasifleştirilecektir.)');" style="margin:0;">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="id" value="${c.id}">
                                            <button type="submit" class="btn btn-sm btn-outline-danger px-2.5 py-1.5" title="Sil/Deaktive Et">
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
