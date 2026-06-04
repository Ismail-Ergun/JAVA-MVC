<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<jsp:include page="header.jsp">
    <jsp:param name="pageTitle" value="Siparişlerim - ISTECH" />
</jsp:include>

<div class="my-4 animated-fade-in">
    <h3 class="fw-bold mb-4"><i class="bi bi-bag-check text-primary me-2"></i>Sipariş Geçmişiniz</h3>

    <c:choose>
        <c:when test="${empty orders}">
            <div class="card text-center border-0 shadow-sm rounded-4 py-5 bg-white">
                <div class="card-body">
                    <i class="bi bi-box-seam fs-1 text-secondary mb-3"></i>
                    <h4 class="fw-bold text-dark">Henüz Siparişiniz Yok</h4>
                    <p class="text-secondary mb-4">Daha önce verdiğiniz bir sipariş bulunmamaktadır. Alışverişe devam ederek ilk siparişinizi oluşturabilirsiniz.</p>
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-premium px-4">Ürünleri Keşfet</a>
                </div>
            </div>
        </c:when>
        
        <c:otherwise>
            <div class="card border-0 shadow-sm rounded-4 p-4 bg-white">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th scope="col" class="border-0 rounded-start">Sipariş No</th>
                                <th scope="col" class="border-0">Tarih</th>
                                <th scope="col" class="border-0">Toplam Tutar</th>
                                <th scope="col" class="border-0">Durum</th>
                                <th scope="col" class="border-0 rounded-end text-end">İşlem</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="ord" items="${orders}">
                                <tr>
                                    <td><span class="fw-bold text-dark">#${ord.id}</span></td>
                                    <td>
                                        <span class="text-secondary fw-medium">
                                            <fmt:formatDate value="${ord.orderDate}" pattern="dd MMMM yyyy HH:mm" />
                                        </span>
                                    </td>
                                    <td>
                                        <span class="fw-bold text-primary">
                                            <fmt:formatNumber value="${ord.totalAmount}" type="currency" currencySymbol="₺" maxFractionDigits="2" />
                                        </span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${ord.status eq 'Beklemede'}">
                                                <span class="badge-status badge-status-beklemede"><i class="bi bi-clock-history"></i> Beklemede</span>
                                            </c:when>
                                            <c:when test="${ord.status eq 'Hazırlanıyor'}">
                                                <span class="badge-status badge-status-hazirlaniyor"><i class="bi bi-gear-wide-connected"></i> Hazırlanıyor</span>
                                            </c:when>
                                            <c:when test="${ord.status eq 'Kargoya Verildi'}">
                                                <span class="badge-status badge-status-kargoda"><i class="bi bi-truck"></i> Kargoya Verildi</span>
                                            </c:when>
                                            <c:when test="${ord.status eq 'Tamamlandı'}">
                                                <span class="badge-status badge-status-tamamlandi"><i class="bi bi-check2-circle"></i> Tamamlandı</span>
                                            </c:when>
                                            <c:when test="${ord.status eq 'İptal Edildi'}">
                                                <span class="badge-status badge-status-iptal"><i class="bi bi-x-circle"></i> İptal Edildi</span>
                                            </c:when>
                                        </c:choose>
                                    </td>
                                    <td class="text-end">
                                        <a href="${pageContext.request.contextPath}/order-detail?id=${ord.id}" class="btn btn-sm btn-premium-outline px-3 py-2 rounded-pill">
                                            <i class="bi bi-list-task me-1"></i> Detaylar
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<!-- Modal for Order Details (Auto-triggered when "order" attribute is in request scope) -->
<c:if test="${not empty order}">
    <div class="modal fade show" id="orderDetailModal" tabindex="-1" aria-labelledby="orderDetailModalLabel" style="display: block; background: rgba(0,0,0,0.5);" aria-modal="true" role="dialog">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
                <div class="modal-header bg-light border-0 py-3 px-4">
                    <h5 class="modal-title fw-bold text-dark" id="orderDetailModalLabel">
                        <i class="bi bi-file-earmark-text text-primary me-2"></i>Sipariş Detayı (#${order.id})
                    </h5>
                    <a href="${pageContext.request.contextPath}/my-orders" class="btn-close" aria-label="Close"></a>
                </div>
                <div class="modal-body p-4">
                    <div class="row mb-4">
                        <div class="col-md-6 mb-3 mb-md-0">
                            <p class="text-secondary mb-1">Müşteri</p>
                            <h6 class="fw-bold text-dark">${order.customerName}</h6>
                            <p class="text-secondary mb-1 mt-3">Sipariş Tarihi</p>
                            <h6 class="fw-semibold text-dark"><fmt:formatDate value="${order.orderDate}" pattern="dd MMMM yyyy HH:mm" /></h6>
                        </div>
                        <div class="col-md-6 text-md-end">
                            <p class="text-secondary mb-1">Sipariş Durumu</p>
                            <div class="mb-3">
                                <c:choose>
                                    <c:when test="${order.status eq 'Beklemede'}">
                                        <span class="badge-status badge-status-beklemede"><i class="bi bi-clock-history"></i> Beklemede</span>
                                    </c:when>
                                    <c:when test="${order.status eq 'Hazırlanıyor'}">
                                        <span class="badge-status badge-status-hazirlaniyor"><i class="bi bi-gear-wide-connected"></i> Hazırlanıyor</span>
                                    </c:when>
                                    <c:when test="${order.status eq 'Kargoya Verildi'}">
                                        <span class="badge-status badge-status-kargoda"><i class="bi bi-truck"></i> Kargoya Verildi</span>
                                    </c:when>
                                    <c:when test="${order.status eq 'Tamamlandı'}">
                                        <span class="badge-status badge-status-tamamlandi"><i class="bi bi-check2-circle"></i> Tamamlandı</span>
                                    </c:when>
                                    <c:when test="${order.status eq 'İptal Edildi'}">
                                        <span class="badge-status badge-status-iptal"><i class="bi bi-x-circle"></i> İptal Edildi</span>
                                    </c:when>
                                </c:choose>
                            </div>
                            <p class="text-secondary mb-1">Toplam Ödeme</p>
                            <h4 class="fw-bold text-primary"><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₺" maxFractionDigits="2" /></h4>
                        </div>
                    </div>

                    <h6 class="fw-bold text-dark mb-3"><i class="bi bi-cart3 me-1 text-primary"></i> Satın Alınan Ürünler</h6>
                    <div class="table-responsive">
                        <table class="table align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th scope="col" class="border-0">Ürün Adı</th>
                                    <th scope="col" class="border-0">Birim Fiyat</th>
                                    <th scope="col" class="border-0">Adet</th>
                                    <th scope="col" class="border-0 text-end">Ara Toplam</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${order.items}">
                                    <tr>
                                        <td><span class="fw-bold text-dark">${item.productName}</span></td>
                                        <td>
                                            <span class="text-secondary fw-semibold">
                                                <fmt:formatNumber value="${item.unitPrice}" type="currency" currencySymbol="₺" maxFractionDigits="2" />
                                            </span>
                                        </td>
                                        <td><span class="fw-semibold text-secondary">${item.quantity}</span></td>
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
                <div class="modal-footer bg-light border-0 py-3 px-4">
                    <a href="${pageContext.request.contextPath}/my-orders" class="btn btn-premium px-4">Kapat</a>
                </div>
            </div>
        </div>
    </div>
</c:if>

<jsp:include page="footer.jsp" />
