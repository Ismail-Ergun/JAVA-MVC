<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!-- Forward if accessed directly without data -->
<c:if test="${empty products and empty categories}">
    <jsp:forward page="/home" />
</c:if>

<jsp:include page="header.jsp">
    <jsp:param name="pageTitle" value="ISTECH - Ana Sayfa" />
</jsp:include>

<!-- Hero Section -->
<div class="hero-section text-center animated-fade-in my-4 shadow-sm">
    <div class="row align-items-center justify-content-center py-5">
        <div class="col-md-8">
            <h1 class="display-4 fw-bold mb-3" style="letter-spacing: -1px;">Geleceğin Teknolojisi, Bugünden Kapınızda</h1>
            <p class="lead text-secondary mb-4">En son model telefonlar, güçlü bilgisayarlar ve aradığınız tüm teknolojik ürünler en iyi fiyat garantisiyle.</p>
            <a href="${pageContext.request.contextPath}/products" class="btn btn-premium btn-lg px-4 py-2">
                <i class="bi bi-bag-heart-fill me-2"></i>Alışverişe Başla
            </a>
        </div>
    </div>
</div>

<!-- Category Ribbon -->
<div class="my-4 animated-fade-in">
    <h3 class="fw-bold mb-3"><i class="bi bi-grid-fill text-primary me-2"></i>Kategoriler</h3>
    <div class="d-flex flex-wrap gap-2">
        <a href="${pageContext.request.contextPath}/products" class="btn btn-premium-outline rounded-pill px-4">
            Tüm Ürünler
        </a>
        <c:forEach var="cat" items="${categories}">
            <a href="${pageContext.request.contextPath}/products?categoryId=${cat.id}" class="btn btn-premium-outline rounded-pill px-4">
                ${cat.name}
            </a>
        </c:forEach>
    </div>
</div>

<!-- Products Grid -->
<div class="my-5 animated-fade-in">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="fw-bold mb-0"><i class="bi bi-stars text-warning me-2"></i>Öne Çıkan Ürünler</h3>
        <a href="${pageContext.request.contextPath}/products" class="text-primary fw-semibold text-decoration-none">
            Tümünü Gör <i class="bi bi-arrow-right"></i>
        </a>
    </div>

    <div class="row g-4">
        <c:forEach var="product" items="${products}">
            <div class="col-12 col-md-6 col-lg-3">
                <div class="card h-100 glass-card">
                    <div class="product-img-container">
                        <!-- Stock Badge -->
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
                            ${product.description.length() > 60 ? product.description.substring(0, 55).concat('...') : product.description}
                        </p>
                        
                        <div class="d-flex justify-content-between align-items-center mt-3 pt-3 border-top">
                            <span class="fs-5 fw-bold text-primary">
                                <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₺" maxFractionDigits="2" />
                            </span>
                            
                            <div class="d-flex gap-1">
                                <a href="${pageContext.request.contextPath}/product-detail?id=${product.id}" class="btn btn-sm btn-premium-outline px-3" title="Detaylar">
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
                                        <button class="btn btn-sm btn-secondary px-3" disabled title="Stokta Yok">
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
</div>

<jsp:include page="footer.jsp" />
