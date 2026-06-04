<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<jsp:include page="header.jsp">
    <jsp:param name="pageTitle" value="ISTECH - Ürünler" />
</jsp:include>

<div class="row my-4 animated-fade-in">
    <!-- Sidebar Filters -->
    <div class="col-lg-3 col-md-4 mb-4">
        <div class="card border-0 shadow-sm rounded-4 p-3 bg-white">
            <h5 class="fw-bold mb-3 px-2 text-dark"><i class="bi bi-funnel-fill text-primary me-2"></i>Kategoriler</h5>
            <div class="d-flex flex-column gap-1">
                <a href="${pageContext.request.contextPath}/products" class="category-sidebar-link ${empty selectedCategory ? 'active' : ''}">
                    <i class="bi bi-tag-fill me-2"></i>Tüm Ürünler
                </a>
                <c:forEach var="cat" items="${categories}">
                    <a href="${pageContext.request.contextPath}/products?categoryId=${cat.id}" class="category-sidebar-link ${selectedCategory.id == cat.id ? 'active' : ''}">
                        <i class="bi bi-tag-fill me-2"></i>${cat.name}
                    </a>
                </c:forEach>
            </div>
        </div>
    </div>

    <!-- Products List -->
    <div class="col-lg-9 col-md-8">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="fw-bold mb-0">
                <c:choose>
                    <c:when test="${not empty selectedCategory}">
                        <i class="bi bi-folder-fill text-primary me-2"></i>${selectedCategory.name}
                    </c:when>
                    <c:when test="${not empty keyword}">
                        <i class="bi bi-search text-primary me-2"></i>"${keyword}" Arama Sonuçları
                    </c:when>
                    <c:otherwise>
                        <i class="bi bi-boxes text-primary me-2"></i>Tüm Ürünlerimiz
                    </c:otherwise>
                </c:choose>
            </h3>
            <span class="text-secondary fw-medium">${products.size()} Ürün Listelendi</span>
        </div>

        <c:choose>
            <c:when test="${empty products}">
                <div class="card text-center border-0 shadow-sm rounded-4 py-5 bg-white">
                    <div class="card-body">
                        <i class="bi bi-search-heart fs-1 text-secondary mb-3"></i>
                        <h4 class="fw-bold text-dark">Ürün Bulunamadı</h4>
                        <p class="text-secondary mb-0">Arama kriterlerinize veya seçilen kategoriye uygun ürün bulunmamaktadır.</p>
                        <a href="${pageContext.request.contextPath}/products" class="btn btn-premium mt-3">Tüm Ürünlere Göz At</a>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="row g-4">
                    <c:forEach var="product" items="${products}">
                        <div class="col-12 col-md-6 col-lg-4">
                            <div class="card h-100 glass-card">
                                <div class="product-img-container">
                                    <c:choose>
                                        <c:when test="${product.stock > 0}">
                                            <span class="product-badge-out">Stokta ${product.stock} adet</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="product-badge-stockout">Tükendi</span>
                                        </c:otherwise>
                                    </c:choose>
                                    <img src="${not empty product.imageUrl ? product.imageUrl : 'https://placehold.co/600x400?text=Urun+Gorseli'}" 
                                         alt="${product.name}" class="product-img">
                                </div>
                                <div class="card-body d-flex flex-column p-4">
                                    <small class="text-secondary fw-semibold text-uppercase mb-1">${product.categoryName}</small>
                                    <h5 class="card-title fw-bold text-dark mb-2">${product.name}</h5>
                                    <p class="card-text text-secondary small mb-3 flex-grow-1">
                                        ${product.description.length() > 80 ? product.description.substring(0, 75).concat('...') : product.description}
                                    </p>
                                    <div class="d-flex justify-content-between align-items-center mt-3 pt-3 border-top">
                                        <span class="fs-5 fw-bold text-primary">
                                            <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₺" maxFractionDigits="2" />
                                        </span>
                                        
                                        <div class="d-flex gap-1">
                                            <a href="${pageContext.request.contextPath}/product-detail?id=${product.id}" class="btn btn-sm btn-premium-outline px-3">
                                                <i class="bi bi-eye-fill"></i>
                                            </a>
                                            <c:choose>
                                                <c:when test="${product.stock > 0}">
                                                    <form action="${pageContext.request.contextPath}/cart" method="POST" style="margin: 0;">
                                                        <input type="hidden" name="action" value="add">
                                                        <input type="hidden" name="productId" value="${product.id}">
                                                        <input type="hidden" name="quantity" value="1">
                                                        <button type="submit" class="btn btn-sm btn-premium px-3">
                                                            <i class="bi bi-cart-plus-fill"></i>
                                                        </button>
                                                    </form>
                                                </c:when>
                                                <c:otherwise>
                                                    <button class="btn btn-sm btn-secondary px-3" disabled>
                                                        <i class="bi bi-cart-x-fill"></i>
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="footer.jsp" />
