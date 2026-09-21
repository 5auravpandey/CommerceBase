<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Products" scope="request"/>
<jsp:include page="header.jsp"/>

<%-- Page Header --%>
<div class="flex flex-col sm:flex-row items-start sm:items-center justify-between pb-4 pt-2 gap-4 mb-6 border-b border-gray-200">
    <h1 class="text-2xl font-semibold text-gray-900 tracking-tight">
        <c:choose>
            <c:when test="${not empty searchKeyword}">
                Search Results: <span class="font-normal text-gray-600"><c:out value="${searchKeyword}"/></span>
            </c:when>
            <c:otherwise>Our Catalog</c:otherwise>
        </c:choose>
    </h1>
</div>

<%-- Error from servlet --%>
<c:if test="${not empty errorMessage}">
    <div class="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-md mb-6 text-sm font-medium shadow-sm">
        <c:out value="${errorMessage}"/>
    </div>
</c:if>

<%-- Filter Bar --%>
<div class="flex flex-wrap items-center gap-3 mb-8 bg-white p-4 rounded-lg shadow-sm border border-gray-200">
    <form method="GET" action="${pageContext.request.contextPath}/products" class="flex gap-2 w-full sm:w-auto">
        <select name="category" onchange="this.form.submit()" class="px-3 py-2 border border-gray-300 rounded-md bg-white text-gray-700 text-sm focus:outline-none focus:ring-1 focus:ring-indigo-500 focus:border-indigo-500 w-full sm:min-w-[200px]">
            <option value="">All Categories</option>
            <c:forEach var="cat" items="${categories}">
                <option value="${cat.categoryId}" <c:if test="${cat.categoryId == selectedCategoryId}">selected</c:if>>
                    <c:out value="${cat.categoryName}"/>
                </option>
            </c:forEach>
        </select>
    </form>

    <form method="GET" action="${pageContext.request.contextPath}/products" class="flex gap-2 flex-grow sm:flex-grow-0 w-full sm:w-auto">
        <input type="text" name="search" placeholder="Search products..."
               value="<c:out value='${searchKeyword}'/>"
               class="px-3 py-2 border border-gray-300 rounded-md bg-white text-gray-700 text-sm focus:outline-none focus:ring-1 focus:ring-indigo-500 focus:border-indigo-500 flex-grow">
        <button type="submit" class="px-4 py-2 bg-gray-900 text-white font-medium text-sm rounded-md hover:bg-gray-800 transition-colors shadow-sm">Search</button>
    </form>
</div>

<%-- Product Grid --%>
<c:choose>
    <c:when test="${not empty products}">
        <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
            <c:forEach var="product" items="${products}">
                <div class="bg-white border border-gray-200 rounded-lg shadow-sm hover:shadow-md transition-shadow flex flex-col overflow-hidden">
                    <div class="w-full h-48 bg-gray-100 flex items-center justify-center text-gray-400 text-sm border-b border-gray-100">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-10 w-10 opacity-20" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" /></svg>
                    </div>
                    <div class="p-5 flex-grow flex flex-col">
                        <h3 class="font-semibold text-gray-900 text-lg mb-1 line-clamp-1">
                            <c:out value="${product.productName}"/>
                        </h3>
                        
                        <div class="mb-3">
                            <c:if test="${not empty product.categoryName}">
                                <span class="bg-gray-100 text-gray-600 text-xs font-medium px-2 py-0.5 rounded"><c:out value="${product.categoryName}"/></span>
                            </c:if>
                        </div>
                        
                        <div class="text-xl font-bold mb-4 text-gray-900">
                            &#8377;<fmt:formatNumber value="${product.price}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                        </div>
                        
                        <div class="text-sm font-medium mb-5 mt-auto">
                            <c:choose>
                                <c:when test="${product.stockQuantity > 0}">
                                    <span class="text-green-600 flex items-center gap-1"><svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" /></svg> In Stock</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-red-500">Out of Stock</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        
                        <div class="flex gap-2">
                            <a href="${pageContext.request.contextPath}/products?id=${product.productId}"
                               class="flex-1 text-center font-medium text-sm px-3 py-2 border border-gray-300 text-gray-700 bg-white hover:bg-gray-50 rounded-md transition-colors shadow-sm">
                                View Details
                            </a>
                            <c:if test="${product.stockQuantity > 0}">
                                <form method="POST" action="${pageContext.request.contextPath}/cart" class="m-0 flex-1 flex">
                                    <input type="hidden" name="action" value="add">
                                    <input type="hidden" name="productId" value="${product.productId}">
                                    <input type="hidden" name="quantity" value="1">
                                    <button type="submit" class="w-full text-center font-medium text-sm px-3 py-2 text-white rounded-md hover:opacity-90 shadow-sm transition-opacity"
                                            style="background:var(--cb-primary);">
                                        Add to Cart
                                    </button>
                                </form>
                            </c:if>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:when>
    <c:otherwise>
        <div class="py-16 text-center bg-white border border-gray-200 rounded-lg shadow-sm">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-16 w-16 mx-auto text-gray-300 mb-4" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" /></svg>
            <h2 class="text-2xl font-semibold text-gray-900 mb-2">No Products Found</h2>
            <p class="text-gray-500 mb-6">Try adjusting your search or filter criteria.</p>
            <a href="${pageContext.request.contextPath}/products" class="inline-block px-5 py-2.5 bg-gray-900 text-white font-medium text-sm rounded-md hover:bg-gray-800 transition-colors shadow-sm">Clear Search</a>
        </div>
    </c:otherwise>
</c:choose>

<jsp:include page="footer.jsp"/>
