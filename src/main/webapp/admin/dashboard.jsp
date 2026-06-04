<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<jsp:include page="../header.jsp">
    <jsp:param name="pageTitle" value="Yönetim Paneli - ISTECH" />
</jsp:include>

<div class="row my-4 animated-fade-in">
    <!-- Admin Sidebar -->
    <div class="col-lg-3 col-md-4 mb-4">
        <div class="card border-0 shadow-sm rounded-4 p-3 bg-white">
            <h5 class="fw-bold mb-3 px-2 text-dark border-bottom pb-2">
                <i class="bi bi-shield-fill-check text-primary me-2"></i>Yönetici İşlemleri
            </h5>
            <div class="d-flex flex-column gap-1">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="category-sidebar-link ${empty usersList ? 'active' : ''}">
                    <i class="bi bi-speedometer2 me-2"></i>Kontrol Paneli
                </a>
                <a href="${pageContext.request.contextPath}/admin/products" class="category-sidebar-link">
                    <i class="bi bi-box-seam me-2"></i>Ürün Yönetimi
                </a>
                <a href="${pageContext.request.contextPath}/admin/categories" class="category-sidebar-link">
                    <i class="bi bi-grid me-2"></i>Kategori Yönetimi
                </a>
                <a href="${pageContext.request.contextPath}/admin/orders" class="category-sidebar-link">
                    <i class="bi bi-receipt me-2"></i>Sipariş Yönetimi
                </a>
                <a href="${pageContext.request.contextPath}/admin/users" class="category-sidebar-link ${not empty usersList ? 'active' : ''}">
                    <i class="bi bi-people me-2"></i>Kullanıcı Yönetimi
                </a>
            </div>
        </div>
    </div>

    <!-- Main Content Area -->
    <div class="col-lg-9 col-md-8">
        <!-- Case 1: Render Registered Users List -->
        <c:choose>
            <c:when test="${not empty usersList}">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h3 class="fw-bold mb-0"><i class="bi bi-people-fill text-primary me-2"></i>Kayıtlı Kullanıcılar</h3>
                    <span class="text-secondary fw-semibold">${usersList.size()} Kullanıcı Kayıtlı</span>
                </div>
                <div class="card border-0 shadow-sm rounded-4 p-4 bg-white">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th scope="col" class="border-0 rounded-start">ID</th>
                                    <th scope="col" class="border-0">Ad Soyad</th>
                                    <th scope="col" class="border-0">E-posta</th>
                                    <th scope="col" class="border-0">Telefon</th>
                                    <th scope="col" class="border-0">Rol</th>
                                    <th scope="col" class="border-0 rounded-end">Kayıt Tarihi</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="u" items="${usersList}">
                                    <tr>
                                        <td><span class="text-secondary">#${u.id}</span></td>
                                        <td><span class="fw-bold text-dark">${u.fullName}</span></td>
                                        <td><span class="fw-medium text-secondary">${u.email}</span></td>
                                        <td><span class="text-secondary">${not empty u.phone ? u.phone : '-'}</span></td>
                                        <td>
                                            <span class="badge ${u.admin ? 'bg-danger-subtle text-danger border border-danger-subtle' : 'bg-primary-subtle text-primary border border-primary-subtle'} rounded-pill px-3 py-1 fw-bold">
                                                ${u.role}
                                            </span>
                                        </td>
                                        <td>
                                            <small class="text-secondary">
                                                <fmt:formatDate value="${u.createdAt}" pattern="dd MMMM yyyy HH:mm" />
                                            </small>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </c:when>

            <c:otherwise>
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h3 class="fw-bold mb-0"><i class="bi bi-speedometer2 text-primary me-2"></i>Yönetici Özet Raporu</h3>
                </div>

                <!-- Metrics Grid -->
                <div class="row g-4 mb-5">
                    <div class="col-6 col-lg-3">
                        <div class="card border-0 shadow-sm rounded-4 p-4 bg-white kpi-card blue h-100">
                            <div class="d-flex align-items-center gap-3">
                                <div class="bg-primary-subtle text-primary p-3 rounded-3 fs-3"><i class="bi bi-box-seam"></i></div>
                                <div>
                                    <h6 class="text-secondary mb-1 fw-semibold small">Toplam Ürün</h6>
                                    <h3 class="fw-bold text-dark mb-0">${totalProducts}</h3>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-6 col-lg-3">
                        <div class="card border-0 shadow-sm rounded-4 p-4 bg-white kpi-card green h-100">
                            <div class="d-flex align-items-center gap-3">
                                <div class="bg-success-subtle text-success p-3 rounded-3 fs-3"><i class="bi bi-grid"></i></div>
                                <div>
                                    <h6 class="text-secondary mb-1 fw-semibold small">Kategori</h6>
                                    <h3 class="fw-bold text-dark mb-0">${totalCategories}</h3>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-6 col-lg-3">
                        <div class="card border-0 shadow-sm rounded-4 p-4 bg-white kpi-card amber h-100">
                            <div class="d-flex align-items-center gap-3">
                                <div class="bg-warning-subtle text-warning p-3 rounded-3 fs-3"><i class="bi bi-people"></i></div>
                                <div>
                                    <h6 class="text-secondary mb-1 fw-semibold small">Kullanıcı</h6>
                                    <h3 class="fw-bold text-dark mb-0">${totalUsers}</h3>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-6 col-lg-3">
                        <div class="card border-0 shadow-sm rounded-4 p-4 bg-white kpi-card purple h-100">
                            <div class="d-flex align-items-center gap-3">
                                <div class="bg-info-subtle text-info p-3 rounded-3 fs-3"><i class="bi bi-receipt"></i></div>
                                <div>
                                    <h6 class="text-secondary mb-1 fw-semibold small">Sipariş (Bekleyen)</h6>
                                    <h3 class="fw-bold text-dark mb-0">${totalOrders} (${pendingOrders})</h3>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Admin Action Card Box -->
                <div class="card border-0 shadow-sm rounded-4 p-5 bg-white mb-4">
                    <div class="row align-items-center">
                        <div class="col-md-8">
                            <h4 class="fw-bold text-dark mb-2">Mağazanızı Kolayca Yönetin</h4>
                            <p class="text-secondary mb-0">Hızlı menüleri kullanarak yeni ürünler ekleyebilir, ürün stok ve açıklamalarını düzenleyebilir, sipariş durumlarını güncelleyebilirsiniz.</p>
                        </div>
                        <div class="col-md-4 text-md-end mt-3 mt-md-0">
                            <a href="${pageContext.request.contextPath}/admin/product-form" class="btn btn-premium py-2.5">
                                <i class="bi bi-plus-circle-fill me-2"></i>Yeni Ürün Ekle
                            </a>
                        </div>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="../footer.jsp" />
