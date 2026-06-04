<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${param.pageTitle != null ? param.pageTitle : 'E-Ticaret Portalı'}</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <!-- Custom Style -->
    <link href="${pageContext.request.contextPath}/css/style.css?v=<%= System.currentTimeMillis() %>" rel="stylesheet">
</head>
<body class="bg-gradient-mesh">

<!-- Calculation of Cart Count -->
<c:set var="cartCount" value="0" />
<c:forEach var="item" items="${sessionScope.cart}">
    <c:set var="cartCount" value="${cartCount + item.quantity}" />
</c:forEach>

<nav class="navbar navbar-expand-lg navbar-custom">
    <div class="container">
        <a class="navbar-brand navbar-brand-premium" href="${pageContext.request.contextPath}/home">
            <i class="bi bi-rocket-takeoff-fill me-2"></i>ISTECH
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarText" aria-controls="navbarText" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        
        <div class="collapse navbar-collapse" id="navbarText">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link fw-semibold text-dark" href="${pageContext.request.contextPath}/home">Ana Sayfa</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link fw-semibold text-dark" href="${pageContext.request.contextPath}/products">Ürünler</a>
                </li>
            </ul>

            <!-- Search Bar -->
            <form class="d-flex me-3" action="${pageContext.request.contextPath}/products" method="GET">
                <div class="input-group">
                    <input class="form-control form-control-premium" type="search" placeholder="Ürün Ara..." aria-label="Search" name="keyword" value="${requestScope.keyword}">
                    <button class="btn btn-premium" type="submit"><i class="bi bi-search"></i></button>
                </div>
            </form>

            <div class="d-flex align-items-center gap-3">
                <!-- Cart icon -->
                <a href="${pageContext.request.contextPath}/cart" class="btn btn-premium-outline position-relative px-3 py-2">
                    <i class="bi bi-cart3 fs-5"></i>
                    <c:if test="${cartCount > 0}">
                        <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger border border-light">
                            ${cartCount}
                        </span>
                    </c:if>
                </a>

                <!-- User Session controls -->
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <div class="dropdown">
                            <button class="btn btn-premium dropdown-toggle" type="button" id="userMenuButton" data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="bi bi-person-circle me-1"></i> ${sessionScope.user.fullName}
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end shadow border-0 mt-2 p-2 rounded-3" aria-labelledby="userMenuButton">
                                <c:if test="${sessionScope.user.admin}">
                                    <li>
                                        <a class="dropdown-item fw-semibold text-primary" href="${pageContext.request.contextPath}/admin/dashboard">
                                            <i class="bi bi-shield-lock me-2"></i>Yönetim Paneli
                                        </a>
                                    </li>
                                    <li><hr class="dropdown-divider"></li>
                                </c:if>
                                <li>
                                    <a class="dropdown-item fw-medium" href="${pageContext.request.contextPath}/my-orders">
                                        <i class="bi bi-bag-check me-2"></i>Siparişlerim
                                    </a>
                                </li>
                                <li><hr class="dropdown-divider"></li>
                                <li>
                                    <a class="dropdown-item fw-medium text-danger" href="${pageContext.request.contextPath}/logout">
                                        <i class="bi bi-box-arrow-right me-2"></i>Çıkış Yap
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login" class="btn btn-premium-outline"><i class="bi bi-box-arrow-in-right me-1"></i>Giriş</a>
                        <a href="${pageContext.request.contextPath}/register" class="btn btn-premium"><i class="bi bi-person-plus me-1"></i>Kayıt Ol</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</nav>

<div class="container my-4 flex-grow-1">
    <!-- Messages Alert Handler -->
    <c:if test="${not empty sessionScope.successMsg}">
        <div class="alert alert-success alert-dismissible fade show shadow-sm rounded-3 border-0" role="alert">
            <i class="bi bi-check-circle-fill me-2"></i>${sessionScope.successMsg}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="successMsg" scope="session" />
    </c:if>
    <c:if test="${not empty requestScope.successMsg}">
        <div class="alert alert-success alert-dismissible fade show shadow-sm rounded-3 border-0" role="alert">
            <i class="bi bi-check-circle-fill me-2"></i>${requestScope.successMsg}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>
    <c:if test="${not empty sessionScope.errorMsg}">
        <div class="alert alert-danger alert-dismissible fade show shadow-sm rounded-3 border-0" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2"></i>${sessionScope.errorMsg}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="errorMsg" scope="session" />
    </c:if>
    <c:if test="${not empty requestScope.errorMsg}">
        <div class="alert alert-danger alert-dismissible fade show shadow-sm rounded-3 border-0" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2"></i>${requestScope.errorMsg}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>
