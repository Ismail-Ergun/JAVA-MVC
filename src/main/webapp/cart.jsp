<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<jsp:include page="header.jsp">
    <jsp:param name="pageTitle" value="ISTECH - Alışveriş Sepeti" />
</jsp:include>

<div class="my-4 animated-fade-in">
    <h3 class="fw-bold mb-4"><i class="bi bi-cart3 text-primary me-2"></i>Alışveriş Sepetiniz</h3>

    <c:choose>
        <c:when test="${empty sessionScope.cart}">
            <div class="card text-center border-0 shadow-sm rounded-4 py-5 bg-white">
                <div class="card-body">
                    <i class="bi bi-cart-x fs-1 text-secondary mb-3"></i>
                    <h4 class="fw-bold text-dark">Sepetiniz Boş</h4>
                    <p class="text-secondary mb-4">Sepetinizde henüz ürün bulunmamaktadır. Harika ürünlerimize göz atarak başlayabilirsiniz.</p>
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-premium px-4">Alışverişe Başla</a>
                </div>
            </div>
        </c:when>
        
        <c:otherwise>
            <div class="row g-4">
                <!-- Cart Items List -->
                <div class="col-lg-8">
                    <div class="card border-0 shadow-sm rounded-4 p-4 bg-white">
                        <div class="table-responsive">
                            <table class="table align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th scope="col" class="border-0 rounded-start">Ürün</th>
                                        <th scope="col" class="border-0">Birim Fiyat</th>
                                        <th scope="col" class="border-0" style="width: 140px;">Adet</th>
                                        <th scope="col" class="border-0">Toplam</th>
                                        <th scope="col" class="border-0 rounded-end text-end">İşlem</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="item" items="${sessionScope.cart}">
                                        <tr>
                                            <td>
                                                <div class="d-flex align-items-center gap-3">
                                                    <img src="${not empty item.product.imageUrl ? item.product.imageUrl : 'https://placehold.co/600x400?text=Urun'}" 
                                                         alt="${item.product.name}" class="cart-table-img shadow-sm">
                                                    <div>
                                                        <h6 class="fw-bold mb-1 text-dark">${item.product.name}</h6>
                                                        <small class="text-secondary">${item.product.categoryName}</small>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <span class="fw-medium text-secondary">
                                                    <fmt:formatNumber value="${item.product.price}" type="currency" currencySymbol="₺" maxFractionDigits="2" />
                                                </span>
                                            </td>
                                            <td>
                                                <!-- Update Quantity Form -->
                                                <form action="${pageContext.request.contextPath}/cart" method="POST" class="d-flex align-items-center gap-1">
                                                    <input type="hidden" name="action" value="update">
                                                    <input type="hidden" name="productId" value="${item.product.id}">
                                                    <input type="number" name="quantity" class="form-control form-control-premium text-center px-1" 
                                                           value="${item.quantity}" min="1" max="${item.product.stock}" style="width: 65px; height: 38px;" required>
                                                    <button type="submit" class="btn btn-sm btn-premium px-2 py-2" title="Güncelle">
                                                        <i class="bi bi-arrow-repeat"></i>
                                                    </button>
                                                </form>
                                            </td>
                                            <td>
                                                <span class="fw-bold text-dark">
                                                    <fmt:formatNumber value="${item.subtotal}" type="currency" currencySymbol="₺" maxFractionDigits="2" />
                                                </span>
                                            </td>
                                            <td class="text-end">
                                                <!-- Remove Item Form -->
                                                <form action="${pageContext.request.contextPath}/cart" method="POST" style="display:inline-block;">
                                                    <input type="hidden" name="action" value="remove">
                                                    <input type="hidden" name="productId" value="${item.product.id}">
                                                    <button type="submit" class="btn btn-sm btn-outline-danger px-3 py-2 border-0 rounded-pill" title="Sil">
                                                        <i class="bi bi-trash3-fill"></i>
                                                    </button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Summary Panel -->
                <div class="col-lg-4">
                    <div class="card border-0 shadow-sm rounded-4 p-4 bg-white">
                        <h5 class="fw-bold mb-4 text-dark border-bottom pb-2">Sipariş Özeti</h5>
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <span class="text-secondary fw-medium">Ara Toplam:</span>
                            <span class="fw-semibold">
                                <fmt:formatNumber value="${grandTotal}" type="currency" currencySymbol="₺" maxFractionDigits="2" />
                            </span>
                        </div>
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <span class="text-secondary fw-medium">Kargo:</span>
                            <span class="text-success fw-bold">Ücretsiz</span>
                        </div>
                        <hr>
                        <div class="d-flex justify-content-between align-items-center mb-4 mt-2">
                            <span class="fs-5 fw-bold text-dark">Genel Toplam:</span>
                            <span class="fs-4 fw-bold text-primary">
                                <fmt:formatNumber value="${grandTotal}" type="currency" currencySymbol="₺" maxFractionDigits="2" />
                            </span>
                        </div>

                        <c:choose>
                            <c:when test="${not empty sessionScope.user}">
                                <form action="${pageContext.request.contextPath}/checkout" method="POST">
                                    <button type="submit" class="btn btn-premium w-100 py-3 mb-2 rounded-3 fs-5">
                                        <i class="bi bi-wallet2 me-2"></i>Siparişi Tamamla
                                    </button>
                                </form>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/login" class="btn btn-premium w-100 py-3 mb-2 rounded-3 fs-5">
                                    <i class="bi bi-box-arrow-in-right me-2"></i>Giriş Yap ve Tamamla
                                </a>
                                <p class="text-secondary small text-center mb-0 mt-2">Sipariş oluşturmak için giriş yapmanız gerekmektedir.</p>
                            </c:otherwise>
                        </c:choose>
                        
                        <a href="${pageContext.request.contextPath}/products" class="btn btn-premium-outline w-100 py-2.5 mt-2 rounded-3">
                            <i class="bi bi-arrow-left me-2"></i>Alışverişe Devam Et
                        </a>
                    </div>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="footer.jsp" />
