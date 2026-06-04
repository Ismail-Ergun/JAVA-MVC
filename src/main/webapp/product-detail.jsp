<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<jsp:include page="header.jsp">
    <jsp:param name="pageTitle" value="${product.name} - Detaylar" />
</jsp:include>

<div class="card border-0 shadow-sm rounded-4 bg-white p-4 my-4 animated-fade-in">
    <div class="row g-4 align-items-center">
        <!-- Product Image Section -->
        <div class="col-md-6">
            <div class="rounded-4 overflow-hidden shadow-sm" style="max-height: 450px; background-color: #f8fafc;">
                <img src="${not empty product.imageUrl ? product.imageUrl : 'https://placehold.co/600x400?text=Urun+Gorseli'}" 
                     alt="${product.name}" class="img-fluid w-100 h-100" style="object-fit: cover; max-height: 450px;">
            </div>
        </div>

        <!-- Product Specs Section -->
        <div class="col-md-6">
            <div class="ps-md-4">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home" class="text-decoration-none">Ana Sayfa</a></li>
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/products" class="text-decoration-none">Ürünler</a></li>
                        <li class="breadcrumb-item active" aria-current="page">${product.categoryName}</li>
                    </ol>
                </nav>

                <h1 class="fw-bold text-dark mb-2">${product.name}</h1>
                <h5 class="text-secondary fw-medium mb-3">Kategori: <span class="badge bg-light text-dark border">${product.categoryName}</span></h5>
                
                <div class="mb-4">
                    <span class="fs-2 fw-bold text-primary">
                        <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₺" maxFractionDigits="2" />
                    </span>
                </div>

                <div class="mb-4">
                    <h5 class="fw-bold text-dark"><i class="bi bi-file-text me-2 text-primary"></i>Ürün Açıklaması</h5>
                    <p class="text-secondary leading-relaxed">${product.description}</p>
                </div>

                <hr class="my-4">

                <!-- Purchase / Stock Section -->
                <div class="d-flex flex-column gap-3">
                    <div class="d-flex align-items-center gap-2">
                        <span class="fw-semibold">Stok Durumu:</span>
                        <c:choose>
                            <c:when test="${product.stock > 0}">
                                <span class="badge bg-success-subtle text-success border border-success-subtle px-3 py-2 rounded-pill fw-bold">
                                    <i class="bi bi-patch-check-fill me-1"></i> Stokta Var (${product.stock} adet)
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-danger-subtle text-danger border border-danger-subtle px-3 py-2 rounded-pill fw-bold">
                                    <i class="bi bi-x-octagon-fill me-1"></i> Stokta Yok / Tükendi
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <c:if test="${product.stock > 0}">
                        <form action="${pageContext.request.contextPath}/cart" method="POST" class="row g-2 align-items-center mt-2">
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="productId" value="${product.id}">
                            
                            <div class="col-auto">
                                <label for="quantity" class="col-form-label fw-semibold">Adet:</label>
                            </div>
                            <div class="col-auto">
                                <input type="number" id="quantity" name="quantity" class="form-control form-control-premium text-center" 
                                       value="1" min="1" max="${product.stock}" style="width: 80px;" required>
                            </div>
                            <div class="col-auto">
                                <button type="submit" class="btn btn-premium px-4 py-2">
                                    <i class="bi bi-cart-plus-fill me-2"></i>Sepete Ekle
                                </button>
                            </div>
                        </form>
                    </c:if>

                    <c:if test="${product.stock == 0}">
                        <div class="alert alert-secondary border-0 rounded-3 mt-2" role="alert">
                            <i class="bi bi-bell-fill me-2"></i>Bu ürün geçici olarak temin edilememektedir. Yeniden stoklara girdiğinde haberdar olmak için takipte kalın.
                        </div>
                        <button class="btn btn-secondary px-4 py-2 mt-2 w-auto align-self-start" disabled>
                            <i class="bi bi-cart-x-fill me-2"></i>Stokta Yok
                        </button>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp" />
