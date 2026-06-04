<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<jsp:include page="../header.jsp">
    <jsp:param name="pageTitle" value="Sipariş Detayı (#${order.id}) - Yönetici Paneli" />
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
            <h3 class="fw-bold mb-0"><i class="bi bi-file-earmark-text text-primary me-2"></i>Sipariş Detayı (#${order.id})</h3>
            <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-premium-outline py-2">
                <i class="bi bi-arrow-left me-1"></i> Siparişlere Dön
            </a>
        </div>

        <div class="card border-0 shadow-sm rounded-4 p-4 bg-white mb-4">
            <div class="row">
                <!-- Customer Details -->
                <div class="col-md-6 mb-3 mb-md-0 border-end">
                    <h5 class="fw-bold text-dark mb-3"><i class="bi bi-person me-2 text-primary"></i>Müşteri Bilgileri</h5>
                    <p class="mb-1 text-secondary">Adı Soyadı:</p>
                    <h6 class="fw-bold text-dark mb-3">${order.customerName}</h6>
                    <p class="mb-1 text-secondary">Müşteri ID:</p>
                    <h6 class="fw-semibold text-dark">#${order.userId}</h6>
                </div>
                
                <!-- Order Metadata / Status form -->
                <div class="col-md-6 ps-md-4">
                    <h5 class="fw-bold text-dark mb-3"><i class="bi bi-info-circle me-2 text-primary"></i>Sipariş Durumu</h5>
                    
                    <form action="${pageContext.request.contextPath}/admin/orders" method="POST" class="mb-3">
                        <input type="hidden" name="action" value="updateStatus">
                        <input type="hidden" name="id" value="${order.id}">
                        
                        <div class="input-group">
                            <select name="status" class="form-select form-control-premium fw-semibold">
                                <option value="Beklemede" ${order.status eq 'Beklemede' ? 'selected' : ''}>Beklemede</option>
                                <option value="Hazırlanıyor" ${order.status eq 'Hazırlanıyor' ? 'selected' : ''}>Hazırlanıyor</option>
                                <option value="Kargoya Verildi" ${order.status eq 'Kargoya Verildi' ? 'selected' : ''}>Kargoya Verildi</option>
                                <option value="Tamamlandı" ${order.status eq 'Tamamlandı' ? 'selected' : ''}>Tamamlandı</option>
                                <option value="İptal Edildi" ${order.status eq 'İptal Edildi' ? 'selected' : ''}>İptal Edildi</option>
                            </select>
                            <button type="submit" class="btn btn-premium px-4">Güncelle</button>
                        </div>
                    </form>

                    <div class="d-flex justify-content-between align-items-center mt-4">
                        <span class="fw-bold text-secondary">Genel Toplam:</span>
                        <span class="fs-3 fw-bold text-primary">
                            <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₺" maxFractionDigits="2" />
                        </span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Purchased Items list -->
        <div class="card border-0 shadow-sm rounded-4 p-4 bg-white">
            <h5 class="fw-bold text-dark mb-3"><i class="bi bi-cart3 me-2 text-primary"></i>Sipariş İçeriği</h5>
            <div class="table-responsive">
                <table class="table align-middle">
                    <thead class="table-light">
                        <tr>
                            <th scope="col" class="border-0">Ürün ID</th>
                            <th scope="col" class="border-0">Ürün Adı</th>
                            <th scope="col" class="border-0">Birim Fiyat</th>
                            <th scope="col" class="border-0">Adet</th>
                            <th scope="col" class="border-0 text-end">Ara Toplam</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${order.items}">
                            <tr>
                                <td><span class="text-secondary">#${item.productId}</span></td>
                                <td><span class="fw-bold text-dark">${item.productName}</span></td>
                                <td>
                                    <span class="text-secondary fw-semibold">
                                        <fmt:formatNumber value="${item.unitPrice}" type="currency" currencySymbol="₺" maxFractionDigits="2" />
                                    </span>
                                </td>
                                <td><span class="fw-bold text-secondary">${item.quantity}</span></td>
                                <td class="text-end">
                                    <span class="fw-bold text-dark">
                                        <fmt:formatNumber value="${item.subtotal}" type="currency" currencySymbol="₺" maxFractionDigits="2" />
                                    </span>
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
