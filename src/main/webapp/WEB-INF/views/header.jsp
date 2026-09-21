<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>
        <c:choose>
            <c:when test="${not empty pageTitle}"><c:out value="${pageTitle}"/> &mdash; <c:out value="${applicationScope.storeConfig.storeName}"/></c:when>
            <c:when test="${not empty applicationScope.storeConfig}"><c:out value="${applicationScope.storeConfig.storeName}"/></c:when>
            <c:otherwise>CommerceBase</c:otherwise>
        </c:choose>
    </title>

    <%-- Tailwind CSS CDN --%>
    <script src="https://cdn.tailwindcss.com"></script>

    <%-- Custom stylesheet for brand-colour variables and overrides --%>
    <link rel="stylesheet" href="${ctx}/assets/css/style.css">

    <%-- Inject white-label theme colour as CSS custom property --%>
    <c:if test="${not empty applicationScope.storeConfig}">
        <style>
            :root {
                --cb-primary: ${fn:escapeXml(applicationScope.storeConfig.themeColor)};
            }
        </style>
    </c:if>
</head>
<body class="bg-gray-50 text-gray-800 min-h-screen flex flex-col font-sans">

<%-- ══════════ NAVBAR ══════════ --%>
<nav class="sticky top-0 z-50 shadow-sm" style="background:var(--cb-primary);">
    <div class="max-w-7xl mx-auto px-5 flex items-center justify-between flex-wrap min-h-[4rem]">

        <a href="${ctx}/" class="flex items-center gap-2 text-white font-bold text-xl tracking-tight no-underline hover:opacity-90 transition-opacity">
            <c:choose>
                <c:when test="${not empty applicationScope.storeConfig}"><c:out value="${applicationScope.storeConfig.storeName}"/></c:when>
                <c:otherwise>CommerceBase</c:otherwise>
            </c:choose>
        </a>

        <ul class="flex items-center gap-2 list-none flex-wrap my-2">

            <li><a href="${ctx}/products" class="text-white/90 hover:text-white hover:bg-white/10 px-3 py-2 rounded-md text-sm font-medium transition-colors">Products</a></li>

            <li>
                <a href="${ctx}/cart" class="text-white/90 hover:text-white hover:bg-white/10 px-3 py-2 rounded-md text-sm font-medium transition-colors flex items-center gap-2">
                    Cart
                    <c:if test="${not empty sessionScope.cart && sessionScope.cart.size() > 0}">
                        <span class="bg-white text-xs font-bold px-2 py-0.5 rounded-full shadow-sm" style="color:var(--cb-primary);"><c:out value="${sessionScope.cart.size()}"/></span>
                    </c:if>
                </a>
            </li>

            <c:choose>
                <c:when test="${not empty sessionScope.loggedInUser}">
                    <c:choose>
                        <c:when test="${sessionScope.loggedInUser.admin}">
                            <li><a href="${ctx}/admin/dashboard" class="text-white/90 hover:text-white hover:bg-white/10 px-3 py-2 rounded-md text-sm font-medium transition-colors">Dashboard</a></li>
                            <li><a href="${ctx}/admin/products/manage" class="text-white/90 hover:text-white hover:bg-white/10 px-3 py-2 rounded-md text-sm font-medium transition-colors">Products</a></li>
                            <li><a href="${ctx}/admin/settings" class="text-white/90 hover:text-white hover:bg-white/10 px-3 py-2 rounded-md text-sm font-medium transition-colors">Settings</a></li>
                        </c:when>
                        <c:otherwise>
                            <li><a href="${ctx}/orders" class="text-white/90 hover:text-white hover:bg-white/10 px-3 py-2 rounded-md text-sm font-medium transition-colors">My Orders</a></li>
                        </c:otherwise>
                    </c:choose>
                    <li>
                        <a href="${ctx}/logout" class="text-white/80 hover:text-white hover:bg-white/10 px-3 py-2 rounded-md text-sm font-medium transition-colors">
                            <c:out value="${sessionScope.loggedInUser.fullName}"/> (Logout)
                        </a>
                    </li>
                </c:when>
                <c:otherwise>
                    <li><a href="${ctx}/login" class="text-white/90 hover:text-white hover:bg-white/10 px-3 py-2 rounded-md text-sm font-medium transition-colors">Login</a></li>
                    <li><a href="${ctx}/register" class="bg-white text-gray-900 hover:bg-gray-50 px-4 py-2 rounded-md text-sm font-semibold shadow-sm transition-colors ml-1">Register</a></li>
                </c:otherwise>
            </c:choose>
        </ul>
    </div>
</nav>

<%-- ══════════ MAIN CONTENT BEGINS — closed by footer.jsp ══════════ --%>
<main class="max-w-7xl mx-auto px-5 py-8 flex-grow w-full">

<%-- One-time flash messages from session --%>
<c:if test="${not empty sessionScope.errorMessage}">
    <div class="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-md mb-6 text-sm font-medium shadow-sm flex items-center gap-2">
        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-red-500" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z" clip-rule="evenodd" /></svg>
        <c:out value="${sessionScope.errorMessage}"/>
    </div>
    <c:remove var="errorMessage" scope="session"/>
</c:if>
<c:if test="${not empty sessionScope.successMessage}">
    <div class="bg-green-50 border border-green-200 text-green-700 px-4 py-3 rounded-md mb-6 text-sm font-medium shadow-sm flex items-center gap-2">
        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-green-500" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" /></svg>
        <c:out value="${sessionScope.successMessage}"/>
    </div>
    <c:remove var="successMessage" scope="session"/>
</c:if>
