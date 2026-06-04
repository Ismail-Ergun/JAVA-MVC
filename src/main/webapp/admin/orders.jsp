<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<jsp:include page="../header.jsp">
    <jsp:param name="pageTitle" value="Sipariş Yönetimi - Yönetici Paneli" />
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
                <a href="${pageContext.request.contextPath}/admin/categories" class="category-sidebar-link">
                    <i class="bi bi-grid me-2"></i>Kategori Yönetimi
                </a>
                <a href="${pageContext.request.contextPath}/admin/orders" class="category-sidebar-link active">
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
            <h3 class="fw-bold mb-0"><i class="bi bi-receipt-cutoff text-primary me-2"></i>Sipariş Yönetimi</h3>
            <span class="text-secondary fw-semibold">${orders.size()} Sipariş Mevcut</span>
        </div>

        <div class="card border-0 shadow-sm rounded-4 p-4 bg-white">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th scope="col" class="border-0 rounded-start">Sipariş No</th>
                            <th scope="col" class="border-0">Müşteri</th>
                            <th scope="col" class="border-0">Tarih</th>
                            <th scope="col" class="border-0">Tutar</th>
                            <th scope="col" class="border-0" style="width: 200px;">Durum Güncelle</th>
                            <th scope="col" class="border-0 rounded-end text-end" style="width: 120px;">Detay</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="ord" items="${orders}">
                            <tr>
                                <td><span class="fw-bold text-dark">#${ord.id}</span></td>
                                <td>
                                    <span class="fw-bold text-dark">${ord.customerName}</span>
                                    <small class="text-secondary d-block">ID: #${ord.userId}</small>
                                </td>
                                <td>
                                    <span class="text-secondary fw-semibold">
                                        <fmt:formatDate value="${ord.orderDate}" pattern="dd MMMM yyyy HH:mm" />
                                    </span>
                                </td>
                                <td>
                                    <span class="fw-bold text-primary">
                                        <fmt:formatNumber value="${ord.totalAmount}" type="currency" currencySymbol="₺" maxFractionDigits="2" />
                                    </span>
                                </td>
                                <td>
                                    <!-- Quick Status Change dropdown with auto-submit -->
                                    <form action="${pageContext.request.contextPath}/admin/orders" method="POST" style="margin:0;">
                                        <input type="hidden" name="action" value="updateStatus">
                                        <input type="hidden" name="id" value="${ord.id}">
                                        <select name="status" class="form-select form-select-sm fw-semibold" onchange="this.form.submit()"
                                                style="border-radius: 8px; border: 1px solid #cbd5e1; background-color: #f8fafc;">
                                            <option value="Beklemede" ${ord.status eq 'Beklemede' ? 'selected' : ''}>Beklemede</option>
                                            <option value="Hazırlanıyor" ${ord.status eq 'Hazırlanıyor' ? 'selected' : ''}>Hazırlanıyor</option>
                                            <option value="Kargoya Verildi" ${ord.status eq 'Kargoya Verildi' ? 'selected' : ''}>Kargoya Verildi</option>
                                            <option value="Tamamlandı" ${ord.status eq 'Tamamlandı' ? 'selected' : ''}>Tamamlandı</option>
                                            <option value="İptal Edildi" ${ord.status eq 'İptal Edildi' ? 'selected' : ''}>İptal Edildi</option>
                                        </select>
                                    </form>
                                </td>
                                <td class="text-end">
                                    <a href="${pageContext.request.contextPath}/admin/order-detail?id=${ord.id}" class="btn btn-sm btn-premium-outline px-3">
                                        <i class="bi bi-eye-fill"></i> Detay
                                    </a>
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
